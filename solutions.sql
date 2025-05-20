-- Add you solution queries below:
-- 1. Write a query to display for each store its store ID, city, and country.
SELECT s.store_id, ci.city, co.country
FROM store as s 
	INNER JOIN address as a ON s.address_id = a.address_id
	INNER JOIN city as ci ON a.city_id = ci.city_id
	INNER JOIN country as co ON ci.country_id = co.country_id;

-- 2. Write a query to display how much business, in dollars, each store brought in.
SELECT c.store_id as store, SUM(p.amount) as business 
FROM payment as p
	INNER JOIN customer as c ON p.customer_id = c.customer_id
GROUP BY c.store_id;

-- 3. What is the average running time of films by category?
-- Assuming running time means the length of the movie
SELECT c.name as category, AVG(f.length) as running_time
FROM film as f
	INNER JOIN film_category as fc ON f.film_id = fc.film_id
	INNER JOIN category as c ON fc.category_id = c.category_id
GROUP BY c.category_id;

-- 4. Which film categories are longest?
-- Assuming longest mean categories with more movies
SELECT c.name as category, COUNT(fc.film_id) as length
FROM film_category as fc
	 INNER JOIN category as c ON fc.category_id = c.category_id
GROUP BY c.category_id
ORDER BY length DESC;

-- In case it meant the longest in terms of running time
SELECT c.name as category, SUM(f.length) as length
FROM film as f
	INNER JOIN film_category as fc ON f.film_id = fc.film_id
	INNER JOIN category as c ON fc.category_id = c.category_id
GROUP BY c.category_id
ORDER BY length;

-- 5. Display the most frequently rented movies in descending order.
SELECT f.title as movie, COUNT(r.rental_id) as num_times_rented
FROM film as f
	INNER JOIN inventory as i ON f.film_id = i.film_id
	INNER JOIN rental as r ON i.inventory_id = r.inventory_id
GROUP BY f.film_id
ORDER BY num_times_rented DESC;

-- 6. List the top five genres in gross revenue in descending order.
SELECT c.name as genere, SUM(p.amount) as gross_revenue
FROM film_category as fc
	INNER JOIN category as c ON fc.category_id = c.category_id
	INNER JOIN inventory as i ON fc.film_id= i.film_id
	INNER JOIN rental as r ON i.inventory_id = r.inventory_id
	INNER JOIN payment as p ON r.rental_id = p.rental_id
GROUP BY c.category_id
ORDER BY gross_revenue
LIMIT 5;


-- 7. Is "Academy Dinosaur" available for rent from Store 1?
SELECT CASE 
		WHEN COUNT(inventory_id) >= SUM(available) THEN 'Yes'
		ELSE 'No'
	END AS is_available	
FROM (
	SELECT i.inventory_id, CASE 
				WHEN max(r.rental_date) IS NOT NULL and  r.return_date IS NULL THEN 0
				ELSE 1
			END as available
		FROM inventory as i 
		INNER JOIN film as f ON f.film_id = i.film_id
		LEFT JOIN rental as r ON i.inventory_id = r.inventory_id
	WHERE  f.title LIKE "%Academy Dinosaur%" AND store_id = 1
	GROUP BY i.inventory_id
) as s;