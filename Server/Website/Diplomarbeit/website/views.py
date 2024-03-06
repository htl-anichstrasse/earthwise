from flask import Blueprint, render_template, request, flash, jsonify
from flask_login import login_required, current_user
from . import db
import json
import random
import requests

views = Blueprint('views', __name__)

server_url = 'http://83.219.181.152:1234/'

@views.route('/', methods=['GET', 'POST'])
@login_required
def home():
    external_server_url = server_url + 'getquizoverview'

    try:
          response = requests.get(external_server_url)
          if response.status_code == 200:
                data = response.json()
                last_5_entries = data["quiz_data"][-5:]
                names = [item[1] for item in last_5_entries]
                types = [item[2] for item in last_5_entries]

                return render_template('home.html', last_5_entries=last_5_entries, names=names, 
                                       types=types, user=current_user)

          else:
                return f"Error: {response.status_code}"
    except Exception as e:
            return f"An error occurred: {str(e)}"
         



  



