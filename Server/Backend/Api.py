import uvicorn
from fastapi import FastAPI
import Diplomarbeit.Server.Backend.ArrangeData as ad
import json


app = FastAPI()

# GET QUIZ OVERVIEW - API
@app.get("/getquizoverview")
def getquizoverview():
    return ad.get_quiz_overview()

# GET QUIZ BY ID - API
@app.get("/getquizbyid/{id}")
def getquiz(id: int):
    return ad.get_quiz_by_id(id)

#TODO TESTEN !!!
# CREATE NEW USER - API
@app.get("/createnewuser/{user}")
def getquiz(user: json):
    # user={"email": email, "username": username, "password": password}
    return ad.create_new_user(user)

#TODO TESTEN !!!
# USER LOGIN - API
@app.get("/userlogin/{logindata}")
def getquiz(logindata: json):
    # logindata={"email": email, "password": password}
    return ad.user_login(logindata)


if __name__ == "__main__":
    uvicorn.run(app, host="localhost", port=8080)