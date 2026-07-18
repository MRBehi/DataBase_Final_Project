-- Trigger 1 : Shows the details of any change on Taxi.Passengers

CREATE OR ALTER TRIGGER Taxi.trg_Passengers ON Taxi.Passengers
AFTER INSERT, UPDATE, DELETE
AS
BEGIN
	--Insert
	IF EXISTS(SELECT* FROM inserted) AND NOT EXISTS(SELECT* FROM deleted)
		BEGIN
			INSERT INTO Taxi.TaxiLogs(TableName, OperationType, OldData, NewData)
			SELECT
				'Taxi.Passengers',
				'Insert',
				'Empty',
				'passenger with ID ' + CAST(i.PassengerId AS NVARCHAR(10)) + 
					'and with the name ' + i.FirstName + ' ' + i.LastName + 'was added .' 
			FROM inserted i;
		END

	--Delete
	IF NOT EXISTS(SELECT* FROM inserted) AND EXISTS(SELECT* FROM deleted)
		BEGIN
			INSERT INTO Taxi.TaxiLogs(TableName, OperationType, OldData, NewData)
			SELECT
				'Taxi.Passengers',
				'Delete',
				'passenger with ID ' + CAST(d.PassengerId AS NVARCHAR(10)) + 
					'and with the name ' + d.FirstName + ' ' + d.LastName + 'was deleted.',
				'Empty'
			FROM deleted d;
		END

	--Update
	IF EXISTS(SELECT* FROM inserted) AND EXISTS(SELECT* FROM deleted)
		BEGIN
			INSERT INTO Taxi.TaxiLogs(TableName, OperationType, OldData, NewData)
			SELECT
				'Taxi.Passengers',
				'Update',
				'Old data -> ' + 'Full Name : ' + d.FirstName + ' ' + d.LastName + 
					'Wallet Balance : ' + CAST(d.WalletBalance AS NVARCHAR(20)),
				'New data -> ' + 'Full Name : ' + i.FirstName + ' ' + i.LastName + 
					'Wallet Balance : ' + CAST(i.WalletBalance AS NVARCHAR(20)) 
			FROM inserted i
			INNER JOIN deleted d ON i.PassengerId = d.PassengerId;
		END

END;

GO

-- Trigger 2 : Changes the drivers status to busy after accepting a trip
CREATE OR ALTER TRIGGER Taxi.trg_afterTripInsert ON Taxi.Trips
AFTER INSERT
AS
BEGIN
    DECLARE @DriverId INT;
    
    SELECT @DriverId = DriverId FROM inserted;

    IF @DriverId IS NOT NULL
    BEGIN
        UPDATE Taxi.Drivers
        SET [Status] = 'busy'
        WHERE DriverId = @DriverId;
    END
END;

GO

-- Trigger 3 : Connecting Taxi to Food
CREATE OR ALTER TRIGGER Taxi.trg_SendToFood
ON Taxi.Deliveries
AFTER UPDATE
AS
BEGIN
    IF EXISTS (SELECT 1 FROM inserted WHERE DeliveryStatus = 'Completed')
    BEGIN
        UPDATE Food.TaxiFoodDeliveries
        SET FoodDeliveryStatus = 'Delivered'
        WHERE FoodDeliverId IN (SELECT FoodDeliverId FROM inserted WHERE DeliveryStatus = 'Completed');

        INSERT INTO Food.OrderStatusHistory (OrderID, Status)
        SELECT d.OrderId, 'Delivered by Taxi'
        FROM inserted i
        JOIN Food.TaxiFoodDeliveries d ON i.FoodDeliverId = d.FoodDeliverId
        WHERE i.DeliveryStatus = 'Completed';
    END
END;