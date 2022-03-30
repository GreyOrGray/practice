/************************************************************************************************************************
Smallest Multiple
Problem 5

2520 is the smallest number that can be divided by each of the numbers from 1 to 10 without any remainder.

What is the smallest positive number that is evenly divisible by all of the numbers from 1 to 20?

Fiddle at http://sqlfiddle.com/#!18/9eecb/159128
************************************************************************************************************************/

--1 brute force
DECLARE 
    @currentNumber BIGINT ,
    @smallestNumber BIGINT

SELECT @currentNumber = 380 --20*19
WHILE @smallestNumber IS NULL
BEGIN
    IF (
        (@currentNumber % 20 = 0) AND
         (@currentNumber % 19 = 0) AND
         (@currentNumber % 18 = 0) AND
         (@currentNumber % 17 = 0) AND
         (@currentNumber % 16 = 0) AND
         (@currentNumber % 15 = 0) AND
         (@currentNumber % 14 = 0) AND
         (@currentNumber % 13 = 0) AND
         (@currentNumber % 12 = 0) AND
         (@currentNumber % 11 = 0) 
        )
        BEGIN
            SET @smallestNumber = @currentNumber
        END
        ELSE
        BEGIN
            SET @currentNumber += 20
        END
END
SELECT @smallestNumber

go
--2 smarter (and faster) brute force

DECLARE 
    @currentNumber BIGINT ,
    @smallestNumber BIGINT

SELECT @currentNumber = 2520 --20*19
WHILE @smallestNumber IS NULL
BEGIN
    IF (
        (@currentNumber % 20 = 0) AND
         (@currentNumber % 19 = 0) AND
         (@currentNumber % 18 = 0) AND
         (@currentNumber % 17 = 0) AND
         (@currentNumber % 16 = 0) AND
         (@currentNumber % 15 = 0) AND
         (@currentNumber % 14 = 0) AND
         (@currentNumber % 13 = 0) AND
         (@currentNumber % 12 = 0) AND
         (@currentNumber % 11 = 0) 
        )
        BEGIN
            SET @smallestNumber = @currentNumber
        END
        ELSE
        BEGIN
            SET @currentNumber += 2520
        END
END
SELECT @smallestNumber
