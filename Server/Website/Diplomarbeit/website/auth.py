from flask import Blueprint, render_template, request, flash, redirect, url_for, send_file, jsonify, session
from .models import User
from . import db   
from flask_login import login_user, login_required, logout_user, current_user
import random
import os
import requests
from website.libr.worldmap.worldmap.worldmap import plot
import website.libr.worldmap.worldmap.worldmap as wm
import json
from matplotlib.colors import ListedColormap
import hashlib
import ast
from flask_mail import Message


# Blueprint für die Authentifizierung erstellen
auth = Blueprint('auth', __name__)

# Initialisierung der Zähler für korrekte und falsche Antworten
correct_answers_count = 0
wrong_answer_count = 0

# Die URL des Servers, zu dem die Anfragen gesendet werden sollen
server_url = 'http://185.106.189.152:1234/'


#-----------------------------------------------------------------------------------------------------
#                                      USERVERWALTUNG
#-----------------------------------------------------------------------------------------------------

# Route zum Zurücksetzen des Passworts  
@auth.route('/reset_password', methods=['GET', 'POST'])
def reset_password():
    return render_template('reset_password.html', user=current_user)


# Route für das Senden der Passwort-Zurücksetzen-E-Mail
@auth.route('/send_reset_email', methods=['GET', 'POST'])
def send_reset_email():
    if request.method == 'POST':
        email = request.form.get('email')
        user = User.query.filter_by(email=email).first()

        if user:
            # URL für das Zurücksetzen des Passworts  
            reset_link = url_for('auth.reset_password', token='your_reset_token', _external=True)

            # Nachricht für die E-Mail erstellen
            msg = Message('Passwort zurücksetzen', sender='earthwise@gmail.com', recipients=[email])
            msg.body = render_template('reset_password_email.txt', user=user, reset_link=reset_link)

            # Die E-Mail über das Mail-Objekt senden
            mail = mail  
            mail.send(msg)

            flash('An email with password reset instructions has been sent to your email address.', 'success')
            return redirect(url_for('auth.login'))
 
    flash('No User for this email found!', 'error')
    return render_template('reset_password.html', user=current_user)


# Route for handling user login
@auth.route('/login', methods=['GET', 'POST'])
def login():
    print("-----------------------------------------------")
    if request.method == 'POST':
        email = request.form.get('email')
        password = request.form.get('password')
        # Hashing the password using SHA-256
        password = hashlib.sha256(password.encode()).hexdigest()

        # Building the URL for the server login
        url = server_url + 'login/' + email + '/' + password
        user = User.query.filter_by(email=email).first()

        if user:
            if user.password == password:        
                try:
                    # Sending a login request to the server
                    response = requests.get(url)
                    if response.status_code == 200:
                        print(response.content) 
                        flash('Logged in successfully!', category='success')
                        login_user(user, remember=True)
                        return redirect(url_for('views.homepage'))
                    else:
                        flash(f'Error: {response.status_code}', category='error')
                except Exception as e:
                    flash(f'An error occurred: {str(e)}', category='error')      
            else:
                flash('Incorrect password, try again.', category='error')
        else:
            flash('Email does not exist.', category='error')

    return render_template("login.html", user=current_user)


# Route for handling user logout
@auth.route('/logout')
@login_required
def logout():
    # Logging out the user
    logout_user()
    return redirect(url_for('auth.login'))


# Route for handling user registration
@auth.route('/sign-up', methods=['GET', 'POST'])
def sign_up():
    if request.method == 'POST':
        # Extracting user registration details from the form
        email = request.form.get('email')
        first_name = request.form.get('firstName')
        password1 = request.form.get('password1')
        password2 = request.form.get('password2')
        
        specialSymbols = ['$', '@', '#', '%', '_']

        # Checking if the email already exists in the database
        user = User.query.filter_by(email=email).first()
        if user:
            flash('Email already exists.', category='error')
        # Validating user registration details
        elif len(email) < 4:
            flash('Email must be greater than 3 characters.', category='error')
        elif len(first_name) < 2:
            flash('First name must be greater than 1 character.', category='error')
        elif password1 != password2:
            flash('Passwords don\'t match.', category='error')
        elif len(password1) < 7: 
            flash('Password must be at least 7 characters.', category='error')
        elif not any(char.isupper() for char in password1):
            flash('Password must contain at least 1 uppercase Letter!', category='error')
        elif not any(char.isdigit() for char in password1):
            flash('Password must contain at least 1 uppercase Letter!', category='error')
        elif not any(char in specialSymbols for char in password1):
            flash('Password should have at least one of these symbols:  $,@,#,%,_ !', category ='error')
        else:
            # Hashing the password using SHA-256
            password = hashlib.sha256(password1.encode()).hexdigest()
            print(password)

            # Constructing the URL for creating a new user on the server
            url = server_url + 'createnewuser/' + email + '/' + first_name + '/' + password            
            try:
                # Sending a request to the server to create a new user
                response = requests.get(url)
                if response.status_code == 200:
                    print(response.content)
                    # Creating a new user in the local database
                    new_user = User(email=email, first_name=first_name, password=password)
                    db.session.add(new_user)
                    db.session.commit()
                    # Logging in the new user
                    login_user(new_user, remember=True)
                    flash('Account created!', category='success')
                    return redirect(url_for('views.homepage'))
                else:
                    flash(f'Error: {response.status_code}', category='error')
            except Exception as e:
                flash(f'An error occurred: {str(e)}', category='error')            

    return render_template("sign_up.html", user=current_user, server_url=server_url)


