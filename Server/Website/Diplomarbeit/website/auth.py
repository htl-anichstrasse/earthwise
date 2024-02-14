from flask import Blueprint, render_template, request, flash, redirect, url_for, send_file, jsonify, session
from .models import User
from werkzeug.security import generate_password_hash, check_password_hash
from . import db   
from flask_login import login_user, login_required, logout_user, current_user
import random
import os
import requests
from website.libr.worldmap.worldmap.worldmap import plot
import requests
import website.libr.worldmap.worldmap.worldmap as wm
import json
from matplotlib.colors import ListedColormap
import hashlib
import shutil



auth = Blueprint('auth', __name__)

correct_answers_count = 0 
wrong_answer_count = 0
home_url = 'http://83.219.162.2:1234/'
school_url = 'http://192.168.0.195:1234/' 


@auth.route('/home', methods=['GET', 'POST'])
def index():
    return render_template('home.html', user=current_user)

@auth.route('/show_pic')
def show_pic():
    # Pfad zum Bild
    pic_path = 'static/flags/Vatican_City.png'
    
    # Rückgabe des Bildes
    return send_file(pic_path, mimetype='image/png')

@auth.route('/login', methods=['GET', 'POST'])
def login():
    if request.method == 'POST':
        email = request.form.get('email')
        password = request.form.get('password')
        password = hashlib.sha256(password.encode()).hexdigest()

        url = home_url + 'login/' + email + '/' + password    
        user = User.query.filter_by(email=email).first()
        if user:
            if user.password == password:        
                try:
                    response = requests.get(url)
                    if response.status_code == 200:
                        print(response.content) 
                        flash('Logged in successfully!', category='success')
                        login_user(user, remember=True)
                        return redirect(url_for('views.home'))
                    else:
                        flash(f'Error: {response.status_code}', category='error')
                except Exception as e:
                    flash(f'An error occurred: {str(e)}', category='error')      
            else:
                flash('Incorrect password, try again.', category='error')
        else:
            flash('Email does not exist.', category='error')
               

    return render_template("login.html", user=current_user)

@auth.route('/logout')
@login_required
def logout():
    logout_user()
    return redirect(url_for('auth.login'))

@auth.route('/sign-up', methods=['GET', 'POST'])
def sign_up():
    if request.method == 'POST':
        email = request.form.get('email')
        first_name = request.form.get('firstName')
        password1 = request.form.get('password1')
        password2 = request.form.get('password2')

        user = User.query.filter_by(email=email).first()
        if user:
            flash('Email already exists.', category='error')
        elif len(email) < 4:
            flash('Email must be greater than 3 characters.', category='error')
        elif len(first_name) < 2:
            flash('First name must be greater than 1 character.', category='error')
        elif password1 != password2:
            flash('Passwords don\'t match.', category='error')
        elif len(password1) < 7: 
            flash('Password must be at least 7 characters.', category='error')
        else:
            password = hashlib.sha256(password1.encode()).hexdigest()
            print(password)
            
            url = home_url + 'createnewuser/' + email + '/' + first_name + '/' + password            
            try:
                response = requests.get(url)
                if response.status_code == 200:
                    print(response.content)
                    new_user = User(email=email, first_name=first_name, password=password)
                    db.session.add(new_user)
                    db.session.commit()
                    login_user(new_user, remember=True)
                    flash('Account created!', category='success')
                    return redirect(url_for('views.home'))
                else:
                    flash(f'Error: {response.status_code}', category='error')
            except Exception as e:
                flash(f'An error occurred: {str(e)}', category='error')            

    return render_template("sign_up.html", user=current_user, home_url=home_url)

@auth.route('/changeUserName', methods=['GET', 'POST'])
def changeUserName():
    if request.method == 'POST':
        email = current_user.email
        new_username = request.form.get('firstName')
        password = request.form.get('password')
        password = hashlib.sha256(password.encode()).hexdigest()
        
        if len(new_username) < 2:
            flash('Username must be greater than 1 character.', category='error')
        elif current_user.password != password:
            flash('Password is incorrect.', category='error')
        else:
            url = home_url + 'changeusername/' + email + '/' + password + '/' + new_username            
            try:
               response = requests.get(url)
               if response.status_code == 200:  
                    user = User.query.filter_by(email=email).first()
                    if user:
                        user.first_name = new_username
                        db.session.commit()
                        print(response.content)
                        flash('Username changed!', category='success')
                    else:
                        flash('Username couldnt be changed!', category='error')
                    return redirect(url_for('views.home'))
               else:
                    flash(f'Error: {response.status_code}', category='error')
            except Exception as e:
                flash(f'An error occurred: {str(e)}', category='error')    
                    
    
            
    return render_template("changeUserName.html", user=current_user, user_name=current_user.first_name)

