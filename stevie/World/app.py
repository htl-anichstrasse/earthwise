from flask import Flask, render_template, request, send_file, url_for
from libr.worldmap.worldmap import plot
import worldmap as wm
#import libr.worldmap.worldmap.worldmap as wm
import io
import os
import shutil

app = Flask(__name__)

# Sample data
county_names = ['Andorra','United Arab Emirates','Afghanistan','Antigua and Barbuda',
 'Anguilla','Albania','Armenia','Angola','Argentina','American Samoa',
 'Austria','Australia','Aruba','Aland Islands','Azerbaijan',
 'Bosnia and Herzegovina','Barbados','Bangladesh','Belgium','Burkina Faso',
 'Bulgaria','Bahrain','Burundi','Benin','Saint Barthelemy',
 'Brunei Darussalam','Bolivia','Bermuda',
 'Bonaire, Sint Eustatius and Saba','Brazil','Bahamas','Bhutan',
 'Bouvet Island','Botswana','Belarus','Belize','Canada',
 'Cocos (Keeling) Islands','Democratic Republic of Congo',
 'Central African Republic','Republic of Congo','Switzerland',
 "Côte d'Ivoire" ,'Cook Islands','Chile','Cameroon','China','Colombia',
 'Costa Rica','Cuba','Cape Verde','Curaçao','Christmas Island','Cyprus',
 'Czech Republic','Germany','Djibouti','Denmark','Dominica',
 'Dominican Republic','Algeria','Ecuador','Egypt','Estonia',
 'Western Sahara','Eritrea','Spain','Ethiopia','Finland','Fiji',
 'Falkland Islands','Federated States of Micronesia','Faroe Islands',
 'France','Gabon','United Kingdom','Georgia','Grenada','French Guiana',
 'Guernsey','Ghana','Gibraltar','Greenland','Gambia','Guinea',
 'Glorioso Islands','Guadeloupe','Equatorial Guinea','Greece',
 'South Georgia and South Sandwich Islands','Guatemala','Guam',
 'Guinea-Bissau','Guyana','Hong Kong','Heard Island and McDonald Islands',
 'Honduras','Croatia','Haiti','Hungary','Indonesia','Ireland','Israel',
 'Isle of Man','India','British Indian Ocean Territory','Iraq','Iran',
 'Iceland','Italy','Jersey','Jamaica','Jordan','Japan',
 'Juan De Nova Island','Kenya','Kyrgyzstan','Cambodia','Kiribati',
 'Comoros','Saint Kitts and Nevis','North Korea','South Korea','Kosovo',
 'Kuwait','Cayman Islands','Kazakhstan', "Lao People's Democratic Republic",
 'Lebanon','Saint Lucia','Liechtenstein','Sri Lanka','Liberia','Lesotho',
 'Lithuania','Luxembourg','Latvia','Libya','Morocco','Monaco','Moldova',
 'Madagascar','Montenegro','Saint Martin','Marshall Islands','Macedonia',
 'Mali','Macau','Myanmar','Mongolia','Northern Mariana Islands',
 'Martinique','Mauritania','Montserrat','Malta','Mauritius','Maldives',
 'Malawi','Mexico','Malaysia','Mozambique','Namibia','New Caledonia',
 'Niger','Norfolk Island','Nigeria','Nicaragua','Netherlands','Norway',
 'Nepal','Nauru','Niue','New Zealand','Oman','Panama','Peru',
 'French Polynesia','Papua New Guinea','Philippines','Pakistan','Poland',
 'Saint Pierre and Miquelon','Pitcairn Islands','Puerto Rico',
 'Palestinian Territories','Portugal','Palau','Paraguay','Qatar','Reunion',
 'Romania','Serbia','Russia','Rwanda','Saudi Arabia','Solomon Islands',
 'Seychelles','Sudan','Sweden','Singapore','Saint Helena','Slovenia',
 'Svalbard and Jan Mayen','Slovakia','Sierra Leone','San Marino','Senegal',
 'Somalia','Suriname','South Sudan','Sao Tome and Principe','El Salvador',
 'Sint Maarten','Syria','Swaziland','Turks and Caicos Islands','Chad',
 'French Southern and Antarctic Lands','Togo','Thailand','Tajikistan',
 'Tokelau','Timor-Leste','Turkmenistan','Tunisia','Tonga','Turkey',
 'Trinidad and Tobago','Tuvalu','Taiwan','Tanzania','Ukraine','Uganda',
 'Jarvis Island','Baker Island','Howland Island','Johnston Atoll',
 'Midway Islands','Wake Island','United States','Uruguay','Uzbekistan',
 'Vatican City','Saint Vincent and the Grenadines','Venezuela',
 'British Virgin Islands','US Virgin Islands','Vietnam','Vanuatu',
 'Wallis and Futuna','Samoa','Yemen','Mayotte','South Africa','Zambia',
 'Zimbabwe']
selected_countries = ['']
opacity = 0.5  # Apply the same opacity to all selected countries

@app.route('/', methods=['GET', 'POST'])
def index():
    global selected_countries
    message = ""

    if request.method == 'POST':
        selected_country = request.form.get('country')

        if selected_country in county_names:
            if selected_country not in selected_countries:
                selected_countries.append(selected_country)
                message = f"{selected_country} added."
            else:
                message = f"{selected_country} is already selected."
        else:
            message = f"{selected_country} is not a valid country."

    # Create the SVG map
    svg_map_tuple = wm.plot(selected_countries, opacity=opacity, map_name='world', cmap='Set1')
    svg_map_df = svg_map_tuple[0]  # Extract the DataFrame from the tuple

    # Convert the DataFrame to a string
    svg_map_str = svg_map_df.to_string(index=False)

    # Save the SVG map in the static folder
    file_path = os.path.join('static', 'world_map.svg')
    with open(file_path, 'w') as file:
        file.write(svg_map_str)

    # Render the HTML template
    return render_template('index.html', map_url=url_for('static', filename='custom_map.svg'), message=message)

if __name__ == '__main__':
    app.run(debug=True)
