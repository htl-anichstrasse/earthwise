import mysql.connector

# ----- DB -----

# CONNECT DB (to establish the connection)
def connect_db():
    # the database is specified with password and host as well as user
    mydb = mysql.connector.connect(host="localhost", user="root", password="david2003", database="diplomarbeit")
    #mydb = mysql.connector.connect(host="localhost", user="root", password="dipl", database="diplomarbeit")
    # the cursor and the database are returned
    return mydb.cursor(), mydb

# EXECUTE STATEMENT (to execute an update, delete or select statement)
def execute_statement(statement):
    # opens the connection to the database
    mycursor, mydb = connect_db()
    # executes the statement
    mycursor.execute(statement)
    result = mycursor.fetchall()
    # closes the database connection
    mydb.close()
    # returns the result
    return result

# EXECUTE STATEMENT FLATTENED (to flatten the return value of a statement)
def execute_statement_flattened(statement):
    # to execute an update, delete or select statement
    result = execute_statement(statement)
    # flattens the list into a one-dimensional list and returns it
    return list(sum(result, ()))

# EXECUTE STATEMENT FLATTENED FIRST ENTRY (to get the first entry of a flattened list)
def execute_statement_flattened_first_entry(statement):
    # to execute an update, delete or select statement and to flatten the return value of a statement
    result = execute_statement_flattened(statement)
    # returns the first entry
    return result[0]

# INSERT DATA (to enter a data record with exception handling)
def insert_data(statement):
    # establish database connection
    mycursor, mydb = connect_db()
    # try executing the insert statement
    try:
        mycursor.execute(statement)
        mydb.commit()
    # exception handling
    except mysql.connector.Error as error:
        mydb.rollback()
        mydb.close()
        json_string = {
            "message_type": "Error",
            "message": error.msg
        }
        return json_string
    # close database connection and return message
    mydb.close()
    json_string = {
        "message_type": "Success",
        "message": ""
    }
    return json_string

# EXECUTE STATEMENT (to execute an update, delete or select statement)
def delete_update_data(statement):
    # opens the connection to the database
    mycursor, mydb = connect_db()
    # executes the statement
    mycursor.execute(statement)
    mydb.commit()
    # closes the database connection
    mydb.close()
    