import mysql.connector

class DatabaseConnector:
    def __init__(self):
        self.mydb = mysql.connector.connect(
            host="localhost",
            user="root",
            password="",
            database="diplomarbeit"
        )
        self.mycursor = self.mydb.cursor()

    # ----- QUIZ -----

    # GET QUIZ OVERVIEW - SELECT
    def get_quiz_overview(self):
        self.mycursor.execute("select quiz_id, name from quiz")
        return self.mycursor.fetchall()
    ##TODO GEHT

    # GET QUIZ BY ID - SELECT
    def get_quiz_by_id(self, id):
        self.mycursor.execute("select * from quiz where quiz_id = " + str(id))
        return self.mycursor.fetchall()
    ##TODO GEHT

    def get_countries_by_quiz(self, select_statement):
        self.mycursor.execute(select_statement)
        return self.mycursor.fetchall()
    ##TODO GEHT

    # ----- USER -----

    # CREATE NEW USER - INSERT
    def create_new_user(self, email, username, password):
        insert_query = 'INSERT INTO user VALUES ("' + email + '", "' + username + '", "' + password + '")'
        try:
            self.mycursor.execute(insert_query)
            self.mydb.commit()
            json_string = {
                "message_type": "Success",
                "message": "User created."
            }
            return json_string
        except mysql.connector.Error as error:
            self.mydb.rollback()
            json_string = {
                "message_type": "Error",
                "message": error.msg
            }
            return json_string
    ##TODO GEHT

    def get_all_users(self):
        select_statement = "select email from user"
        self.mycursor.execute(select_statement)
        results = self.mycursor.fetchall()
        emails = list(sum(results, ()))
        return emails
    ##TODO GEHT

    # USER LOGIN - SELECT
    def get_password_by_email(self, email):
        select_statement = "select password from user where email = %s"
        self.mycursor.execute(select_statement, (email,))
        results = self.mycursor.fetchall()
        passwords = list(sum(results, ()))
        return passwords[0]
    ##TODO GEHT
    
db_connector = DatabaseConnector()