# Route for handling changing user's username
@auth.route('/changeUserName', methods=['GET', 'POST'])
def changeUserName():
    if request.method == 'POST':
        # Extracting user details from the current user
        email = current_user.email
        new_username = request.form.get('firstName')
        password = request.form.get('password')
        password = hashlib.sha256(password.encode()).hexdigest()

        # Validating the new username and password
        if len(new_username) < 2:
            flash('Username must be greater than 1 character.', category='error')
        elif current_user.password != password:
            flash('Password is incorrect.', category='error')
        else:
            # Constructing the URL for changing the username on the server
            url = server_url + 'changeusername/' + email + '/' + password + '/' + new_username            
            try:
                # Sending a request to the server to change the username
                response = requests.get(url)
                if response.status_code == 200:  
                    # Updating the username in the local database
                    user = User.query.filter_by(email=email).first()
                    if user:
                        user.first_name = new_username
                        db.session.commit()
                        print(response.content)
                        flash('Username changed!', category='success')
                    else:
                        flash('Username could not be changed!', category='error')
                    return redirect(url_for('views.homepage'))
                else:
                    flash(f'Error: {response.status_code}', category='error')
            except Exception as e:
                flash(f'An error occurred: {str(e)}', category='error')    

    return render_template("changeUserName.html", user=current_user, user_name=current_user.first_name)


# Route for handling changing user's password
@auth.route('/changeUserPassword', methods=['GET', 'POST'])
def changeUserPassword():
    if request.method == 'POST':
        # Extracting user details from the current user
        email = current_user.email
        password1 = request.form.get('password1')
        password2 = request.form.get('password2')
        password3 = request.form.get('password3')
        
        specialSymbols = ['$', '@', '#', '%', '_']

        # Validating the new passwords
        if password2 != password3:
            flash('Passwords don\'t match.', category='error')
        elif len(password1) < 7: 
            flash('Password must be at least 7 characters.', category='error')
        elif not any(char.isupper() for char in password1):
            flash('Password must contain at least 1 uppercase Letter!', category='error')
        elif not any(char.isdigit() for char in password1):
            flash('Password must contain at least 1 uppercase Letter!', category='error')
        elif not any(char in specialSymbols for char in password1):
            flash('Password should have at least one of these symbols:  $,@,#,%,_ !', category ='error')
        else:
            # Hashing the new password before sending to the server
            password2 = hashlib.sha256(password2.encode()).hexdigest()
            # Constructing the URL for changing the password on the server
            url = server_url + 'changepassword/' + email + '/' + password1 + '/' + password2           
            try:
                # Sending a request to the server to change the password
                response = requests.get(url)
                if response.status_code == 200:
                    # Updating the password in the local database
                    user = User.query.filter_by(email=email).first()
                    if user:
                        user.password = password2
                        db.session.commit()
                        print(response.content)
                        flash('Password changed!', category='success')
                    else:                    
                        flash('Password could not be changed!', category='error')
                else:
                    flash(f'Error: {response.status_code}', category='error')
            except Exception as e:
                flash(f'An error occurred: {str(e)}', category='error')     

    return render_template("changeUserPassword.html", user=current_user, email=current_user.email)


