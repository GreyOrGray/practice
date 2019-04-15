
DECLARE @x int = 20, @design nvarchar(MAX)

WHILE (@x >= 1)
BEGIN
    SELECT @design = REPLICATE('*', @x)
    select @design
    SET @x -= 1
end