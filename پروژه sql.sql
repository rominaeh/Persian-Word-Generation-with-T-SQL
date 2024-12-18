ALTER PROCEDURE GetWords
    @Lengths NVARCHAR(20),
    @Char NVARCHAR(10)
AS
BEGIN
    SET NOCOUNT ON;

    DECLARE @Len1 INT;
    DECLARE @Len2 INT;

    -- Parse the lengths from the input parameter
    SELECT @Len1 = CAST(SUBSTRING(@Lengths, 1, CHARINDEX(',', @Lengths + ',') - 1) AS INT),
           @Len2 = CAST(SUBSTRING(@Lengths, CHARINDEX(',', @Lengths + ',') + 1, LEN(@Lengths)) AS INT);

    DECLARE @SQLQuery NVARCHAR(MAX);

    SET @SQLQuery = N'
    SELECT word
    FROM [dbo].[PersianToPersianDictionary]
    WHERE LEN(TRIM(word)) IN (@Len1, @Len2)
    AND TRIM(word) LIKE N''%[' + @Char + N']%''
    AND TRIM(word) NOT LIKE N''%[^' + @Char + N']%'';
    ';

    EXEC sp_executesql @SQLQuery, N'@Len1 INT, @Len2 INT', @Len1, @Len2;
END;

EXEC GetWords @Lengths = '3,4', @Char = N'شتکم';
