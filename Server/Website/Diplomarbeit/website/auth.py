from flask import Blueprint, render_template, request, flash, redirect, url_for, send_file, jsonify, session
from .models import User
from werkzeug.security import generate_password_hash, check_password_hash
from . import db   
from flask_login import login_user, login_required, logout_user, current_user
import random
import os
from worldmap.worldmap import plot
import requests
import website.libr.worldmap.worldmap.worldmap as wm
import json
from matplotlib.colors import ListedColormap


auth = Blueprint('auth', __name__)

correct_answers_count = 0 
wrong_answer_count = 0
home_url = 'http://83.219.186.131:1234/'
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

        user = User.query.filter_by(email=email).first()
        if user:
            if check_password_hash(user.password, password):
                flash('Logged in successfully!', category='success')
                login_user(user, remember=True)
                return redirect(url_for('views.home'))
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
            new_user = User(email=email, first_name=first_name, password=generate_password_hash(
                password1, method='sha256'))
            db.session.add(new_user)
            db.session.commit()
            login_user(new_user, remember=True)
            flash('Account created!', category='success')
            return redirect(url_for('views.home'))

    return render_template("sign_up.html", user=current_user)

@auth.route('/flagOverview', methods=['GET', 'POST'])
def flagOverview():
    external_server_url = 'http://192.168.0.195:1234/getquizoverview'

    try:
          response = requests.get(external_server_url)
          if response.status_code == 200:
              data = response.json()
              quiz_data = data["quiz_data"]
              quiz_ids = []
              quiz_names = []

                
              for id, name in quiz_data:
                quiz_id = id
                quiz_name = name.strip('{}')  
                quiz_ids.append(quiz_id)
                quiz_names.append(quiz_name)

                

              return render_template('flagOverview.html', quiz_ids=quiz_ids, quiz_names=quiz_names, user=current_user)
          else:
                return f"Error: {response.status_code}"
    except Exception as e:
            return f"An error occurred: {str(e)}"


@auth.route('/allFlags', methods=['GET', 'POST'])
def allFlags():
    external_server_url = school_url + 'getquizbyid/1' 

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
    external_server_url_2 = school_url + 'getquizbyid/2'
    external_server_url_3 = school_url + 'getquizbyid/3'
    external_server_url_4 = school_url + 'getquizbyid/4'
    external_server_url_5 = school_url + 'getquizbyid/5'
    external_server_url_6 = school_url + 'getquizbyid/6'
    external_server_url_7 = school_url + 'getquizbyid/7' 

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
        quiz_name = "Test-Quiz"
        discription = "Welches Land ist das?"
        
        path = 'C:/Diplomarbeit/Diplomarbeit/website/static/flags/'
        selected_countries = []

        for _ in range(4):
            files = os.listdir(path)
            random_file = random.choice(files)
            whole_path = os.path.join(path, random_file)
            new_path = whole_path.split('/static')[-1]
            selected_countries.append(new_path)
        
        land1 = selected_countries[0]
        land2 = selected_countries[1]
        land3 = selected_countries[2]
        land4 = selected_countries[3]
        
        correctLand = random.choice(selected_countries)
        
        return render_template("multiChoiseQuiz.html", user=current_user, quiz_name=quiz_name, discription=discription, 
                            correctLand=correctLand,land1=land1, land2=land2, land3=land3, land4=land4, correct_answers_count=correct_answers_count)

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
        quiz_name = "Test-Quiz"
        discription = "What are the names of these countries?"
        path = 'C:/Diplomarbeit/Diplomarbeit/website/static/flags/'
        files = os.listdir(path)
        lands = []
        for _ in range(4):
            random_file = random.choice(files)
            whole_path = os.path.join(path, random_file)
            new_path = whole_path.split('/static')[-1]
            land = new_path
            lands.append(land)
        
        land_names = []

        for land in lands:
            land_name = land.split("/")[-1]
            land_changed = land_name.split(".")[0]
            land_changed = land_changed.replace('_', ' ')
            land_names.append(land_changed)
            
        return render_template("flagNameQuiz.html", user=current_user, quiz_name=quiz_name, discription=discription, land1=lands[0],
                            land2=lands[1], land3=lands[2], land4=lands[3], land_names=land_names)
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
        quiz_name = "Test-Quiz"
        discription = "Wie heißt dieses Land?"
        
        path = 'C:/Diplomarbeit/Diplomarbeit/website/static/flags/'
        files = os.listdir(path)
        random_file = random.choice(files)
        whole_path = os.path.join(path, random_file)
        new_path = whole_path.split('/static')[-1]
        land = new_path
        
        land_name = land.split("/")[-1]
        land_name = land_name.split(".")[0]
        land_name = land_name.replace('_', ' ')

        
        return render_template("singleFlagNameQuiz.html", user=current_user, quiz_name=quiz_name, 
                            discription=discription, land=land, land_name=land_name)

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
        quiz_name = "Test-Quiz"
        
        path = 'C:/Diplomarbeit/Diplomarbeit/website/static/flags/'
        files = os.listdir(path)
        random_file1 = random.choice(files)
        random_file2 = random.choice(files)
        whole_path1 = os.path.join(path, random_file1)
        whole_path2 = os.path.join(path, random_file2)
        new_path1 = whole_path1.split('/static')[-1]
        new_path2 = whole_path2.split('/static')[-1]
        land1 = new_path1
        land2 = new_path2

        
        correctLand = land1
        incorrectLand = land2
            
        land1 = land1.split("/")[-1] 
        correctLandName = land1.split(".")[0]
        correctLandName = correctLandName.replace('_', ' ')
        
        land2 = land2.split("/")[-1] 
        incorrectLandName = land2.split(".")[0]
        incorrectLandName = incorrectLandName.replace('_', ' ')
            
        buttons = ["button1", "button2"]
        random.shuffle(buttons)
        
        return render_template("twoFlagsQuiz.html", user=current_user, quiz_name=quiz_name, 
                            incorrectLand=incorrectLand, correctLand=correctLand, 
                            correctLandName=correctLandName, incorrectLandName=incorrectLandName, buttons=buttons)
    else:
        # Leite zu einer anderen Seite weiter
        session['quiz_count'] = 0
        return redirect(url_for('auth.learningResults', referrer='twoFlagsQuiz'))
    