# Route for handling user deletion
@auth.route('/deleteUser', methods=['GET', 'POST'])
def deleteUser():
    if request.method == 'POST':
        # Extracting user details from the current user
        email = current_user.email
        password1 = request.form.get('password1')
        password1 = hashlib.sha256(password1.encode()).hexdigest()

        # Validating the password
        if password1 != current_user.password:
            flash('Passwords don\'t match.', category='error')
        elif len(password1) < 7: 
            flash('Password must be at least 7 characters.', category='error')
        else:
            # Constructing the URL for deleting the user on the server
            url = server_url + 'deleteuser/' + email + '/' + password1         
            try:
                # Sending a request to the server to delete the user
                response = requests.get(url)
                if response.status_code == 200:
                    # Removing the user from the local database
                    user_to_delete = User.query.filter_by(email=email).first()
                    if user_to_delete:
                        db.session.delete(user_to_delete)
                        db.session.commit()
                        logout_user()
                        flash('User has been deleted!', category='success')
                        logout_user()
                        return redirect(url_for('auth.sign_up'))
                    else:
                        flash('Could not find the email in the session', category='error')
                else:
                    flash(f'Error: {response.status_code}', category='error')
            except Exception as e:
                flash(f'An error occurred: {str(e)}', category='error')     

    return render_template("deleteUser.html", user=current_user, email=current_user.email, user_name=current_user.first_name)





#-----------------------------------------------------------------------------------------------------
#                                          QUIZZES
#-----------------------------------------------------------------------------------------------------
# Route to render the flag quiz template.
@auth.route('/flagQuiz', methods=['GET', 'POST'])
def flagQuiz():
    return render_template("flagQuiz.html", user=current_user)


# Route to handle and render the multiple-choice quiz.
@auth.route('/multiChoiseQuiz', methods=['GET', 'POST'])
def multiChoiseQuiz():
    global correct_answers_count

    # Initialize quiz count in session if not present
    if 'quiz_count' not in session:
        session['quiz_count'] = 0

    session['quiz_count'] += 1

    # Check if the quiz count is within the limit
    if session['quiz_count'] <= 5:
        external_server_url = server_url + 'getquizbyid/1'
        try:
            response = requests.get(external_server_url)
            if response.status_code == 200:
                quiz_name = "Test-Quiz"
                description = "Welches Land ist das?"

                # Extract country data from the response
                data = response.json()
                country_data = data['country_data']
                country_data = list(map(lambda pair: pair[0], country_data))
                countries = [country for country in country_data]

                # Randomly select four countries for the quiz
                random_countries = random.sample(countries, 4)
                country_paths = ['/flags/' + country.replace(" ", " ") + '.png' for country in random_countries]

                # Randomly select one country as the correct answer
                correctLand = random.choice(country_paths)

                return render_template("multiChoiseQuiz.html", user=current_user, quiz_name=quiz_name,
                                       description=description, correctLand=correctLand, land1=country_paths[0],
                                       land2=country_paths[1], land3=country_paths[2], land4=country_paths[3],
                                       correct_answers_count=correct_answers_count)
            else:
                return f"Error: {response.status_code}"
        except Exception as e:
            return f"An error occurred: {str(e)}"
    else:
        session['quiz_count'] = 0
        return redirect(url_for('auth.learningResults', referrer='multiChoiseQuiz'))


# Route to handle and render the flag name quiz.
@auth.route('/flagNameQuiz', methods=['GET', 'POST'])
def flagNameQuiz():
    global correct_answers_count

    # Initialize quiz count in session if not present
    if 'quiz_count' not in session:
        session['quiz_count'] = 0

    session['quiz_count'] += 1

    # Check if the quiz count is within the limit
    if session['quiz_count'] <= 5:
        external_server_url = server_url + 'getquizbyid/1'
        try:
            response = requests.get(external_server_url)
            if response.status_code == 200:
                quiz_name = "4 Flags Quiz"
                description = "What are the names of these countries?"

                # Extract country data from the response
                data = response.json()
                country_data = data['country_data']
                country_data = list(map(lambda pair: pair[0], country_data))
                countries = [country for country in country_data]

                # Randomly select four countries for the quiz
                random_countries = random.sample(countries, 4)
                country_paths = ['/flags/' + country.replace(" ", " ") + '.png' for country in random_countries]
                country_names = [country.replace("_", " ") for country in random_countries]

                return render_template("flagNameQuiz.html", user=current_user, quiz_name=quiz_name,
                                       description=description, land1=country_paths[0], land2=country_paths[1],
                                       land3=country_paths[2], land4=country_paths[3], land_names=country_names)
            else:
                return f"Error: {response.status_code}"
        except Exception as e:
            return f"An error occurred: {str(e)}"

    else:
        session['quiz_count'] = 0
        return redirect(url_for('auth.learningResults', referrer='flagNameQuiz'))

        
