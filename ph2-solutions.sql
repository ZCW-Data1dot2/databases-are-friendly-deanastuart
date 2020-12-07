/* SQL "Sakila" database query exercises - phase 1 */

-- Database context
USE sakila;

-- Your solutions...
* Write an SQL script with queries that answer the following questions:
### Phase 2. Longer, Harder, More Realistic.

Use google as lightly as possible in solving these. These are the kind of queries that any data engineer should be able to perform on a familiar dataset.

* 1a. Display the first and last names of all actors from the table `actor`. 
	select first_name, last_name from actor;

* 1b. Display the first and last name of each actor in a single column in upper case letters. Name the column `Actor Name`. 
	select concat(Upper(first_name), " " ,(last_name)) as "Actor Name" from actor;

* 2a. You need to find the ID number, first name, and last name of an actor, of whom you know only the first name, "Joe." What is one query would you use to obtain this information?
  	select actor_id, first_name, last_name from actor
	where first_name like 'Joe';
* 2b. Find all actors whose last name contain the letters `GEN`:
	select actor_id, first_name, last_name from actor
	where last_name like '%GEN%';
  	
* 2c. Find all actors whose last names contain the letters `LI`. This time, order the rows by last name and first name, in that order:
	select actor_id, first_name, last_name from actor
	where last_name like '%LI%'
	order by last_name, first_name desc;

* 2d. Using `IN`, display the `country_id` and `country` columns of the following countries: Afghanistan, Bangladesh, and China:
	select country_id, country from country
	where country in ('Afghanistan', 'Bangladesh', 'China');

* 3a. Add a `middle_name` column to the table `actor`. Position it between `first_name` and `last_name`. Hint: you will need to specify the data type.
	alter table actor
	add column middle_name VARCHAR(45) After first_name;
  	
* 3b. You realize that some of these actors have tremendously long last names. Change the data type of the `middle_name` column to `blobs`.
	alter table actor
	modify column middle_name BLOB;

* 3c. Now delete the `middle_name` column.
	alter table actor
	DROP column middle_name;

* 4a. List the last names of actors, as well as how many actors have that last name.
	select last_name, count(last_name) as count
	FROM Actor
	Group by last_name;
  	
* 4b. List last names of actors and the number of actors who have that last name, but only for names that are shared by at least two actors
	select last_name, count(last_name) as count
	FROM Actor
	Group by last_name
	having count > 1;
  	
* 4c. Oh, no! The actor `HARPO WILLIAMS` was accidentally entered in the `actor` table as `GROUCHO WILLIAMS`, the name of Harpo's second cousin's husband's yoga teacher. Write a query to fix the record.
	to get actor id:
	select first_name, last_name, actor_id from actor
	where first_name = 'groucho';

	update actor
	set first_name = 'HARPO'
	where actor_id = 172;
  	

* 4d. Perhaps we were too hasty in changing `GROUCHO` to `HARPO`. It turns out that `GROUCHO` was the correct name after all! In a single query, if the first name of the actor is currently `HARPO`, change it to `GROUCHO`. Otherwise, change the first name to `MUCHO GROUCHO`, as that is exactly what the actor will be with the grievous error. BE CAREFUL NOT TO CHANGE THE FIRST NAME OF EVERY ACTOR TO `MUCHO GROUCHO`, HOWEVER! (Hint: update the record using a unique identifier.)
	update actor
	set first_name = CASE
    	when first_name = 'HARPO' then 'GROUCHO'
    	else 'MUCHO GROUCO'
    	END
    	where actor_id = 172;

