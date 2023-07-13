-- DROP DATABASE aws_p5_gans_database;
CREATE DATABASE aws_p5_gans_database;

USE aws_p5_gans_database;

-- SELECT * FROM weather_table;

-- DROP TABLE city_table;
CREATE TABLE city_table (
	city_id VARCHAR(6),
    city_name VARCHAR(50),
    country_code VARCHAR(4),
    PRIMARY KEY (city_id)
);

-- DROP TABLE airport_table;
CREATE TABLE airport_table (
	iata_code VARCHAR(6), 
    airport_name VARCHAR(50),
    PRIMARY KEY (iata_code)
);

-- DROP TABLE city_airport_table;
CREATE TABLE city_airport_table (
	city_id VARCHAR(6), 
    iata_code VARCHAR(6), 
    FOREIGN KEY (city_id) REFERENCES city_table (city_id),
    FOREIGN KEY (iata_code) REFERENCES airport_table (iata_code)
);

-- DROP TABLE city_data_table;
CREATE TABLE city_data_table (
	city_id VARCHAR (6),
    city_name VARCHAR(50),
	country VARCHAR(50),
	latitude FLOAT(6),
	longitude FLOAT(6),
	population INTEGER,
	FOREIGN KEY (city_id) references city_table (city_id),
    primary key (city_name)
);

-- DROP TABLE weather_table;
CREATE TABLE weather_table (
	city_name VARCHAR(50),
	country_code VARCHAR(4),
	date_time DATETIME,
	temperature FLOAT(2),
	wind_speed FLOAT(2),
	humidity INT,
	outlook VARCHAR(50),
	data_collection_from DATETIME,
    FOREIGN KEY (city_name) REFERENCES city_data_table (city_name)
    );
    
-- DROP TABLE arrivals_table;
CREATE TABLE arrivals_table (
	city_id VARCHAR(6),
	flight_number VARCHAR(10),
	arrival_time DATETIME,
	from_icao VARCHAR(4),
	from_iata VARCHAR(4),
	from_city VARCHAR(50),
	arrival_terminal VARCHAR(2),
	airline VARCHAR(50),
	data_collection_from DATETIME, 
    FOREIGN KEY (city_id) REFERENCES city_table (city_id)
);