@auth.route('/changeUserPassword', methods=['GET', 'POST'])
def changeUserPassword():
    if request.method == 'POST':
        email = current_user.email
        password1 = request.form.get('password1')
        password2 = request.form.get('password2')
        password3 = request.form.get('password3')
        
        if password2 != password3:
            flash('Passwords don\'t match.', category='error')
        elif len(password1) < 7: 
            flash('Password must be at least 7 characters.', category='error')
        else:
            password2 = hashlib.sha256(password2.encode()).hexdigest()
            url = home_url + 'changepassword/' + email + '/' + password1 + '/' + password2           
            try:
                response = requests.get(url)
                if response.status_code == 200:
                    user = User.query.filter_by(email=email).first()
                    if user:
                        user.password = password2
                        db.session.commit()
                        print(response.content)
                        flash('Password changed!', category='success')
                    else:                    
                        flash('Password couldnt changed!', category='error')
                else:
                    flash(f'Error: {response.status_code}', category='error')
            except Exception as e:
                flash(f'An error occurred: {str(e)}', category='error')     
            
    return render_template("changeUserPassword.html", user=current_user, email=current_user.email)

@auth.route('/deleteUser', methods=['GET', 'POST'])
def deleteUser():
    if request.method == 'POST':
        email = current_user.email
        user_name = current_user.first_name
        password1 = request.form.get('password1')
        password1 = hashlib.sha256(password1.encode()).hexdigest()
        
        if password1 != current_user.password:
            flash('Passwords don\'t match.', category='error')
        elif len(password1) < 7: 
            flash('Password must be at least 7 characters.', category='error')
        else:
            url = home_url + 'deleteuser/' + email + '/' + password1         
            try:
                response = requests.get(url)
                if response.status_code == 200:
                    user_to_delete = User.query.filter_by(email=email).first()
                    if user_to_delete:
                        
                        db.session.delete(user_to_delete)
                        db.session.commit()
                        logout_user()
                    
                        print(response.content)
                        flash('User has been deleted!', category='success')
                        logout_user()
                        return redirect(url_for('auth.sign_up'))
                    else:
                        flash('Couldnt find the email in the session', category='error')
                else:
                    flash(f'Error: {response.status_code}', category='error')
            except Exception as e:
                flash(f'An error occurred: {str(e)}', category='error')     
            
    return render_template("deleteUser.html", user=current_user, email=current_user.email, user_name=current_user.first_name)

@auth.route('/flagOverview', methods=['GET', 'POST'])
def flagOverview():
    external_server_url = home_url + 'getquizoverview'

    try:
          response = requests.get(external_server_url)
          if response.status_code == 200:
              data = response.json()
              quiz_data = data["quiz_data"]
              quiz_ids = []
              quiz_names = []
              quiz_types = []
              count = 0

              for quiz in quiz_data:
                count += 1
                quiz_ids.append(quiz[0])
                quiz_names.append(quiz[1])
                quiz_types.append(quiz[2])
              
              high_scores = get_high_scores()

              return render_template('flagOverview.html', quiz_ids=quiz_ids, quiz_names=quiz_names,
                                     quiz_types=quiz_types, count=count, high_scores=high_scores, user=current_user)
          else:
                return f"Error: {response.status_code}"
    except Exception as e:
            return f"An error occurred: {str(e)}"
        
def get_high_scores():
    external_server_url = home_url + 'getallscores/' + current_user.email

    try:
          response = requests.get(external_server_url)
          if response.status_code == 200:
              
              data = response.json()
              return data
              
          else:
                return f"Error: {response.status_code}"
    except Exception as e:
        return f"An error occurred: {str(e)}"

