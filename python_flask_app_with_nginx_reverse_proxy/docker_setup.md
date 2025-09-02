This document explains how to set up and run the Flask application with MySQL database and Nginx reverse proxy using Docker and Docker Compose.

# Docker Setup Guide  

This guide walks through 3 incremental setups for a Flask application:  
- Part 1: Flask only (in-memory data)  
- Part 2: Flask + MySQL (local, with Docker Compose)  
- Part 3: Flask + MySQL + Nginx (reverse proxy, local DB or AWS RDS)  

Each part builds on the previous one, demonstrating how to scale from a simple app → containerized service → production-like stack.

1. ## 📌 Project Structure

python_flask_app_with_nginx_reverse_proxy/
├─ part1_flask_only/
├─ part2_flask_mysql/
├─ part3_flask_mysql_nginx/
├─ README.md           # overview + links to parts
├─ manual_setup.md     # Connecting Ngnix to RDS
├─ docker_setup.md     # detailed doc for all 3 parts

2. ## Part 1 — Flask only (in-memory)

Folder: part1_flask_only/

app.py
requirements.txt
Dockerfile
# Run
docker build -t flask-only:latest ./part1_flask_only
docker run -d -p 5001:5000 --name flask-only flask-only:latest
# Open: http://localhost:5001

3. ## Part 2 — Flask + MySQL (local, Docker Compose)

Folder: part2_flask_mysql/

app.py
requirements.txt
Dockerfile
docker-compose.yml
.env
init.sql
#Run
cd part2_flask_mysql
docker compose up -d --build
# Open: http://localhost:5000

4. ## Part 3 — Flask + MySQL + Nginx (reverse proxy)
Folder: part3_flask_mysql_nginx/

app.py (same as Part 2)
requirements.txt
Dockerfile
nginx/default.conf
docker-compose.yml - (local MySQL variant)
.env (same keys)
init.sql (same as Part 2)
#Run
cd part3_flask_mysql_nginx
docker compose up -d --build
# Open Nginx endpoint: http://localhost:8080   (or http://localhost if you mapped 80:80)

#Switching Part 3 to AWS RDS

Keep nginx and web services.

✅ Remove db service from docker-compose.yml  
✅ Update .env with RDS endpoint and credentials  
✅ Run: docker compose up -d --build web nginx  

# Output Consistency screenshot :

Part 1 → http://localhost:5001

Part 2 → http://localhost:5000

Part 3 → http://localhost:8080

Each part should display the user list in the browser and below is one of it.

! [localhost output] (aws_two_tier_app/docs/output_localhost.png)

🎉 Congratulations! You’ve deployed a Flask + MySQL app from scratch → Dockerized → scaled with Compose → put behind Nginx → connected to AWS RDS.  


 

