-- Write a function that tests whether a string is a palindrome.

CREATE FUNCTION [Palindrome1] (@input VARCHAR(MAX))
RETURNS VARCHAR(4)
/********
SELECT [Palindrome1]('gray')
SELECT [Palindrome1]('wakawakaw')
*******/
AS
BEGIN
    DECLARE @output VARCHAR(4)
    SELECT @output = IIF(@input = REVERSE(@input), 'yep','nope')
    RETURN @output
END
 
go
 
CREATE FUNCTION [Palindrome2] (@input VARCHAR(MAX))
RETURNS VARCHAR(4)
/********
pre 2012 edition
SELECT [Palindrome2]('gray')
SELECT [Palindrome2]('wakawakaw')
*******/
AS
BEGIN
    DECLARE @output VARCHAR(4)
    SELECT @output =
        CASE
            WHEN @input = REVERSE(@input) THEN 'yep'
            ELSE 'nope'
        END
    RETURN @output
END
 
GO