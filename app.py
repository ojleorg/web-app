from flask import Flask, jsonify, request
from flask_swagger_ui import get_swaggerui_blueprint
from dotenv import load_dotenv, find_dotenv
from os import environ
from random import choice

SWAGGER_URL = "/docs"
API_URL = "/static/swagger.json"

load_dotenv(find_dotenv())

app = Flask(__name__)

access_list = [{'username': 'jay', 'server_ip': '8.8.8.8'}]
access_types = ['ssh', 'rsh', 'telnet', 'http', 'ftp']

swagger_ui_blueprint = get_swaggerui_blueprint(
    SWAGGER_URL,
    API_URL,
    config={
        'app_name': 'Access API'
    }
)

app.register_blueprint(swagger_ui_blueprint, url_prefix=SWAGGER_URL)


@app.route("/")
def index():
    return "Yup, it's a hackerman™ server access web app with \
            <a href='/docs'>REST endpoint</a>!"


@app.route('/access')
def get_access():
    print(environ.get("TEST_VAR"))
    return jsonify(access_list)


@app.route('/access', methods=['POST', 'DELETE'])
def manage_access():
    data = request.get_json()
    json_keys = data.keys()
    if len(data) != 2:
        return '', 400
    if ('name' not in json_keys or 'server_ip' not in json_keys):
        return '', 400
    if request.method == 'POST':
        access_list.append(data)
        access_type = choice(access_types)
        name = data.get("name")
        server_ip = data.get("server_ip")
        message = (
            f"User {name} received {access_type} "
            f"access to server {server_ip}"
        )
        return jsonify({"Message": message})
    if request.method == 'DELETE':
        if data in access_list:
            access_list.remove(data)
            return ''
        else:
            return '', 400
