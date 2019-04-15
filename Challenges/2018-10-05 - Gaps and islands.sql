/*******************************************************************************************

Given a table of contract time periods, simplify the contiguous time periods; 
identifying the period(s) where a given customer had an active agreement (99999999 is a key used to identify something still active):


*******************************************************************************************/
IF OBJECT_ID('tempdb..#t1') IS NOT NULL
    DROP TABLE #t1
CREATE TABLE #t1 (CustomerKey INT , ContractStartDateKey INT, ContractEndDateKey INT)
 
INSERT INTO #t1 (CustomerKey,ContractStartDateKey,ContractEndDateKey)
 
SELECT          34,  20140103,   20150303
UNION SELECT    34,  20141121,   20150302
UNION SELECT    34,  20150430,   20161010
UNION SELECT    34,  20150901,   20161010
UNION SELECT    34,  20151113,   20161010
UNION SELECT    34,  20160713,   99999999
UNION SELECT    34,  20180202,   99999999
UNION SELECT    1,   20170120,   20170819
UNION SELECT    2,   20160105,   99999999
UNION SELECT    56,  20130406,   20140506
UNION SELECT    56,  20130806,   20141106
 
GO
 
/*******************************************************************************
            First pass with recursive CTE and ROW_NUMBER()
*******************************************************************************/
;
WITH ContractTimeRangeBuilder(CustomerKey, ContractStartDateKey, ContractEndDateKey, ContractStartDateKey2, ContractEndDateKey2) AS
(
    SELECT CustomerKey, ContractStartDateKey, ContractEndDateKey, 19000101 AS ContractStartDateKey2, 19000101 AS ContractEndDateKey2
    FROM #t1 AS r
    UNION ALL
    SELECT #t1.CustomerKey, ContractTimeRangeBuilder.ContractStartDateKey, #t1.ContractEndDateKey, #t1.ContractStartDateKey, ContractTimeRangeBuilder.ContractEndDateKey
    FROM #t1
    JOIN ContractTimeRangeBuilder
        ON #t1.CustomerKey = ContractTimeRangeBuilder.CustomerKey
        AND
        (#t1.ContractEndDateKey > ContractTimeRangeBuilder.ContractEndDateKey
        AND #t1.ContractStartDateKey <= ContractTimeRangeBuilder.ContractEndDateKey)
      
)
,ContractTimeRangeFinder AS
(
    SELECT ROW_NUMBER() OVER (PARTITION BY CustomerKey,  ContractEndDateKey ORDER BY ContractStartDateKey) AS IDInRange,
    *
    FROM ContractTimeRangeBuilder r
    WHERE ContractEndDateKey NOT IN (SELECT ContractEndDateKey2 FROM ContractTimeRangeBuilder WHERE CustomerKey = r.CustomerKey)
)
 
SELECT CustomerKey, ContractStartDateKey, ContractEndDateKey
FROM ContractTimeRangeFinder
    WHERE IDInRange = 1
ORDER BY CustomerKey
 
GO
 
/*******************************************************************************
            Second pass without recursive CTE
            because user said he couldn't use them
*******************************************************************************/
 
WITH test as
(
    SELECT
    a.* , b.rowID AS rowID2, b.ContractStartDateKey AS ContractStartDateKey2, b.ContractEndDateKey AS ContractEndDateKey2
    FROM
    (SELECT ROW_NUMBER() OVER (PARTITION BY CustomerKey ORDER BY ContractStartDateKey, ContractEndDateKey) AS rowID, * FROM #t1) a
    LEFT JOIN (SELECT ROW_NUMBER() OVER (PARTITION BY CustomerKey ORDER BY ContractStartDateKey, ContractEndDateKey) AS rowID, * FROM #t1) b
        ON b.rowID <> a.rowID
        AND b.CustomerKey = a.CustomerKey
        AND b.ContractStartDateKey BETWEEN a.ContractStartDateKey AND a.ContractEndDateKey
 
)
 
SELECT TOP 1  WITH TIES
    t.CustomerKey, t.ContractStartDateKey, CASE WHEN ContractEndDateKey2 IS NULL OR ContractEndDateKey2 < ContractEndDateKey THEN ContractEndDateKey ELSE ContractEndDateKey2 END AS ContractEndDateKey
FROM test t
WHERE
    ContractStartDateKey NOT IN (SELECT ContractStartDateKey2 FROM test WHERE t.CustomerKey  = customerkey AND ContractStartDateKey2 IS NOT null)
ORDER BY ROW_NUMBER() OVER (PARTITION BY customerKey, ContractStartDateKey ORDER BY ContractStartDateKey, CASE WHEN ContractEndDateKey2 IS NULL OR ContractEndDateKey2 < ContractEndDateKey THEN ContractEndDateKey ELSE ContractEndDateKey2 end DESC)