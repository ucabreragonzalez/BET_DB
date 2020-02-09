CREATE OR REPLACE VIEW v_strategy_picks AS
    SELECT 
        s.sport_nm,
        c.country_nm,
        d.division_nm,
        sr.match_dt,
        f.match_time,
        sr.home_team_nm,
        sr.away_team_nm,
        sr.strategy_nm,
        sr.result_score,
        sr.description,
        if(r.full_time_home_team_goals is null,null,
			case
				when sr.description like '+2.5 goals%' and r.full_time_home_team_goals + r.full_time_away_team_goals > 2.5 then 'W'
				when sr.description like '-2.5 goals%' and r.full_time_home_team_goals + r.full_time_away_team_goals < 2.5 then 'W'
				else 'L'
			end
        ) as strategy_result,
        sr.created_dt,
        r.full_time_home_team_goals,
        r.full_time_away_team_goals,
        -- r.full_time_home_team_goals + r.full_time_away_team_goals as total_goals,
        r.full_time_result
    FROM
        t_strategy_results sr
            JOIN
        t_division d ON d.division_cd = sr.division_cd
            JOIN
        t_country c ON c.country_id = d.country_id
            JOIN
        t_sport s ON s.sport_id = d.sport_id
            LEFT JOIN
        t_fixtures f ON f.division_cd = sr.division_cd
            AND f.match_dt = sr.match_dt
            AND f.home_team_nm = sr.home_team_nm
            AND f.away_team_nm = sr.away_team_nm
            LEFT JOIN
        t_results r ON r.division_cd = sr.division_cd
            AND r.match_dt = sr.match_dt
            AND r.home_team_nm = sr.home_team_nm
            AND r.away_team_nm = sr.away_team_nm;