-- Sample Data for Hotel Chains
INSERT INTO hotel_chain (chain_name, central_office_address, email, phone_number) VALUES
('Luxury Retreats', '123 Executive Plaza, New York, NY 10001', 'contact@luxuryretreats.com', '2125551234'),
('Coastal Hotels', '456 Seaside Drive, Miami, FL 33101', 'info@coastalhotels.com', '3055556789'),
('Mountain Escapes', '789 Alpine Road, Denver, CO 80202', 'reservations@mountainescapes.com', '3035554567'),
('Urban Stays', '321 Downtown Avenue, Chicago, IL 60601', 'support@urbanstays.com', '3125552345'),
('Countryside Inns', '654 Rural Route, Austin, TX 78701', 'hello@countrysideinns.com', '5125557890');

-- Sample Hotels for each Chain
INSERT INTO hotel (chain_id, hotel_name, address, email, phone_number, category) VALUES
-- Luxury Retreats Hotels
(1, 'Luxury Manhattan Hotel', '789 Broadway, New York, NY 10003', 'manhattan@luxuryretreats.com', '2125559876', 5),
(1, 'Luxury Hamptons Resort', '123 Beach Road, East Hampton, NY 11937', 'hamptons@luxuryretreats.com', '6315552468', 5),

-- Coastal Hotels
(2, 'Miami Beach Grand', '100 Ocean Drive, Miami Beach, FL 33139', 'miamibeach@coastalhotels.com', '3055553690', 4),
(2, 'Key West Paradise', '200 Sunset Key, Key West, FL 33040', 'keywest@coastalhotels.com', '3055554321', 4),

-- Mountain Escapes
(3, 'Aspen Peak Lodge', '500 Mountain View, Aspen, CO 81611', 'aspen@mountainescapes.com', '9705551111', 4),
(3, 'Rocky Mountain Resort', '750 Alpine Way, Vail, CO 81657', 'vail@mountainescapes.com', '9705552222', 4),

-- Urban Stays
(4, 'Chicago Downtown Hotel', '123 Michigan Avenue, Chicago, IL 60611', 'downtown@urbanstays.com', '3125554567', 3),
(4, 'Chicago River Hotel', '456 Riverwalk, Chicago, IL 60601', 'river@urbanstays.com', '3125555678', 3),

-- Countryside Inns
(5, 'Texas Hill Country Inn', '100 Ranch Road, Fredericksburg, TX 78624', 'hillcountry@countrysideinns.com', '8305551234', 3),
(5, 'Austin Countryside Lodge', '250 Rural Route, Austin, TX 78717', 'austin@countrysideinns.com', '5125556789', 3);

-- Sample Rooms
INSERT INTO room (hotel_id, price, capacity, view_type, extendable, amenities, damages) VALUES
-- Luxury Manhattan Hotel Rooms
(1, 350.00, 2, 'Sea View', true, '{Wi-Fi, TV, Mini-bar, Air Conditioning}', NULL),
(1, 500.00, 4, 'Sea View', true, '{Wi-Fi, TV, Mini-bar, Air Conditioning, Jacuzzi}', NULL),
(1, 250.00, 1, 'Mountain View', false, '{Wi-Fi, TV, Air Conditioning}', NULL),

-- Luxury Hamptons Resort Rooms
(2, 600.00, 2, 'Sea View', true, '{Wi-Fi, TV, Mini-bar, Air Conditioning, Balcony}', NULL),
(2, 800.00, 4, 'Mountain View', true, '{Wi-Fi, TV, Mini-bar, Air Conditioning, Private Terrace}', NULL),

-- Miami Beach Grand Rooms
(3, 300.00, 2, 'Mountain View', true, '{Wi-Fi, TV, Mini-bar, Air Conditioning}', NULL),
(3, 450.00, 3, 'Sea View', true, '{Wi-Fi, TV, Mini-bar, Air Conditioning, Kitchenette}', NULL),

-- Key West Paradise Rooms
(4, 400.00, 2, 'Sea View', true, '{Wi-Fi, TV, Mini-bar, Air Conditioning, Balcony}', NULL),
(4, 550.00, 4, 'Sea View', true, '{Wi-Fi, TV, Mini-bar, Air Conditioning, Private Deck}', NULL),

