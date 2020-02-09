DELIMITER $$
drop procedure if exists sp_whalebets_o25;

create procedure sp_whalebets_o25(in in_strategy_nm varchar(100), in in_division_cd varchar(10), in in_match_dt date, in in_home_team_nm varchar(20), in in_away_team_nm varchar(20))
begin
	declare lv_strategy_nm varchar(100);
	declare ld_match_dt date;
	declare lv_home_team varchar(20);
	declare lv_away_team varchar(20);
	declare li_prev_matches int;
	declare li_prev_days int;
    
	set lv_strategy_nm = in_strategy_nm;
	set ld_match_dt = in_match_dt; -- current_date();
	set lv_home_team = in_home_team_nm; -- 'Espanol';
	set lv_away_team = in_away_team_nm; -- 'Ath Bilbao';
	set li_prev_matches = 5;
	set li_prev_days = null; -- this could be an extra param

	begin
		drop table if exists tmp_team_results;
        call  sp_get_temp_results(ld_match_dt, lv_home_team, null, li_prev_matches, null);
        call  sp_get_temp_results(ld_match_dt, null, lv_away_team, li_prev_matches, null);
    
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
		SUM(full_time_home_team_goals + full_time_away_team_goals) / 5,
		IF(SUM(full_time_home_team_goals + full_time_away_team_goals) / 5 >= 5,
			'+2.5 goals',
			'-2.5 goals')
	FROM
		tmp_team_results;
	end;
end$$

DELIMITER ;