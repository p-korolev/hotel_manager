-- Query to see bookings by customer
SELECT customer_id, COUNT(*) AS total_bookings
FROM booking
GROUP BY customer_id;

-- Query to see which customers have more than 1 booking
SELECT full_name
FROM customer
WHERE customer_id IN (
    SELECT customer_id
    FROM booking
    WHERE status = 'Pending'
    GROUP BY customer_id
    HAVING COUNT(*) > 1
);