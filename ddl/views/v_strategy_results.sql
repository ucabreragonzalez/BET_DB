set collation_connection = 'utf8mb4_unicode_ci';
CREATE OR REPLACE VIEW v_strategy_results AS
    SELECT 
        s.sport_nm,
        c.country_nm,
        d.division_nm,
        sr.match_dt,
        f.match_time,
        sr.home_team_nm,
        sr.away_team_nm,
        IFNULL(r.o25_odd, f.o25_odd) AS o25_odd,
        IFNULL(r.u25_odd, f.u25_odd) AS u25_odd,
        sr.strategy_nm,
        sr.score,
        sr.forecast,
        sr.matches_analized,
        sr.percentage_passed,
        sr.description,
        IF(r.full_time_home_team_goals IS NULL,
            NULL,
            CASE
                WHEN
                    sr.forecast = '+2.5 goals'
                        AND r.full_time_home_team_goals + r.full_time_away_team_goals > 2.5
                THEN
                    'W'
                WHEN
                    sr.forecast = '-2.5 goals'
                        AND r.full_time_home_team_goals + r.full_time_away_team_goals < 2.5
                THEN
                    'W'
                ELSE 'L'
            END) AS strategy_result,
        sr.created_dt,
        r.full_time_home_team_goals,
        r.full_time_away_team_goals,
        r.full_time_result,
        CASE
            WHEN r.full_time_home_team_goals + r.full_time_away_team_goals > 2.5 THEN '+2.5'
            WHEN r.full_time_home_team_goals + r.full_time_away_team_goals < 2.5 THEN '-2.5'
            ELSE NULL
        END AS full_time_o25_result
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