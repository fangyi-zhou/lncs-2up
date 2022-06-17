from flask import Flask, request, send_file
import shutil
import tempfile
import os
import subprocess

app = Flask(__name__)


def is_pdf(filename):
    return "." in filename and filename.rsplit(".", 1)[1].lower() == "pdf"


@app.route("/")
def hello():
    has_psutil = shutil.which("pstops")
    return "It works!" if has_psutil else "It doesn't work."


@app.route("/process", methods=["POST"])
def process():
    if request.method == "POST":
        print(request.files)
        if "file" not in request.files:
            return "You need to update a file"
        file = request.files["file"]
        if file and is_pdf(file.filename):
            filename = "input.pdf"
            with tempfile.TemporaryDirectory() as d:
                out_path = os.path.join(d, filename)
                file.save(out_path)
                subprocess.check_output(["./lncs2up.sh", out_path])
                return send_file(os.path.join(d, "input_out.pdf"))
