from flask import Flask, render_template_string
import os, time
import mysql.connector

app = Flask(__name__)

def get_conn():
    host = os.environ.get("DB_HOST", "db")
    user = os.environ.get("DB_USER", "appuser")
    password = os.environ.get("DB_PASSWORD", "app_password123")
    database = os.environ.get("DB_NAME", "myappdb")
    port = int(os.environ.get("DB_PORT", "3306"))
    for i in range(10):
        try:
            return mysql.connector.connect(
                host=host, user=user, password=password, database=database, port=port
            )
        except mysql.connector.Error as e:
            print(f"DB not ready ({i+1}/10): {e}")
            time.sleep(2)
    return mysql.connector.connect(
        host=host, user=user, password=password, database=database, port=port
    )

def get_users():
    conn = get_conn()
    cur = conn.cursor()
    cur.execute("SELECT name, email FROM users ORDER BY id;")
    rows = cur.fetchall()
    cur.close(); conn.close()
    return rows

@app.route("/")
def home():
    users = get_users()
    html = "<h1>Users (Local MySQL)</h1><ul>"
    for name, email in users:
        html += f"<li>{name} - {email}</li>"
    html += "</ul>"
    return render_template_string(html)

if __name__ == "__main__":
    app.run(host="0.0.0.0", port=5000, debug=True)
