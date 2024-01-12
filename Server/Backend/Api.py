import uvicorn
from fastapi import FastAPI
import json
import ArrangeDataForApi as ad

app = FastAPI()

# ----- QUIZ -----

# GET QUIZ OVERVIEW - API
@app.get("/getquizoverview")
def getquizoverview():
    return ad.get_quiz_overview() # {"quiz_data": quiz_data} -> quiz_data = [[quiz_id, name], ...]
##TODO GEHT

# GET QUIZ BY ID - API
@app.get("/getquizbyid/{id}") # /getquizbyid/id
def getquiz(id: int):
    return ad.get_quiz_by_id(id) # {"quiz_id": quiz_id, "quiz_name": name, "discription": discription, "country_data": country_data}
##TODO GEHT

# ----- USER -----

# CREATE NEW USER - API
@app.get("/createnewuser/{email}/{username}/{password}") # /createnewuser/email/username/password
def createnewuser(email: str, username: str, password: str):
    return ad.create_new_user(email, username, password) # {"message_type": message_type,"message": message}
##TODO GEHT

# USER LOGIN - API
@app.get("/login/{email}/{password}") # /createnewuser/email/password
def login(email: str, password: str):
    ##TODO MAYBE BRAUCHMA DA NO DASS DA USER MIT ZRUGGEBEN WIRT MUSS NO MIT LUCA DRÜBER REDEN
    return ad.user_login(email, password) # {"message_type": message_type,"message": message}
##TODO GEHT

##TODO USER LÖSCHEN, PASSWORT ÄNDERN, EMAIL ÄNDERN, NUTZERNAME ÄNDERN

##TODO HIGHSCORE SCHICKEN, HIGHSCORE ABRUFEN, ...

if __name__ == "__main__":
    uvicorn.run(app, host="localhost", port=8080)