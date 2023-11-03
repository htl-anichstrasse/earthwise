# CLASS FOR QUIZ
class quiz(object): 
    def __init__(self, quiz_id, quiz_name, discription, quiz_type, needed_properties, criteria, specific_criteria): 
        self.quiz_id = quiz_id
        self.quiz_name = quiz_name
        self.discription = discription
        self.quiz_type = quiz_type
        self.needed_properties = needed_properties
        self.criteria = criteria
        self.specific_criteria = specific_criteria
    #TODO def methode(self): 
    
# CLASS FOR COUNTRY
class country(object): 
    def __init__(self, country_id, country_name, continent): 
        self.country_id = country_id
        self.country_name = country_name
        self.continent = continent

# CLASS FOR USER
class user(object): 
    def __init__(self, email, username, password): 
        self.email = email
        self.username = username
        self.password = password