-- Aspen Peak Lodge Rooms
(5, 400.00, 2, 'Sea View', true, '{Wi-Fi, TV, Mini-bar, Air Conditioning}', NULL),
(5, 600.00, 4, 'Mountain View', true, '{Wi-Fi, TV, Mini-bar, Air Conditioning, Fireplace}', NULL),

-- Rocky Mountain Resort Rooms
(6, 350.00, 2, 'Mountain View', true, '{Wi-Fi, TV, Mini-bar, Air Conditioning}', NULL),
(6, 500.00, 3, 'Mountain View', true, '{Wi-Fi, TV, Mini-bar, Air Conditioning, Private Balcony}', NULL),

-- Chicago Downtown Hotel Rooms
(7, 250.00, 2, 'Sea View', false, '{Wi-Fi, TV, Air Conditioning}', NULL),
(7, 350.00, 3, 'Mountain View', true, '{Wi-Fi, TV, Mini-bar, Air Conditioning}', NULL),

-- Chicago River Hotel Rooms
(8, 200.00, 1, 'Sea View', false, '{Wi-Fi, TV, Air Conditioning}', NULL),
(8, 300.00, 2, 'Sea View', true, '{Wi-Fi, TV, Mini-bar, Air Conditioning}', NULL),

-- Texas Hill Country Inn Rooms
(9, 200.00, 2, 'Mountain View', true, '{Wi-Fi, TV, Air Conditioning}', NULL),
(9, 300.00, 3, 'Mountain View', true, '{Wi-Fi, TV, Mini-bar, Air Conditioning}', NULL),

-- Austin Countryside Lodge Rooms
(10, 180.00, 1, 'Mountain View', false, '{Wi-Fi, TV, Air Conditioning}', NULL),
(10, 250.00, 2, 'Sea View', true, '{Wi-Fi, TV, Mini-bar, Air Conditioning}', NULL);

-- Sample Customers
INSERT INTO customer (full_name, address, id_type, id_number, registration_date) VALUES
('John Smith', '123 Main St, New York, NY 10001', 'SSN', '123-45-6789', CURRENT_DATE),
('Emily Johnson', '456 Elm Street, Chicago, IL 60601', 'Driver''s License', 'A1234567', CURRENT_DATE),
('Michael Brown', '789 Oak Avenue, Miami, FL 33101', 'SIN', '987-654-321', CURRENT_DATE),
('Sarah Davis', '321 Pine Road, Denver, CO 80202', 'SSN', '456-78-9012', CURRENT_DATE),
('David Wilson', '654 Maple Lane, Austin, TX 78701', 'Driver''s License', 'B9876543', CURRENT_DATE);

-- Sample Employees
INSERT INTO employee (hotel_id, full_name, address, ssn, role) VALUES
(1, 'Robert Taylor', '100 Staff Quarters, New York, NY 10002', '111-22-3333', 'Front Desk Manager'),
(3, 'Jennifer Martinez', '200 Employee Housing, Miami, FL 33102', '444-55-6666', 'Guest Services Coordinator'),
(5, 'Christopher Lee', '300 Lodge Staff Area, Aspen, CO 81611', '777-88-9999', 'Concierge'),
(7, 'Amanda Rodriguez', '400 Hotel Staff Residence, Chicago, IL 60602', '222-33-4444', 'Reservation Specialist'),
(9, 'Daniel Kim', '500 Inn Staff Complex, Fredericksburg, TX 78624', '555-66-7777', 'Operations Manager');

-- Sample Managers (Subset of Employees)
INSERT INTO manager (employee_id, hotel_id) VALUES
(1, 1),
(2, 3),
(3, 5),
(4, 7),
(5, 9);

-- Sample Bookings
INSERT INTO booking (customer_id, room_id, employee_id, check_in_date, check_out_date, status) VALUES
(1, 1, 1, CURRENT_DATE + INTERVAL '15 days', CURRENT_DATE + INTERVAL '18 days', 'Confirmed'),
(2, 6, 2, CURRENT_DATE + INTERVAL '20 days', CURRENT_DATE + INTERVAL '23 days', 'Pending'),
(3, 11, 3, CURRENT_DATE + INTERVAL '10 days', CURRENT_DATE + INTERVAL '13 days', 'Confirmed'),
(4, 16, 4, CURRENT_DATE + INTERVAL '25 days', CURRENT_DATE + INTERVAL '28 days', 'Pending'),
(5, 21, 5, CURRENT_DATE + INTERVAL '30 days', CURRENT_DATE + INTERVAL '33 days', 'Confirmed');