@auth.route('/allFlags', methods=['GET', 'POST'])
def allFlags():
    external_server_url = home_url + 'getquizbyid/1' 

    try:
          response = requests.get(external_server_url)
          if response.status_code == 200:
              data = response.json()
              country_data = data['country_data']

              country_names = [country[0].replace(' ', '_') for country in country_data]


              return render_template('allFlags.html', country_names=country_names, user=current_user)
          else:
                return f"Error: {response.status_code}"
    except Exception as e:
            return f"An error occurred: {str(e)}"

@auth.route('/allFlagsByContinent', methods=['GET', 'POST'])
def allFlagsByContinent():
    external_server_url_2 = home_url + 'getquizbyid/2'
    external_server_url_3 = home_url + 'getquizbyid/3'
    external_server_url_4 = home_url + 'getquizbyid/4'
    external_server_url_5 = home_url + 'getquizbyid/5'
    external_server_url_6 = home_url + 'getquizbyid/6'
    external_server_url_7 = home_url + 'getquizbyid/7' 

    try:
          response2 = requests.get(external_server_url_2)
          response3 = requests.get(external_server_url_3)
          response4 = requests.get(external_server_url_4)
          response5 = requests.get(external_server_url_5)
          response6 = requests.get(external_server_url_6)
          response7 = requests.get(external_server_url_7)
          
          if response2.status_code and response3.status_code and response4.status_code and response5.status_code and response6.status_code and response7.status_code== 200:
              country_names_list = []
              response_list = [response2, response3, response4, response5, response6, response7]
              for i in response_list:
                response = i
                data = response.json()
                country_data = data['country_data']

                country_names = [country[0].replace(' ', '_') for country in country_data]
                country_names_list.append(country_names)


              return render_template('allFlagsByContinent.html', country_names_list=country_names_list, user=current_user)
          else:
                return f"Error: {response2.status_code}"
    except Exception as e:
            return f"An error occurred: {str(e)}"

@auth.route('/flagQuiz', methods=['GET', 'POST'])
def flagQuiz():
    return render_template("flagQuiz.html", user=current_user)

@auth.route('/learningResults/<referrer>', methods=['GET', 'POST'])
def learningResults(referrer):
    global correct_answers_count
    global wrong_answer_count
    sum = correct_answers_count+wrong_answer_count
    return render_template("learningResults.html", user=current_user, correct_answers_count=correct_answers_count, 
                           wrong_answer_count=wrong_answer_count, sum=sum, referrer=referrer)

@auth.route('/reset_points/<referrer>')
def reset_points(referrer):
    global correct_answers_count
    global wrong_answer_count
    correct_answers_count = 0
    wrong_answer_count = 0
    session['quiz_count'] = 0

    if referrer:
        if referrer == 'multiChoiseQuiz':
            return redirect(url_for('auth.multiChoiseQuiz'))

        elif referrer =='singleFlagNameQuiz':
            return redirect(url_for('auth.singleFlagNameQuiz'))
        
        elif referrer =='flagNameQuiz':
            return redirect(url_for('auth.flagNameQuiz'))
        
        elif referrer =='twoFlagsQuiz':
            return redirect(url_for('auth.twoFlagsQuiz'))
        
        elif referrer =='textQuiz':
            return redirect(url_for('auth.textQuiz'))

    return redirect(url_for('auth.home'))

@auth.route('/multiChoiseQuiz', methods=['GET', 'POST'])
def multiChoiseQuiz():
    global correct_answers_count
    
    if 'quiz_count' not in session:
        session['quiz_count'] = 0

    # Erhöhe die Zählvariable
    session['quiz_count'] += 1

    # Überprüfe, ob die Seite 5 Mal aufgerufen wurde
    if session['quiz_count'] <= 5:
        external_server_url = home_url + 'getquizbyid/1' 
        try:
            response = requests.get(external_server_url)
            if response.status_code == 200:
                quiz_name = "Test-Quiz"
                discription = "Welches Land ist das?"
                
                data = response.json()
                country_data = data['country_data']
                countries = [country[0] for country in country_data]

                random_countries = random.sample(countries, 4)
                country_paths = ['/flags/' + country.replace(" ", "_") + '.png' for country in random_countries]
                
                correctLand = random.choice(country_paths)
                
                return render_template("multiChoiseQuiz.html", user=current_user, quiz_name=quiz_name, discription=discription, 
                            correctLand=correctLand,land1=country_paths[0], land2=country_paths[1], 
                            land3=country_paths[2], land4=country_paths[3], correct_answers_count=correct_answers_count)
            else:
                    return f"Error: {response.status_code}"
        except Exception as e:
                return f"An error occurred: {str(e)}"
    else:
        # Leite zu einer anderen Seite weiter
        session['quiz_count'] = 0
        return redirect(url_for('auth.learningResults', referrer = 'multiChoiseQuiz'))

