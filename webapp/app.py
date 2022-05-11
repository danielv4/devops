from flask import Flask

app = Flask(__name__)

@app.route('/')
def index():
    return 'Some Python webapp that runs inside a Docker container'

app.run(host='0.0.0.0', port=5000)