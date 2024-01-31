#Temporäre Inserts für die Datenbank (später über api python skript)

#für country
insert into country values(1, "Austria", "europe");
insert into country values(2, "Germany", "europe");
insert into country values(3, "France", "europe");

#für quiz
insert into quiz values(1,"Testcountries","This is a discription", "mapQuiz","countryId, countryName","continent","europe");
insert into quiz values(2,"Testcountries2","This is a discription2", "mapQuiz","countryId, countryName","continent","europe");

select * from country;
SELECT COUNT(*) AS entry_count FROM country;
select capital from country where name = "Eritrea"; 

select count(*) AS c from country where independent = true and continent = "Oceania";

select * from quiz;
select * from user;
select * from score;