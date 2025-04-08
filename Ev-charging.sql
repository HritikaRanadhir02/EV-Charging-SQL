-- SQL Project: EV Charging Station Usage Analysis
use evcharging;
-- STEP 1: Create Tables
-- STEP 2: Example Data Inserts 
DROP TABLE station_usage;    -- if already present 
DROP TABLE chargers;
DROP TABLE stations;
CREATE TABLE stations (
    station_id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(100),
    city VARCHAR(100),
    state VARCHAR(50),
    latitude DECIMAL(9,6),
    longitude DECIMAL(9,6)
);
CREATE TABLE chargers (
    charger_id INT AUTO_INCREMENT PRIMARY KEY,
    type VARCHAR(50),
    power_output_kW DECIMAL(5,2)
);
INSERT INTO stations (name, city, state, latitude, longitude) VALUES
('EV Station A', 'San Francisco', 'CA', 37.7749, -122.4194),
('EV Station B', 'Los Angeles', 'CA', 34.0522, -118.2437),  
('EV Station C', 'Austin', 'TX', 30.2672, -97.7431);
select * from stations;

INSERT INTO chargers (type, power_output_kW) VALUES
('Level 2', 7.2),
('DC Fast', 50.0);
select * from chargers;

CREATE TABLE station_usage (
    usage_id INT AUTO_INCREMENT PRIMARY KEY,
    station_id INT,
    charger_id INT,
    usage_date DATE,
    start_time TIME,
    end_time TIME,
    energy_consumed_kWh DECIMAL(6,2),
    FOREIGN KEY (station_id) REFERENCES stations(station_id),
    FOREIGN KEY (charger_id) REFERENCES chargers(charger_id)
);
INSERT INTO station_usage (station_id, charger_id, usage_date, start_time, end_time, energy_consumed_kWh) VALUES
(1, 2, '2024-06-01', '17:30:00', '18:00:00', 25.5),
(2, 1, '2024-06-01', '09:00:00', '09:45:00', 6.8),
(3, 2, '2024-06-02', '19:00:00', '19:30:00', 30.2),
(1, 1, '2024-06-02', '12:00:00', '12:30:00', 7.5);
select * from station_usage;

-- STEP 3: Sample Queries

-- 1. Top states by number of sessions
SELECT s.state, COUNT(*) AS session_count
FROM station_usage u
JOIN stations s ON u.station_id = s.station_id
GROUP BY s.state
ORDER BY session_count DESC;

-- 2. Peak usage hours
SELECT EXTRACT(HOUR FROM start_time) AS hour, COUNT(*) AS session_count
FROM station_usage
GROUP BY hour
ORDER BY session_count DESC;

-- 3. Most energy consumed by charger type
SELECT c.type, SUM(u.energy_consumed_kWh) AS total_energy
FROM station_usage u
JOIN chargers c ON u.charger_id = c.charger_id
GROUP BY c.type
ORDER BY total_energy DESC;

-- 4. Daily usage trend
SELECT usage_date, SUM(energy_consumed_kWh) AS total_energy
FROM station_usage
GROUP BY usage_date
ORDER BY usage_date;

-- END OF PROJECT BASE