# Route to handle and render the single flag name quiz.
@auth.route('/singleFlagNameQuiz', methods=['GET', 'POST'])
def singleFlagNameQuiz():
    global correct_answers_count

    # Initialize quiz count in session if not present
    if 'quiz_count' not in session:
        session['quiz_count'] = 0

    session['quiz_count'] += 1

    # Check if the quiz count is within the limit
    if session['quiz_count'] <= 5:
        external_server_url = server_url + 'getquizbyid/1'
        try:
            response = requests.get(external_server_url)

            if response.status_code == 200:
                quiz_name = "Test-Quiz"
                description = "What are the names of these countries?"

                # Extract country data from the response
                data = response.json()
                country_data = data['country_data']
                country_data = list(map(lambda pair: pair[0], country_data))

                # Randomly select a country for the quiz
                random_country = random.choice(country_data)
                country_path = "/flags/" + random_country.replace(" ", " ") + '.png'
                country_name = random_country.replace("_", " ")

                return render_template("singleFlagNameQuiz.html", user=current_user, quiz_name=quiz_name,
                                       description=description, land=country_path, land_name=country_name)
            else:
                return f"Error: {response.status_code}"
        except Exception as e:
            return f"An error occurred: {str(e)}"
    else:
        session['quiz_count'] = 0
        return redirect(url_for('auth.learningResults', referrer='singleFlagNameQuiz'))


# Route to handle and render the two flags quiz.
@auth.route('/twoFlagsQuiz', methods=['GET', 'POST'])
def twoFlagsQuiz():
    global correct_answers_count

    # Initialize quiz count in session if not present
    if 'quiz_count' not in session:
        session['quiz_count'] = 0

    session['quiz_count'] += 1

    # Check if the quiz count is within the limit
    if session['quiz_count'] <= 5:
        external_server_url = server_url + 'getquizbyid/1'
        try:
            response = requests.get(external_server_url)

            if response.status_code == 200:
                quiz_name = "Test-Quiz"

                # Extract country data from the response
                data = response.json()
                country_data = data['country_data']
                country_data = list(map(lambda pair: pair[0], country_data))
                countries = [country for country in country_data]

                # Randomly select two countries for the quiz
                random_country1 = random.choice(countries)
                random_country2 = random.choice(countries)
                whole_path1 = "/flags/" + random_country1.replace(" ", " ") + '.png'
                whole_path2 = "/flags/" + random_country2.replace(" ", " ") + '.png'

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
        session['quiz_count'] = 0
        return redirect(url_for('auth.learningResults', referrer='twoFlagsQuiz'))

    
# Route to handle and render server quizzes based on quiz type.
@auth.route('/serverQuiz/<quizId>', methods=['GET', 'POST'])
def serverQuiz(quizId):
    # External server URL to fetch quiz data.
    external_server_url = server_url + 'getquizbyid/' + quizId

    try:
        # Make a request to the external server to get quiz data.
        response = requests.get(external_server_url)
        
        if response.status_code == 200:
            # Parse the JSON response.
            data = response.json()

            # Extract quiz details from the data.
            quiz_name = data['quiz_name']
            description = data['description']
            country_data = data['country_data']
            quiz_type = data['quiz_type']

            # Route to the appropriate handler based on quiz type.
            if quiz_type == 'flagquiz':
                return handle_flag_quiz(quiz_name, description, country_data, quizId)
            elif quiz_type == 'mapquiz':
                return handle_map_quiz(country_data, quiz_name, description, quizId)
            elif quiz_type == 'tablequiz':
                return handle_table_quiz(quiz_name, description, country_data, quizId)
            elif quiz_type == 'neighboringcountries':
                return handle_neighboringcountries_quiz(quiz_name, description, country_data, quizId)
        else:
            return f"Error: {response.status_code}"
    except Exception as e:
        return f"An error occurred: {str(e)}"


# Function to handle and render flag quiz page.
def handle_flag_quiz(quiz_name, description, country_data, quizId):
    # Extract only the country names from the provided country data.
    country_data = list(map(lambda pair: pair[0], country_data))

    # Render the flag quiz template.
    return render_template('serverQuiz.html', quiz_name=quiz_name, description=description, country_data=country_data, 
                           user=current_user, quizId=quizId, server_url=server_url)

    
