DELIMITER $$

CREATE PROCEDURE BookTicket(
    IN p_passenger_id INT,
    IN p_train_id INT,
    IN p_seat_number VARCHAR(10)
)
BEGIN
    DECLARE seat_count INT;
    DECLARE auto_booking_id INT;

    -- Check if passenger exists
    IF NOT EXISTS (SELECT 1 FROM Passenger WHERE passenger_id = p_passenger_id) THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Passenger does not exist';
    END IF;

    -- Check if train exists
    IF NOT EXISTS (SELECT 1 FROM Train WHERE train_id = p_train_id) THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Train does not exist';
    END IF;

    -- Check if seat is already booked and confirmed
    SELECT COUNT(*) INTO seat_count 
    FROM Booking 
    WHERE train_id = p_train_id AND seat_number = p_seat_number AND status = 'Confirmed';

    IF seat_count > 0 THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Seat already booked';
    ELSE
        INSERT INTO Booking (passenger_id, train_id, seat_number, booking_date, status)
        VALUES (p_passenger_id, p_train_id, p_seat_number, CURDATE(), 'Confirmed');

        SELECT LAST_INSERT_ID() INTO auto_booking_id;
        SELECT CONCAT('Booking successful, ID: ', auto_booking_id) AS message;
    END IF;
END$$

DELIMITER ;
