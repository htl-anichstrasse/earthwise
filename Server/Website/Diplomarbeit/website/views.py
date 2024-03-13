from flask import Blueprint, render_template, request, flash, jsonify
from flask_login import login_required, current_user
from . import db
import requests

views = Blueprint('views', __name__)

server_url = 'http://185.106.189.152:1234/'

@views.route('/', methods=['GET', 'POST'])
@login_required
def homepage():
    # Endpoint to get quiz overview from the external server
    external_server_url = server_url + 'getquizoverview'

    try:
        response = requests.get(external_server_url)

        if response.status_code == 200:
            data = response.json()

            # Extract the last 5 entries from the quiz data
            last_5_entries = data["quiz_data"][-5:]

            # Extract names and types from the last 5 entries
            names = [item[1] for item in last_5_entries]
            types = [item[2] for item in last_5_entries]

            return render_template('homepage.html', last_5_entries=last_5_entries, names=names, types=types, user=current_user)
        else:
            return f"Error: {response.status_code}"
    except Exception as e:
        return f"An error occurred: {str(e)}"
