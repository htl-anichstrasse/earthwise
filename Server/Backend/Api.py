import uvicorn
from fastapi import FastAPI
import json
import ArrangeDataForApi as ad

app = FastAPI()

# ----- QUIZ -----
##TODO KOMPLETT ABGESCHLOSSEN

# GET QUIZ OVERVIEW (to display all quizzes in an overview)
@app.get("/getquizoverview") # /getquizoverview
def getquizoverview():
    return ad.get_quiz_overview() # {"quiz_data": [[quiz_id, name, quiz_type], ...]}

# GET QUIZ BY ID (to get all the data from a quiz by id)
@app.get("/getquizbyid/{id}") # /getquizbyid/id
def getquiz(id: int):
    return ad.get_quiz_by_id(id) # {"quiz_id": quiz_id, "quiz_name": name, "description": description, "quiz_type":quiz_type, "country_data": country_data}

# GET ALL QUIZ DATA (for the offline version of the app to save the quizzes in a text document)
@app.get("/getallquizdata") # /getallquizdata
def getallquizdata():
    return ad.get_all_quiz_data() # [{"quiz_id": quiz_id,"quiz_name":name,"description": description,"quiz_type":quiz_type,"country_data":["cca2","cca2", ...]}, ... ]

# GET ALL alternativeE SPELLINGS (for the offline version of the app to save the possible spellings in a text document)
@app.get("/getallalternativespellings") # /getallalternativeespellings
def getallalternativespellings():
    return ad.get_all_alternative_spellings() # {"cca2":["alternativee_spelling", ...], ...}

# GET alternativeE SPELLINGS BY CCA2 (to get the alternative spelling to a cca2)
@app.get("/getalternativespellingsbycca2/{cca2}") # /getalternativespellingsbycca2/cca2
def getalternativespellingsbycca2(cca2: str):
    return ad.get_alternative_spellings_by_cca2(cca2) # ["alternative_spelling", ...] OR {"message_type": message_type,"message": message}

# ----- USER -----
##TODO KOMPLETT ABGESCHLOSSEN

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

# DELETE USER (to delete the user from the database)
@app.get("/deleteuser/{email}/{password}") # /deleteuser/email/password
def deleteuser(email: str, password: str):
    return ad.delete_user(email, password) # {"message_type": message_type,"message": message}

# GET USERNAME AND LEVEL (to get the username and level)
@app.get("/getusernameandlevel/{email}") # /getusernameandlevel/email
def getusernameandlevel(email: str):
    return ad.get_username_and_level(email) # {"username": username,"level": level} OR {"message_type": message_type,"message": message}

# INCREASE LEVEL (to increase a users level)
@app.get("/increaselevel/{email}/{levelincrease}") # /increaselevel/email/levelincrease
def increaselevel(email: str, levelincrease: int):
    return ad.increase_level(email, levelincrease) # {"message_type": message_type,"message": message}

# ----- SCORE -----
##TODO KOMPLETT ABGESCHLOSSEN

# SET SCORE - API
@app.get("/setscore/{email}/{quizid}/{score}/{achivablescore}/{neededtime}") # /setscore/email/quizid/score/achivablescore/neededtime
def setscore(email: str, quizid: int, score: int, achivablescore: int, neededtime: int):
    return ad.set_score(email, quizid, score, achivablescore, neededtime) # {"message_type": message_type,"message": message}

# GET SCORE - API
@app.get("/getscore/{email}/{quizid}") # /getscore/email/quizid
def getscore(email: str, quizid: int):
    return ad.get_score(email, quizid) # [email, quiz_id, score, achivable_score, needed_time] OR {"message_type": message_type,"message": message}

# GET ALL SCORES - API
@app.get("/getallscores/{email}") # /getallscores/email
def getallscores(email: str):
    return ad.get_all_scores_by_email(email) # [[email, quiz_id, score, achivable_score, needed_time], ...]

if __name__ == "__main__":
    uvicorn.run(app, host="localhost", port=8080)