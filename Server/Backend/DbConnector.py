import mysql.connector

mydb = mysql.connector.connect(
    host="localhost",
    user="root",
    password="david2003",
    database="diplomarbeit"
)

mycursor = mydb.cursor()

def getquiz(id):
    mycursor.execute("SELECT * FROM country")
    return mycursor.fetchall()