@auth.route('/check_answer/<selected_answer>', methods=['POST'])
def check_answer(selected_answer):
    global correct_answers_count
    global wrong_answer_count
    correct_answer = request.form.get('correct_answer')

    is_correct = selected_answer == correct_answer
    if is_correct:
        correct_answers_count += 1
    else:
        wrong_answer_count+=1

    return jsonify({'is_correct': is_correct, 'correct_answers_count': correct_answers_count})

@auth.route('/flagNameQuiz', methods=['GET', 'POST'])
def flagNameQuiz():
    global correct_answers_count
    
    if 'quiz_count' not in session:
        session['quiz_count'] = 0

    # Erhöhe die Zählvariable
    session['quiz_count'] += 1

    # Überprüfe, ob die Seite 5 Mal aufgerufen wurde
    if session['quiz_count'] <= 4:
        external_server_url = home_url + 'getquizbyid/1' 
        try:
            response = requests.get(external_server_url)
            if response.status_code == 200:
                quiz_name = "Test-Quiz"
                discription = "What are the names of these countries?"
                
                data = response.json()
                country_data = data['country_data']

                countries = [country[0] for country in country_data]
                random_countries = random.sample(countries, 4)
                country_paths = ['/flags/' + country.replace(" ", "_") + '.png' for country in random_countries]
                country_names = [country.replace("_", " ") for country in random_countries]


                return render_template("flagNameQuiz.html", user=current_user, quiz_name=quiz_name, discription=discription, land1=country_paths[0],
                            land2=country_paths[1], land3=country_paths[2], land4=country_paths[3], land_names=country_names)
            else:
                    return f"Error: {response.status_code}"
        except Exception as e:
                return f"An error occurred: {str(e)}"
        
    else:
        # Leite zu einer anderen Seite weiter
        session['quiz_count'] = 0
        return redirect(url_for('auth.learningResults', referrer = 'flagNameQuiz'))
        
@auth.route('/singleFlagNameQuiz', methods=['GET', 'POST'])
def singleFlagNameQuiz():
    global correct_answers_count
    
    if 'quiz_count' not in session:
        session['quiz_count'] = 0

    # Erhöhe die Zählvariable
    session['quiz_count'] += 1

    # Überprüfe, ob die Seite 5 Mal aufgerufen wurde
    if session['quiz_count'] <= 5:
        external_server_url = home_url + 'getquizbyid/1' 
        try:
            response = requests.get(external_server_url)
            if response.status_code == 200:
                quiz_name = "Test-Quiz"
                discription = "What are the names of these countries?"
                
                data = response.json()
                country_data = data['country_data']

                countries = [country[0] for country in country_data]
                random_country = random.choice(countries)
                country_path = "/flags/" + random_country.replace(" ", "_") + '.png' 
                country_name = random_country.replace("_", " ") 


                return render_template("singleFlagNameQuiz.html", user=current_user, quiz_name=quiz_name, 
                                       discription=discription, land=country_path, land_name=country_name)
            else:
                    return f"Error: {response.status_code}"
        except Exception as e:
                return f"An error occurred: {str(e)}"

    else:
        # Leite zu einer anderen Seite weiter
        session['quiz_count'] = 0
        return redirect(url_for('auth.learningResults', referrer= 'singleFlagNameQuiz'))

