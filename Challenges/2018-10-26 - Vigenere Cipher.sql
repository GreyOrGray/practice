/******************

Vigenère Cipher

The Challenge
Create a function/procedure/script/whatever that will encrypt and decrypt text using the Vigenère Cipher.

Encrypting should "follow the tradition by removing all spaces and punctuation, converting all letters to upper case, and dividing the result into 5-letter blocks"
Encrypted Example: CIVTL LRPGW CIRR
Decryption Key: vigenere


Background
The Vigenère Cipher is a method of encrypting alphabetic text originally described in the 1500s.

The following information came from here.

The 'key' for a vigenere cipher is a key word. e.g. 'FORTIFICATION'

The Vigenere Cipher uses the following tableau (the 'tabula recta') to encipher the plaintext:

    A B C D E F G H I J K L M N O P Q R S T U V W X Y Z
    ---------------------------------------------------
A   A B C D E F G H I J K L M N O P Q R S T U V W X Y Z
B   B C D E F G H I J K L M N O P Q R S T U V W X Y Z A
C   C D E F G H I J K L M N O P Q R S T U V W X Y Z A B
D   D E F G H I J K L M N O P Q R S T U V W X Y Z A B C
E   E F G H I J K L M N O P Q R S T U V W X Y Z A B C D
F   F G H I J K L M N O P Q R S T U V W X Y Z A B C D E
G   G H I J K L M N O P Q R S T U V W X Y Z A B C D E F
H   H I J K L M N O P Q R S T U V W X Y Z A B C D E F G
I   I J K L M N O P Q R S T U V W X Y Z A B C D E F G H
J   J K L M N O P Q R S T U V W X Y Z A B C D E F G H I
K   K L M N O P Q R S T U V W X Y Z A B C D E F G H I J
L   L M N O P Q R S T U V W X Y Z A B C D E F G H I J K
M   M N O P Q R S T U V W X Y Z A B C D E F G H I J K L
N   N O P Q R S T U V W X Y Z A B C D E F G H I J K L M
O   O P Q R S T U V W X Y Z A B C D E F G H I J K L M N
P   P Q R S T U V W X Y Z A B C D E F G H I J K L M N O
Q   Q R S T U V W X Y Z A B C D E F G H I J K L M N O P
R   R S T U V W X Y Z A B C D E F G H I J K L M N O P Q
S   S T U V W X Y Z A B C D E F G H I J K L M N O P Q R
T   T U V W X Y Z A B C D E F G H I J K L M N O P Q R S
U   U V W X Y Z A B C D E F G H I J K L M N O P Q R S T
V   V W X Y Z A B C D E F G H I J K L M N O P Q R S T U
W   W X Y Z A B C D E F G H I J K L M N O P Q R S T U V
X   X Y Z A B C D E F G H I J K L M N O P Q R S T U V W
Y   Y Z A B C D E F G H I J K L M N O P Q R S T U V W X
Z   Z A B C D E F G H I J K L M N O P Q R S T U V W X Y

To encipher a message, repeat the keyword above the plaintext:

FORTIFICATIONFORTIFICATIONFO
DEFENDTHEEASTWALLOFTHECASTLE

Now we take the letter we will be encoding, 'D', and find it on the first column on the tableau. Then, we move along the 'D' row of the tableau until we come to the column with the 'F' at the top (The 'F' is the keyword letter for the first 'D'), the intersection is our ciphertext character, 'I'.

So, the ciphertext for the above plaintext is:

FORTIFICATIONFORTIFICATIONFO
DEFENDTHEEASTWALLOFTHECASTLE
ISWXVIBJEXIGGBOCEWKBJEVIGGQS

******************/

