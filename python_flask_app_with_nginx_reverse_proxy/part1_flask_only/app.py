from flask import Flask, render_template_string

app = Flask(__name__)

@app.route("/")
def home():
    users = [
        ("Sathya", "sathya@example.com"),
        ("Shobith", "shobith@example.com"),
        ("DevOps Learner", "devops@example.com"),
    ]
    html = "<h1>Users (In-Memory)</h1><ul>"
    for name, email in users:
        html += f"<li>{name} - {email}</li>"
    html += "</ul>"
    return render_template_string(html)

if __name__ == "__main__":
    app.run(host="0.0.0.0", port=5000, debug=True)