# Function to handle and render the map quiz page.
def handle_map_quiz(country_data, quiz_name, description, quizId):
    # Extract country names from the provided country data.
    county_names = country_data
    country_names_list = [country[0] for country in county_names]
    
    # Set the maximum points for the quiz based on the number of countries.
    max_points = len(country_names_list)
    
    # Global variables for managing the state of the map quiz.
    global selected_countries
    global is_reset
    global first_time
    global selected_country
    
    # Initialize variables for the first-time flag and user messages.
    first_time = True
    message = ""
    
    # Generate the initial SVG map if it's the first time.
    if first_time:
        svg_map_tuple = plot([' '], opacity=opacity * len(selected_countries), cmap='ocean')
        first_time = False
    
    # Handle form submissions for the map quiz.
    if request.method == 'POST':
        if is_reset:
            try:
                # Delete SVG file and reset selected countries.
                delete_svg_file()
                svg_map_tuple = plot([' '], opacity=opacity * len(selected_countries), cmap='ocean')
                is_reset = False
            except Exception as e:
                message = f"An error occurred while generating the map: {e}"
        else:
            # Get the selected country from the form.
            selected_country = capitalize_first_letter(request.form.get('country'))
            
            # Check if the selected country is valid and process accordingly.
            valid_country_found = False
            for select in county_names:
                if select[0] == selected_country:
                    if selected_country not in selected_countries:
                        # Add the selected country to the list.
                        selected_countries.append(selected_country)
                        message = f"{selected_country} added."
                        valid_country_found = True
                        try:
                            # Generate the updated SVG map.
                            svg_map_tuple = plot(selected_countries, opacity=opacity * len(selected_countries), cmap='Green')
                        except Exception as e:
                            message = f"An error occurred while generating the map: {e}"
                    else:
                        message = f"{selected_country} is already selected."
                    break
            
            if not valid_country_found:
                message = f"{selected_country} is not a valid country."
    
    # Save selected countries to the text file before rendering the template.
    save_selected_countries()
    return render_template('worldmapQuiz.html', map_exists=True, message=message, 
                           selected_countries=selected_countries, quiz_name=quiz_name, 
                           description=description, user=current_user, 
                           country_names_list=country_names_list, max_points=max_points, 
                           county_names=county_names, quizId=quizId)


# Function to handle and render the table quiz page.
def handle_table_quiz(quiz_name, description, country_data, quizId):
    
    return render_template('tableQuiz.html', quiz_name=quiz_name, description=description, country_data=country_data, 
                           user=current_user, quizId=quizId, server_url=server_url)

    
# Render the template for the neighboring countries quiz.
def handle_neighboringcountries_quiz(quiz_name, description, country_data, quizId):
    # Convert the 'country_data' string, which represents a dictionary, to a Python dictionary
    country_data = ast.literal_eval(country_data)
    full_names = alternate_spellings(country_data)
    print(type(full_names))
    return render_template('neighboringcountriesQuiz.html', quiz_name=quiz_name, description=description, country_data=full_names, 
                           user=current_user, quizId=quizId, server_url=server_url)


# Get alternative spellings for country names.
def alternate_spellings(country_codes):
    if isinstance(country_codes, str):
        country_codes = ast.literal_eval(country_codes)
    external_server_url = server_url + 'getallalternativespellings'
    try:
        response = requests.get(external_server_url)
        if response.status_code == 200:
            country_data = response.json()
            country_names = []
            for code in country_codes:
                if code in country_data:
                    for name in country_data[code]:
                        if len(name) > 3:
                            country_names.append(name)
            return country_names
        else:
            return f"Error: {response.status_code}"
    except Exception as e:
        return f"An error occurred: {str(e)}"






#-----------------------------------------------------------------------------------------------------
#                                        ALLGEMEIN
#-----------------------------------------------------------------------------------------------------

# Route for the home page
@auth.route('/homepage', methods=['GET', 'POST'])
def homepage():
    # Constructing the URL for fetching quiz overview from the external server
    external_server_url = server_url + 'getquizoverview'

    try:
        # Sending a request to the external server to get quiz overview
        response = requests.get(external_server_url)
        if response.status_code == 200:
            # Parsing the response JSON and extracting the last 5 quiz entries
            data = response.json()
            last_5_entries = data["quiz_data"][-5:]
            names = [item[1] for item in last_5_entries]
            types = [item[2] for item in last_5_entries]

            return render_template('homepage.html', last_5_entries=last_5_entries, names=names,
                                   types=types, user=current_user)
        else:
            return f"Error: {response.status_code}"
    except Exception as e:
        return f"An error occurred: {str(e)}"

# Route for showing a picture
@auth.route('/show_pic')
def show_pic():
    # Setting the path for the picture to be displayed
    pic_path = 'static/LOGO.png'
    return send_file(pic_path, mimetype='image/png')


# Route for fetching the profile picture
@auth.route('/profile_picture')
def profile_picture():
    # Setting the path for the default profile picture
    pic_path = "static/blank-profile-picture-973460_960_720.webp"
    return send_file(pic_path, mimetype='image/png')


