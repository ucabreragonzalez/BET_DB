DELIMITER $$
DROP FUNCTION IF EXISTS fnSplitString;
CREATE FUNCTION fnSplitString(in_string VARCHAR(255), in_delimiter VARCHAR(12), in_position INT)
RETURNS varchar(255)
DETERMINISTIC
BEGIN
	DECLARE str_return VARCHAR(255);
    SET str_return = REPLACE(SUBSTRING(SUBSTRING_INDEX(in_string, in_delimiter, in_position), LENGTH(SUBSTRING_INDEX(in_string, in_delimiter, in_position -1)) + 1), in_delimiter, '');
    
	RETURN str_return;
END$$
DELIMITER ;