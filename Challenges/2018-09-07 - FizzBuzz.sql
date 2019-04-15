WITH fizzBuzzer AS
(
    SELECT 0 AS RowNumber, 'fizzbuzz' AS FizzBuzzVal
    UNION ALL
    SELECT fizzBuzzer.RowNumber + 1,
        CASE
            WHEN (fizzBuzzer.RowNumber + 1) % 3 = 0 AND (fizzBuzzer.RowNumber + 1) % 5 = 0 THEN 'fizzbuzz'
            WHEN (fizzBuzzer.RowNumber + 1) % 3 = 0 THEN 'fizz'
            WHEN (fizzBuzzer.RowNumber + 1) % 5 = 0 THEN 'buzz'
            ELSE CAST(fizzBuzzer.RowNumber+1 AS VARCHAR(3))
        END
    FROM fizzBuzzer
    WHERE fizzBuzzer.RowNumber < 100
)
SELECT fizzBuzzer.FizzBuzzVal FROM fizzBuzzer WHERE fizzBuzzer.RowNumber > 0
 
 
 
WITH Tally (n) AS
(
    SELECT ROW_NUMBER() OVER (ORDER BY (SELECT NULL))
    FROM (VALUES(0),(0),(0),(0),(0),(0),(0),(0),(0),(0)) a(n)
    CROSS JOIN (VALUES(0),(0),(0),(0),(0),(0),(0),(0),(0),(0)) b(n)
)
SELECT
    CASE
        WHEN (n/3.0) = CAST(n/3.0 AS INT) AND (n/5.0) = CAST(n/5.0 AS INT) THEN 'FizzBuzz'
        WHEN (n/3.0) = CAST(n/3.0 AS INT) THEN 'Fizz'
        WHEN (n/5.0) = CAST(n/5.0 AS INT) THEN 'Buzz'
        ELSE CAST(n AS VARCHAR(4))
    END AS x
FROM Tally