# Route for the user profile page
@auth.route('/profileSite', methods=['GET', 'POST'])
def profileSite():
    # Extracting user email and constructing the URL for fetching username and level
    email = current_user.email
    external_server_url = server_url + 'getusernameandlevel/' + email

    try:
        # Sending a request to the external server to get username and level
        response = requests.get(external_server_url)
        if response.status_code == 200:
            # Parsing the response JSON and extracting user level
            data = response.json()
            level = data['level']

            return render_template("profileSite.html", user=current_user, user_email=current_user.email,
                                   user_name=current_user.first_name, level=level)
        else:
            return f"Error: {response.status_code}"
    except Exception as e:
        return f"An error occurred: {str(e)}"

    
    
    
        
#-----------------------------------------------------------------------------------------------------
#                                        ALLE FLAGGEN
#-----------------------------------------------------------------------------------------------------

# Route for displaying all flags
@auth.route('/allFlags', methods=['GET', 'POST'])
def allFlags():
    # Constructing the URL for fetching country data from the external server
    external_server_url = server_url + 'getquizbyid/1'

    try:
        # Sending a request to the external server to get country data
        response = requests.get(external_server_url)
        if response.status_code == 200:
            # Parsing the response JSON and extracting country data
            data = response.json()
            country_data = data['country_data']

            # Extracting country names and replacing spaces in the names
            country_names = [country[0].replace(' ', ' ') for country in country_data]

            return render_template('allFlags.html', country_names=country_names, user=current_user)
        else:
            return f"Error: {response.status_code}"
    except Exception as e:
        return f"An error occurred: {str(e)}"


# Route for displaying all flags grouped by continent
@auth.route('/allFlagsByContinent', methods=['GET', 'POST'])
def allFlagsByContinent():
    # Constructing the URLs for fetching country data from the external server for different continents
    external_server_url_2 = server_url + 'getquizbyid/2'
    external_server_url_3 = server_url + 'getquizbyid/3'
    external_server_url_4 = server_url + 'getquizbyid/4'
    external_server_url_5 = server_url + 'getquizbyid/5'
    external_server_url_6 = server_url + 'getquizbyid/6'
    external_server_url_7 = server_url + 'getquizbyid/7'

    try:
        # Sending requests to the external server to get country data for different continents
        response2 = requests.get(external_server_url_2)
        response3 = requests.get(external_server_url_3)
        response4 = requests.get(external_server_url_4)
        response5 = requests.get(external_server_url_5)
        response6 = requests.get(external_server_url_6)
        response7 = requests.get(external_server_url_7)

        # Checking if all requests were successful (status code 200)
        if response2.status_code and response3.status_code and response4.status_code and response5.status_code and response6.status_code and response7.status_code == 200:
            country_names_list = []
            response_list = [response2, response3, response4, response5, response6, response7]

            # Extracting country names for each continent and appending to the list
            for response in response_list:
                data = response.json()
                country_data = data['country_data']
                country_names = [country[0].replace(' ', ' ') for country in country_data]
                country_names_list.append(country_names)

            return render_template('allFlagsByContinent.html', country_names_list=country_names_list, user=current_user)
        else:
            return f"Error: {response2.status_code}"
    except Exception as e:
        return f"An error occurred: {str(e)}"



#-----------------------------------------------------------------------------------------------------
#                                        ÜBERSICHT
#-----------------------------------------------------------------------------------------------------

# Route for displaying a flag overview with quiz information
@auth.route('/serverQuizzesOverview', methods=['GET', 'POST'])
def serverQuizzesOverview():
    # Constructing the URL for fetching quiz overview data from the external server
    external_server_url = server_url + 'getquizoverview'

    try:
        # Sending a request to the external server to get quiz overview data
        response = requests.get(external_server_url)
        if response.status_code == 200:
            # Parsing the response JSON and extracting quiz data
            data = response.json()
            quiz_data = data["quiz_data"]
            quiz_ids = []
            quiz_names = []
            quiz_types = []
            count = 0

            # Extracting quiz information and counting the number of quizzes
            for quiz in quiz_data:
                count += 1
                quiz_ids.append(quiz[0])
                quiz_names.append(quiz[1])
                quiz_types.append(quiz[2])

            # Getting high scores for quizzes
            high_scores = get_high_scores()

            return render_template('serverQuizzesOverview.html', quiz_ids=quiz_ids, quiz_names=quiz_names,
                                   quiz_types=quiz_types, count=count, high_scores=high_scores, user=current_user)
        else:
            return f"Error: {response.status_code}"
    except Exception as e:
        return f"An error occurred: {str(e)}"


# Route for displaying the learn page
@auth.route('/learningQuizzesOverview', methods=['GET', 'POST'])
def learningQuizzesOverview():
    return render_template("learningQuizzesOverview.html", user=current_user)





#-----------------------------------------------------------------------------------------------------
#                                      PUNKTE/LEVEL VERWALTUNG
#-----------------------------------------------------------------------------------------------------

