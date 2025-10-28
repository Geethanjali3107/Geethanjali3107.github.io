CREATE TABLE Passenger (
    passenger_id INT PRIMARY KEY AUTO_INCREMENT,
    name VARCHAR(50) NOT NULL,
    passport_no VARCHAR(20) UNIQUE NOT NULL,
    gender CHAR(1),
    nationality VARCHAR(20) DEFAULT 'Indian'
);

CREATE TABLE RailwayStation (
    station_id INT PRIMARY KEY AUTO_INCREMENT,
    name VARCHAR(50),
    city VARCHAR(50),
    state VARCHAR(50)
);

CREATE TABLE Train (
    train_id INT PRIMARY KEY AUTO_INCREMENT,
    train_name VARCHAR(100),
    source_station_id INT,
    destination_station_id INT,
    departure DATETIME,
    arrival DATETIME,
    FOREIGN KEY (source_station_id) REFERENCES RailwayStation(station_id),
    FOREIGN KEY (destination_station_id) REFERENCES RailwayStation(station_id)
);

CREATE TABLE Booking (
    booking_id INT PRIMARY KEY AUTO_INCREMENT,
    passenger_id INT NOT NULL,
    train_id INT NOT NULL,
    seat_number VARCHAR(10) NOT NULL,
    booking_date DATE NOT NULL,
    status ENUM('Confirmed', 'Cancelled') DEFAULT 'Confirmed',
    FOREIGN KEY (passenger_id) REFERENCES Passenger(passenger_id),
    FOREIGN KEY (train_id) REFERENCES Train(train_id)
);
