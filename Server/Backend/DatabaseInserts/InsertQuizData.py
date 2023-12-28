import mysql.connector
import DataForQuizzes as d

mydb = mysql.connector.connect(
    host="localhost",
    user="root",
    password="david2003",
    database="diplomarbeit"
)
mycursor = mydb.cursor()

#FIELDS IN DATABASE
#quiz_id(int), name(string), discription(string), quiz_type(string), select_statement(string)

def insert_into_database(insert_query):
    try:
        mycursor.execute(insert_query)
        mydb.commit()
        print("Data inserted successfully.")
    except mysql.connector.Error as error:
        mydb.rollback()
        print(f"Error inserting record: {error}")
        
if __name__ == '__main__':
    tempcount = 0
    for i in d.data:
        tempcount = tempcount + 1
        print(i)
        insert_into_database(i)
        print(tempcount)
    mycursor.close()
    mydb.close()
    ##TODO UMBAUEN SO DASS MIT INSTALATIONSDATEI AUFGERUFEN WIRD