/*******************************************************************
Vigenere Cipher
-- I guarantee there is a better way than this...

Vigenere 
	@Key VARCHAR(100)	= encryption/decryption key
	@input VARCHAR(200) = input text
	@encrypt BIT		= 1 for encrypt, 0 for decrypt

tests:
    SELECT dbo.vigenere('vigenere','Friday Code Challenge',1)
    SELECT dbo.vigenere('vigenere','AZOHN CTSYM ILNPC IIOK',0)
 
*******************************************************************/
CREATE FUNCTION Vigenere (@Key VARCHAR(100), @input VARCHAR(200), @encrypt BIT)
RETURNS VARCHAR(200)
AS
BEGIN
 
    SET @Key = UPPER(@Key)
    SET @input = UPPER(@input)
 
    DECLARE @i INT, @result varchar(500)
    SET @result = @input
    SET @i = patindex('%[^A-Z]%', @result)
    WHILE @i > 0
    BEGIN
        SET @result = STUFF(@result, @i, 1, '')
        SET @i = patindex('%[^A-Z]%', @result)
    END
    SET @input = @result
 
    DECLARE @KeyTable TABLE
    (ID INT, ShiftValue INT)
 
    DECLARE @CodeTable TABLE
    (ID INT, ASCIINumber INT)
 
    INSERT INTO @KeyTable
    SELECT
        ROW_NUMBER() OVER (ORDER BY (SELECT NULL)),
        ASCII(substring(a.b, v.number+1, 1) ) -65
    FROM (SELECT @Key b) a
    JOIN master..spt_values v
        ON v.number < len(a.b)
    WHERE v.type = 'P'
 
 
    INSERT INTO @CodeTable
    SELECT
        ROW_NUMBER() OVER (ORDER BY (SELECT NULL)),
        ASCII(substring(a.b, v.number+1, 1) )
    FROM (SELECT @input b) a
    JOIN master..spt_values v
        ON v.number < len(a.b)
    WHERE v.type = 'P'
 
    DECLARE @CurrentCharPosition INT = 1, @CurrentKeyPosition INT = 1, @output VARCHAR(200) = ''
 
    /*
    ######Decrypt
    */
    WHILE @CurrentCharPosition <= (SELECT MAX(ID) FROM @CodeTable)
    BEGIN
        IF @encrypt = 1
        BEGIN
            IF LEN(@output) > 1 AND LEN(REPLACE(@output,' ','')) %5 = 0
            BEGIN
                SELECT
                    @output = @output + ' '
            END
            SELECT
                @output =   @output +
                                CASE
                                    WHEN
                                        ASCIINumber +
                                        (
                                            SELECT shiftvalue
                                            FROM @KeyTable
                                            WHERE id = @CurrentKeyPosition
                                        ) > 90
                                    THEN
                                        CHAR(
                                                64 +
                                                    (
                                                            (
                                                                ASCIINumber +
                                                                (
                                                                    SELECT shiftvalue
                                                                    FROM @KeyTable
                                                                    WHERE id = @CurrentKeyPosition
                                                                )
                                                            ) - 90
                                                    )
                                            )
                                    ELSE
                                        CHAR(
                                                ASCIINumber +
                                                (
                                                    SELECT shiftvalue
                                                    FROM @KeyTable
                                                    WHERE id = @CurrentKeyPosition
                                                )
                                            ) END FROM @CodeTable WHERE id = @CurrentCharPosition
        END
        ELSE
        BEGIN
            SELECT
            @output =   @output +
                            CASE WHEN ASCIINumber < 65 OR ASCIINumber > 90 THEN CHAR(ASCIINumber)
                                WHEN
                                    ASCIINumber -
                                    (
                                        SELECT shiftvalue
                                        FROM @KeyTable
                                        WHERE id = @CurrentKeyPosition
                                    ) < 65
                                THEN
                                    CHAR(
                                            91 -
                                                (
                                                    65 -
                                                        (
                                                            ASCIINumber -
                                                            (
                                                                SELECT shiftvalue
                                                                FROM @KeyTable
                                                                WHERE id = @CurrentKeyPosition
                                                            )
                                                        )
                                                )
                                        )
                                ELSE
                                    CHAR(
                                            ASCIINumber -
                                            (
                                                SELECT shiftvalue
                                                FROM @KeyTable
                                                WHERE id = @CurrentKeyPosition
                                            )
                                        ) END FROM @CodeTable WHERE id = @CurrentCharPosition
        END
    
        SET @CurrentCharPosition += 1
        IF @CurrentKeyPosition = (SELECT MAX(ID) FROM @KeyTable)
        BEGIN
            SET @CurrentKeyPosition = 1
        END
        ELSE
        BEGIN
            SET @CurrentKeyPosition += 1
        END
 
    END
 
    RETURN @output
END