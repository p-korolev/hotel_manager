# This is essentially a copy of connection.py
# For testing; ignore

import os
from sqlalchemy import create_engine, Column, Integer, String, Date, Float, Boolean, ARRAY, Text
from sqlalchemy.ext.declarative import declarative_base
from sqlalchemy.orm import sessionmaker
from dotenv import load_dotenv
from datetime import datetime, timedelta

# Load environment variables
load_dotenv()

# Database connection
from app.config.config import Config
DATABASE_URL = Config.SQLALCHEMY_DATABASE_URI
engine = create_engine(DATABASE_URL)
SessionLocal = sessionmaker(autocommit=False, autoflush=False, bind=engine)
Base = declarative_base()

class DatabaseManager:
    def __init__(self):
        self.session = SessionLocal()

    def add_hotel_chain(self, name, address, email, phone):
        try:
            from sqlalchemy.orm.exc import IntegrityError
            from app.models.models import HotelChain

            new_chain = HotelChain(
                chain_name=name,
                central_office_address=address,
                email=email,
                phone_number=phone
            )
            self.session.add(new_chain)
            self.session.commit()
            return new_chain.chain_id
        except IntegrityError:
            self.session.rollback()
            raise ValueError("Hotel chain could not be added due to data constraints.")

    def search_available_rooms(self, check_in, check_out, capacity=None, view_type=None, max_price=None):
        from app.models.models import Room, Rental, Hotel

        query = self.session.query(Room).join(Hotel)
        
        # Excluding unavailable rooms
        subquery = self.session.query(Rental.room_id).filter(
            (Rental.check_in_date < check_out) & 
            (Rental.check_out_date > check_in)
        ).subquery()

        query = query.filter(~Room.room_id.in_(subquery))

        # Additional filtering
        if capacity:
            query = query.filter(Room.capacity == capacity)
        if view_type:
            query = query.filter(Room.view_type == view_type)
        if max_price:
            query = query.filter(Room.price <= max_price)

        return query.all()

    def create_booking(self, customer_id, room_id, check_in, check_out):
        from app.models.models import Booking

        new_booking = Booking(
            customer_id=customer_id,
            room_id=room_id,
            check_in_date=check_in,
            check_out_date=check_out,
            status='Pending'
        )
        self.session.add(new_booking)
        self.session.commit()
        return new_booking.booking_id

    def close(self):
        self.session.close()

# For testing; ignore
if __name__ == '__main__':
    db = DatabaseManager()
    
    available_rooms = db.search_available_rooms(
        check_in=datetime.now().date(),
        check_out=datetime.now().date() + timedelta(days=3),
        capacity=2,
        view_type='Sea View',
        max_price=200.00
    )
    for room in available_rooms:
        print(f"Room {room.room_id}: ${room.price}, Capacity: {room.capacity}")
    db.close()

    