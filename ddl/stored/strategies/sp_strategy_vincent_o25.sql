DELIMITER $$
drop procedure if exists sp_strategy_vicent_o25;

create procedure sp_strategy_vicent_o25(in in_strategy_nm varchar(100), in in_division_cd varchar(10), in in_match_dt date, in in_home_team_nm varchar(50), in in_away_team_nm varchar(50))
begin
	declare lv_strategy_nm varchar(100);
	declare ld_match_dt date;
	declare lv_home_team varchar(50);
	declare lv_away_team varchar(50);
	declare li_prev_matches int;
	declare li_prev_days int;
    
    declare ld_goals_weight decimal(3,1);
    declare ld_2_scored_weight decimal(3,1);
    
	set lv_strategy_nm = in_strategy_nm;
	set ld_match_dt = in_match_dt; -- current_date();
	set lv_home_team = in_home_team_nm; -- 'Espanol';
	set lv_away_team = in_away_team_nm; -- 'Ath Bilbao';
	set li_prev_matches = 4;
	set li_prev_days = null; -- this could be an extra param

	set ld_goals_weight = 4 / (li_prev_matches * 2);
	set ld_2_scored_weight = 6 / (li_prev_matches * 2);

	begin
        call  sp_get_temp_results(ld_match_dt, lv_home_team, lv_home_team, li_prev_matches, null, true);
        call  sp_get_temp_results(ld_match_dt, lv_away_team, lv_away_team, li_prev_matches, null, false);
    
		DELETE FROM t_strategy_results 
		WHERE
			strategy_nm = lv_strategy_nm
			AND division_cd = in_division_cd
			AND match_dt = ld_match_dt
			AND home_team_nm = lv_home_team
			AND away_team_nm = lv_away_team;
    
	insert into t_strategy_results (strategy_nm, division_cd, match_dt, home_team_nm, away_team_nm, result_score, description)
		SELECT 
			lv_strategy_nm,
			in_division_cd,
			ld_match_dt,
			lv_home_team,
			lv_away_team,
			ROUND(SUM(over_goals) + SUM(both_scored), 1),
			CONCAT(IF(SUM(over_goals) + SUM(both_scored) >= 0, '+', '-'),'2.5 goals | '
				, ROUND((SUM(IF(total_goals > 2.5, 1, 0)) / COUNT(*)) * 100, 1), '% >2.5')
		FROM
			(SELECT 
				CONCAT(lv_home_team, ' vs ', lv_away_team) AS match_nm,
					ld_match_dt AS match_dt,
					full_time_home_team_goals,
					full_time_away_team_goals,
					full_time_home_team_goals + full_time_away_team_goals AS total_goals,
					IF(full_time_home_team_goals + full_time_away_team_goals > 2.5, 1, - 1) * ld_goals_weight AS over_goals,
					IF(full_time_home_team_goals > 0
						AND full_time_away_team_goals > 0, 1, - 1) * ld_2_scored_weight AS both_scored
			FROM
				tmp_team_results) x
		GROUP BY match_nm , match_dt;
	end;
end$$

DELIMITER ;