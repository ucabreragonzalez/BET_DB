DELIMITER $$
drop procedure if exists sp_get_temp_results;

create procedure sp_get_temp_results(in in_match_dt date, in in_home_team_nm varchar(50), in in_away_team_nm varchar(50), in in_prev_matches int, in in_prev_days int, in in_clean_table bool)
begin

    set @prev_matches = coalesce(in_prev_matches, 100000);
	set @row_number = 0;
    
    IF in_clean_table THEN
		DROP TEMPORARY TABLE IF EXISTS tmp_team_results;
	END IF;
    
	CREATE TEMPORARY TABLE if not exists tmp_team_results select 0 as rn, v_results.* from v_results limit 0;

	insert into tmp_team_results
    SELECT *
	FROM
		(SELECT 
			(@row_number:=@row_number + 1) AS rn, v_results.*
		FROM
			v_results
		WHERE
			1 = 1
				AND
                (
					(
						in_prev_days IS NULL
                        AND match_dt < in_match_dt
					)
					OR	
					(
						in_prev_days IS NOT NULL
						AND match_dt BETWEEN in_match_dt - INTERVAL in_prev_days DAY AND in_match_dt
					)
                )
				AND CASE
				WHEN
					in_home_team_nm IS NOT NULL
						AND in_away_team_nm IS NULL
				THEN
					home_team_nm = in_home_team_nm
				WHEN
					in_home_team_nm IS NULL
						AND in_away_team_nm IS NOT NULL
				THEN
					away_team_nm = in_away_team_nm
				WHEN
					in_home_team_nm IS NOT NULL
						AND in_home_team_nm = in_away_team_nm
				THEN
					in_home_team_nm IN (home_team_nm , away_team_nm)
				WHEN
					in_home_team_nm LIKE '@%'
						AND in_home_team_nm LIKE '@%'
				THEN
					(home_team_nm = replace(in_home_team_nm, '@', '')
						AND away_team_nm = replace(in_away_team_nm, '@', ''))
						OR (away_team_nm = replace(in_home_team_nm, '@', '')
						AND home_team_nm = replace(in_away_team_nm, '@', ''))
				ELSE home_team_nm = in_home_team_nm
					AND away_team_nm = in_away_team_nm
			END
		ORDER BY match_dt DESC) x
	WHERE rn <= @prev_matches;
    
end$$

DELIMITER ;