CREATE OR REPLACE VIEW v_team_strength AS
with div_goals_avg as
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
		t_results tr
	group by
		division_cd,
		season
) x)
select
	s.sport_nm,
	c.country_nm,
	d.division_nm,
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
		t_results
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
			t_results
		group by
			division_cd,
			season ,
			away_team_nm
		) a on a.division_cd = h.division_cd and a.season = h.season and a.team_nm = h.team_nm
join div_goals_avg dg on dg.division_cd = h.division_cd and dg.season = h.season
JOIN t_division d ON d.division_cd = h.division_cd
JOIN t_country c ON c.country_id = d.country_id
JOIN t_sport s ON s.sport_id = d.sport_id;