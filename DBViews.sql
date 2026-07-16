-- view 1 : Ongoing Trips 
CREATE OR ALTER VIEW Taxi.v1_activeTrips
AS
SELECT 
	T.TripId,
    P.FirstName + ' ' + P.LastName AS PassengerName,
    D.FirstName + ' ' + D.LastName AS DriverName,
    V.Model AS VehicleModel,
    V.LicensePlate,
    T.SourceAddress,
    T.DestinationAddress,
    T.Fare,
    T.TripStatus
FROM Taxi.Trips T
	INNER JOIN Taxi.Passengers P ON T.PassengerId = P.PassengerId
	INNER JOIN Taxi.Drivers D ON T.DriverId = D.DriverId
	INNER JOIN Taxi.Vehicles V ON D.DriverId = V.DriverId
WHERE T.TripStatus IN ('requested', 'ontrip');

GO

-- view 2 : Drivers Performance
CREATE OR ALTER VIEW Taxi.v2_driversPerformance
AS
SELECT
	D.DriverId,
	D.FirstName + ' ' + D.LastName AS DriverName,
	COUNT(T.TripId) AS TotalTrips,
	SUM(T.Fare) AS TotalEarning, 
	CAST(AVG(D.Rating) AS DECIMAL(2,1)) AS AverageRate
FROM Taxi.Drivers D
	LEFT JOIN Taxi.Trips T ON D.DriverId = T.DriverId AND T.TripStatus = 'completed'
	GROUP BY D.DriverId, D.FirstName, D.LastName, D.[Status]; 
	
GO

-- view 3 : Passengers Summary 

CREATE OR ALTER VIEW Taxi.v3_passengerSummary
AS
SELECT 
    P.PassengerId,
    P.FirstName + ' ' + P.LastName AS PassengerName,
    P.PhoneNumber,
    P.WalletBalance,
    COUNT(T.TripId) AS TotalTrips,
    SUM(Payments.Amount) AS TotalPayment
FROM Taxi.Passengers P
LEFT JOIN Taxi.Trips T ON P.PassengerId = T.PassengerId
LEFT JOIN Taxi.Payments ON T.TripId = Payments.TripId
GROUP BY P.PassengerId, P.FirstName, P.LastName, P.PhoneNumber, P.WalletBalance;