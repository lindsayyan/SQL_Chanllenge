use sakila;
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

select  * from sakila.actor

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
update sakila.actor set first_name='GROUCHO'
where Last_name='WILLIAMS' and first_name='HARPO'


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



#7a. The music of Queen and Kris Kristofferson have seen an unlikely resurgence. 
#As an unintended consequence, films starting with the letters K and Q have also soared in popularity. 
#Use subqueries to display the titles of movies starting with the letters K and Q whose language is English.
select title from film
where title like'K%' or title like 'Q%'

#7b. Use subqueries to display all actors who appear in the film Alone Trip.
select title,first_name, last_name 
from 
(select * from film
where title ='Alone Trip') a
join film_actor b 
on a.film_id=b.film_ID
join actor c
on b.actor_ID=c.actor_ID

#7c. You want to run an email marketing campaign in Canada, 
#for which you will need the names and email addresses of all Canadian customers. Use joins to retrieve this information.

select c.first_name, c.last_name, c.email
from customer c
join address a
on c.address_id = a.address_id
join city b
on a.city_id = b.city_id
join country d
on b.country_id = d.country_id
where country = "CANADA";

#7d. Sales have been lagging among young families, 
#and you wish to target all family movies for a promotion. 
#Identify all movies categorized as famiy films.

select title, name as Cateory
from 
(select * from category where name ='Family') a
join film_category b 
on a.category_ID=b.category_id
join film c
on b.film_ID=c.film_ID

#7e. Display the most frequently rented movies in descending order.
select title,count(a.inventory_ID) as rented_times
from rental b
join inventory a
on a.inventory_id=b.inventory_id
join film c
on a.film_ID=c.film_ID
group by title
order by count(a.inventory_ID) desc


#7f. Write a query to display how much business, in dollars, each store brought in.
select a.store_id, sum(d.amount) as 'Total_Revenue'
from  store a
join inventory b
on a.store_id = b.store_id
join rental c
on b.inventory_id = c.inventory_id
join payment d
on c.rental_id = d.rental_id
group by a.store_id;

#7g. Write a query to display for each store its store ID, city, and country.
select b.store_id, c.city, d.country
from store b
join address a
on b.address_id = a.address_id
join city c
on a.city_id = c.city_id
join country d
on c.country_id = d.country_id;

#7h. List the top five genres in gross revenue in descending order. 
#(Hint: you may need to use the following tables: category, film_category, inventory, payment, and rental.)
select a.name as 'Movie Genres', sum(e.amount) as 'Gross Revenue'
from category a
join film_category b
on a.category_id = b.category_id
join inventory c
on b.film_id = c.film_id
join rental d
on c.inventory_id = d.inventory_id
join payment e
on d.rental_id = e.rental_id
group by a.category_id
order by sum(e.amount) desc
limit 5;


#8a. In your new role as an executive, you would like to have an easy way of viewing the Top five genres by gross revenue. Use the solution from the problem above to create a view. If you haven't solved 7h, you can substitute another query to create a view.
CREATE VIEW `top_five_genres` as 
select a.name as 'Movie Genres', sum(e.amount) as 'Gross Revenue'
from category a
join film_category b
on a.category_id = b.category_id
join inventory c
on b.film_id = c.film_id
join rental d
on c.inventory_id = d.inventory_id
join payment e
on d.rental_id = e.rental_id
group by a.category_id
order by sum(e.amount) desc
limit 5;


#8b. How would you display the view that you created in 8a?
SELECT * FROM `top_five_genres`;

#8c. You find that you no longer need the view top_five_genres. Write a query to delete it.
DROP VIEW `top_five_genres`;


