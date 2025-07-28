# WoodenGhost Docker Project

A containerized Python Flask application.

## Quick Start

### Using Docker Compose (Recommended)
```bash
docker-compose up --build
```

### Using Docker directly
```bash
# Build the image
docker build -t woodenghost .

# Run the container
docker run -p 8000:8000 woodenghost
```

## Access the Application

- Main application: http://localhost:8000
- Health check: http://localhost:8000/health

## Development

### Local Development
```bash
# Install dependencies
pip install -r requirements.txt

# Run locally
python app.py
```

### Project Structure
```
woodenghost/
├── Dockerfile
├── docker-compose.yml
├── requirements.txt
├── app.py
├── .dockerignore
└── README.md
```

## Environment Variables

- `PORT`: Application port (default: 8000)
- `ENV`: Environment mode (development/production) 