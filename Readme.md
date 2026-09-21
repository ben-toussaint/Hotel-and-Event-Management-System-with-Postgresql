# ATTRIBUTES IN SCHEMA

## CUSTOMER
Stores information about customers who book hotel rooms or events.

Schama:
```
Customer(
    customer_id PK,
    first_name,
    last_name,
    gender,
    phone,
    email,
    address
);
```

Relationships
One Customer can make many Hotel Bookings.
One Customer can make many Event Bookings.

## HOTEL_ROOM
Stores all hotel rooms.

Schema:
```
Hotel_Room(
    room_id PK,
    room_number,
    room_type,
    capacity,
    price_per_night,
    status
)
```

Relationships
One room can appear in many bookings over time.

## HOTEL_BOOKING
Records hotel reservations.

Schema:
```
Hotel_Booking(
    booking_id PK,
    customer_id FK,
    room_id FK,
    check_in_date,
    check_out_date,
    booking_date,
    booking_status
)
```

Relationships
Customer (1) --------< (M) Hotel_Booking.
Hotel_Room (1) --------< (M) Hotel_Booking.
Hotel_Booking (1) -------- (1) Payment.

## EVENT_HALL
Stores conference halls and event venues.

Schema:
```
Event_Hall(
    hall_id PK,
    hall_name,
    capacity,
    location,
    rental_price,
    status
)
```

Relationship:
Event_Hall (1) --------< (M) Event_Booking

## EVENT_BOOKING
Stores bookings made for events.
Schema:
```
Event_Booking(
    event_booking_id PK,
    customer_id FK,
    hall_id FK,
    event_name,
    event_date,
    start_time,
    end_time,
    number_of_guests,
    booking_status
)
```

Relationships:
Customer (1) --------< (M) Event_Booking
Event_Hall (1) --------< (M) Event_Booking
Event_Booking (1) -------- (1) Payment

## SERVICE
Stores extra services provided by the hotel.

Examples:
Catering
Decoration
Laundry
Airport Pickup
Wi-Fi
Projector Rental

Schema:
```
Service(
    service_id PK,
    service_name,
    description,
    price
)
```

Relationships
A service can be requested by many event bookings.
An event booking can request many services.
Therefore: Since PostgreSQL cannot directly implement a many-to-many relationship, we create a junction table.

## EVENT_SERVICE(Junction table)
Bridge (junction) table.

Schema:
```
Event_Service(
    event_booking_id FK,
    service_id FK,
    quantity,

    PRIMARY KEY(event_booking_id, service_id)
)
```

## PAYMENT
Stores payment information.

Schema:
```
Payment(
    payment_id PK,
    hotel_booking_id FK NULL,
    event_booking_id FK NULL,
    payment_date,
    amount,
    payment_method,
    payment_status
)
```

Relationships:
A payment belongs to either a hotel booking or an event booking.

## STAFF
Stores hotel employees.

```
Staff(
    staff_id PK,
    first_name,
    last_name,
    phone,
    position,
    salary
)
```

Relationships:
One staff member can manage many event bookings.(1:M)
Therefore: We should add staff_id FK inside Event_Booking.

## ROOM_MAINTENANCE
Keeps maintenance history for hotel rooms.

Schema:
```
Room_Maintenance(
    maintenance_id PK,
    room_id FK,
    staff_id FK,
    maintenance_date,
    description,
    maintenance_status
)
```

Relationships:
Hotel_Room (1) --------< (M) Room_Maintenance

Staff (1) --------< (M) Room_Maintenance