# Function to fetch high scores for the current user from the external server
def get_high_scores():
    # Constructing the URL for fetching high scores
    external_server_url = server_url + 'getallscores/' + current_user.email

    try:
        # Sending a request to the external server to get high scores
        response = requests.get(external_server_url)
        if response.status_code == 200:
            # Parsing the response JSON and returning the high score data
            data = response.json()
            return data
        else:
            return f"Error: {response.status_code}"
    except Exception as e:
        return f"An error occurred: {str(e)}"


# Route for displaying learning results based on the referrer
@auth.route('/learningResults/<referrer>', methods=['GET', 'POST'])
def learningResults(referrer):
    # Calculating the total count of correct and wrong answers
    global correct_answers_count
    global wrong_answer_count
    sum = correct_answers_count + wrong_answer_count

    return render_template("learningResults.html", user=current_user, correct_answers_count=correct_answers_count,
                           wrong_answer_count=wrong_answer_count, sum=sum, referrer=referrer)


# Route for resetting points (correct and wrong answer counts)
@auth.route('/reset_points/<referrer>')
def reset_points(referrer):
    # Resetting global counters for correct and wrong answers
    global correct_answers_count
    global wrong_answer_count
    correct_answers_count = 0
    wrong_answer_count = 0
    session['quiz_count'] = 0

    # Redirecting to the appropriate quiz based on the referrer
    if referrer:
        if referrer == 'multiChoiseQuiz':
            return redirect(url_for('auth.multiChoiseQuiz'))

        elif referrer == 'singleFlagNameQuiz':
            return redirect(url_for('auth.singleFlagNameQuiz'))

        elif referrer == 'flagNameQuiz':
            return redirect(url_for('auth.flagNameQuiz'))

        elif referrer == 'twoFlagsQuiz':
            return redirect(url_for('auth.twoFlagsQuiz'))

        elif referrer == 'textQuiz':
            return redirect(url_for('auth.textQuiz'))

    return redirect(url_for('auth.homepage'))


# Route to check if the selected answer is correct and update counts
@auth.route('/check_answer/<selected_answer>', methods=['POST'])
def check_answer(selected_answer):
    global correct_answers_count
    global wrong_answer_count

    # Getting the correct answer from the form
    correct_answer = request.form.get('correct_answer')

    # Checking if the selected answer is correct and updating counts
    is_correct = selected_answer == correct_answer
    if is_correct:
        correct_answers_count += 1
    else:
        wrong_answer_count += 1

    # Returning JSON response indicating correctness and updated counts
    return jsonify({'is_correct': is_correct, 'correct_answers_count': correct_answers_count})


# Route to set and update the user's score for a quiz
@auth.route('/set_score', methods=['GET', 'POST'])
def set_score():
    try:
        if request.method == 'POST':
            # Extracting data from the JSON request
            email = current_user.email
            data = request.get_json()
            quiz_id = data['quiz_id']
            score = data['score']
            achievable_score = data['achievable_score']
            needed_time = data['needed_time']

            # Constructing the URL to set the user's score on the external server
            external_server_url = server_url + 'setscore/' + email + '/' + str(quiz_id) + '/' + str(score) + '/' + str(achievable_score) + '/' + str(needed_time)

            # Sending a request to the external server to set the score
            response = requests.get(external_server_url)

            if response.status_code == 200:
                # Parsing the response JSON and checking for success or high score
                data = response.json()
                message_type = data.get('message_type')
                print(response.content)

                # Checking if the user's level should be increased
                check_level_increase()

                if message_type == 'Success':
                    flash("New Highscore", category="Success")

                return "Success"
            else:
                return f"Error: {response.status_code}"
    except Exception as e:
        print(str(e))
        return f"An error occurred: {str(e)}", 500


# Function to check if the user's level should be increased based on accumulated points and time
def check_level_increase():
    try:
        # Constructing the URL to fetch all scores for the current user
        external_server_url = server_url + 'getallscores/' + current_user.email
        response = requests.get(external_server_url)

        if response.status_code == 200:
            # Parsing the response JSON to calculate various sums related to points and time
            data = response.json()
            points_sum = sum(item[2] for item in data if item[2] == item[3])
            time_sum = sum(item[4] for item in data)
            points_per_time_sum = sum(100 / item[4] for item in data) if time_sum > 0 else 0
            whole_sum = points_sum + points_per_time_sum
            current_level = get_user_level()

            # Checking different level thresholds and increasing the level if necessary
            if whole_sum < 500 and current_level != 1:
                increase_level(1)
            elif 500 <= whole_sum < 1000 and current_level != 2:
                increase_level(1)
            elif 1000 <= whole_sum < 1500 and current_level != 3:
                increase_level(1)
            elif 1500 <= whole_sum < 2000 and current_level != 4:
                increase_level(1)
            elif 2000 <= whole_sum < 3000 and current_level != 5:
                increase_level(1)
            elif whole_sum >= 3000 and current_level != 6:
                increase_level(1)
        else:
            return f"Error: {response.status_code}"
    except Exception as e:
        return f"An error occurred: {str(e)}"


