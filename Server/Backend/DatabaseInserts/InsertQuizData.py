#from MySQLdb import Error
import mysql.connector
import DataForQuizzes as d

#def connect_to_database():
#    try:
        #mydb = mysql.connector.connect(host="localhost", user="root", password="dipl", database="diplomarbeit")
mydb = mysql.connector.connect(host="localhost", user="root", password="david2003", database="diplomarbeit", auth_plugin='mysql_native_password')
mycursor = mydb.cursor()
#        return mycursor
#    except Error as e:
#        print(f"Error connectin to MySQL database: {e}")
#        return None
#def check_connection(db):
#    if db.is_connected():
#        print("Connection is active.")
#    else:
#        print("Connection lost. Trying to reconnect...")
#        db.reconnect(attempts=3, delay=5)
#        if db.is_connected():
#            print("Reconnection successful.")
#        else:
#            print("Failed to reconnect to the database.")
#mydb = connect_to_database()
#if mydb is not None:
#    check_connection(mydb)
#    mycursor = mydb.cursor()
#else:
#    print("Unable to establish database connection.")

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







