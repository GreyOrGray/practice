/*
Write function that translates a text to Pig Latin and back. 
English is translated to Pig Latin by taking the first letter of every word, 
moving it to the end of the word and adding ‘ay’. 
“The quick brown fox” becomes “He-tay uick-qay rown-bay ox-fay”.

--English to pig latin
DECLARE @text NVARCHAR(MAX)
SELECT @text = 'The quick brown fox'
SELECT dbo.pigLatin(@text) AS [Translated], @text AS [Original]
 
--Latin to pig latin
DECLARE @text NVARCHAR(MAX)
SELECT @text = 'Lorem ipsum dolor sit amet, ne quod sale vim, duo cu diam essent legimus, mel in antiopam praesent. Soleat doctus singulis an duo, cu per meliore graecis. Ferri dicat vis id, ut nam unum illum ponderum. Case integre splendide cu eam, sit no volumus consectetuer.'
SELECT dbo.pigLatin(@text) AS [Translated], @text AS [Original]
 
--Pig latin to English
DECLARE @text NVARCHAR(MAX)
SELECT @text = 'E-thay uick-qay rown-bay'
SELECT dbo.pigLatin(@text) AS [Translated], @text AS [Original]
 
*/
 
ALTER FUNCTION pigLatin (@text NVARCHAR(MAX))
RETURNS NVARCHAR(MAX)
AS
BEGIN
    DECLARE @output nvarchar(MAX);
 
    DECLARE @itsAPig BIT = 0;
 
    DECLARE @textSplit TABLE
    (
        RowID int IDENTITY,
        words nvarchar(MAX),
        place INT,
        newtest INT,
        test nvarchar(MAX),
        pigHere INT
    );
 
     WITH textSplitter AS
    (
            SELECT CAST('' AS NVARCHAR(MAX)) AS words
            ,CAST(0 AS int) AS place
            ,CAST(0 AS int) AS newtest
            ,CAST(@text as varchar(max)) AS test
            --,CAST(0 AS int) AS again
            UNION ALL
            SELECT
            RTRIM(LTRIM(SUBSTRING(@text,place + CASE 
			WHEN PATINDEX('%[^a-z]%',RIGHT(@text,LEN(@text) - place)) = 0 THEN 1
			WHEN newtest <> 1 THEN 1
            WHEN newtest = 1 AND CAST(PATINDEX('%[^a-z]%',RIGHT(@text,LEN(@text) - place)) AS INT) = 1 THEN 1
            WHEN newtest = 1 AND CAST(PATINDEX('%[^a-z]%',RIGHT(@text,LEN(@text) - place)) AS INT) > 1 THEN 1
            ELSE 0 end,
                PATINDEX('%[^a-z]%',RIGHT(@text,LEN(@text) - place + CASE
                        WHEN PATINDEX('%[^a-z]%',RIGHT(@text,LEN(@text) - place)) = 0 THEN LEN(@text)-place
						WHEN newtest > 1 AND CAST(PATINDEX('%[^a-z]%',RIGHT(@text,LEN(@text) - place)) AS INT) = 1 THEN 0
                        WHEN newtest = 1 AND CAST(PATINDEX('%[^a-z]%',RIGHT(@text,LEN(@text) - place)) AS INT) > 1 THEN -1
                        
						ELSE -1
                        END))
                )
                ))
                    AS words,
            CAST(CASE
                WHEN PATINDEX('%[^a-z]%',RIGHT(@text,LEN(@text) - place)) = 0 THEN LEN(@text) 
                ELSE PATINDEX('%[^a-z]%',RIGHT(@text,LEN(@text) - place))+place + CASE
                    WHEN newtest > 1 AND CAST(PATINDEX('%[^a-z]%',RIGHT(@text,LEN(@text) - place)) AS INT) = 1 THEN 0
                    WHEN newtest = 1 AND CAST(PATINDEX('%[^a-z]%',RIGHT(@text,LEN(@text) - place)) AS INT) > 1 THEN -1
                    WHEN newtest = 1 AND CAST(PATINDEX('%[^a-z]%',RIGHT(@text,LEN(@text) - place)) AS INT) = 1 THEN 0
                    WHEN newtest = 0 AND CAST(PATINDEX('%[^a-z]%',RIGHT(@text,LEN(@text) - place)) AS INT) = 1 THEN 0
                    WHEN CAST(PATINDEX('%[^a-z]%',RIGHT(@text,LEN(@text) - place))-1 AS INT) = 0 THEN 1
                    WHEN newtest = 0 THEN -1
                    ELSE -2
                    END
                END  AS INT) AS place,
            CAST(PATINDEX('%[^a-z]%',RIGHT(@text,LEN(@text) - place)) AS INT),
                    CAST(RIGHT(@text,LEN(@text) - place) AS VARCHAR(MAX))
            FROM textSplitter w
            WHERE place < LEN(@text)
         
    )    
       

    INSERT INTO @textSplit
    (
        words,
        place,
        newtest,
        test,
        pigHere
    ) SELECT *, 0 FROM textSplitter
    OPTION (MAXRECURSION 0);
 
    UPDATE t SET t.pigHere = 3
    FROM @textSplit t
    WHERE (t.words LIKE 'yay' OR t.words LIKE '%ay')
    AND (SELECT words FROM @textSplit WHERE RowID = t.RowID-1) = '-'
 
 
    UPDATE t SET t.pigHere = 2
    FROM @textSplit t
    WHERE (SELECT pigHere FROM @textSplit WHERE RowID = t.RowID+1) = '3'
 
    UPDATE t SET t.pigHere = 1
    FROM @textSplit t
    WHERE (SELECT pigHere FROM @textSplit WHERE RowID = t.RowID+1) = '2'
 
    IF (SELECT (SUM((pigHere)*100.0))/COUNT(1) FROM @textSplit WHERE words NOT LIKE '%[^a-z]%' AND words NOT LIKE '' ) > 5
    BEGIN
        SET @itsAPig = 1
    END
 
    IF @itsAPig = 1
    BEGIN
 
        WITH pigHerder AS
        (
            SELECT *, LAG(words,2) OVER(ORDER BY rowID) AS pigBackside FROM @textSplit
        )
        ,pigSquisher AS
        (
            SELECT *,
            CONCAT(
            CASE
                WHEN words LIKE '%yay' THEN LEFT(words, LEN(words)-3)
                WHEN words LIKE '%ay' THEN LEFT(words, LEN(words)-2)
            END, pigHerder.pigBackside)
            AS Squished FROM pigHerder WHERE pigHerder.pigHere IN (0,3)
        )
        ,pigCapitalizer as
        (
             SELECT *,
                CASE WHEN ASCII(lower(pigBackside)) <> ASCII(pigBackside) THEN UPPER(LEFT(Squished,1))+LOWER(SUBSTRING(Squished,2,LEN(Squished))) ELSE Squished END AS fixed
                FROM pigSquisher
        )
        ,pigSorter AS
        (
            SELECT ROW_NUMBER() OVER (ORDER BY RowID)  AS newIDNumber, * FROM
            (SELECT RowID, CASE WHEN words = '' THEN ' ' ELSE words end AS words FROM pigCapitalizer WHERE pigHere = 0
            UNION ALL
            SELECT RowID, fixed FROM pigCapitalizer WHERE pigHere = 3) a
        )
 
        , final AS
        (
            SELECT newIDNumber, words FROM pigSorter WHERE newIDNumber = 1
            UNION ALL
            SELECT pigSorter.newIDNumber,
                final.words + pigSorter.words
            FROM final
                JOIN pigSorter
            ON pigSorter.newIDNumber = final.newIDNumber+1
        )
        SELECT TOP 1 @output = words FROM final ORDER BY final.newIDNumber DESC
        OPTION (MAXRECURSION 0)
         
 
    END
    ELSE
    BEGIN
        WITH translate AS
            (
                SELECT LEN(words) AS wordlength, ROW_NUMBER() OVER (ORDER BY place) AS rowNumber,
                *,
                LOWER(CASE
                WHEN LEN(words) = 0 THEN ' '
                WHEN LEN(words) > 0 AND words NOT LIKE '%[^a-z]%'
                    THEN
                        CASE WHEN LEN(words) <= 2 OR words IN ('and') THEN CONCAT(words,'-yay')
                        ELSE CONCAT( RIGHT(words, LEN(words) - CASE WHEN LEFT(words,2) IN ('ex','sh','th','zh') then 2 ELSE 1 end), '-', LEFT(words, CASE WHEN LEFT(words,2) IN ('ex','sh','th','zh') then 2 ELSE 1 end), 'ay') end
                    ELSE words END) AS piggy
                    FROM @textSplit
                WHERE place > 0
            ), capitalize AS
            (
                SELECT *,
                CASE WHEN ASCII(UPPER(LEFT(words,1))) = ASCII(LEFT(words,1)) THEN UPPER(LEFT(piggy,1))+LOWER(SUBSTRING(piggy,2,LEN(piggy))) ELSE translate.piggy END AS fixed
                FROM translate
            )
            , final AS
            (
                SELECT rownumber, fixed FROM capitalize WHERE rownumber = 1
                UNION ALL
                SELECT capitalize.rowNumber,
                    final.fixed + capitalize.fixed
                FROM final
                    JOIN capitalize
                ON capitalize.rowNumber = final.rowNumber+1
            )
            SELECT  TOP 1 @output = fixed FROM final ORDER BY final.rowNumber desc
            OPTION (MAXRECURSION 0)
             
    END
    RETURN @output
END