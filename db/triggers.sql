-- ALL TRIGGERS, FUNCTIONS, QUERIES, VIEWS


-- Customers cannot book more than 2 rooms at a time
CREATE OR REPLACE FUNCTION check_customer_booking_limit()
RETURNS TRIGGER AS $$
BEGIN
    IF (SELECT COUNT(*) FROM booking 
        WHERE customer_id = NEW.customer_id 
        AND status != 'Completed') > 2 THEN
        RAISE EXCEPTION 'Customer cannot book more than 2 rooms at a time';
    END IF;
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER enforce_booking_limit
BEFORE INSERT ON booking
FOR EACH ROW EXECUTE FUNCTION check_customer_booking_limit();

-- A room taken room cannot be rented
CREATE OR REPLACE FUNCTION check_room_availability()
RETURNS TRIGGER AS $$
BEGIN
    IF EXISTS (
        SELECT 1 FROM rental 
        WHERE room_id = NEW.room_id 
        AND (
            (NEW.check_in_date BETWEEN check_in_date AND check_out_date) OR
            (NEW.check_out_date BETWEEN check_in_date AND check_out_date) OR
            (check_in_date BETWEEN NEW.check_in_date AND NEW.check_out_date)
        )
    ) THEN
        RAISE EXCEPTION 'Room is not available for the selected dates';
    END IF;
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER enforce_room_availability
BEFORE INSERT ON rental
FOR EACH ROW EXECUTE FUNCTION check_room_availability();

-- Indexes
CREATE INDEX idx_booking_customer ON booking(customer_id);
CREATE INDEX idx_room_price ON room(price);
CREATE INDEX idx_employee_hotel ON employee(hotel_id);

-- View of available rooms per area
CREATE OR REPLACE VIEW available_rooms_per_area AS
SELECT h.address AS area, COUNT(r.room_id) AS available_rooms
FROM hotel h
JOIN room r ON r.hotel_id = h.hotel_id
WHERE r.room_id NOT IN (
    SELECT room_id FROM rental
    WHERE CURRENT_DATE BETWEEN check_in_date AND check_out_date
)
GROUP BY h.address;

-- View of room capacity per hotel
CREATE OR REPLACE VIEW total_room_capacity_per_hotel AS
SELECT h.hotel_id, h.hotel_name, SUM(r.capacity) AS total_capacity
FROM hotel h
JOIN room r ON r.hotel_id = h.hotel_id
GROUP BY h.hotel_id, h.hotel_name;