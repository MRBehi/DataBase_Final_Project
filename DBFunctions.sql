-- function 1 : calculates the final fare after submitting the coupon
CREATE OR ALTER FUNCTION Taxi.f1_finalFare(@couponId INT, @fare DECIMAL(12,2))
RETURNS DECIMAL(12,2)
AS
BEGIN
    DECLARE @discountPercentage INT = 0;
    DECLARE @finalFare DECIMAL(12,2);
    
    IF @couponId IS NOT NULL
    BEGIN
        SET @discountPercentage = (
            SELECT ISNULL(DiscountPercentage, 0)
            FROM Taxi.Coupons
            WHERE CouponId = @couponId
        );
    END;
    
    SET @finalFare = @fare - (@fare * @discountPercentage / 100.00);
    RETURN @finalFare;
END;
GO

-- function 2 : checks if the passenger has enough money to pay for the trip (with coupon check)
CREATE OR ALTER FUNCTION Taxi.f2_checkBalance(@tripId INT, @passengerId INT)
RETURNS BIT
AS 
BEGIN
    DECLARE @currentBalance DECIMAL(12,2);
    DECLARE @initialFare DECIMAL(12,2);
    DECLARE @couponId INT;
    DECLARE @actualFare DECIMAL(12,2);
    DECLARE @result BIT = 0;

    SET @currentBalance = (
        SELECT WalletBalance 
        FROM Taxi.Passengers 
        WHERE PassengerId = @passengerId
    );

    SELECT @initialFare = Fare, @couponId = CouponId
    FROM Taxi.Trips
    WHERE TripId = @tripId;

    SET @actualFare = Taxi.f1_finalFare(@couponId, @initialFare);

    IF @currentBalance >= @actualFare
    BEGIN
        SET @result = 1;
    END
    ELSE
    BEGIN
        SET @result = 0;
    END;

    RETURN @result;
END;
GO