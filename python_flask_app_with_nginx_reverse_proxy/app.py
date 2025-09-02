
from flask import Flask, render_template_string
import mysql.connector

app = Flask(__name__)

def get_users():
    conn = mysql.connector.connect(
        host="sathya-mysql.ct8saec4omnf.ap-south-1.rds.amazonaws.com",
        user="appuser",
        password="your_password_here",
        database="myappdb"
    )
    cursor = conn.cursor()
    cursor.execute("SELECT name, email FROM users;")
    rows = cursor.fetchall()
    cursor.close()
    conn.close()
    return rows

@app.route("/")
def home():
    users = get_users()
    html = "<h1>Users from RDS</h1><ul>"
    for name, email in users:
        html += f"<li>{name} - {email}</li>"
    html += "</ul>"
    return render_template_string(html)

if __name__ == "__main__":
    app.run(host="0.0.0.0", port=5000)
