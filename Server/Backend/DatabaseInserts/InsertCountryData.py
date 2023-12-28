import DataForContries as d
import mysql.connector
import json

#ALL KEYS IN DATAFORDATABASE
#   ['name', 'tld', 'cca2', 'ccn3', 'cca3', 'independent', 'status', 'unMember', 'currencies', 'idd', 'capital', 'altSpellings', 'region', 'subregion', 
#   'languages', 'translations', 'latlng', 'landlocked', 'area', 'demonyms', 'flag', 'maps', 'population', 'car', 'timezones', 'continents', 'flags', 
#   'coatOfArms', 'startOfWeek', 'capitalInfo', 'postalCode', 'cioc', 'borders', 'fifa', 'gini']

#KEYS WE USE
#   ['name', 'cca2', 'cca3', 'independent', 'status', 'unMember', 'currencies', 'capital',
#   'languages', 'landlocked', 'area', 'population', 'car', 'timezones', 'continents', 'borders']

#FIELDS IN DATABASE
#   name (string), official_name (string), cca2 (string), cca3 (string), independent (boolean), status (string), un_member (boolean), currencies (list), 
#   capital (list), languages (list), landlocked (boolean), area (float), population (int), timezones (list), continent (string), borders (list)

mydb = mysql.connector.connect(
    host="localhost",
    user="root",
    password="david2003",
    database="diplomarbeit"
)
mycursor = mydb.cursor()

def arrange_insert_string(data):
    # NAME, OFFICIAL_NAME
    allnames = data['name']
    name = allnames['common'].encode('utf-8')
    name = name.decode('utf-8')
    print("\nname: " + name)
    official_name = allnames['official'].encode('utf-8')
    official_name = official_name.decode('utf-8')
    #print("official_name: " + official_name)
    
    # CCA2, CCA3
    cca2 = data['cca2']
    cca3 = data['cca3']
    #print("cca2: " + cca2 + " cca3: " + cca3)
    
    # INDEPENDENT
    if 'independent' in data:
        independent = data['independent']
    else:
        #FOR KOSOVO WHITCH DOSNT HAVE A VARIBLE CALLED INDEPENDENT
        independent = False
    #print("independent: " + str(independent))
    
    # STATUS, UN_MEMBER
    status = data['status']
    un_member = data['unMember']
    #print("status: " + status + " un_member: " + str(un_member))
    
    # CURRENCIES
    if 'currencies' in data:
        currencies = data['currencies']
    else:
        currencies = {}
    #print("currensies: " + str(currencies))
    
    # CAPITAL
    if 'capital' in data:
        allcapitals = data['capital']
        # IMMER LISTE WEIL 2 LÄNDER HABEN MEHR ALS EIENE HAUPTSTAT
        for i in allcapitals:
            i = i.encode('utf-8')
            i = i.decode('utf-8')
        capital = allcapitals
    else:
        capital = ""
    #print("capital: " + str(capital))
    
    # LANGUAGES
    languages = []
    if 'languages' in data:
        alllanguages = data['languages']
        for i in alllanguages:
            language = alllanguages[i].encode('utf-8')
            languages.append(language.decode('utf-8'))
    #print("languages: " + str(languages))
    
    # LANDLOCKED
    landlocked = data['landlocked']
    #print("landlocked: " + str(landlocked))
    
    # AREA
    area = data['area']
    #print("area: " + str(area))
    
    # POPULATION
    population = data['population']
    #print("population: " + str(population))
    
    # TIMEZONES
    timezones = data['timezones']
    #print("timezones: " + str(timezones))
    
    # CONTINENT
    #the case of two continents isnt relevant anymore, due to the fact there were 3 conties which i 
    # manualy changed to one continent (Turkey, Russia, Azerbaijan)
    continents = data['continents']
    if len(continents) > 1:
        print("Error: " + name + " has more than one continent.")
    else:
        continent = continents[0]
    #print("continent: " + str(continent))
    
    # BORDERS
    if 'borders' in data:
        borders = data['borders']
    else:
        borders = []
    #print("borders: " + str(borders))
    
    # ARRANGE INSERT STRING
    #name (string), official_name (string), cca2 (string), cca3 (string), independent (boolean), status (string), un_member (boolean), currencies (list), 
    #capital (list), languages (list), landlocked (boolean), area (float), population (int), timezones (list), continents (list), borders (list)
    returnvalue = '"' + name + '","' + official_name + '","' + cca2 + '","' + cca3 + '","' + str(int(independent)) + '","' + status + '","' + str(int(un_member)) 
    returnvalue = returnvalue + '","' + str(currencies) + '","' + str(capital) + '","' + str(languages) + '","' + str(int(landlocked)) + '","' + str(area)
    returnvalue = returnvalue + '","' + str(population) + '","' + str(timezones) + '","' + str(continent) + '","' + str(borders) + '"'
    return returnvalue

def list_to_json(values):
    values_json = json.dumps(values)
    return values_json

def insert_into_database(insertstring):
    insert_query = "INSERT INTO country VALUES (" + str(insertstring) + ")"
    try:
        mycursor.execute(insert_query)
        mydb.commit()
        print("Data inserted successfully.")
    except mysql.connector.Error as error:
        mydb.rollback()
        print(f"Error inserting record: {error}")
    

if __name__ == '__main__':
    alldata = d.data
    tempcount = 0
    for i in alldata:
        insertstring = arrange_insert_string(i)
        tempcount = tempcount + 1
        print("\n" + insertstring)
        insert_into_database(insertstring)
        print(tempcount)
    mycursor.close()
    mydb.close()
    ##TODO UMBAUEN SO DASS MIT INSTALATIONSDATEI AUFGERUFEN WIRD
    