@auth.route('/textQuiz', methods=['GET', 'POST'])
def textQuiz():
    global correct_answers_count
    
    if 'quiz_count' not in session:
        session['quiz_count'] = 0

    # Erhöhe die Zählvariable
    session['quiz_count'] += 1

    # Überprüfe, ob die Seite 5 Mal aufgerufen wurde
    if session['quiz_count'] <= 5:
        quiz_name = "Test-Quiz"
        discription = "Wie heißt das Land dessen Flagge mehr als 4 Ecken hat?"
        answer = "Nepal"
        
        return render_template("textQuiz.html", user=current_user, quiz_name=quiz_name, 
                            discription=discription, answer=answer)

    else:
        # Leite zu einer anderen Seite weiter
        session['quiz_count'] = 0
        return redirect(url_for('auth.learningResults', referrer='textQuiz'))

@auth.route('/twoFlagsQuiz', methods=['GET', 'POST'])
def twoFlagsQuiz():
    global correct_answers_count
    
    if 'quiz_count' not in session:
        session['quiz_count'] = 0

    session['quiz_count'] += 1

    if session['quiz_count'] <= 5:
        external_server_url = home_url + 'getquizbyid/1'
        try:
            response = requests.get(external_server_url)
            if response.status_code == 200:
                quiz_name = "Test-Quiz"
                
                data = response.json()
                country_data = data['country_data']
                countries = [country[0] for country in country_data]
                
                random_country1 = random.choice(countries)
                random_country2 = random.choice(countries)
                whole_path1 = "/flags/" + random_country1.replace(" ", "_") + '.png'
                whole_path2 = "/flags/" + random_country2.replace(" ", "_") + '.png'
                
                correctLand = whole_path1
                incorrectLand = whole_path2
                
                country_list = [random_country1, random_country2]
                random_county_name = random.choice(country_list)

                return render_template("twoFlagsQuiz.html", user=current_user, quiz_name=quiz_name, 
                            incorrectLand=incorrectLand, correctLand=correctLand, 
                            correctLandName=random_country1, incorrectLandName=random_country2, 
                            random_county_name=random_county_name)
            else:
                    return f"Error: {response.status_code}"
        except Exception as e:
                return f"An error occurred: {str(e)}"
    else:
        # Leite zu einer anderen Seite weiter
        session['quiz_count'] = 0
        return redirect(url_for('auth.learningResults', referrer='twoFlagsQuiz'))
    
@auth.route('/learnPage', methods=['GET', 'POST'])
def learnPage():
    return render_template("learnPage.html", user=current_user)

@auth.route('/profileSite', methods=['GET', 'POST'])
def profileSite():
    email = current_user.email
    external_server_url = home_url + 'getusernameandlevel/' + email
    try:
          response = requests.get(external_server_url)
          if response.status_code == 200:
              data = response.json()
              level = data['level']
              
              return render_template("profileSite.html", user=current_user,user_email = current_user.email, 
                           user_name = current_user.first_name, level=level)
          else:
                return f"Error: {response.status_code}"
    except Exception as e:
            return f"An error occurred: {str(e)}"
    




# List of county names from the world map
county2_names = wm.list_county_names(map_name='world')

# Initializing variables
selected_countries = [' ']
selected_country = [' ']
opacity = 0.5
single_color_cmap = ListedColormap(['#06d009'])  
filename='website/static/selected_countries.txt'  # File path to store selected countries
is_reset = False  # Flag to indicate if the reset action is triggered
first_time = True  # Flag to indicate if it's the first time running the application
file_cleared = False  # Flag to indicate if the selected_countries file is cleared
selected_country = " "  # Variable to store the currently selected country


def capitalize_first_letter(text):
    """Function to capitalize the first letter of a string."""
    return text.capitalize()


def save_selected_countries():
    """Function to save selected countries to a text file."""
    with open(filename, 'w') as f:
        json.dump(selected_countries, f)

def delete_selected_countries():
    """Function to delete selected countries from the file."""
    global selected_countries
    global selected_country
    with open(filename, 'w') as f:
        json.dump([" "], f)
    selected_countries = [' ']
    selected_country = [' ']

def load_selected_countries():
    """Function to load selected countries from a text file."""
    global selected_countries
    global selected_country
    try:
        with open(filename, 'r') as f:
            selected_countries = json.load(f)
    except FileNotFoundError:
        selected_countries = [' ']
    selected_country = [' ']

