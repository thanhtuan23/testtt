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

# Tạo Virtual Environment
RUN python -m venv /opt/venv
ENV PATH="/opt/venv/bin:$PATH"

COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt

# =============================================================
# STAGE 2: Secure Production Runner Stage (Non-root user)
# =============================================================
FROM python:3.11-slim AS runner

WORKDIR /app

ENV PYTHONDONTWRITEBYTECODE=1 \
    PYTHONUNBUFFERED=1 \
    PATH="/opt/venv/bin:${PATH}" \
    ENVIRONMENT="production"

# Tạo non-root user và group riêng biệt
RUN groupadd -g 10001 appgroup && \
    useradd -u 10001 -g appgroup -s /sbin/nologin appuser

# Copy virtual environment từ builder stage
COPY --from=builder /opt/venv /opt/venv

# Copy mã nguồn và phân quyền cho appuser
COPY --chown=10001:10001 src/ ./src/

# Chuyển sang UID số thay vì tên chữ (Chuẩn DL3066)
USER 10001

EXPOSE 8000

# Docker Healthcheck
HEALTHCHECK --interval=30s --timeout=5s --start-period=5s --retries=3 \
  CMD ["python", "-c", "import urllib.request; urllib.request.urlopen('http://localhost:8000/health')"]

CMD ["uvicorn", "src.main:app", "--host", "0.0.0.0", "--port", "8000"]