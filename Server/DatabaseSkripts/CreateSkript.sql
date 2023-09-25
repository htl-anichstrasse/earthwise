
#Datenbank erzeugen (früher oder später muss der Name der Datenbank noch angepasst werden)
create database Diplomarbeit collate utf16_general_ci;

#Datennbank verwenden (auch hier Namen anpassen)
use Diplomarbeit;

#Datenbank löschen
#drop database Diplomarbeit

#Quiz Tabelle erstellen
create table quiz(
	quizId int unsigned not null,
    quizName varchar(100) not null,
    discription varchar (1000) not null,
    quiz_type varchar(100) not null,
    neededProperties varchar(100),
    criteria varchar(100),
    spespecificCriteria varchar(100),
    
    constraint quizId_pk primary key (quizId)
)engine=InnoDB;

#Country Tabelle erstellen
create table country(
	countryId int unsigned not null,
    countryName varchar(100) not null,
    continent varchar(100) not null,
    #Hier noch mehr properties 

	constraint countryId_pk primary key (countryId)
);