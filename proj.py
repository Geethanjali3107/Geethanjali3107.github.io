from flask import Flask, request, jsonify
import mysql.connector
from mysql.connector import Error

app = Flask(__name__)

def get_db_connection():
    return mysql.connector.connect(
        host='localhost',
        database='railway_db',
        user='your_mysql_user',
        password='your_mysql_password'
    )

@app.route('/book_ticket', methods=['POST'])
def book_ticket():
    data = request.json
    passenger_id = data.get('passengerId')
    train_id = data.get('trainId')
    seat_number = data.get('seatNumber')

    if not all([passenger_id, train_id, seat_number]):
        return jsonify({'error': 'All fields are required.'})

    try:
        conn = get_db_connection()
        cursor = conn.cursor()

        # Call the stored procedure BookTicket
        cursor.callproc('BookTicket', [passenger_id, train_id, seat_number])
        conn.commit()

        # Assuming the procedure returns message as a select
        for result in cursor.stored_results():
            row = result.fetchone()
            message = row[0] if row else 'Booking successful.'
        
        cursor.close()
        conn.close()
        return jsonify({'message': message})

    except Error as e:
        return jsonify({'error': str(e)})

@app.route('/cancel_booking', methods=['POST'])
def cancel_booking():
    data = request.json
    booking_id = data.get('bookingId')

    if not booking_id:
        return jsonify({'error': 'Booking ID is required.'})

    try:
        conn = get_db_connection()
        cursor = conn.cursor()

        # Call the stored procedure CancelBooking
        cursor.callproc('CancelBooking', [booking_id])
        conn.commit()

        for result in cursor.stored_results():
            row = result.fetchone()
            message = row[0] if row else 'Booking cancelled.'

        cursor.close()
        conn.close()
        return jsonify({'message': message})

    except Error as e:
        return jsonify({'error': str(e)})

if __name__ == '__main__':
    app.run(debug=True)
