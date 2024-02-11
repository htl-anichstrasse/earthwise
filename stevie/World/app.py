from flask import Flask, render_template, request, jsonify
from libr.worldmap.worldmap import plot  # Importing plot function from worldmap module
import libr.worldmap.worldmap.worldmap as wm
import io
import os
from os import path
import shutil
from matplotlib.colors import ListedColormap
import json
from flask_compress import Compress

app = Flask(__name__)  # Creating a Flask application instance
compress = Compress(app)  # Initializing the compression extension

# List of county names from the world map
county_names = wm.list_county_names(map_name='world')

# Initializing variables
selected_countries = [' ']
selected_country = [' ']
opacity = 0.5
single_color_cmap = ListedColormap(['#06d009'])  
filename='World\static\selected_countries.txt'  # File path to store selected countries
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
    if(os.path.exists('World\static\custom_map.svg')):
        os.remove("World\static\custom_map.svg")
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


@app.before_request
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


@app.route('/', methods=['GET', 'POST'])
def index():
    """Route for the index page."""
    global selected_countries
    global is_reset
    global first_time
    global selected_country
    message = ""  # Variable to store messages for the user
    svg_map_tuple = plot([' '], opacity=opacity * len(selected_countries), cmap='ocean')  # Generate initial SVG map

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
            if selected_country in county_names:  # Check if selected country is valid
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
    return render_template('index.html', map_exists=True, message=message, selected_countries=selected_countries)


@app.route('/reset', methods=['GET', 'POST'])
def reset():
    """Route to reset selected countries."""
    global selected_countries
    global is_reset 
    is_reset = True
    if(delete_svg_file()):
        return jsonify({'success': True})
    else: 
        return False


if __name__ == '__main__':
    app.run(debug=True)  # Run the Flask application
