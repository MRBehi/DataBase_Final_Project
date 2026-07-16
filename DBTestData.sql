INSERT INTO Taxi.Passengers (FirstName, LastName, PhoneNumber, WalletBalance, JoinDate) VALUES
('Luffy', 'Monkey D.', '09121111111', 500000.00, '2026-01-01'),
('Zoro', 'Roronoa', '09122222222', 150.00, '2026-01-02'),
('Nami', 'Cat Burglar', '09123333333', 9999999.99, '2026-01-03'),
('Usopp', 'God', '09124444444', 12000.00, '2026-01-04'),
('Sanji', 'Vinsmoke', '09125555555', 150000.00, '2026-01-05'),
('Chopper', 'Tony Tony', '09126666666', 500.00, '2026-01-06'),
('Robin', 'Nico', '09127777777', 85000.00, '2026-01-07'),
('Franky', 'Cutty Flam', '09128888888', 320000.00, '2026-01-08'),
('Brook', 'Soul King', '09129999999', 45000.00, '2026-01-09'),
('Jinbe', 'First Son of Sea', '09120000000', 250000.00, DEFAULT);

INSERT INTO Taxi.Drivers (FirstName, LastName, NationalCode, PhoneNumber, [Status], Rating) VALUES
('Gol D.', 'Roger', '1111111111', '09131111111', 'available', 5.00),
('Silvers', 'Rayleigh', '2222222222', '09132222222', 'available', 4.90),
('Edward', 'Newgate', '3333333333', '09133333333', 'busy', 4.85);

INSERT INTO Taxi.Vehicles (DriverId, LicensePlate, Model, Color, ProductionYear) VALUES
(1, 'OR0001', 'Oro Jackson', 'Gold', 1997),
(2, 'SB0002', 'Striker Boat', 'Silver', 2005),
(3, 'MobyD3', 'Moby Dick', 'White', 2010);

INSERT INTO Taxi.Coupons (Code, DiscountPercentage, ExpiryDate) VALUES
('ONEPIECE', 100, '2026-12-31'),
('MEAT', 30, '2026-08-30'),
('WANO', 50, '2026-09-15');

INSERT INTO Taxi.Trips (PassengerId, DriverId, CouponId, SourceAddress, DestinationAddress, Fare, TripStatus, CreatedAt) VALUES
(1, 1, 1, 'Foosha Village', 'Loguetown', 5000.00, 'completed', '2026-07-10'),
(2, 2, NULL, 'Sabaody Archipelago', 'Zou Island', 3500.00, 'completed', '2026-07-11'),
(3, 3, 3, 'Water 7', 'Enies Lobby', 12000.00, 'ontrip', '2026-07-15');

INSERT INTO Taxi.Payments (TripId, Amount, PaymentMethod, PaymentTime) VALUES
(1, 0.00, 'online', '2026-07-10 12:00:00'),
(2, 3500.00, 'cash', '2026-07-11 15:30:00');

INSERT INTO Taxi.SavedAddresses (PassengerId, Title, FullAddress) VALUES
(1, 'Home', 'Foosha Village, Windmill Island'),
(1, 'Favorite Restaurant', 'Baratie Sea Restaurant'),
(2, 'Training Dojo', 'Shimotsuki Village Dojo'),
(3, 'Orange Grove', 'Cocoyasi Village, Conomi Islands'),
(5, 'Kitchen', 'Baratie Kitchen');

INSERT INTO Taxi.DriverShifts (DriverId, StartTime, EndTime) VALUES
(1, '2026-07-10 08:00:00', '2026-07-10 20:00:00'),
(2, '2026-07-11 09:00:00', '2026-07-11 17:00:00'),
(3, '2026-07-15 07:00:00', NULL);

INSERT INTO Taxi.Feedbacks (TripId, Score, Comments) VALUES
(1, 5, 'Best trip ever! The Driver is truly the King of the Seas!'),
(2, 4, 'Good driver, but I got lost anyway. definitely his fault .');