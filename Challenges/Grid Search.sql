/* Build out the table */
CREATE TABLE Client
(
	Client VARCHAR(100)
	, Client_Location VARCHAR(12)
)

INSERT INTO dbo.Client
(
    Client,
    Client_Location
)
VALUES
('HQ','0,0')
,('Cust1','-1,9')
,('Cust2','7,11')
,('Cust3','-5,5')
,('Cust4','4,1')
,('Cust5','5,6')
,('Cust6','6,5')


/* Ex 1 */
SELECT 
	*
FROM dbo.Client
WHERE
	CAST(PARSENAME(REPLACE(Client_Location,',','.'),2) AS int) BETWEEN -5 AND 5
	AND CAST(PARSENAME(REPLACE(Client_Location,',','.'),1) AS int) BETWEEN -5 AND 5

/* Ex 2 */
SELECT 
	Client
	, Client_Location
FROM dbo.Client
CROSS APPLY STRING_SPLIT(Client_Location,',')
WHERE 
	value BETWEEN -5 AND 5
GROUP BY Client, Client_Location
HAVING COUNT(client) = 2
	

