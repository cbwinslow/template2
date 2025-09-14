# Multi-stage Python Dockerfile
FROM python:3.11-slim as base

# Set environment variables
ENV PYTHONUNBUFFERED=1 \
    PYTHONDONTWRITEBYTECODE=1 \
    PIP_NO_CACHE_DIR=1 \
    PIP_DISABLE_PIP_VERSION_CHECK=1

# Install system dependencies
RUN apt-get update && apt-get install -y \
    build-essential \
    curl \
    && rm -rf /var/lib/apt/lists/*

# Create non-root user
RUN groupadd -r appuser && useradd -r -g appuser appuser

# Development stage
FROM base as development

WORKDIR /app

# Install poetry
RUN pip install poetry

# Copy dependency files
COPY pyproject.toml poetry.lock* ./

# Configure poetry
RUN poetry config virtualenvs.create false

# Install dependencies
RUN poetry install --with dev

# Copy source code
COPY . .

# Change ownership to appuser
RUN chown -R appuser:appuser /app
USER appuser

EXPOSE 8000

CMD ["python", "-m", "uvicorn", "src.main:app", "--host", "0.0.0.0", "--port", "8000", "--reload"]

# Production stage
FROM base as production

WORKDIR /app

# Install only runtime dependencies
RUN pip install poetry

# Copy dependency files
COPY pyproject.toml poetry.lock ./

# Configure poetry and install production dependencies
RUN poetry config virtualenvs.create false && \
    poetry install --only=main --no-dev

# Copy source code
COPY src ./src

# Create directories and set permissions
RUN chown -R appuser:appuser /app
USER appuser

EXPOSE 8000

# Health check
HEALTHCHECK --interval=30s --timeout=30s --start-period=5s --retries=3 \
    CMD curl -f http://localhost:8000/health || exit 1

CMD ["python", "-m", "uvicorn", "src.main:app", "--host", "0.0.0.0", "--port", "8000"]