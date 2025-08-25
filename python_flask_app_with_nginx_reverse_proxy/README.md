✨ Connecting Ngnix to RDS
   Since Ngnix is a web server, it cannot talk to database directly, so we need web application in between.

**PYTHON FLASK APP WITH NGNIX REVERSE PROXY**

👉 First, log in again with SSH to your EC2 instance:

ssh -i "C:/Users/Sathya/Downloads/terraform-key-mumbai.pem" ec2-user@<your-ec2-public-ip>

## Step 1: Install Python & Flask on EC2
# Update
sudo yum update -y

# Install Python3 and pip
sudo yum install -y python3 python3-pip

# Install Flask and MySQL connector
pip3 install flask flask-mysql-connector gunicorn

## Step 2: Create Flask App

Make a new folder for your app:

mkdir ~/flaskapp && cd ~/flaskapp

Create app.py:

## Step 3: Test Flask App

Run Flask:

python3 app.py

Now in EC2:

curl http://localhost:5000
You should see your users (Sathya, Shobi Kutty) printed.

## Step 4: Run Flask with Gunicorn (Production WSGI)

Stop the test app (Ctrl+C) and run with Gunicorn:

gunicorn --bind 0.0.0.0:8000 app:app

## Step 5: Configure Nginx as Reverse Proxy

Edit Nginx config:

sudo nano /etc/nginx/conf.d/flaskapp.conf
Add:
server {
    listen 80;

    server_name _;

    location / {
        proxy_pass http://127.0.0.1:8000;
        proxy_set_header Host $host;
        proxy_set_header X-Real-IP $remote_addr;
        proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
        proxy_set_header X-Forwarded-Proto $scheme;
    }
}

Save & exit, then:

sudo nginx -t
sudo systemctl restart nginx

## Step 6: Access via Browser

Open in your browser:

http://<your-ec2-public-ip> i.e http://13.200.242.69/

🎉 You’ll see the users list from RDS served via Flask behind Nginx.

✨ This is now a 2-tier architecture:

Frontend (Nginx + Flask App on EC2)

Backend (RDS MySQL)

Output for both :

`![ Output] (Test_Flask_app.png)
