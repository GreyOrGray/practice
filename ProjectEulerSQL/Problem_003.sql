/************************************************************************************************************************
Largest prime factor
Problem 3
The prime factors of 13195 are 5, 7, 13 and 29.

What is the largest prime factor of the number 600851475143 ?

Notes: I hate both of these.
************************************************************************************************************************/

--1
DECLARE 
    @currentNumber BIGINT = 600851475143,
    @largestPrimeFactor BIGINT,
    @odd BIGINT = 3,
    @final nvarchar(MAX)

WHILE (@currentNumber % 2) = 0
BEGIN
    SET @currentNumber = @currentNumber/ 2
    SET @largestPrimeFactor = 2
END
WHILE @currentNumber <> 1
BEGIN
    IF (@currentNumber % @odd) = 0
    BEGIN
        SET @largestPrimeFactor = @odd
        SET @currentNumber = @currentNumber/@odd
    END
    SET @odd += 2
END

SELECT @largestPrimeFactor AS val1

--2 
GO

DECLARE 
    @currentNumber BIGINT = 600851475143,
    @largestPrimeFactor BIGINT,
    @odd BIGINT= 3

WHILE (@odd <= SQRT(600851475143))
BEGIN
    IF (@currentNumber % @odd) = 0
    BEGIN
        SELECT @largestPrimeFactor = @odd,
        @currentNumber = @currentNumber/@odd
    END
    SET @odd += 2
END
SELECT @largestPrimeFactor


--3
DECLARE 
    @currentNumber BIGINT = 11,
    @largestPrimeFactor BIGINT,
    @odd BIGINT= 2

WHILE (@odd <= SQRT(600851475143))
BEGIN
    WHILE (@currentNumber % @odd) = 0
    BEGIN
        SELECT @largestPrimeFactor = @odd,
        @currentNumber = @currentNumber/@odd
    END
    IF @odd = 2
    BEGIN SET @odd += 1 END
    ELSE BEGIN SET @odd += 2 end
END
SELECT @largestPrimeFactor AS resultVal

