/************************************************************************************************************************
1
If we list all the natural numbers below 10 that are multiples of 3 or 5, we get 3, 5, 6 and 9. The sum of these multiples is 23.
Find the sum of all the multiples of 3 or 5 below 1000.
************************************************************************************************************************/

--1
DECLARE @final INT = 0, @working INT = 0
WHILE @working < 1000
BEGIN
    IF (@working%3 = 0) OR (@working%5 = 0)
    BEGIN
        SELECT @final += @working
    END
    SET @working += 1
END
SELECT @final AS val1


--2
GO

DECLARE @final INT = 0, @working INT = 0
WHILE @working < 1000
BEGIN
    SELECT @final += CASE WHEN (@working%3) = 0 OR (@working%5) = 0 THEN @working ELSE 0 END
    SET @working += 1
END
SELECT @final AS val2

--3
go

WITH eulerCTE AS
(
    SELECT 0 AS val
    UNION ALL
    SELECT val + 1 FROM eulerCTE
    WHERE val < 999
)
SELECT SUM(val) AS val3 FROM eulerCTE WHERE val % 3 = 0 OR val % 5 = 0 OPTION (MAXRECURSION 0)