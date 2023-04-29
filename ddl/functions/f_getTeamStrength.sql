DELIMITER $$
DROP FUNCTION IF EXISTS getTeamStrength;
CREATE FUNCTION getTeamStrength(in_division_cd VARCHAR(10), in_team_nm VARCHAR(50), in_season INT, in_match_dt DATETIME, in_type VARCHAR(2))
RETURNS DECIMAL(8,4)
DETERMINISTIC
BEGIN
	DECLARE ld_calc_date DATE;
    DECLARE ls_team_strength DECIMAL(8,4);

    SET ld_calc_date = cast(coalesce(in_match_dt, now()) AS DATE);

    SET ls_team_strength = (
			select
                case
                    when in_type = 'HA' then home_attack_strength
                    when in_type = 'HD' then home_defence_strength
                    when in_type = 'AA' then away_attack_strength
                    when in_type = 'AD' then away_defence_strength
                end as team_strength
            from t_team_strength
            where 1=1
            and division_cd = in_division_cd
            and team_nm = in_team_nm
            and season = in_season
            and calculated_dt = (
                select max(calculated_dt) from t_team_strength
                where division_cd = in_division_cd
                and team_nm = in_team_nm
                and season = in_season
                and calculated_dt < ld_calc_date
            )
        );

	RETURN ls_team_strength;
END$$
DELIMITER ;