DELIMITER $$
DROP FUNCTION IF EXISTS getGoalsExpected;
CREATE FUNCTION getGoalsExpected(in_leg varchar(1), in_division_nm varchar(50), in_home_team_nm varchar(50), in_away_team_nm varchar(50), in_season INT, in_match_dt date)
RETURNS DECIMAL(13,10)
DETERMINISTIC
BEGIN
	DECLARE ln_GEx DECIMAL(13,10);
    SET ln_GEx = (
			with tmp_results as
			( select * from t_results
			where season = in_season
            and division_cd = (select division_cd from t_division where division_nm = in_division_nm)
			and match_dt < coalesce(in_match_dt, match_dt)
			)
			, div_goals_avg as
			(select
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
			) x)
			, teams_strength as 
			(select
				h.season,
				h.team_nm,
				h.full_time_home_goals_scored_avg / dg.full_time_home_goals_scored_avg as home_attack_strength,
				h.full_time_home_goals_conceded_avg / dg.full_time_home_goals_conceded_avg as home_defence_strength,
				a.full_time_away_goals_scored_avg / dg.full_time_away_goals_scored_avg as away_attack_strength,
				a.full_time_away_goals_conceded_avg / dg.full_time_away_goals_conceded_avg as away_defence_strength,
				dg.full_time_home_goals_scored_avg as league_home_scored_avg,
				dg.full_time_away_goals_scored_avg as league_away_scored_avg,
				dg.full_time_home_goals_conceded_avg as league_home_conceded_avg,
				dg.full_time_away_goals_conceded_avg as league_away_conceded_avg
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
			LEFT JOIN (
					select
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
			join div_goals_avg dg on dg.division_cd = h.division_cd and dg.season = h.season)
			select
				case in_leg when upper('H') then
					home.home_attack_strength * away.away_defence_strength * home.league_home_scored_avg
				else
					home.home_defence_strength * away.away_attack_strength * away.league_away_scored_avg
				end
            from teams_strength home
			cross join teams_strength away
			where home.team_nm = in_home_team_nm
			and away.team_nm = in_away_team_nm
        );
	RETURN ln_GEx;
END$$
DELIMITER ;