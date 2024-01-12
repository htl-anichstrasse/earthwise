
# CLASS FOR QUIZ

class quiz(object): 
    def __init__(self, quiz_id, name, discription, quiz_type, select_statement): 
        self.quiz_id = quiz_id
        self.name = name
        self.discription = discription
        self.quiz_type = quiz_type
        self.select_statement = select_statement
    #TODO def methode(self): 
    
# CLASS FOR COUNTRY

class country(object): 
    def __init__(self, name, official_name, cca2, cca3, independent, status, un_member, currencies, capital, languages, landlocked, area, population, timezones, continent, borders): 
        self.name = name
        self.official_name = official_name
        self.cca2 = cca2
        self.cca3 = cca3
        self.independent = independent
        self.status = status
        self.un_member = un_member
        self.currencies = currencies
        self.capital = capital
        self.languages = languages
        self.landlocked = landlocked
        self.area = area
        self.population = population
        self.timezones = timezones
        self.continent = continent
        self.borders = borders

# CLASS FOR USER

class user(object): 
    def __init__(self, email, username, password): 
        self.email = email
        self.username = username
        self.password = password
        
# CLASS FOR SCORE
class score(object): 
    def __init__(self, email, quiz_id, score, achivable_score, needed_time): 
        self.email = email
        self.quiz_id = quiz_id
        self.score = score
        self.achivable_score = achivable_score
        self.needed_time = needed_time