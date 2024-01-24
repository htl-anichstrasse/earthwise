from flask import Blueprint, render_template, request, flash, jsonify
from flask_login import login_required, current_user
from . import db
import json
import random
import requests

views = Blueprint('views', __name__)


@views.route('/', methods=['GET', 'POST'])
@login_required
def home():
    
    #external_server_url = 'http://83.219.186.131:1234/getquizoverview'
    external_server_url = 'http://192.168.0.195:1234/getquizoverview'

    try:
            # Senden Sie eine GET-Anfrage an den externen Server
          response = requests.get(external_server_url)

            # Überprüfen Sie, ob die Anfrage erfolgreich war (Statuscode 200)
          if response.status_code == 200:
                # Verarbeiten Sie die Daten, z.B. konvertieren Sie sie in JSON
              data = response.json()

                # Hier können Sie die Daten verwenden, z.B. an die Vorlage übergeben
              return render_template('home.html', data=data, user=current_user)
          else:
                # Wenn die Anfrage nicht erfolgreich war, geben Sie eine Fehlermeldung zurück
                return f"Error: {response.status_code}"
    except Exception as e:
            # Behandeln Sie Ausnahmen, z.B. Verbindungsprobleme
            return f"An error occurred: {str(e)}"



    #return render_template("home.html", user=current_user, user_email = current_user.email, 
     #                      user_name = current_user.first_name)





