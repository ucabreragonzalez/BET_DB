CREATE OR REPLACE VIEW v_results AS
    SELECT 
        s.sport_nm,
        c.country_nm,
        d.division_nm,
        r.season,
        r.match_dt,
        r.match_time,
        r.home_team_nm,
        r.away_team_nm,
        r.full_time_home_team_goals,
        r.full_time_away_team_goals,
        r.full_time_result,
        r.half_time_home_team_goals,
        r.half_time_away_team_goals,
        r.half_time_result,
        r.referee_nm,
        r.home_team_shots,
        r.away_team_shots,
        r.home_team_shots_on_target,
        r.away_team_shots_on_target,
        r.home_team_fouls_committed,
        r.away_team_fouls_committed,
        r.home_team_corners,
        r.away_team_corners,
        r.home_team_yellow_cards,
        r.away_team_yellow_cards,
        r.home_team_red_cards,
        r.away_team_red_cards,
        r.o25_odd,
        r.u25_odd,
        r.created_dt
    FROM
        t_results r
            JOIN
        t_division d ON d.division_cd = r.division_cd
            JOIN
        t_country c ON c.country_id = d.country_id
            JOIN
        t_sport s ON s.sport_id = d.sport_id;