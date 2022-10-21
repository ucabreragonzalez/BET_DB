CREATE OR REPLACE VIEW v_strategy_join AS
    SELECT 
        s.sport_nm,
        c.country_nm,
        d.division_nm,
        m.match_dt,
        m.match_time,
        m.season,
        m.home_team_nm,
        m.away_team_nm,
        CASE
			WHEN m.full_time_goals > 2.5 THEN '+2.5'
			WHEN m.full_time_goals < 2.5 THEN '-2.5'
			ELSE NULL
		END AS full_time_o25_result,
        m.half_time_goals,
        m.full_time_goals,
        m.u25_odd,
        m.o25_odd,
        -- ===================
        sr1.strategy_nm AS strategy_nm_a,
        sr1.score AS score_a,
        sr1.forecast AS forecast_a,
        sr1.matches_analized AS matches_analized_a,
        sr1.percentage_passed AS percentage_passed_a,
        IF(m.full_time_goals IS NOT NULL AND sr1.forecast IS NOT NULL,
            CASE
                WHEN sr1.forecast = '+2.5 goals' AND m.full_time_goals > 2.5
                THEN 'W'
                WHEN sr1.forecast = '-2.5 goals' AND m.full_time_goals < 2.5
                THEN 'W'
                ELSE 'L'
            END,
            NULL) AS strategy_result_a,
        sr2.strategy_nm AS strategy_nm_b,
        sr2.score AS score_b,
        sr2.forecast AS forecast_b,
        sr2.matches_analized AS matches_analized_b,
        sr2.percentage_passed AS percentage_passed_b,
        IF(m.full_time_goals IS NOT NULL AND sr2.forecast IS NOT NULL,
            CASE WHEN sr2.forecast = '+2.5 goals' AND m.full_time_goals > 2.5
                THEN 'W'
                WHEN sr2.forecast = '-2.5 goals' AND m.full_time_goals < 2.5
                THEN 'W'
                ELSE 'L'
            END,
            NULL) AS strategy_result_b,
        sr3.strategy_nm AS strategy_nm_c,
        sr3.score AS score_c,
        sr3.forecast AS forecast_c,
        sr3.matches_analized AS matches_analized_c,
        sr3.percentage_passed AS percentage_passed_c,
        IF(m.full_time_goals IS NOT NULL AND sr3.forecast IS NOT NULL,
            CASE
				WHEN sr3.forecast = '+2.5 goals' AND m.full_time_goals > 2.5
                THEN 'W'
                WHEN sr3.forecast = '-2.5 goals' AND m.full_time_goals < 2.5
                THEN 'W'
                ELSE 'L'
            END,
            NULL) AS strategy_result_c,
            sr4.strategy_nm AS strategy_nm_d,
            sr4.score AS score_d,
            sr4.forecast AS forecast_d,
            sr4.matches_analized AS matches_analized_d,
            sr4.percentage_passed AS percentage_passed_d,
            IF(m.full_time_goals IS NOT NULL AND sr4.forecast IS NOT NULL,
                CASE
                    WHEN sr4.forecast = '+2.5 goals' AND m.full_time_goals > 2.5
                    THEN 'W'
                    WHEN sr4.forecast = '-2.5 goals' AND m.full_time_goals < 2.5
                    THEN 'W'
                    ELSE 'L'
                END,
                NULL) AS strategy_result_d,
                sr5.strategy_nm AS strategy_nm_e,
                sr5.score AS score_e,
                sr5.forecast AS forecast_e,
                sr5.matches_analized AS matches_analized_e,
                sr5.percentage_passed AS percentage_passed_e,
                IF(m.full_time_goals IS NOT NULL AND sr5.forecast IS NOT NULL,
                    CASE
                        WHEN sr5.forecast = '+2.5 goals' AND m.full_time_goals > 2.5
                        THEN 'W'
                        WHEN sr5.forecast = '-2.5 goals' AND m.full_time_goals < 2.5
                        THEN 'W'
                        ELSE 'L'
                    END,
                    NULL) AS strategy_result_e,
                    sr6.strategy_nm AS strategy_nm_f,
                    sr6.score AS score_f,
                    sr6.forecast AS forecast_f,
                    sr6.matches_analized AS matches_analized_f,
                    sr6.percentage_passed AS percentage_passed_f,
                    IF(m.full_time_goals IS NOT NULL AND sr6.forecast IS NOT NULL,
                        CASE
                            WHEN sr6.forecast = '+2.5 goals' AND m.full_time_goals > 2.5
                            THEN 'W'
                            WHEN sr6.forecast = '-2.5 goals' AND m.full_time_goals < 2.5
                            THEN 'W'
                            ELSE 'L'
                        END,
                        NULL) AS strategy_result_f
    FROM
        (SELECT 
            r.division_cd,
			r.match_dt,
			r.match_time,
			r.season,
			r.home_team_nm,
			r.away_team_nm,
            r.u25_odd,
            r.o25_odd,
            r.half_time_home_team_goals + r.half_time_away_team_goals AS half_time_goals,
            r.full_time_home_team_goals + r.full_time_away_team_goals AS full_time_goals
        FROM
            t_results r
			UNION ALL
		SELECT 
            f.division_cd,
			f.match_dt,
			f.match_time,
			f.season,
			f.home_team_nm,
			f.away_team_nm,
            f.u25_odd,
            f.o25_odd,
			NULL,
			NULL
        FROM
            t_fixtures f
        WHERE
            NOT EXISTS( SELECT 
                    1
                FROM
                    t_results r
                WHERE
                    f.division_cd = r.division_cd
                        AND f.match_dt = r.match_dt
                        AND f.home_team_nm = r.home_team_nm
                        AND f.away_team_nm = r.away_team_nm)) m
            JOIN
        t_division d ON d.division_cd = m.division_cd
            JOIN
        t_country c ON c.country_id = d.country_id
            JOIN
        t_sport s ON s.sport_id = d.sport_id
            LEFT JOIN
        t_strategy_results sr1 ON m.division_cd = sr1.division_cd
            AND m.match_dt = sr1.match_dt
            AND m.home_team_nm = sr1.home_team_nm
            AND m.away_team_nm = sr1.away_team_nm
            AND sr1.strategy_nm = 'Andreas h2h >2.5 G'
            LEFT JOIN
        t_strategy_results sr2 ON m.division_cd = sr2.division_cd
            AND m.match_dt = sr2.match_dt
            AND m.home_team_nm = sr2.home_team_nm
            AND m.away_team_nm = sr2.away_team_nm
            AND sr2.strategy_nm = 'Vincent\'s >2.5 G'
            LEFT JOIN
        t_strategy_results sr3 ON m.division_cd = sr3.division_cd
            AND m.match_dt = sr3.match_dt
            AND m.home_team_nm = sr3.home_team_nm
            AND m.away_team_nm = sr3.away_team_nm
            AND sr3.strategy_nm = 'Whalebets >2.5 G'
			LEFT JOIN
        t_strategy_results sr4 ON m.division_cd = sr4.division_cd
            AND m.match_dt = sr4.match_dt
            AND m.home_team_nm = sr4.home_team_nm
            AND m.away_team_nm = sr4.away_team_nm
            AND sr4.strategy_nm = 'xG Last Season >2.5 G'
			LEFT JOIN
        t_strategy_results sr5 ON m.division_cd = sr5.division_cd
            AND m.match_dt = sr5.match_dt
            AND m.home_team_nm = sr5.home_team_nm
            AND m.away_team_nm = sr5.away_team_nm
            AND sr5.strategy_nm = 'xG Current Season >2.5 G'
            LEFT JOIN
        t_strategy_results sr6 ON m.division_cd = sr6.division_cd
            AND m.match_dt = sr6.match_dt
            AND m.home_team_nm = sr6.home_team_nm
            AND m.away_team_nm = sr6.away_team_nm
            AND sr6.strategy_nm = 'xG Average >2.5 G'