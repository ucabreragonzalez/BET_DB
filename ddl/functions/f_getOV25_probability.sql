DELIMITER $$
DROP FUNCTION IF EXISTS getOV25_probability;
CREATE FUNCTION getOV25_probability( in_home_expected DECIMAL(13,10), in_away_expected DECIMAL(13,10))
RETURNS DECIMAL(13,10)
DETERMINISTIC
BEGIN
	DECLARE ln_probability DECIMAL(13,10);
    SET ln_probability = (
			with scores AS 
			(select 0 as h,0 as a
				union
				select 1 as h,1 as a
				union
				select 1 as h,0 as a
				union
				select 0 as h,1 as a
				union
				select 2 as h,0 as a
				union
				select 0 as h,2 as a)
			select sum(getPoissonDist(h, in_home_expected, FALSE) * getPoissonDist(a, in_away_expected, FALSE)) as pct from scores
        );
	RETURN (1 - ln_probability);
END$$
DELIMITER ;









