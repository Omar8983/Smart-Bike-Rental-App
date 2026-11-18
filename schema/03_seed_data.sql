-- =====================================================================
-- Smart Bike Rental App - GIU Software Engineering, Milestone 2
-- File: 03_seed_data.sql
-- Purpose: Insert sample data into all six tables.
-- Run this file after 01_create_tables.sql.
-- All names, emails, and password hashes are fake sample values.
-- Prices are in Egyptian Pounds (EGP).
-- =====================================================================

BEGIN;

-- ---------------------------------------------------------------------
-- users (password_hash values are placeholders, not real hashes)
-- ---------------------------------------------------------------------
INSERT INTO users (user_id, full_name, email, password_hash, role, created_at) VALUES
    (1, 'Ahmed Hassan',      'ahmed.hassan@example.com',  'sample_hash_not_a_real_password_1', 'rider',   '2026-10-01 10:00:00+02'),
    (2, 'Mariam Adel',       'mariam.adel@example.com',   'sample_hash_not_a_real_password_2', 'rider',   '2026-10-03 12:30:00+02'),
    (3, 'Youssef Kamal',     'youssef.kamal@example.com', 'sample_hash_not_a_real_password_3', 'rider',   '2026-10-05 09:15:00+02'),
    (4, 'Nour Ibrahim',      'nour.ibrahim@example.com',  'sample_hash_not_a_real_password_4', 'admin',   '2026-09-20 08:00:00+02'),
    (5, 'GreenWheels Fleet', 'fleet@greenwheels.example', 'sample_hash_not_a_real_password_5', 'company', '2026-09-15 08:00:00+02');

-- ---------------------------------------------------------------------
-- stations
-- ---------------------------------------------------------------------
INSERT INTO stations (station_id, name, location, capacity, operating_info, is_active) VALUES
    (1, 'GIU Main Gate', 'GIU Campus Main Gate, New Administrative Capital',    10, 'Open 24/7',                TRUE),
    (2, 'GIU Library',   'Next to the GIU Central Library, New Administrative Capital', 8, 'Daily 08:00 - 22:00', TRUE),
    (3, 'Capital Park',  'Central Park Entrance, New Administrative Capital',   12, 'Daily 06:00 - 23:00',      TRUE);

-- ---------------------------------------------------------------------
-- pricing_plans
-- ---------------------------------------------------------------------
INSERT INTO pricing_plans (pricing_plan_id, name, duration, price, is_active) VALUES
    (1, 'Hourly', INTERVAL '1 hour',  20.00,  TRUE),
    (2, 'Daily',  INTERVAL '1 day',   100.00, TRUE),
    (3, 'Weekly', INTERVAL '7 days',  500.00, TRUE);

-- ---------------------------------------------------------------------
-- bikes
-- Bikes 4 and 5 are currently rented (station_id is NULL).
-- Bike 2 is in maintenance because of an open brake damage report.
-- ---------------------------------------------------------------------
INSERT INTO bikes (bike_id, station_id, qr_code, status) VALUES
    (1, 2,    'BIKE-QR-0001', 'available'),
    (2, 3,    'BIKE-QR-0002', 'maintenance'),
    (3, 1,    'BIKE-QR-0003', 'available'),
    (4, NULL, 'BIKE-QR-0004', 'rented'),
    (5, NULL, 'BIKE-QR-0005', 'rented'),
    (6, 2,    'BIKE-QR-0006', 'available');

-- ---------------------------------------------------------------------
-- rentals
-- Completed rentals have end_time, end_station_id, and total_cost.
-- Active rentals do not (bike not returned yet).
-- ---------------------------------------------------------------------
INSERT INTO rentals (rental_id, user_id, bike_id, start_station_id, end_station_id, pricing_plan_id,
                     start_time, end_time, status, total_cost) VALUES
    -- Completed: 1h45m on the hourly plan -> 2 hours x 20 = 40 EGP
    (1, 1, 1, 1, 2,    1, '2026-11-10 09:00:00+02', '2026-11-10 10:45:00+02', 'completed', 40.00),
    -- Completed: same-day rental on the daily plan -> 100 EGP
    (2, 2, 2, 2, 3,    2, '2026-11-12 08:00:00+02', '2026-11-12 18:00:00+02', 'completed', 100.00),
    -- Completed: 50 minutes on the hourly plan -> 1 hour x 20 = 20 EGP
    (3, 3, 3, 1, 1,    1, '2026-11-15 14:00:00+02', '2026-11-15 14:50:00+02', 'completed', 20.00),
    -- Active: weekly plan, started 2 days ago
    (4, 2, 5, 1, NULL, 3, '2026-11-16 09:00:00+02', NULL,                     'active',    NULL),
    -- Active: hourly plan, started today
    (5, 1, 4, 3, NULL, 1, '2026-11-18 17:30:00+02', NULL,                     'active',    NULL);

-- ---------------------------------------------------------------------
-- damage_reports (each reported by the rider who used the bike)
-- ---------------------------------------------------------------------
INSERT INTO damage_reports (report_id, bike_id, user_id, issue_type, description, status, created_at) VALUES
    (1, 2, 2, 'brakes', 'Rear brake is weak and squeaks when stopping.',  'in_progress', '2026-11-12 18:05:00+02'),
    (2, 3, 3, 'lights', 'Front light does not turn on.',                  'resolved',    '2026-11-15 14:55:00+02'),
    (3, 1, 1, 'other',  'Bell is loose but the bike is safe to ride.',    'open',        '2026-11-10 10:50:00+02');

-- ---------------------------------------------------------------------
-- Move identity counters past the explicit IDs used above, so that new
-- rows inserted later (without an ID) do not collide with seed data.
-- ---------------------------------------------------------------------
SELECT setval(pg_get_serial_sequence('users', 'user_id'),                 (SELECT MAX(user_id) FROM users));
SELECT setval(pg_get_serial_sequence('stations', 'station_id'),           (SELECT MAX(station_id) FROM stations));
SELECT setval(pg_get_serial_sequence('pricing_plans', 'pricing_plan_id'), (SELECT MAX(pricing_plan_id) FROM pricing_plans));
SELECT setval(pg_get_serial_sequence('bikes', 'bike_id'),                 (SELECT MAX(bike_id) FROM bikes));
SELECT setval(pg_get_serial_sequence('rentals', 'rental_id'),             (SELECT MAX(rental_id) FROM rentals));
SELECT setval(pg_get_serial_sequence('damage_reports', 'report_id'),      (SELECT MAX(report_id) FROM damage_reports));

COMMIT;
