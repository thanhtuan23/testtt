# =============================================================
# STAGE 1: Builder Stage
# =============================================================
FROM python:3.11-slim AS builder

WORKDIR /app

ENV PYTHONDONTWRITEBYTECODE=1 \
    PYTHONUNBUFFERED=1

RUN apt-get update && apt-get install -y --no-install-recommends \
    build-essential \
    && rm -rf /var/lib/apt/lists/*

COPY requirements.txt .
RUN pip install --no-cache-dir --user -r requirements.txt

# =============================================================
# STAGE 2: Secure Production Runner Stage (Non-root user)
# =============================================================
FROM python:3.11-slim AS runner

WORKDIR /app

ENV PYTHONDONTWRITEBYTECODE=1 \
    PYTHONUNBUFFERED=1 \
    PATH="/home/appuser/.local/bin:${PATH}" \
    ENVIRONMENT="production"

# Tạo non-root user và group riêng biệt vì lý do bảo mật
RUN groupadd -g 10001 appgroup && \
    useradd -u 10001 -g appgroup -s /bin/bash -m appuser

# Copy installed packages từ builder stage
COPY --from=builder --chown=appuser:appgroup /root/.local /home/appuser/.local
COPY --chown=appuser:appgroup src/ ./src/

# Chuyển sang non-root user
USER appuser

EXPOSE 8000

# Docker Healthcheck
HEALTHCHECK --interval=30s --timeout=5s --start-period=5s --retries=3 \
  CMD python -c "import urllib.request; urllib.request.urlopen('http://localhost:8000/health')" || exit 1

CMD ["uvicorn", "src.main:app", "--host", "0.0.0.0", "--port", "8000"]