* 5a. You cannot locate the schema of the `address` table. Which query would you use to re-create it? 
	'address', 'CREATE TABLE `address` (\n  `address_id` smallint unsigned NOT NULL AUTO_INCREMENT,\n  `address` varchar(50) NOT NULL,\n  `address2` varchar(50) DEFAULT NULL,\n  `district` varchar(20) NOT NULL,\n  `city_id` smallint unsigned NOT NULL,\n  `postal_code` varchar(10) DEFAULT NULL,\n  `phone` varchar(20) NOT NULL,\n  `location` geometry NOT NULL /*!80003 SRID 0 */,\n  `last_update` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,\n  PRIMARY KEY (`address_id`),\n  KEY `idx_fk_city_id` (`city_id`),\n  SPATIAL KEY `idx_location` (`location`),\n  CONSTRAINT `fk_address_city` FOREIGN KEY (`city_id`) REFERENCES `city` (`city_id`) ON DELETE RESTRICT ON UPDATE CASCADE\n) ENGINE=InnoDB AUTO_INCREMENT=606 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci'


  * Hint: [https://dev.mysql.com/doc/refman/5.7/en/show-create-table.html](https://dev.mysql.com/doc/refman/5.7/en/show-create-table.html)

* 6a. Use `JOIN` to display the first and last names, as well as the address, of each staff member. Use the tables `staff` and `address`:
	select first_name, last_name, address from staff
	join address using(address_id);


* 6b. Use `JOIN` to display the total amount rung up by each staff member in August of 2005. Use tables `staff` and `payment`. 
	select first_name, last_name, sum(amount) from staff
	join payment using(staff_id)
	where payment_date like '2005-08%'
	group by first_name, last_name;
  	
* 6c. List each film and the number of actors who are listed for that film. Use tables `film_actor` and `film`. Use inner join.
	select title, count(distinct actor_id) as actors from film
	inner join film_actor using (film_id)
	group by title
	order by actors desc;
  	
* 6d. How many copies of the film `Hunchback Impossible` exist in the inventory system?
	select title, count(distinct inventory_id) from inventory
	join film using (film_id)
	where title = 'Hunchback Impossible'
	group by title;

* 6e. Using the tables `payment` and `customer` and the `JOIN` command, list the total paid by each customer. List the customers alphabetically by last name
	select customer_id, first_name, last_name, sum(amount) from customer
	join payment using(customer_id)
	group by customer_id
	order by last_name desc;

* 7a. The music of Queen and Kris Kristofferson have seen an unlikely resurgence. As an unintended consequence, films starting with the letters `K` and `Q` have also soared in popularity. Use subqueries to display the titles of movies starting with the letters `K` and `Q` whose language is English. 
	select * from film
	join language using (language_id)
	where name = 'English' and title in
	(select title from film where title like 'k%' or title like 'q%');

* 7b. Use subqueries to display all actors who appear in the film `Alone Trip`.
	select title, first_name, last_name from film
	join  film_actor using (film_id)
	join actor using (actor_id)
	where title = 'Alone Trip';
   
* 7c. You want to run an email marketing campaign in Canada, for which you will need the names and email addresses of all Canadian customers. Use joins to retrieve this information.
	select first_name, last_name, email from customer
	join address using (address_id)
	join city using (city_id)
	join country using (country_id)
	where country = 'Canada'

* 7d. Sales have been lagging among young families, and you wish to target all family movies for a promotion. Identify all movies categorized as famiy films.
	select * from film
	join film_category using (film_id)
	join category using (category_id)
	where name = 'Family';

* 7e. Display the most frequently rented movies in descending order.
	select title, count(film_id) as rcount from rental 
	join inventory using (inventory_id)
	join film using (film_id)
	group by title
	order by rcount desc;
  	
* 7f. Write a query to display how much business, in dollars, each store brought in.
	select staff.store_id, sum(payment.amount) from staff
	join payment on (staff.staff_id = payment.staff_id)
	join rental on (rental.rental_id = payment.rental_id)
	group by staff.store_id;

* 7g. Write a query to display for each store its store ID, city, and country.
	select store_id, city, country from store
	join address using (address_id)
	join city using (city_id)
	join country using (country_id);
  	
* 7h. List the top five genres in gross revenue in descending order. (**Hint**: you may need to use the following tables: category, film_category, inventory, payment, and rental.)
	select name, sum(amount) as gross_rev from category
	join film_category using (category_id)
	join inventory using (film_id)
	join rental using (inventory_id)
	join payment using (customer_id)
	group by name
	order by gross_rev desc
	limit 5;
  	
* 8a. In your new role as an executive, you would like to have an easy way of viewing the Top five genres by gross revenue. Use the solution from the problem above to create a view. If you haven't solved 7h, you can substitute another query to create a view.

create view gross_rev_by_genre as
select name, sum(amount) as gross_rev from category
join film_category using (category_id)
join inventory using (film_id)
join rental using (inventory_id)
join payment using (customer_id)
group by name
order by gross_rev desc
limit 5;
  	
* 8b. How would you display the view that you created in 8a?
select * from gross_rev_by_genre;

* 8c. You find that you no longer need the view `top_five_genres`. Write a query to delete it.
drop view gross_rev_by_genre;