# Function to increase the user's level by a specified number
def increase_level(number):
    try:
        # Constructing the URL to increase the user's level
        external_server_url = server_url + 'increaselevel/' + current_user.email + '/' + str(number)
        response = requests.get(external_server_url)

        if response.status_code == 200:
            flash("You have reached a new Level", category="success")
        else:
            return f"Error: {response.status_code}"
    except Exception as e:
        return f"An error occurred: {str(e)}"


# Function to get the user's current level
def get_user_level():
    email = current_user.email
    external_server_url = server_url + 'getusernameandlevel/' + email

    try:
        # Fetching user data, including the current level, from the external server
        response = requests.get(external_server_url)

        if response.status_code == 200:
            # Parsing the response JSON to extract and return the user's level
            data = response.json()
            level = data['level']
            return level
        else:
            return f"Error: {response.status_code}"
    except Exception as e:
        return f"An error occurred: {str(e)}"

        
        
        
        
#-----------------------------------------------------------------------------------------------------
#                                         WELTKARTE
#-----------------------------------------------------------------------------------------------------
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

# Method to save selected countries to a text file
def save_selected_countries():
    """Function to save selected countries to a text file."""
    with open(filename, 'w') as f:
        json.dump(selected_countries, f)

# Function to delete selected countries from the file
def delete_selected_countries():
    #Resets the selected countries list and file to contain only an empty space.
    global selected_countries
    global selected_country
    with open(filename, 'w') as f:
        json.dump([" "], f)
    selected_countries = [' ']
    selected_country = [' ']

# Function to load selected countries from a text file
def load_selected_countries():
    #Attempts to load selected countries from the file. If the file doesn't exist,
    #initializes the selected countries with an empty space
    global selected_countries
    global selected_country
    try:
        with open(filename, 'r') as f:
            selected_countries = json.load(f)
    except FileNotFoundError:
        selected_countries = [' ']
    selected_country = [' ']

# Function to generate an empty SVG map
def generate_empty_svg_map():
    #Creates an empty SVG map using the plot function.
    try:
        svg_map_tuple = plot(None, opacity=opacity, cmap='Set1')  # Passing None to create an empty map
        return svg_map_tuple
    except Exception as e:
        return None

# Function to delete the SVG file and reset selected countries
def delete_svg_file():
    #Deletes the existing SVG file, resets the selected countries list and file to contain only an empty space,
    #and generates an empty SVG map

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


# Function to clear the selected countries file
def clear_selected_countries_file():
    #Resets the selected countries list and file to contain only an empty space
    with open(filename, 'w') as f:
        json.dump([" "], f)

# Function to run before the first request is processed
@auth.before_request
def before_request():
    global file_cleared
    global selected_countries
    global selected_country
    # Clear selected_countries.txt file only if it hasn't been cleared before
    if not file_cleared:
        clear_selected_countries_file()
        file_cleared = True
        selected_countries = [" "]
        selected_country = " "

load_selected_countries()  

# Route for the index page
@auth.route('/worldmapQuiz', methods=['GET', 'POST'])
def worldmapQuiz():
    global selected_countries
    global is_reset
    global first_time
    global selected_country
    first_time = True
    message = ""  # Variable to store messages for the user
    
    # Generate initial SVG map if it's the first time accessing the page
    if(first_time):
        svg_map_tuple = plot([' '], opacity=opacity * len(selected_countries), cmap='ocean')
        first_time = False
   
    # Handle form submission
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
            
            # Check if selected country is valid
            if selected_country in county2_names:
                if selected_country not in selected_countries:
                    selected_countries.append(selected_country)  # Add selected country to the list
                    message = f"{selected_country} added."
                    
                    # Generate SVG map with updated selected countries
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
    return render_template('worldmapQuiz.html', map_exists=True, message=message, selected_countries=selected_countries, user=current_user)

#Route to reset selected countries
@auth.route('/reset', methods=['GET', 'POST'])
def reset():
    global selected_countries
    global is_reset 
    is_reset = True
    
    # Delete SVG file and reset selected countries
    if(delete_svg_file()):
        return jsonify({'success': True})
    else: 
        return False
