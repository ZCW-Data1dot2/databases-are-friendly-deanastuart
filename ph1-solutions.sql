/* SQL "Sakila" database query exercises - phase 1 */

-- Database context
USE sakila;

-- Your solutions...
* 1. Which actors have the first name ‘Scarlett’
	select * from actor
	where first_name = "Scarlett";
* 2. Which actors have the last name ‘Johansson’
	select * from actor
	where last_name = "Johansson";
* 3. How many distinct actors last names are there? 121
	select last_name, count(last_name) from actor
	GROUP BY last_name;
* 4. Which last names are not repeated? 66
	select last_name from actor GROUP BY last_name having count(last_name) = 1
* 5. Which last names appear more than once?
	select last_name from actor GROUP BY last_name having count(last_name) > 1
* 6. Which actor has appeared in the most films?
	select actor.actor_id, actor.first_name, actor.last_name,
       count(actor_id) as film_count
	from actor join film_actor using (actor_id)
	group by actor_id
	order by film_count desc
	limit 1;
* 7. Is ‘Academy Dinosaur’ available for rent from Store 1?
	select *
	from inventory
	join film using(film_id)
	where store_id = 1 and title like 'ACADEMY DINOSAUR';
* 8. Insert a record to represent Mary Smith renting ‘Academy Dinosaur’ from Mike Hillyer at Store 1 today .
	insert into rental (rental_date, inventory_id, customer_id, staff_id)
	values (NOW(), 1, 1, 1);
* 9. When is ‘Academy Dinosaur’ due?
	select rental_date,
       rental_date + interval
                   (select rental_duration from film where film_id = 1) day
                   as due_date
	from rental
	where rental_id = (select rental_id from rental order by rental_id desc limit 1);
* 10. What is that average running time of all the films in the sakila DB?
	select avg(length) from film;
* 11. What is the average running time of films by category?
	select category.name, avg(length) from film
	join film_category on (film.film_id = film_category.film_id)
	join category using (category_id)
	group by (category.name);
* 12. Why does this query return the empty set? 
	Film.film_is is small int type and inventory.film_id is a medium type

`select * from film natural join inventory;`

The solutions to these are in [sakila-queries-answers.sql](doc/sakila-queries-answers.sql) (But don't look at them until you've really tried to solved them all yourself.)
