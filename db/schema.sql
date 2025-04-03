-- Hotel Chain Table
CREATE TABLE hotel_chain (
    chain_id SERIAL PRIMARY KEY,
    chain_name VARCHAR(100) NOT NULL,
    central_office_address VARCHAR(200) NOT NULL,
    email VARCHAR(100) NOT NULL CHECK (email ~* '^[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\.[A-Z|a-z]{2,}$'),
    phone_number VARCHAR(20) NOT NULL CHECK (phone_number ~ '^\d{10}$')
);

-- Hotel Table
CREATE TABLE hotel (
    hotel_id SERIAL PRIMARY KEY,
    chain_id INTEGER REFERENCES hotel_chain(chain_id) ON DELETE CASCADE,
    hotel_name VARCHAR(100) NOT NULL,
    address VARCHAR(200) NOT NULL,
    email VARCHAR(100),
    phone_number VARCHAR(20),
    category INTEGER NOT NULL CHECK (category >= 1 AND category <= 5)
);

-- Room Table
CREATE TABLE room (
    room_id SERIAL PRIMARY KEY,
    hotel_id INTEGER REFERENCES hotel(hotel_id) ON DELETE CASCADE,
    price NUMERIC(10,2) CHECK (price > 0),
    capacity INTEGER CHECK (capacity > 0),
    view_type VARCHAR(50) CHECK (view_type IN ('Sea View', 'Mountain View', 'No View')),
    extendable BOOLEAN DEFAULT FALSE,
    amenities TEXT[],
    damages TEXT
);

-- Customer Table
CREATE TABLE customer (
    customer_id SERIAL PRIMARY KEY,
    full_name VARCHAR(200) NOT NULL,
    address VARCHAR(200) NOT NULL,
    id_type VARCHAR(20) CHECK (id_type IN ('SIN', 'SSN', 'Driver''s License')),
    id_number VARCHAR(50) UNIQUE NOT NULL,
    registration_date DATE DEFAULT CURRENT_DATE
);

-- Employee Table
CREATE TABLE employee (
    employee_id SERIAL PRIMARY KEY,
    hotel_id INTEGER REFERENCES hotel(hotel_id) ON DELETE CASCADE,
    full_name VARCHAR(200) NOT NULL,
    address VARCHAR(200) NOT NULL,
    ssn VARCHAR(50) UNIQUE NOT NULL,
    role VARCHAR(100) NOT NULL CHECK (role != '')
);

-- Manager Table (Sub-entity of Employee)
CREATE TABLE manager (
    employee_id INTEGER PRIMARY KEY REFERENCES employee(employee_id) ON DELETE CASCADE,
    hotel_id INTEGER REFERENCES hotel(hotel_id) UNIQUE
);

-- Booking Table
CREATE TABLE booking (
    booking_id SERIAL PRIMARY KEY,
    customer_id INTEGER REFERENCES customer(customer_id),
    room_id INTEGER REFERENCES room(room_id),
    employee_id INTEGER REFERENCES employee(employee_id),
    check_in_date DATE NOT NULL,
    check_out_date DATE NOT NULL,
    status VARCHAR(50) NOT NULL CHECK (status != ''),
    CONSTRAINT check_dates CHECK (check_in_date < check_out_date)
);

-- Rental Table
CREATE TABLE rental (
    rental_id SERIAL PRIMARY KEY,
    booking_id INTEGER REFERENCES booking(booking_id),
    customer_id INTEGER REFERENCES customer(customer_id),
    room_id INTEGER REFERENCES room(room_id),
    employee_id INTEGER REFERENCES employee(employee_id),
    check_in_date DATE NOT NULL,
    check_out_date DATE NOT NULL
);

-- Archive Table
CREATE TABLE archive (
    archive_id SERIAL PRIMARY KEY,
    room_id INTEGER,
    booking_id INTEGER,
    customer_id INTEGER,
    rental_id INTEGER,
    employee_id INTEGER,
    archived_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);
