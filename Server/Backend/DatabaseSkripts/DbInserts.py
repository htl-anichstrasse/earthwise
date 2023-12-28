import mysql.connector

mydb = mysql.connector.connect(
    host="localhost",
    user="root",
    password="david2003",
    database="diplomarbeit"
)
mycursor = mydb.cursor()

