from flask import Flask, render_template, request, send_file, url_for, jsonify
from libr.worldmap.worldmap import plot
#import worldmap as wm
import libr.worldmap.worldmap.worldmap as wm
import io
import os
import shutil
from matplotlib.colors import ListedColormap

app = Flask(__name__)

# Sample data
county_names = wm.list_county_names(map_name='world')


selected_countries = [' ']
selected_country = None
opacity = 0.5
single_color_cmap = ListedColormap(['#06d009'])  
# Einmal Aufrufen damit es kein no URL found
#svg_map_tuple = plot(selected_countries, opacity=[opacity] * len(selected_countries), cmap='Set1')
# Nutzerfreundlicher -> immer den ersten Buchstaben capital
def capitalize_first_letter(text):
    return text.capitalize()

# Function to delete the SVG file and reset selected_countries
def delete_svg_file():
    selected_countries = [' ']
    try:
        os.remove("static/custom_map.svg")
        selected_countries = [' ']
    except OSError:
        print('OK')
        pass



@app.route('/', methods=['GET', 'POST'])
def index():
    global selected_countries
    message = ""
    
    map_exists = False
    if request.method == 'POST':
        selected_country = capitalize_first_letter(request.form.get('country'))    
        if selected_country in county_names:
            if selected_country not in selected_countries:
                selected_countries.append(selected_country)
                message = f"{selected_country} added."
                try:
                    svg_map_tuple = plot(selected_countries, opacity= opacity* len(selected_countries), cmap = 'Set1')
                except Exception as e:
                    message = f"An error occurred while generating the map: {e}"
            else:
                message = f"{selected_country} is already selected."
        else:
            message = f"{selected_country} is not a valid country."

    return render_template('index.html', map_exists=map_exists, message=message, selected_countries=selected_countries)
@app.route('/reset', methods=['GET', 'POST'])
def reset():
    global selected_countries
    selected_countries = [' ']
    delete_svg_file()
    return jsonify({'success': True})



if __name__ == '__main__':
    app.run(debug=True)