def generate_empty_svg_map():
    """Function to generate an empty SVG map."""
    try:
        svg_map_tuple = plot(None, opacity=opacity, cmap='Set1')  # Passing None to create an empty map
        return svg_map_tuple
    except Exception as e:
        return None

def delete_svg_file():
    """Function to delete the SVG file and reset selected countries."""
    global selected_countries
    global selected_country
    if(os.path.exists('website/static/custom_map.svg')):
        os.remove("website/static/custom_map.svg")
    with open(filename, 'w') as f:
        json.dump([" "], f)
    selected_countries = [' ']
    selected_country = [' ']
    generate_empty_svg_map()
    return jsonify({'success': True})

def clear_selected_countries_file():
    """Function to clear the selected countries file."""
    with open(filename, 'w') as f:
        json.dump([" "], f)

@auth.before_request
def before_request():
    """Function to run before the first request is processed."""
    global file_cleared
    global selected_countries
    global selected_country
    # Clear selected_countries.txt file only if it hasn't been cleared before
    if not file_cleared:
        clear_selected_countries_file()
        file_cleared = True
        selected_countries = [" "]
        selected_country = " "

load_selected_countries()  # Load selected countries when the application starts

@auth.route('/worldmap', methods=['GET', 'POST'])
def worldmap():
    """Route for the index page."""
    global selected_countries
    global is_reset
    global first_time
    global selected_country
    first_time = True
    #shutil_move = False
    message = ""  # Variable to store messages for the user
    if(first_time):
        svg_map_tuple = plot([' '], opacity=opacity * len(selected_countries), cmap='ocean')  # Generate initial SVG map
        first_time = False
   
    if request.method == 'POST':
        if(is_reset):
            try:
                delete_svg_file()  # Delete SVG file and reset selected countries
                svg_map_tuple = plot([' '], opacity=opacity * len(selected_countries), cmap='ocean')
                is_reset = False
            except Exception as e:
                message = f"An error occurred while generating the map: {e}"
        else:
            selected_country = capitalize_first_letter(request.form.get('country'))  # Get selected country from form
            if selected_country in county2_names:  # Check if selected country is valid
                if selected_country not in selected_countries:
                    selected_countries.append(selected_country)  # Add selected country to the list
                    message = f"{selected_country} added."
                    try:
                        svg_map_tuple = plot(selected_countries, opacity=opacity * len(selected_countries), cmap='Green')
                    except Exception as e:
                        message = f"An error occurred while generating the map: {e}"
                else:
                    message = f"{selected_country} is already selected."
            else:
                message = f"{selected_country} is not a valid country."

    # Save selected_countries to the text file before rendering the template
    save_selected_countries()
    return render_template('worldmap.html', map_exists=True, message=message, selected_countries=selected_countries, user=current_user)

@auth.route('/reset', methods=['GET', 'POST'])
def reset():
    """Route to reset selected countries."""
    global selected_countries
    global is_reset 
    is_reset = True
    if(delete_svg_file()):
        return jsonify({'success': True})
    else: 
        return False




