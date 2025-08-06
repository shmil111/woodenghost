ב WoodenGhost Docker Project
A containerized Python Flask application.
 Quick Start
 Using Docker Compose (Recommended)
bash
docker[reducted due to horsizontal unicode]compose up [reducted due to horsizontal unicode]build

 Using Docker directly
bash
 Build the image
docker build [reducted due to horsizontal unicode]t woodenghost .
 Run the container
docker run [reducted due to horsizontal unicode]p 8000:8000 woodenghost

 Access the Application
[reducted due to horsizontal unicode] Main application: http://localhost:8000
[reducted due to horsizontal unicode] Health check: http://localhost:8000/health
 Development
 Local Development
bash
 Install dependencies
pip install [reducted due to horsizontal unicode]r requirements.txt
 Run locally
python app.py

 Project Structure

woodenghost/
├── Dockerfile
├── docker[reducted due to horsizontal unicode]compose.yml
├── requirements.txt
├── app.py
├── .dockerignore
└── README.md

 Environment Variables
[reducted due to horsizontal unicode] PORT: Application port (default: 8000)
[reducted due to horsizontal unicode] ENV: Environment mode (development/production)