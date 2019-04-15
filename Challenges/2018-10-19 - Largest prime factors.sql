/*******************************************************
Given the below code to build and populate a table, output the largest prime factors for each value in the table.

CREATE TABLE #numbersForWork
(numberVal NUMERIC)
 
INSERT INTO #numbersForWork
VALUES
(105),(600851475143),(POWER(CAST(10 AS NUMERIC),12)-3)
*******************************************************/

CREATE FUNCTION primeFactor (@n numeric)
RETURNS numeric
AS
BEGIN
    DECLARE
        @output NUMERIC,
        @currentPrime numeric,
        @currentValue numeric= 2
 
    WHILE (@currentValue <= SQRT(@n))
    BEGIN
        WHILE (@n % @currentValue) = 0
        BEGIN
            SELECT
                @currentPrime = @currentValue,
                @n = @n/@currentPrime
        END
        SET @currentValue += IIF(@currentValue = 2,1,2)
    END
    SELECT @output = IIF(@currentPrime < @n, @n, @currentPrime)
    RETURN @output
END
 
GO
 
-- Get the results
SELECT dbo.primeFactor(numberVal) AS largestPrimeFactor FROM #numbersForWork