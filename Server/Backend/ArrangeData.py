import DbConnector as dbc
import json

# GET QUIZ OVERVIEW - FILTER UND ARRANGE JSON STRING
def get_quiz_overview():
    quiz_data = dbc.get_quiz_overview()
    json_string = {
        "quiz_data": quiz_data
    }
    return json_string

# GET QUIZ BY ID - FILTER AND ARRAGE JSON STRING
def get_quiz_by_id(id):
    quiz_data = dbc.get_quiz_by_id(id)
    row = quiz_data[0]
    quiz_id, quiz_name, discription, quiz_type, needed_properties, criteria, specific_criteria = row
    if quiz_type == "mapQuiz":
        country_data = dbc.get_countries_by_quiz(needed_properties, criteria, specific_criteria)
        json_string = {
            "quiz_id": quiz_id,
            "quiz_name": quiz_name,
            "discription": discription,
            "country_data": country_data
        }
        return json_string
    return "quiz type not existing"
