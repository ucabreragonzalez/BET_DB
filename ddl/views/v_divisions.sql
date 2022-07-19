CREATE OR REPLACE VIEW v_divisions AS
    SELECT 
        c.country_id,
        c.country_nm,
        d.division_cd,
        d.division_nm,
        d.sport_id
    FROM
        t_country c
			JOIN
        t_division d ON d.country_id = c.country_id;