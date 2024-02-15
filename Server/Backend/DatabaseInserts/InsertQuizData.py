#from MySQLdb import Error
import mysql.connector
import DataForQuizzes as d

#mydb = mysql.connector.connect(host="localhost", user="root", password="dipl", database="diplomarbeit")
mydb = mysql.connector.connect(host="localhost", user="root", password="david2003", database="diplomarbeit", auth_plugin='mysql_native_password')
mycursor = mydb.cursor()

#FIELDS IN DATABASE
#quiz_id(int), name(string), description(string), quiz_type(string), select_statement(string)

def insert_into_database(insert_query):
    try:
        mycursor.execute(insert_query)
        mydb.commit()
        print("Data inserted successfully.")
    except mysql.connector.Error as error:
        mydb.rollback()
        print(f"Error inserting record: {error}")

def all_neighboring_countries():
    mycursor.execute("select name from country where independent = true")
    result = mycursor.fetchall()
    result2 = []
    for i in result:
        result2.append(i[0])      
    print(result2)
    dicttest = {"1": "2", "4": "5"}
    for i in dicttest:
        print(i)
        if i == "4":
            print(dicttest["4"])
            
            
    #INSERT INTO quiz VALUES (21, "All capitals of in Oceania", "Name the capitals of all 15 independent countries in Oceania.", "tablequiz", \'select name, cca2, capital from country where independent = true and continent = "Oceania"\')'
    mydb.close()
        
if __name__ == '__main__':
    tempcount = 0
    for i in d.data:
        tempcount = tempcount + 1
        print(i)
        insert_into_database(i)
        print(tempcount)
    mycursor.close()
    mydb.close()
    #all_neighboring_countries()
    ##TODO UMBAUEN SO DASS MIT INSTALATIONSDATEI AUFGERUFEN WIRD







