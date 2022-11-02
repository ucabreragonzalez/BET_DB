DELIMITER $$
drop procedure if exists sp_calculate_team_strength;

create procedure sp_calculate_team_strength(in_calc_date datetime)
begin
	declare ld_calc_date date;

    SET ld_calc_date = cast(coalesce(in_calc_date, now()) as date);

	begin
		insert into t_team_strength (season,division_cd,team_nm,home_attack_strength,home_defence_strength,away_attack_strength,away_defence_strength,league_home_scored_avg,league_away_scored_avg,league_home_conceded_avg,league_away_conceded_avg,calculated_dt)
		with tmp_seasons as (
            select
                division_cd,
                (select max(season) from t_results where division_cd = d.division_cd and match_dt <= ld_calc_date) as season
            from t_division as d
        )
        , tmp_results as (
            select tr.*
            from t_results as tr
            inner join tmp_seasons as ts on ts.division_cd = tr.division_cd and ts.season = tr.season
            where tr.match_dt < ld_calc_date
        )
        , tmp_div_goals_avg as (
            select
                x.*,
                full_time_away_goals_scored_avg as full_time_home_goals_conceded_avg,
                full_time_home_goals_scored_avg as full_time_away_goals_conceded_avg
            from
                (
                    select
                        division_cd,
                        season,
                        avg(full_time_home_team_goals) as full_time_home_goals_scored_avg,
                        avg(full_time_away_team_goals) as full_time_away_goals_scored_avg
                    from
                        tmp_results tr
                    group by
                        division_cd,
                        season
                ) x
        )
        select
            h.season,
            h.division_cd,
            h.team_nm,
            cast(h.full_time_home_goals_scored_avg / dg.full_time_home_goals_scored_avg as decimal(8,4)) as home_attack_strength,
            cast(h.full_time_home_goals_conceded_avg / dg.full_time_home_goals_conceded_avg as decimal(8,4)) as home_defence_strength,
            cast(a.full_time_away_goals_scored_avg / dg.full_time_away_goals_scored_avg as decimal(8,4)) as away_attack_strength,
            cast(a.full_time_away_goals_conceded_avg / dg.full_time_away_goals_conceded_avg as decimal(8,4)) as away_defence_strength,
            dg.full_time_home_goals_scored_avg as league_home_scored_avg,
            dg.full_time_away_goals_scored_avg as league_away_scored_avg,
            dg.full_time_home_goals_conceded_avg as league_home_conceded_avg,
            dg.full_time_away_goals_conceded_avg as league_away_conceded_avg,
            ld_calc_date
        from
            (select
                division_cd,
                season,
                home_team_nm as team_nm,
                AVG(full_time_home_team_goals) as full_time_home_goals_scored_avg,
                AVG(full_time_away_team_goals) as full_time_home_goals_conceded_avg
            from
                tmp_results
            group by
                division_cd,
                season ,
                home_team_nm) h
        LEFT JOIN
            (select
                division_cd,
                season,
                away_team_nm as team_nm,
                AVG(full_time_away_team_goals) as full_time_away_goals_scored_avg,
                AVG(full_time_home_team_goals) as full_time_away_goals_conceded_avg
            from
                tmp_results
            group by
                division_cd,
                season ,
                away_team_nm
            ) a on a.division_cd = h.division_cd and a.season = h.season and a.team_nm = h.team_nm
        join tmp_div_goals_avg dg on dg.division_cd = h.division_cd and dg.season = h.season;
	end;
end$$

DELIMITER ;