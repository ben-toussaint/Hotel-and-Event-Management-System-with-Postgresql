CREATE TABLE Customer(
    customer_id SERIAL PRIMARY KEY,
    first_name VARCHAR(50) NOT NULL,
    last_name VARCHAR(50) NOT NULL,
    gender VARCHAR(10) NOT NULL
        CHECK(gender IN ('Male','Female')),
    phone VARCHAR(15) NOT NULL UNIQUE,
    email VARCHAR(100) NOT NULL UNIQUE,
    address VARCHAR(100) NOT NULL
);

CREATE TABLE Hotel_Room(
    room_id SERIAL PRIMARY KEY,
    room_number VARCHAR(10) NOT NULL UNIQUE,
    room_type VARCHAR(30) NOT NULL,
    capacity INT NOT NULL
        CHECK(capacity > 0),
    price_per_night DECIMAL(10,2) NOT NULL
        CHECK(price_per_night > 0),
    status VARCHAR(20)
        DEFAULT 'Available'
        CHECK(status IN ('Available','Occupied','Maintenance'))
);

CREATE TABLE Hotel_Booking(
    booking_id SERIAL PRIMARY KEY,

    customer_id INT NOT NULL,

    room_id INT NOT NULL,

    check_in_date DATE NOT NULL,

    check_out_date DATE NOT NULL,

    booking_date DATE
        DEFAULT CURRENT_DATE,

    booking_status VARCHAR(20)
        DEFAULT 'Pending'
        CHECK(booking_status IN
        ('Pending','Confirmed','Cancelled')),

    FOREIGN KEY(customer_id)
        REFERENCES Customer(customer_id),

    FOREIGN KEY(room_id)
        REFERENCES Hotel_Room(room_id),

    CHECK(check_out_date > check_in_date)
);

CREATE TABLE Event_Hall(

    hall_id SERIAL PRIMARY KEY,

    hall_name VARCHAR(50)
        NOT NULL UNIQUE,

    capacity INT
        NOT NULL
        CHECK(capacity>0),

    location VARCHAR(100)
        NOT NULL,

    rental_price DECIMAL(10,2)
        NOT NULL
        CHECK(rental_price>0),

    status VARCHAR(20)
        DEFAULT 'Available'
        CHECK(status IN
        ('Available','Booked','Maintenance'))
);

CREATE TABLE Staff(

    staff_id SERIAL PRIMARY KEY,

    first_name VARCHAR(50) NOT NULL,

    last_name VARCHAR(50) NOT NULL,

    phone VARCHAR(15)
        NOT NULL UNIQUE,

    position VARCHAR(50)
        NOT NULL,

    salary DECIMAL(10,2)
        CHECK(salary>0)
);

CREATE TABLE Event_Booking(

    event_booking_id SERIAL PRIMARY KEY,

    customer_id INT NOT NULL,

    hall_id INT NOT NULL,

    staff_id INT NOT NULL,

    event_name VARCHAR(100)
        NOT NULL,

    event_date DATE NOT NULL,

    start_time TIME NOT NULL,

    end_time TIME NOT NULL,

    number_of_guests INT
        CHECK(number_of_guests>0),

    booking_status VARCHAR(20)
        DEFAULT 'Pending'
        CHECK(booking_status IN
        ('Pending','Confirmed','Cancelled')),

    FOREIGN KEY(customer_id)
        REFERENCES Customer(customer_id),

    FOREIGN KEY(hall_id)
        REFERENCES Event_Hall(hall_id),

    FOREIGN KEY(staff_id)
        REFERENCES Staff(staff_id),

    CHECK(end_time > start_time)
);

CREATE TABLE Service(

    service_id SERIAL PRIMARY KEY,

    service_name VARCHAR(50)
        NOT NULL UNIQUE,

    description TEXT,

    price DECIMAL(10,2)
        NOT NULL
        CHECK(price>=0)
);

CREATE TABLE Event_Service(

    event_booking_id INT,

    service_id INT,

    quantity INT
        DEFAULT 1
        CHECK(quantity>0),

    --PRIMARY KEY(event_booking_id,service_id),

    FOREIGN KEY(event_booking_id)
        REFERENCES Event_Booking(event_booking_id),

    FOREIGN KEY(service_id)
        REFERENCES Service(service_id)
);
DROP TABLE Event_Service;
CREATE TABLE Payment(

    payment_id SERIAL PRIMARY KEY,

    hotel_booking_id INT,

    event_booking_id INT,

    payment_date DATE
        DEFAULT CURRENT_DATE,

    amount DECIMAL(10,2)
        NOT NULL
        CHECK(amount>0),

    payment_method VARCHAR(20)
        NOT NULL
        CHECK(payment_method IN
        ('Cash','Card','Mobile Money','Bank Transfer')),

    payment_status VARCHAR(20)
        DEFAULT 'Pending'
        CHECK(payment_status IN
        ('Pending','Completed','Failed')),

    FOREIGN KEY(hotel_booking_id)
        REFERENCES Hotel_Booking(booking_id),

    FOREIGN KEY(event_booking_id)
        REFERENCES Event_Booking(event_booking_id)
);