@auth.route('/learnPage', methods=['GET', 'POST'])
def learnPage():
    return render_template("learnPage.html", user=current_user)

@auth.route('/profileSite', methods=['GET', 'POST'])
def profileSite():
    return render_template("profileSite.html", user=current_user,user_email = current_user.email, 
                           user_name = current_user.first_name)




# Sample data
county_names = wm.list_county_names(map_name='world')


selected_countries = [' ']
selected_country = [' ']
opacity = 0.5
single_color_cmap = ListedColormap(['#06d009'])  
filename='website\static\selected_countries.txt'
is_reset = True
# Nutzerfreundlicher -> immer den ersten Buchstaben capital
def capitalize_first_letter(text):
    return text.capitalize()



# Function to save selected_countries to a text file
def save_selected_countries():
    with open(filename, 'w') as f:
        json.dump(selected_countries, f)

# Function to load selected_countries from a text file
def load_selected_countries():
    global selected_countries
    global selected_country
    try:
        with open(filename, 'r') as f:
            selected_countries = json.load(f)
    except FileNotFoundError:
        selected_countries = [' ']
    selected_country = [' ']

def generate_empty_svg_map():
    try:
        # Pass None as selected_countries to create an empty map
        svg_map_tuple = plot(None, opacity=opacity, cmap='Set1')
        return svg_map_tuple
    except Exception as e:
        return None

# Function to delete the SVG file and reset selected_countries
def delete_svg_file():
    global selected_countries
    global selected_country
    os.remove("static\custom_map.svg")
    with open(filename, 'w') as f:
        json.dump([" "], f)
    
    selected_countries = [' ']
    selected_country = [' ']
    return jsonify({'success': True})


load_selected_countries()


@auth.route('/worldmap', methods=['GET', 'POST'])
def worldmap():
    global selected_countries
    global is_reset
    message = ""

    map_exists = False

    if request.method == 'POST':
        if(is_reset):
            try:
                svg_map_tuple = plot([' '], opacity=opacity * len(selected_countries), cmap='ocean')
                is_reset = False
            except Exception as e:
                message = f"An error occurred while generating the map: {e}"
        else:
            
            selected_country = capitalize_first_letter(request.form.get('country'))
            
            for _ in range(10):
                print(selected_country)
            if selected_country in county_names:
                print(selected_country)
                if selected_country not in selected_countries:
                    selected_countries.append(selected_country)
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
    return render_template('worldmap.html', map_exists=map_exists, message=message, selected_countries=selected_countries)


@auth.route('/reset', methods=['GET', 'POST'])
def reset():
    global selected_countries
    global is_reset 
    is_reset = True
    if(delete_svg_file()):
        return jsonify({'success': True})
    else: 
        return False

@auth.route('/serverQuiz/<quizId>', methods=['GET', 'POST'])
def serverQuiz(quizId):
    external_server_url = school_url + 'getquizbyid/' + quizId

    try:
          response = requests.get(external_server_url)
          if response.status_code == 200:
              data = response.json()
              quiz_name = data['quiz_name']
              description = data['discription']
              country_data = data['country_data']

              country_names = [country[0].replace(' ', '_') for country in country_data]


              return render_template('serverQuiz.html', quiz_name=quiz_name, description=description, country_names=country_names, user=current_user)
          else:
                return f"Error: {response.status_code}"
    except Exception as e:
            return f"An error occurred: {str(e)}"
