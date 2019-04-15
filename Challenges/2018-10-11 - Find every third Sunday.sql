--find date OF ALL third sundays in 2017
 
--option 1
WITH tally (val) AS
(
    SELECT ROW_NUMBER() OVER (ORDER BY (SELECT NULL)) - 1
    FROM (VALUES(0), (0), (0), (0), (0), (0), (0), (0), (0), (0)) a(val)
    CROSS JOIN (VALUES(0), (0), (0), (0), (0), (0), (0), (0), (0), (0)) b(val)
    CROSS JOIN (VALUES(0), (0), (0), (0), (0), (0), (0), (0), (0), (0)) c(val)
)
,sundays AS
(
    SELECT ROW_NUMBER() OVER (PARTITION BY  DATEPART(MONTH,DATEADD(DAY,val, '01/01/2017')) ORDER BY DATEPART(WEEKDAY,DATEADD(DAY,val, '01/01/2017'))) AS numberInMonth,
        DATEADD(DAY,val, '01/01/2017') AS [CalendarDate]
    FROM tally
    WHERE val BETWEEN 0 AND 364
        AND  DATEPART(WEEKDAY,DATEADD(DAY,val, '01/01/2017'))  = 1
)
SELECT CAST(CalendarDate AS DATE) AS CalendarDate FROM sundays WHERE numberInMonth = 3
 
GO
 
--option 2
WITH calendar as
 (
    SELECT
        CAST('01/01/2017' AS DATE) AS CalendarDate
    UNION ALL
    SELECT
        DATEADD(d,1,CalendarDate) AS CalendarDate
    FROM calendar
    WHERE CalendarDate < '12/31/2017'
)
SELECT CalendarDate
FROM
(
    SELECT ROW_NUMBER() OVER (PARTITION BY DATEPART(month, calendar.CalendarDate) ORDER BY DATEPART(WEEKDAY, calendar.CalendarDate)) AS numberInMonth,
    CalendarDate
    FROM calendar
    WHERE DATEPART(WEEKDAY, calendar.CalendarDate) = 1
     
) a
WHERE numberInMonth = 3
OPTION (MAXRECURSION 0)   