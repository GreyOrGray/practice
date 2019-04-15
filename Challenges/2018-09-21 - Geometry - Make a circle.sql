--Create a circle in spatial results with a radius of 6 and center coordinates (0,0) like the image below (with or without fill).


--use circularstring to make a circle
DECLARE @point1    VARCHAR (10)    = N'0 6';
DECLARE @point2     VARCHAR (10)    = N'6 0';
DECLARE @point3    VARCHAR (10)    = N'0 -6';
DECLARE @point4     VARCHAR (10)    = N'-6 0';
 
 
DECLARE @boundingCircle VARCHAR(300)
SET @boundingCircle = 'CURVEPOLYGON(CIRCULARSTRING('+  --curvepolygon fills the circle
        @point1 + ','
        +   @point2 + ','
        +   @point3 + ','
        +   @point4 + ','
        +   @point1 +
                     + '))';
SELECT CAST(@boundingCircle AS GEOMETRY)
 
 
GO
 
--make a circle with the radius equal to a line defined
DECLARE @point1X    VARCHAR (10)    = N'0';
DECLARE @point1Y     VARCHAR (10)    = N'6';
DECLARE @point2X    VARCHAR (10)    = N'0';
DECLARE @point2Y     VARCHAR (10)    = N'0';
 
DECLARE @g GEOMETRY, @h GEOMETRY, @radius FLOAT; 
SET @g = geometry::STLineFromText('LINESTRING ('+   @point1X + ' ' + @point1Y + ','+   @point2X + ' ' + @point2Y + ')', 0);
SELECT @radius= @g.STLength()
 
DECLARE @poly NVARCHAR(MAX)
SET @g = geometry::STGeomFromText('POINT (0 0)', 0); 
SELECT @poly = @g.STBuffer(@radius).ToString();
SELECT geometry::STGeomFromText(@poly, 0);
 
 
GO
 
--just make a damn circle
DECLARE @g GEOMETRY, @poly NVARCHAR(MAX), @radius FLOAT = 6
SET @g = geometry::STGeomFromText('POINT (0 0)', 0); 
SELECT @poly = @g.STBuffer(@radius).ToString();
SELECT geometry::STGeomFromText(@poly, 0);
 
GO
 
--no fill damn circle
DECLARE @g GEOMETRY, @poly NVARCHAR(MAX), @radius FLOAT = 6
SET @g = geometry::STGeomFromText('POINT (0 0)', 0); 
SELECT @poly = @g.STBuffer(@radius).ToString();
SELECT @poly = REPLACE(REPLACE(REPLACE(@poly, 'POLYGON','CIRCULARSTRING'),'((','('),'))',')')
SELECT CAST(@poly AS GEOMETRY)