ב Use an official base image
FROM python:3.11-slim
# Set working directory in container
WORKDIR /app
# Copy requirements first for better caching
COPY requirements.txt .
# Install dependencies
RUN pip install –no-cache-dir -r requirements.txt
# Copy application code
COPY . .
# Expose port
EXPOSE 8000
# Default command
CMD ["python", "app.py"]