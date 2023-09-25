#Datenbank Konektor mit diversen Selects, Inserts, Deletes und Updates

#port vom sql server ausfinden muss i no
import pyodbc 
cnxn = pyodbc.connect('DRIVER={Devart ODBC Driver for SQL Server};Server=myserver;Database=Diplomarbeit;Port=myport;User ID=root;Password=david2003')

#brauch i daweil mal nit
#cursor = cnxn.cursor()
#cursor.execute("INSERT INTO EMP (EMPNO, ENAME, JOB, MGR) VALUES (535, 'Scott', 'Manager', 545)") 

#Temp -> kimmt entweder von der Website oder simmer ruft methode dan später direkt auf
quizId = 1

#test für select FUNKTIONIERT NO NIT
cursor = cnxn.cursor()	
cursor.execute("SELECT * FROM quiz where quizId={quizId}") 
row = cursor.fetchone() 
while row:
    #Temp -> in variablen sopeichern und anschließend sollt dan an jason String formen
    print (row) 
    row = cursor.fetchone()
    