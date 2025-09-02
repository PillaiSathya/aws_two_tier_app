# Python Flask App with Nginx Reverse Proxy

This repo demonstrates **two approaches** to deploying a Flask + MySQL app:

---

## 📌 Track 1: Manual Setup (EC2 + Nginx + Flask + RDS)
- Step-by-step manual installation on EC2
- Configure Nginx reverse proxy
- Connect Flask app to AWS RDS

[See Guide →](manual_setup.md)

## 📌 Track 2: Containerized Setup (Docker + Compose + RDS)
- Dockerize Flask app
- Run Flask + MySQL locally with Docker Compose
- Extend to AWS RDS for production
- Can be combined with Nginx container

[See Guide →](docker_setup.md)

## 📌 Project Structure

python_flask_app_with_nginx_reverse_proxy/
├─ part1_flask_only/
├─ part2_flask_mysql/
├─ part3_flask_mysql_nginx/
├─ README.md           # overview + links to parts
├─ manual_setup.md     # Connecting Ngnix to RDS
├─ docker_setup.md     # detailed doc for all 3 parts

(Reconstructed project into 3 parts with separate app.py versions)