CREATE TABLE Room_Maintenance(

    maintenance_id SERIAL PRIMARY KEY,

    room_id INT NOT NULL,

    staff_id INT NOT NULL,

    maintenance_date DATE
        DEFAULT CURRENT_DATE,

    description TEXT
        NOT NULL,

    maintenance_status VARCHAR(20)
        DEFAULT 'Pending'
        CHECK(maintenance_status IN
        ('Pending','Completed')),

    FOREIGN KEY(room_id)
        REFERENCES Hotel_Room(room_id),

    FOREIGN KEY(staff_id)
        REFERENCES Staff(staff_id)
);

--INSERTING RECORDS
--CUSTOMER
INSERT INTO Customer(first_name,last_name,gender,phone,email,address)
VALUES
('John','Smith','Male','0788000001','john.smith@gmail.com','Kigali'),
('Alice','Johnson','Female','0788000002','alice@gmail.com','Musanze'),
('Peter','Brown','Male','0788000003','peter@gmail.com','Huye'),
('Grace','Uwase','Female','0788000004','grace@gmail.com','Rubavu'),
('Kevin','Mugisha','Male','0788000005','kevin@gmail.com','Kigali'),
('Linda','Mukamana','Female','0788000006','linda@gmail.com','Muhanga'),
('Eric','Habimana','Male','0788000007','eric@gmail.com','Nyagatare'),
('Diane','Uwera','Female','0788000008','diane@gmail.com','Rusizi'),
('Patrick','Ndayisaba','Male','0788000009','patrick@gmail.com','Kigali'),
('Sandra','Ingabire','Female','0788000010','sandra@gmail.com','Kayonza');

--Hotel rooms
INSERT INTO Hotel_Room(room_number,room_type,capacity,price_per_night,status)
VALUES
('101','Single',1,45,'Available'),
('102','Single',1,45,'Available'),
('201','Double',2,80,'Available'),
('202','Double',2,80,'Occupied'),
('301','Suite',4,150,'Available'),
('302','Suite',4,150,'Maintenance'),
('401','VIP',6,250,'Available'),
('402','VIP',6,250,'Available');

--Event Halls
INSERT INTO Hotel_Room(room_number,room_type,capacity,price_per_night,status)
VALUES
('101','Single',1,45,'Available'),
('102','Single',1,45,'Available'),
('201','Double',2,80,'Available'),
('202','Double',2,80,'Occupied'),
('301','Suite',4,150,'Available'),
('302','Suite',4,150,'Maintenance'),
('401','VIP',6,250,'Available'),
('402','VIP',6,250,'Available');

--Staff
INSERT INTO Staff(first_name,last_name,phone,position,salary)
VALUES
('James','Mugabo','0788111111','Receptionist',600),
('Olivia','Uwimana','0788222222','Event Manager',900),
('Daniel','Hakizimana','0788333333','Maintenance Officer',700),
('Sarah','Mukeshimana','0788444444','Accountant',850);

--Service
INSERT INTO Service(service_name,description,price)
VALUES
('Catering','Food and Drinks',1500),
('Decoration','Hall Decoration',800),
('Projector','Projector Rental',120),
('Laundry','Laundry Service',30),
('Airport Pickup','Transport Service',60);

--Hotel_Booking
INSERT INTO Hotel_Booking
(customer_id,room_id,check_in_date,check_out_date,booking_status)
VALUES
(1,1,'2026-08-01','2026-08-03','Confirmed'),
(2,3,'2026-08-02','2026-08-06','Confirmed'),
(3,5,'2026-08-05','2026-08-07','Pending'),
(4,2,'2026-08-08','2026-08-10','Confirmed'),
(5,7,'2026-08-10','2026-08-12','Cancelled'),
(6,8,'2026-08-12','2026-08-14','Confirmed'),
(7,1,'2026-08-16','2026-08-18','Pending'),
(8,3,'2026-08-20','2026-08-22','Confirmed');

--Event_Booking.
INSERT INTO Hotel_Booking
(customer_id,room_id,check_in_date,check_out_date,booking_status)
VALUES
(1,1,'2026-08-01','2026-08-03','Confirmed'),
(2,3,'2026-08-02','2026-08-06','Confirmed'),
(3,5,'2026-08-05','2026-08-07','Pending'),
(4,2,'2026-08-08','2026-08-10','Confirmed'),
(5,7,'2026-08-10','2026-08-12','Cancelled'),
(6,8,'2026-08-12','2026-08-14','Confirmed'),
(7,1,'2026-08-16','2026-08-18','Pending'),
(8,3,'2026-08-20','2026-08-22','Confirmed');

SELECT *
FROM Hotel_Booking;

--Event service
INSERT INTO Event_Service
(event_booking_id, service_id, quantity)
VALUES
(7,1,1),
(7,2,1),
(8,1,1),
(9,3,2),
(10,2,1),
(12,5,3);

--Payment.
INSERT INTO Payment
(hotel_booking_id,event_booking_id,amount,payment_method,payment_status)
VALUES
(1,NULL,90,'Card','Completed'),
(2,NULL,320,'Cash','Completed'),
(3,NULL,300,'Mobile Money','Pending'),
(4,NULL,160,'Card','Completed'),
(5,NULL,500,'Bank Transfer','Failed'),
(6,NULL,300,'Cash','Completed'),
(NULL,1,2700,'Bank Transfer','Completed'),
(NULL,2,2400,'Card','Completed'),
(NULL,3,2000,'Mobile Money','Pending'),
(NULL,6,3800,'Bank Transfer','Completed');

--
