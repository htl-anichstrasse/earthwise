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
    return ad.user_login(email, password) # {"message_type": message_type,"message": message}
##TODO GEHT

# USER CHANGE PASSWORD - API
@app.get("/changepassword/{email}/{password}/{newpassword}") # /changepassword/email/password/newpassword
def changepassword(email: str, password: str, newpassword: str):
    return ad.change_password_user(email, password, newpassword) # {"message_type": message_type,"message": message}
##TODO TESTEN

# USER CHANGE EMIAL - API
#@app.get("/changeemail/{email}/{password}/{newemail}") # /changeemail/email/password/newemail
#def changeemail(email: str, password: str, newemail: str):
#    return ad.change_email_user(email, password, newemail) # {"message_type": message_type,"message": message}
##TODO NICHT UMSETZBAR DA EMAIL PRIMARY KEY IST

# USER CHANGE USERNAME - API
@app.get("/changeusername/{email}/{password}/{newusername}") # /changeusername/email/password/newusername
def changeusername(email: str, password: str, newusername: str):
    return ad.change_username_user(email, password, newusername) # {"message_type": message_type,"message": message}
##TODO TESTEN

# DELET USER - API
@app.get("/deletuser/{email}/{password}") # /deletuser/email/password
def deletuser(email: str, password: str):
    return ad.delet_user(email, password) # {"message_type": message_type,"message": message}
##TODO TESTEN

##TODO HIGHSCORE SCHICKEN, HIGHSCORE ABRUFEN, ...

if __name__ == "__main__":
    uvicorn.run(app, host="localhost", port=8080)