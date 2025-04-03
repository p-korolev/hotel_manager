# All API routes using Flask
from flask import Blueprint, request, jsonify
from flask import render_template
from app.config.database import get_db
from app.models.models import Room, Booking, Customer, Hotel, HotelChain
from sqlalchemy.orm import Session
from datetime import datetime

api = Blueprint('api', __name__)

@api.route('/api/rooms/search', methods=['POST'])
def search_rooms():
    data = request.json
    db = next(get_db())
    
    try:
        # Filtering dates
        check_in = datetime.fromisoformat(data.get('check_in'))
        check_out = datetime.fromisoformat(data.get('check_out'))
        
        # Query
        query = db.query(Room)
        
        # Filtering booked rooms
        booked_rooms = db.query(Booking.room_id).filter(
            (Booking.check_in_date < check_out) & 
            (Booking.check_out_date > check_in)
        ).all()
        
        # Excluding booked rooms
        query = query.filter(~Room.room_id.in_([r[0] for r in booked_rooms]))
        
        # Checking other constraints
        if data.get('capacity'):
            query = query.filter(Room.capacity == data['capacity'])
        
        if data.get('view_type'):
            query = query.filter(Room.view_type == data['view_type'])
        
        if data.get('max_price'):
            query = query.filter(Room.price <= data['max_price'])
        
        # Display filtered results
        rooms = query.all()
        return jsonify([
            {
                'id': room.room_id, 
                'price': room.price, 
                'capacity': room.capacity, 
                'view_type': room.view_type,
                'hotel_name': room.hotel.hotel_name
            } for room in rooms
        ])
    
    # Print exception if filtering errors occur
    except Exception as e:
        import traceback
        traceback.print_exc()
        return jsonify({'error': str(e)}), 400
    finally:
        db.close()

@api.route('/api/bookings/create', methods=['POST'])
def create_booking():
    data = request.json
    db = next(get_db())
    
    try:
        # Customer validation
        customer = db.query(Customer).get(data['customer_id'])
        if not customer:
            return jsonify({'error': 'Customer not found'}), 404
        
        # Room validation
        room = db.query(Room).get(data['room_id'])
        if not room:
            return jsonify({'error': 'Room not found'}), 404
        
        # Create booking
        new_booking = Booking(
            customer_id=customer.customer_id,
            room_id=room.room_id,
            check_in_date=datetime.fromisoformat(data['check_in']),
            check_out_date=datetime.fromisoformat(data['check_out']),
            status='Confirmed'
        )
        
        db.add(new_booking)
        db.commit()
        
        return jsonify({
            'booking_id': new_booking.booking_id,
            'message': 'Booking created successfully'
        }), 201
    
    # Print error if booking fails
    except Exception as e:
        db.rollback()
        return jsonify({'error': str(e)}), 400
    finally:
        db.close()


@api.route('/api/hotels', methods=['GET'])
def list_hotels():
    db = next(get_db())
    try:
        chain_id = request.args.get('chain_id')
        query = db.query(Hotel)
        if chain_id:
            query = query.filter(Hotel.chain_id == chain_id)
        hotels = query.all()
        return jsonify([
            {
                'id': hotel.hotel_id,
                'name': hotel.hotel_name,
                'address': hotel.address,
                'category': hotel.category
            } for hotel in hotels
        ])
    except Exception as e:
        return jsonify({'error': str(e)}), 400
    finally:
        db.close()

@api.route('/api/hotel-chains', methods=['GET'])
def get_hotel_chains():
    db = next(get_db())
    try:
        chains = db.query(HotelChain).all()
        return jsonify([
            {
                'id': chain.chain_id,
                'name': chain.chain_name,
                'email': chain.email,
                'phone': chain.phone_number
            } for chain in chains
        ])
    except Exception as e:
        return jsonify({'error': str(e)}), 400
    finally:
        db.close()

# Home route, displays site html page
@api.route('/', methods=['GET'])
def home():
    return render_template('site.html')

