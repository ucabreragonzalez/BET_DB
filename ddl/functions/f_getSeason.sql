DELIMITER $$
DROP FUNCTION IF EXISTS getSeason;
CREATE FUNCTION getSeason( in_season INT, in_adjustment INT)
RETURNS INT
DETERMINISTIC
BEGIN
	DECLARE ln_season INT;
    SET ln_season = coalesce(in_season, (select max(season) from v_results));
    SET ln_season = (
			with tmp_seasons as (SELECT season, row_number() over() as rn FROM ( select distinct season as season from v_results) vr order by season asc)
			select season
			from tmp_seasons
			where rn = (select rn + coalesce(in_adjustment, 0) from tmp_seasons where season = ln_season)
        );

	RETURN ln_season;
END$$
DELIMITER ;