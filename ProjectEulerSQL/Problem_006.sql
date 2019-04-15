/************************************************************************************************************************
Sum square difference
Problem 6

The sum of the squares of the first ten natural numbers is,

12 + 22 + ... + 102 = 385
The square of the sum of the first ten natural numbers is,

(1 + 2 + ... + 10)2 = 552 = 3025
Hence the difference between the sum of the squares of the first ten natural numbers and the square of the sum is 3025 − 385 = 2640.

Find the difference between the sum of the squares of the first one hundred natural numbers and the square of the sum.
************************************************************************************************************************/

--1 brute force
DECLARE 
    @currentNumber BIGINT = 0,
    @sumOfSquares BIGINT = 0,
    @squareOfSums BIGINT = 0

WHILE @currentNumber < 101
BEGIN
    SELECT 
        @sumOfSquares  += SQUARE(@currentNumber)
        ,@squareOfSums +=@currentNumber
        ,@currentNumber += 1
END

SELECT SQUARE(@squareOfSums) - @sumOfSquares   AS result
