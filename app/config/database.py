# Copy of models.py
# For testing purposes; can ignore

import os
from sqlalchemy import create_engine, Column, Integer, String, DateTime, Float, Boolean, ForeignKey
from sqlalchemy.ext.declarative import declarative_base
from sqlalchemy.orm import sessionmaker, relationship
from dotenv import load_dotenv
from datetime import datetime
from app.config.config import Config

# Load environment variables
load_dotenv()

# Database configuration
DATABASE_URL = Config.SQLALCHEMY_DATABASE_URI
print("FINAL DATABASE_URL used by create_engine():", DATABASE_URL)

# Create engine
engine = create_engine(DATABASE_URL, echo=True)
SessionLocal = sessionmaker(autocommit=False, autoflush=False, bind=engine)

Base = declarative_base()

class HotelChain(Base):
    __tablename__ = 'hotel_chain'

    id = Column(Integer, primary_key=True)
    name = Column(String(100), nullable=False)
    central_office_address = Column(String(200), nullable=False)
    email = Column(String(100), nullable=False)
    phone_number = Column(String(20), nullable=False)
    
    # Relationships
    hotels = relationship("Hotel", back_populates="chain")

class Hotel(Base):
    __tablename__ = 'hotel'

    id = Column(Integer, primary_key=True)
    chain_id = Column(Integer, ForeignKey('hotel_chains.id'))
    name = Column(String(100), nullable=False)
    address = Column(String(200), nullable=False)
    email = Column(String(100), nullable=False)
    phone_number = Column(String(20), nullable=False)
    category = Column(Integer, nullable=False)
    
    chain = relationship("HotelChain", back_populates="hotel")
    rooms = relationship("Room", back_populates="hotel")
    employees = relationship("Employee", back_populates="hotel")

class Room(Base):
    __tablename__ = 'room'

    id = Column(Integer, primary_key=True)
    hotel_id = Column(Integer, ForeignKey('hotel.id'))
    price = Column(Float, nullable=False)
    capacity = Column(Integer, nullable=False)
    view_type = Column(String(50), nullable=False)
    extendable = Column(Boolean, default=False)
    amenities = Column(String, nullable=True)
    damages = Column(String, nullable=True)
    
    hotel = relationship("Hotel", back_populates="room")
    bookings = relationship("Booking", back_populates="room")

class Customer(Base):
    __tablename__ = 'customer'

    id = Column(Integer, primary_key=True)
    full_name = Column(String(200), nullable=False)
    address = Column(String(200), nullable=False)
    id_type = Column(String(20), nullable=False)
    id_number = Column(String(50), unique=True, nullable=False)
    registration_date = Column(DateTime, default=datetime.utcnow)
    
    bookings = relationship("Booking", back_populates="customer")

class Employee(Base):
    __tablename__ = 'employee'

    id = Column(Integer, primary_key=True)
    hotel_id = Column(Integer, ForeignKey('hotel.id'))
    full_name = Column(String(200), nullable=False)
    address = Column(String(200), nullable=False)
    ssn = Column(String(50), unique=True, nullable=False)
    role = Column(String(100), nullable=False)
    
    hotel = relationship("Hotel", back_populates="employee")
    bookings = relationship("Booking", back_populates="employee")

class Booking(Base):
    __tablename__ = 'booking'

    id = Column(Integer, primary_key=True)
    customer_id = Column(Integer, ForeignKey('customer.id'))
    room_id = Column(Integer, ForeignKey('room.id'))
    employee_id = Column(Integer, ForeignKey('employee.id'))
    check_in_date = Column(DateTime, nullable=False)
    check_out_date = Column(DateTime, nullable=False)
    status = Column(String(50), nullable=False)
  
    customer = relationship("Customer", back_populates="booking")
    room = relationship("Room", back_populates="booking")
    employee = relationship("Employee", back_populates="booking")

def create_tables():
    Base.metadata.create_all(bind=engine)

# Get database session
def get_db():
    db = SessionLocal()
    try:
        yield db
    finally:
        db.close()