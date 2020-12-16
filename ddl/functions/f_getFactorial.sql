DELIMITER $$
DROP FUNCTION IF EXISTS getFactorial;
CREATE FUNCTION getFactorial( in_number INT )
RETURNS BIGINT
DETERMINISTIC
BEGIN
	-- https://www.percona.com/blog/2020/02/13/introduction-to-mysql-8-0-recursive-common-table-expression-part-2/
	
	DECLARE lb_factorial BIGINT;

	SET lb_factorial = (WITH RECURSIVE factorial(n, fact) AS ( 
	SELECT 0, 1 
	UNION ALL  
	SELECT n + 1, fact * (n+1)  
	FROM factorial 
	WHERE n < in_number )
    SELECT fact from factorial where n = in_number);

	RETURN (lb_factorial);
END$$
DELIMITER ;