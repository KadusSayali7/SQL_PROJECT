--Q. Who are the top 10 customers by total purchases?--

select customer.first_name,customer.last_name,count(total) as total_purchases
from customer
join invoice on customer.customer_id=invoice.customer_id
group by 1,2
order by 3 desc
limit 10

-- Q.What is the average purchase amount per customer--
	
	with cte as (
	select customer.customer_id,sum(invoice.total) as amount_spent
	from customer
	join invoice on customer.customer_id=invoice.customer_id
	group by 1
	)
	select avg(amount_spent) from cte

--Q. Which genres are the most popular by sales and number of tracks--
	
select genre.name,track.track_id,sum(invoice_line.quantity*invoice_line.unit_price) as total_amount
from track
join invoice_line on track.track_id=invoice_line.track_id
join  genre on track.genre_id=genre.genre_id
group by 1, 2
order by 3 desc
limit 1

	
--Q.Who is senior most employee based on job title--

select first_name
from employee
order by levels desc
limit 1

--Q. Which countries have the most Invoices?--

select billing_country,
from invoice
order by total desc
limit 1


--Q. What are top3 values of total invoices?--

select total
from invoice
order by total desc 
limit 3

/* Q.Which city has the best customers? We would like to throw a promotional Music Festival in the city we made the most money. 
Write a query that returns one city that has the highest sum of invoice totals. 
Return both the city name & sum of all invoice totals */

select billing_city,sum(total) as highest_sum
from invoice 
group by billing_city
order by highest_sum desc
limit 1


/* Q.Who is the best customer? The customer who has spent the most money will be declared the best customer. 
Write a query that returns the person who has spent the most money.*/

SELECT c.last_name,c.first_name,sum(i.total) as spending
FROM customer as c join invoice as i on c.customer_id=i.customer_id
group by c.customer_id
order by spending desc 
limit 1


/*Q .Write query to return the email, first name, last name, & Genre of all Rock Music listeners. 
Return your list ordered alphabetically by email starting with A.*/
select * from track

select distinct email,first_name,last_name,genre.name
from customer
join invoice on customer.customer_id=invoice.customer_id
join invoice_line on invoice.invoice_id=invoice_line.invoice_id
join track on invoice_line.track_id=track.track_id
join genre on track.genre_id=genre.genre_id
where genre.name='Rock'
order by email 


/* Q.Let's invite the artists who have written the most rock music in our dataset. 
Write a query that returns the Artist name and total track count of the top 10 rock bands. */

select artist.artist_id,artist.name,count(artist.artist_id) as no_of_songs
from track
join album on track.album_id=album.album_id
join artist on album.artist_id= artist.artist_id
join genre on track.genre_id=genre.genre_id
where genre.name='Rock'
group by artist.artist_id
order by no_of_songs desc
limit 10

/* Q. Return all the track names that have a song length longer than the average song length. 
Return the Name and Milliseconds for each track. Order by the song length with the longest songs listed first*/

Select name, milliseconds  
from track
where milliseconds>
(select avg(milliseconds) from track)
order by milliseconds desc


/*Q.Find how much amount spent by each customer on artists? Write a query to return customer name, artist name and total spent */

with cte as(
	select artist.name as artist_name,artist.artist_id,sum(invoice_line.quantity*invoice_line.unit_price) as total_sales 
	from invoice_line
	join track on invoice_line.track_id=track.track_id
	join album on track.album_id=album.album_id
	join  artist on album.artist_id=artist.artist_id
	group by 1,2
	order by total_sales desc 
	limit 1
)
	select customer.first_name,customer.last_name,cte.artist_name,
	sum(invoice_line.quantity*invoice_line.unit_price) as amount_spent
    from invoice
    join customer on invoice.customer_id=customer.customer_id
	join invoice_line on invoice.invoice_id=invoice_line.invoice_id
	join track on invoice_line.track_id=track.track_id
	join album on track.album_id=album.album_id
    join cte on cte.artist_id=album.artist_id
	group by 1,2 ,3
	order by amount_spent desc

/* Q. We want to find out the most popular music Genre for each country. We determine the most popular genre as the genre 
with the highest amount of purchases. Write a query that returns each country along with the top Genre. For countries where 
the maximum number of purchases is shared return all Genres.*/

with cte as (
	select customer.country,genre.genre_id,genre.name,count(invoice_line.quantity) as highest_purchases,
	ROW_NUMBER() OVER(PARTITION BY customer.country ORDER BY COUNT(invoice_line.quantity) DESC) AS RowNo
	from invoice_line 
	join invoice on invoice_line.invoice_id=invoice.invoice_id
	join customer on  customer.customer_id = invoice.customer_id
	join track on invoice_line.track_id=track.track_id
	join genre on track.genre_id=genre.genre_id
	group by 1,2,3
	order by 3 asc, 4 desc
	
)
select * from cte  where RowNo<=1

	/* Q.  Write a query that determines the customer that has spent the most on music for each country. 
Write a query that returns the country along with the top customer and how much they spent. 
For countries where the top amount spent is shared, provide all customers who spent this amount.*/


with cte as(
	select customer.first_name,customer.last_name,invoice.billing_country,sum(invoice.total) as amount_spent,
	ROW_NUMBER() OVER(partition by billing_country order by sum(invoice.total) desc) as rown
	from customer
	join invoice on customer.customer_id=invoice.customer_id
	group by 1,2,3
	order by 3 asc, 4 desc
)

select * from cte where rown<=1





