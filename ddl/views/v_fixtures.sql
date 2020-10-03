CREATE OR REPLACE VIEW v_fixtures AS
    SELECT 
        s.sport_nm,
        c.country_nm,
        d.division_nm,
        f.match_dt,
        f.match_time,
        f.home_team_nm,
        f.away_team_nm,
        f.o25_odd,
        f.u25_odd,
        f.created_dt
    FROM
        t_fixtures f
            JOIN
        t_division d ON d.division_cd = f.division_cd
            JOIN
        t_country c ON c.country_id = d.country_id
            JOIN
        t_sport s ON s.sport_id = d.sport_id;