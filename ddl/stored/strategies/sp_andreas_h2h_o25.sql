DELIMITER $$
drop procedure if exists sp_andreas_h2h_o25;

create procedure sp_andreas_h2h_o25(in in_strategy_nm varchar(100), in in_division_cd varchar(10), in in_match_dt date, in in_home_team_nm varchar(50), in in_away_team_nm varchar(50))
begin
	declare lv_strategy_nm varchar(100);
	declare ld_match_dt date;
	declare lv_home_team varchar(50);
	declare lv_away_team varchar(50);
	declare li_prev_matches int;
	declare li_prev_days int;
    
    declare ld_weight decimal(3,1);
    
	set lv_strategy_nm = in_strategy_nm;
	set ld_match_dt = in_match_dt; -- current_date();
	set lv_home_team = in_home_team_nm; -- 'Espanol';
	set lv_away_team = in_away_team_nm; -- 'Ath Bilbao';
	set li_prev_matches = 3;
	set li_prev_days = null; -- this could be an extra param

	set ld_weight = 10 / li_prev_matches;

	begin
        call  sp_get_temp_results(ld_match_dt, CONCAT('@', lv_home_team), CONCAT('@', lv_away_team), li_prev_matches, null, true);
		begin
			DELETE FROM t_strategy_results 
			WHERE
				strategy_nm = lv_strategy_nm
				AND division_cd = in_division_cd
				AND match_dt = ld_match_dt
				AND home_team_nm = lv_home_team
				AND away_team_nm = lv_away_team;
		end; 
        
		begin
			insert into t_strategy_results (strategy_nm, division_cd, match_dt, home_team_nm, away_team_nm, score, forecast, matches_analized, percentage_passed, description)
			SELECT 
				lv_strategy_nm,
				in_division_cd,
				ld_match_dt,
				lv_home_team,
				lv_away_team,
				ROUND(SUM(over_goals), 1) AS score,
				CONCAT(IF(SUM(over_goals) >= 0, '+', '-'), '2.5 goals') AS forecast,
				COUNT(*) AS matches_analized,
				ROUND((SUM(IF(total_goals > 2.5, 1, 0)) / COUNT(*)) * 100, 1) AS percentage_passed,
				'Last 3 matches | Score > 0 = +2.5 goals' AS description
			FROM
				(SELECT 
					full_time_home_team_goals + full_time_away_team_goals AS total_goals,
						IF(full_time_home_team_goals + full_time_away_team_goals > 2.5, 1, - 1) * ld_weight AS over_goals
				FROM
					tmp_team_results) x;
		end;
	end;
end$$

DELIMITER ;