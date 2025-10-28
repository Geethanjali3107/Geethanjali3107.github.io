DELIMITER $$

CREATE PROCEDURE CancelBooking(
    IN p_booking_id INT
)
BEGIN
    DECLARE booking_exists INT;

    -- Check if booking exists and is confirmed
    SELECT COUNT(*) INTO booking_exists 
    FROM Booking 
    WHERE booking_id = p_booking_id AND status = 'Confirmed';

    IF booking_exists = 0 THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Active booking not found';
    ELSE
        UPDATE Booking SET status = 'Cancelled' WHERE booking_id = p_booking_id;
        SELECT CONCAT('Booking cancelled successfully, ID: ', p_booking_id) AS message;
    END IF;
END$$

DELIMITER ;
