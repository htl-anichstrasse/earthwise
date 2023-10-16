import uvicorn
from fastapi import FastAPI

import ArrangeData as ad
from ArrangeData import get_quiz_by_id

app = FastAPI()

# GET QUIZ OVERVIEW - API
@app.get("/getquizoverview")
def getquizoverview():
    return ad.get_quiz_overview()

# GET QUIZ BY ID - API
@app.get("/getquizbyid/{id}")
def getquiz(id: int):
    return ad.get_quiz_by_id(id)

if __name__ == "__main__":
    uvicorn.run(app, host="localhost", port=8080)