@auth.route('/serverQuiz/<quizId>', methods=['GET', 'POST'])
def serverQuiz(quizId):
    external_server_url = home_url + 'getquizbyid/' + quizId

    try:
          response = requests.get(external_server_url)
          if response.status_code == 200:
              data = response.json()
              quiz_name = data['quiz_name']
              description = data['discription']
              country_data = data['country_data']
              quiz_type = data['quiz_type']
              
              if quiz_type == 'flagquiz':
                    country_names = [country[0].replace(' ', '_') for country in country_data]

                    return render_template('serverQuiz.html', quiz_name=quiz_name, description=description, country_names=country_names, 
                                     user=current_user, quizId=quizId, home_url=home_url)
              else:
                    county_names = country_data
                    country_names_list = [country[0] for country in county_names]
                    max_points = len(country_names_list)
                    global selected_countries
                    global is_reset
                    global first_time
                    global selected_country
                    first_time = True
                    #shutil_move = False
                    message = ""  # Variable to store messages for the user
                    if(first_time):
                        svg_map_tuple = plot([' '], opacity=opacity * len(selected_countries), cmap='ocean')  # Generate initial SVG map
                        first_time = False
                
                    if request.method == 'POST':
                        if(is_reset):
                            try:
                                delete_svg_file()  # Delete SVG file and reset selected countries
                                svg_map_tuple = plot([' '], opacity=opacity * len(selected_countries), cmap='ocean')
                                is_reset = False
                            except Exception as e:
                                message = f"An error occurred while generating the map: {e}"
                        else:
                            selected_country = capitalize_first_letter(request.form.get('country'))  # Get selected country from form
    
                            valid_country_found = False

                            for select in county_names:
                                if select[0] == selected_country:
                                    if selected_country not in selected_countries:
                                        selected_countries.append(selected_country)  
                                        message = f"{selected_country} added."
                                        valid_country_found = True
                                        try:
                                            svg_map_tuple = plot(selected_countries, opacity=opacity * len(selected_countries), cmap='Green')
                                        except Exception as e:
                                            message = f"An error occurred while generating the map: {e}"
                                    else:
                                        message = f"{selected_country} is already selected."
                                    break  

                            if not valid_country_found:
                                message = f"{selected_country} is not a valid country."
                                valid_country_found = False

                    save_selected_countries()
                    return render_template('worldmap.html', map_exists=True, message=message, 
                                           selected_countries=selected_countries, quiz_name=quiz_name, 
                                           description=description, user=current_user, 
                                           country_names_list=country_names_list, max_points=max_points, 
                                           county_names=county_names, quizId=quizId)
                  
          else:
                return f"Error: {response.status_code}"
    except Exception as e:
            return f"An error occurred: {str(e)}"

@auth.route('/set_score', methods=['GET','POST'])
def set_score():
    try:
        if request.method == 'POST':
            email = current_user.email
            data = request.get_json()
            quiz_id = data['quiz_id']
            score = data['score']
            achievable_score = data['achievable_score']
            needed_time = data['needed_time']
                
            external_server_url = home_url + 'setscore/' + email + '/' + str(quiz_id) + '/' + str(score) + '/' + str(achievable_score) + '/' + str(needed_time)
            
            response = requests.get(external_server_url)
            
            if response.status_code == 200:
                data = response.json()
                message_type = data.get('message_type')
                print(response.content)
                check_level_increase()
                if(message_type == 'Success'):
                    flash("New Highscore", category="Success") #geht irgendwie nit 
                return "Success"  
            else:
                return f"Error: {response.status_code}"
    except Exception as e:
        print(str(e))  
        return f"An error occurred: {str(e)}", 500  

def check_level_increase():
    try:
          external_server_url = home_url + 'getallscores/' + current_user.email
          response = requests.get(external_server_url)
          if response.status_code == 200:
              data = response.json()
              points_sum = sum(item[2] for item in data)
              current_level = get_user_level()
              
              if points_sum < 50 and current_level != 1:
                    increase_level(1)
              elif points_sum < 100 and points_sum >= 50 and current_level != 2:
                    increase_level(1)
              elif points_sum < 250 and points_sum >= 100 and current_level != 3:
                    increase_level(1)
              elif points_sum < 400 and points_sum >= 250 and current_level != 4:
                    increase_level(1)
              elif points_sum < 600 and points_sum >= 400 and current_level != 5:
                    increase_level(1)
              elif points_sum >= 600 and current_level != 6:
                    increase_level(1)
              
          else:
                return f"Error: {response.status_code}"
    except Exception as e:
        return f"An error occurred: {str(e)}"
    
def increase_level(number):
    try:
        external_server_url = home_url + 'increaselevel/' + current_user.email + '/' + str(number)
        print(external_server_url)
        response = requests.get(external_server_url)
        print(response.status_code)
        if response.status_code == 200:
            print(response.content)
            flash("You have reached a new Level", category="success")
        else:
            return f"Error: {response.status_code}"
    except Exception as e:
        return f"An error occurred: {str(e)}"

def get_user_level():
    email = current_user.email
    external_server_url = home_url + 'getusernameandlevel/' + email
    try:
          response = requests.get(external_server_url)
          if response.status_code == 200:
              data = response.json()
              level = data['level']
              
              return level
          else:
                return f"Error: {response.status_code}"
    except Exception as e:
            return f"An error occurred: {str(e)}"