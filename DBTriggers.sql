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