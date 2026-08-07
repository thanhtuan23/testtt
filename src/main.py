"""
Sample Secure FastAPI Application
"""
import os
# pyrefly: ignore [missing-import]
from fastapi import FastAPI, status
from pydantic import BaseModel

app = FastAPI(
    title="DevSecOps Boilerplate API",
    description="Sample production-ready API with DevSecOps CI/CD",
    version="1.0.0"
)


class HealthResponse(BaseModel):
    status: str
    version: str
    environment: str


@app.get("/", status_code=status.HTTP_200_OK)
def root():
    return {"message": "Welcome to DevSecOps Boilerplate API", "status": "running"}


@app.get("/health", response_model=HealthResponse, status_code=status.HTTP_200_OK)
def health_check():
    """Health check endpoint for Docker & K8s probes"""
    env = os.getenv("ENVIRONMENT", "development")
    return HealthResponse(
        status="healthy",
        version="1.0.0",
        environment=env
    )
