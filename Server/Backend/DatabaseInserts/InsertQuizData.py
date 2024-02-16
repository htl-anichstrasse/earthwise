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
    mycursor.execute("select cca2 from country where independent = true")
    countries = mycursor.fetchall()
    countries_filterd = []
    for c in countries:
        countries_filterd.append(c[0])
    quiz_count = 22
    for c in countries_filterd:
        mycursor.execute("select cca2 from border_to_country where border = \'" + c + "\'")
        result = mycursor.fetchall()
        mycursor.execute("select border from border_to_country where cca2 = \'" + c + "\'")
        result2 = mycursor.fetchall()
        borders = result + result2
        borders_filterd = []
        for b in borders:
            borders_filterd.append(b[0])
        if borders_filterd != []:
            mycursor.execute("select name from country where cca2 =\'" + c + "\'")
            name = mycursor.fetchall()
            name_filterd = name[0]
            insert_string = 'INSERT INTO quiz VALUES (' + str(quiz_count) + ', "All neighboring countries of ' + name_filterd[0] + '", "Name all ' + str(len(borders_filterd)) + ' neighboring countries of ' + name_filterd[0] + '", "neighboringcountries", "' + str(borders_filterd) + '")'
            insert_into_database(insert_string)
            quiz_count = quiz_count + 1
        
if __name__ == '__main__':
    tempcount = 0
    for i in d.data:
        tempcount = tempcount + 1
        print(i)
        insert_into_database(i)
        print(tempcount)
    all_neighboring_countries()
    mycursor.close()
    mydb.close()
    
    ##TODO UMBAUEN SO DASS MIT INSTALATIONSDATEI AUFGERUFEN WIRD







