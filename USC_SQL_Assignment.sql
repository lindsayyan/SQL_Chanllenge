##1a
select first_name,last_name from sakila.actor


#1b. Display the first and last name of each actor in a single column in upper case letters. Name the column Actor Name.
select concat(upper(first_name)," ",upper(last_name)) as Name from sakila.actor


#2a. You need to find the ID number, 
select actor_ID,First_name from sakila.actor
where first_name='Joe'


#2b. Find all actors whose last name contain the letters GEN:
select * from sakila.actor
where last_name like'%GEN%'

#2c. Find all actors whose last names contain the letters LI. This time, order the rows by last name and first name, in that order:
select Last_name,First_name from sakila.actor
where last_name like'%LI%'
order by last_name,first_name


#2d. Using IN, display the country_id and country columns of the following countries: Afghanistan, Bangladesh, and China:
select country_ID,country from sakila.country
where country in ('Afghanistan','Bangladesh','China')


#3a. Add a middle_name column to the table actor. Position it between first_name and last_name. 
#Hint: you will need to specify the data type.

ALTER TABLE sakila.actor add COLUMN
Middle_name varchar(20) NOT NULL
AFTER first_name;

#3b. You realize that some of these actors have tremendously long last names. 
#Change the data type of the middle_name column to blobs.
ALTER TABLE sakila.actor alter COLUMN
Middle_name mediumblob ;

#3c. Now delete the middle_name column.

Alter table sakila.actor 
drop column Middle_name;

#4a. List the last names of actors, as well as how many actors have that last name
select Last_name, count(*) from sakila.actor 
group by Last_name

#4b. List last names of actors and the number of actors who have that last name, 
#but only for names that are shared by at least two actors
select Last_name, count(*) from sakila.actor 
group by Last_name
having count(*)>1

#4c. Oh, no! The actor HARPO WILLIAMS was accidentally entered in the actor table as GROUCHO WILLIAMS, 
#the name of Harpo's second cousin's husband's yoga teacher. Write a query to fix the record.

update sakila.actor set first_name='HARPO'
 where Last_name='WILLIAMS' and first_name='GROUCHO'

#4d. Perhaps we were too hasty in changing GROUCHO to HARPO. 
#It turns out that GROUCHO was the correct name after all! In a single query, 
#if the first name of the actor is currently HARPO, change it to GROUCHO. Otherwise, 
#change the first name to MUCHO GROUCHO, as that is exactly what the actor will be with the grievous error. 
#BE CAREFUL NOT TO CHANGE THE FIRST NAME OF EVERY ACTOR TO MUCHO GROUCHO, HOWEVER! (Hint: update the record using a unique identifier.)
UPDATE sakila.actor
   SET first_name 
   Case WHEN first_name = 'HARPO' AND last_name = 'WILLIAMS' THEN 'GROUCHO' 
    when first_name = 'GROUCHO' AND last_name = 'WILLIAMS' THEN 'MUCHO GROUCHO'  
    ELSE  first_name 
END


#5a. You cannot locate the schema of the address table. Which query would you use to re-create it? 
#Hint: https://dev.mysql.com/doc/refman/5.7/en/show-create-table.html

create table if not exists sakila.address
(
UserID int INTEGER(11) AUTO_INCREMENT NOT NULL,
address varchar(50) not null
) 


#6a. Use JOIN to display the first and last names, as well as the address, of each staff member. Use the tables staff and address:

select a.address_ID,First_name,last_name, address
from staff a
join address b
on a.address_id=b.address_ID



#6b. Use JOIN to display the total amount rung up by each staff member in August of 2005. Use tables staff and payment.

select first_name, last_name, sum(amount)as total from
(select * from payment  where Payment_date between '2005-08-01' and '2005-08-30') a
join staff b
on a.staff_ID=b.staff_ID
group by first_name, last_name


#6c. List each film and the number of actors who are listed for that film. Use tables film_actor and film. Use inner join.

select a.title,count(distinct Actor_ID) as num_actor from 
(select Film_ID,title from film ) a
join film_actor b 
on a.film_Id=b.film_ID
group by A.film_ID


#6d. How many copies of the film Hunchback Impossible exist in the inventory system?
SELECT title,count(distinct inventory_ID) as copies  
FROM inventory a
join Film b 
on a.film_ID=b.film_ID
group by title

#6e. Using the tables payment and customer and the JOIN command, 
#list the total paid by each customer. List the customers alphabetically by last name:
select first_name,last_name,sum(amount) as Total_paid 
from payment a 
join customer b 
on a.customer_ID=b.customer_ID
group by first_name,last_name
order by last_name




    