DELIMITER $$
-- https://numoraclerecipes.blogspot.com/search?q=poisson
DROP FUNCTION IF EXISTS getPoissonDist;
CREATE FUNCTION getPoissonDist( in_r INT, in_mu DECIMAL(13,10), in_iscumulative BOOLEAN)
RETURNS DECIMAL(13,10)
DETERMINISTIC
BEGIN

	DECLARE ln_dist DECIMAL(13,10);
    DECLARE lb_iscumulative BOOLEAN;
    
    SET lb_iscumulative = coalesce(in_iscumulative, FALSE);
		
    IF lb_iscumulative THEN
		SET ln_dist = (
			WITH RECURSIVE serie(n) AS ( 
			SELECT 0
			UNION ALL
			SELECT n + 1
			FROM serie
			WHERE n < in_r )
			SELECT SUM((power(in_mu, n) * exp(-in_mu))/getFactorial(n)) from serie
        );
	ELSE
		SET ln_dist = (
			SELECT (power(in_mu, in_r) * exp(-in_mu))/getFactorial(in_r)
		);
    END IF;

	RETURN (ln_dist);
END$$
DELIMITER ;









