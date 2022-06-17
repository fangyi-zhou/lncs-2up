from flask import Flask
import shutil

app = Flask(__name__)

@app.route("/")
def hello():
    has_psutil = shutil.which("pstops")
    return "It works!" if has_psutil else "It doesn't work."
