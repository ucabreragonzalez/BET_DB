DELIMITER $$
drop procedure if exists sp_goals_expected_o25;

create procedure sp_goals_expected_o25( in in_date_from date, in in_date_to date )
begin
	declare lv_strategy_nm varchar(100);
	declare ld_date_from date;
	declare ld_date_to date;
    
	set lv_strategy_nm = 'xG {type} >2.5 G';
	set ld_date_from = coalesce(in_date_from, current_date());
    set ld_date_to = coalesce(in_date_to, ld_date_from);

	begin
        DELETE FROM t_strategy_results 
		WHERE
			strategy_nm like 'xG % >2.5 G'
			AND match_dt BETWEEN ld_date_from AND ld_date_to;
    
		insert into t_strategy_results (strategy_nm, division_cd, match_dt, home_team_nm, away_team_nm, score, forecast, matches_analized, percentage_passed, description)
		with tmp_fixtures as
		( SELECT x.division_cd, d.division_nm, x.season, x.match_dt, x.home_team_nm, x.away_team_nm
			FROM
				(SELECT division_cd, season,  match_dt, home_team_nm, away_team_nm
				FROM t_fixtures
				WHERE match_dt BETWEEN ld_date_from AND ld_date_to
				UNION
				SELECT division_cd, season, match_dt, home_team_nm, away_team_nm
				FROM t_results
				WHERE match_dt BETWEEN ld_date_from AND ld_date_to) x
			JOIN t_division d ON d.division_cd = x.division_cd
		)
		, tmp_OV25prob as
		( select 
			vf.*
			, getOV25_probability(
				getGoalsExpected('H', vf.division_nm, vf.home_team_nm, vf.away_team_nm, getSeason(vf.season, -1), vf.match_dt),
				getGoalsExpected('A', vf.division_nm, vf.home_team_nm, vf.away_team_nm, getSeason(vf.season, -1), vf.match_dt)
			) as OV25prob_minus_1
            , getOV25_probability(
				getGoalsExpected('H', vf.division_nm, vf.home_team_nm, vf.away_team_nm, getSeason(vf.season, 0), vf.match_dt),
				getGoalsExpected('A', vf.division_nm, vf.home_team_nm, vf.away_team_nm, getSeason(vf.season, 0), vf.match_dt)
			) as OV25prob_current
		from tmp_fixtures vf
		)
		select 
			replace(lv_strategy_nm, '{type}','Last Season')
			, x.division_cd
			, x.match_dt
			, x.home_team_nm
			, x.away_team_nm
			, ROUND(x.OV25prob_minus_1 * 100, 1) AS score
			, CASE WHEN x.OV25prob_minus_1 is null then 'NA'
				WHEN x.OV25prob_minus_1 >= 0.5 Then '+2.5 goals'
				ELSE '-2.5 goals'
			  END as forecast
			, NULL
			, NULL
			, 'Score >= .5 = +2.5 goals | Last Season Performance' AS description
		from tmp_OV25prob x
        union all
        select 
			replace(lv_strategy_nm, '{type}','Current Season')
			, x.division_cd
			, x.match_dt
			, x.home_team_nm
			, x.away_team_nm
			, ROUND(x.OV25prob_current * 100, 1) AS score
			, CASE WHEN x.OV25prob_current is null then 'NA'
				WHEN x.OV25prob_current >= 0.5 Then '+2.5 goals'
				ELSE '-2.5 goals'
			  END as forecast
			, NULL
			, NULL
			, 'Score >= .5 = +2.5 goals | Current Season Performance' AS description
		from tmp_OV25prob x
        union all
        select 
			replace(lv_strategy_nm, '{type}','Average')
			, x.division_cd
			, x.match_dt
			, x.home_team_nm
			, x.away_team_nm
			, ROUND(((coalesce(x.OV25prob_minus_1, x.OV25prob_current) + coalesce(x.OV25prob_current, x.OV25prob_minus_1)) / 2) * 100, 1) AS score
			, CASE WHEN ((coalesce(x.OV25prob_minus_1, x.OV25prob_current) + coalesce(x.OV25prob_current, x.OV25prob_minus_1)) / 2) >= 0.5 Then '+2.5 goals'
				ELSE '-2.5 goals'
			  END as forecast
			, NULL
			, NULL
			, 'Score >= .5 = +2.5 goals | Average Performance' AS description
		from tmp_OV25prob x;
	end;
end$$

DELIMITER ;