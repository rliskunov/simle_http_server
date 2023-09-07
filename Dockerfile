# Use an official Python runtime as a parent image
FROM python:3.10-buster as builder

# Set environment varibles
ENV PYTHONDONTWRITEBYTECODE 1
ENV PYTHONUNBUFFERED 1

# Set working directory in the container
WORKDIR /app

# Install dependencies
COPY requirements.txt .
RUN python -m venv /opt/venv && \
    . /opt/venv/bin/activate && \
    pip install --no-cache-dir -r requirements.txt

# Start a new build stage
FROM python:3.10-slim-buster

# Create a group and user
RUN groupadd -r appuser && useradd -u 1001 --no-log-init -r -g appuser appuser

LABEL version=1.0.0
LABEL maintainer="Roman Liskunov liskunov.roma@yandex.ru"
LABEL description="Example task about DevOps"
LABEL securitytxt="https://www.example.com/.well-known/security.txt"

# Copy the dependencies from the builder stage
COPY --from=builder /opt/venv /opt/venv

# Copy the current directory contents into the container
WORKDIR /app
COPY app .

# Add the virtual environment to the PATH
ENV PATH="/opt/venv/bin:$PATH"

# Change to a non-root user
USER appuser

# Make port 8000 available to the outside
EXPOSE 8000

# Health check instruction
HEALTHCHECK --interval=30s --timeout=3s --start-period=5s --retries=3 CMD [ "curl", "http://localhost:8000" ]

# Run the application
CMD ["uvicorn", "main:app", "--host", "0.0.0.0", "--port", "8000"]
