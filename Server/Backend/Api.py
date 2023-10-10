import uvicorn
from fastapi import FastAPI

import ArrangeData as ad

app = FastAPI()

@app.get("/hallo")
def hello():
    print("le go")
    return {"Hello world!"}

@app.get("/getquiz/{id}")
def getquiz(id: int):
    return {"id": ad.getquiz(id)}

if __name__ == "__main__":
    uvicorn.run(app, host="localhost", port=8080)
