import uvicorn
from fastapi import FastAPI
import json
import ArrangeDataForApi as ad

app = FastAPI()

# ----- QUIZ -----
##TODO DA FEHLT A NO WAS

# GET QUIZ OVERVIEW (to display all quizzes in an overview)
@app.get("/getquizoverview") # /getquizoverview
def getquizoverview():
    return ad.get_quiz_overview() # {"quiz_data": [[quiz_id, name, quiz_type], ...]}
##TODO GEHT

# GET QUIZ BY ID (to get all the data from a quiz by id)
@app.get("/getquizbyid/{id}") # /getquizbyid/id
def getquiz(id: int):
    return ad.get_quiz_by_id(id) # {"quiz_id": quiz_id, "quiz_name": name, "discription": discription, "country_data": country_data}
##TODO GEHT

# GET ALL QUIZ DATA (for the offline version of the app to save the quizzes in a text document)
@app.get("/getallquizdata") # /getallquizdata
def getallquizdata():
    return ad.get_all_quiz_data() # [{"quiz_id": quiz_id,"quiz_name":name,"discription": discription,"quiz_type":quiz_type,"country_data":["cca2","cca2", ...]}, ... ]
##TODO GEHT

# ----- USER -----
##TODO FERTIG

# CREATE NEW USER (to create a new user)
@app.get("/createnewuser/{email}/{username}/{password}") # /createnewuser/email/username/password
def createnewuser(email: str, username: str, password: str):
    return ad.create_new_user(email, username, password) # {"message_type": message_type,"message": message}

# USER LOGIN (to log in which means that the email and password are correct)
@app.get("/login/{email}/{password}") # /createnewuser/email/password
def login(email: str, password: str):
    return ad.user_login(email, password) # {"message_type": message_type,"message": message}

# USER CHANGE PASSWORD (to change the password of a user)
@app.get("/changepassword/{email}/{password}/{newpassword}") # /changepassword/email/password/newpassword
def changepassword(email: str, password: str, newpassword: str):
    return ad.change_password_user(email, password, newpassword) # {"message_type": message_type,"message": message}

# USER CHANGE USERNAME (to change the username of a user)
@app.get("/changeusername/{email}/{password}/{newusername}") # /changeusername/email/password/newusername
def changeusername(email: str, password: str, newusername: str):
    return ad.change_username_user(email, password, newusername) # {"message_type": message_type,"message": message}

# DELET USER (to delete the user from the database)
@app.get("/deletuser/{email}/{password}") # /deletuser/email/password
def deletuser(email: str, password: str):
    return ad.delet_user(email, password) # {"message_type": message_type,"message": message}

# ----- SCORE -----
##TODO DA FEHLT NO EINIGES

# SET SCORE - API
@app.get("/setscore/{email}/{quizid}/{score}/{achivablescore}/{neededtime}") # /setscore/email/quizid/score/achivablescore/neededtime
def setscore(email: str, quizid: int, score: int, achivablescore: int, neededtime: int):
    return ad.set_score(email, quizid, score, achivablescore, neededtime) # {"message_type": message_type,"message": message}
##TODO TESTEN UND SCHREIBEN

##TODO HIGHSCORE SCHICKEN, HIGHSCORE ABRUFEN, ...
##TODO GET USERNAME, ...

if __name__ == "__main__":
    uvicorn.run(app, host="localhost", port=8080)