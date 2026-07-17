-- A procedure for creating a trip request
CREATE OR ALTER PROCEDURE Taxi.sp_createTrip 
@passengerId INT,
@sourceAddress NVARCHAR(255),
@destinationAddress NVARCHAR(255),
@fare DECIMAL(10,2),
@couponId VARCHAR(20) = NULL,
@newTripId INT OUTPUT
AS 
BEGIN
	INSERT INTO Taxi.Trips(PassengerId, DriverId, SourceAddress, DestinationAddress, Fare, CouponId, TripStatus)
	VALUES(@passengerId, NULL, @sourceAddress, @destinationAddress, @fare, @couponId, 'requested');
	SET @newTripId = SCOPE_IDENTITY();

END;

GO

-- A procedure for when the driver accepts the trip request
CREATE OR ALTER PROCEDURE Taxi.sp_acceptTrip
@tripId INT,
@driverId INT
AS 
BEGIN
	UPDATE Taxi.Trips
	SET DriverId = @driverId, TripStatus = 'accepted'
	WHERE TripId = @tripId;

	UPDATE Taxi.Drivers 
	SET [Status] = 'busy'
	WHERE DriverId = @driverId;

END;

GO 

CREATE OR ALTER PROCEDURE Taxi.sp_completeTrip
@tripId INT,
@paymentmethod NVARCHAR(20)
AS
BEGIN
    DECLARE @PassengerId INT;
    DECLARE @DriverId INT;
    DECLARE @Fare DECIMAL(10, 2);

    SELECT @PassengerId = PassengerId, @DriverId = DriverId, @Fare = Fare
    FROM Taxi.Trips
    WHERE TripId = @tripId;

	BEGIN TRY
		BEGIN TRANSACTION;

			UPDATE Taxi.Trips
			SET TripStatus = 'completed'
			WHERE TripId = @tripId;

			UPDATE Taxi.Passengers
			SET WalletBalance = WalletBalance - @Fare
			WHERE PassengerId = @PassengerId;

			UPDATE Taxi.Drivers
			SET [Status] = 'active'
			WHERE DriverId = @DriverId;

			INSERT INTO Taxi.Payments (TripId, Amount, PaymentMethod)
			VALUES (@tripId, @Fare, @paymentmethod);

		COMMIT TRANSACTION;
	END TRY
    BEGIN CATCH

        IF @@TRANCOUNT > 0
        BEGIN
            ROLLBACK TRANSACTION;
        END;
        THROW;

    END CATCH
END;