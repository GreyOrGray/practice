/************************************************************************************************************************
Largest palindrome product
Problem 4
A palindromic number reads the same both ways. The largest palindrome made from the product of two 2-digit numbers is 9009 = 91 × 99.

Find the largest palindrome made from the product of two 3-digit numbers.
************************************************************************************************************************/

--1
WITH cal(val) AS 
(
    SELECT ROW_NUMBER() OVER (ORDER BY (SELECT NULL)) - 1
    from
    (VALUES(0), (0), (0), (0), (0), (0), (0), (0), (0), (0)) a(val)
    CROSS join
    (VALUES(0), (0), (0), (0), (0), (0), (0), (0), (0), (0)) b(val)
    CROSS join
    (VALUES(0), (0), (0), (0), (0), (0), (0), (0), (0), (0)) c(val)
)
SELECT TOP 1 *, (c1.val* c2.val)
FROM cal c1
CROSS JOIN cal c2
WHERE c1.val >= 100
    AND c2.val >= 100
    AND (c1.val* c2.val) = REVERSE(c1.val* c2.val)
ORDER BY (c1.val* c2.val) desc
