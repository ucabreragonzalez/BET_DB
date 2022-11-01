-- COUNTRY
CREATE TABLE t_country (
    country_id INT NOT NULL AUTO_INCREMENT,
    country_nm VARCHAR(20) NOT NULL UNIQUE,
    created_dt DATETIME,
    PRIMARY KEY tcountry_pk (country_id)
);

CREATE 
    TRIGGER  tcountry_bi_trg
 BEFORE INSERT ON t_country FOR EACH ROW 
    SET NEW . created_dt = NOW();

-- SPORT
CREATE TABLE t_sport (
    sport_id INT NOT NULL AUTO_INCREMENT,
    sport_nm VARCHAR(20) NOT NULL UNIQUE,
    created_dt DATETIME,
    PRIMARY KEY tsport_pk (sport_id)
);

CREATE 
    TRIGGER  tsport_bi_trg
 BEFORE INSERT ON t_sport FOR EACH ROW 
    SET NEW . created_dt = NOW();
    
-- DIVISION
CREATE TABLE t_division (
    division_cd VARCHAR(10) NOT NULL,
    division_nm VARCHAR(50) NOT NULL,
    country_id INT NOT NULL,
    sport_id INT NOT NULL,
    created_dt DATETIME,
    PRIMARY KEY t_division_pk (division_cd , country_id , sport_id),
    CONSTRAINT tdivision_countryid_fk FOREIGN KEY (country_id)
        REFERENCES t_country (country_id),
    CONSTRAINT tdivision_sportid_fk FOREIGN KEY (sport_id)
        REFERENCES t_sport (sport_id)
);

CREATE 
    TRIGGER  tdivision_bi_trg
 BEFORE INSERT ON t_division FOR EACH ROW 
    SET NEW . created_dt = NOW();
    
-- RESULTS
CREATE TABLE t_results (
    division_cd VARCHAR(10) NOT NULL,
    season INT,
    match_dt DATE NOT NULL,
    match_time TIME,
    home_team_nm VARCHAR(50) NOT NULL,
    away_team_nm VARCHAR(50) NOT NULL,
    full_time_home_team_goals INT,
    full_time_away_team_goals INT,
    full_time_result VARCHAR(1),
    half_time_home_team_goals INT,
    half_time_away_team_goals INT,
    half_time_result VARCHAR(1),
    referee_nm VARCHAR(20),
    home_team_shots INT,
    away_team_shots INT,
    home_team_shots_on_target INT,
    away_team_shots_on_target INT,
    home_team_fouls_committed INT,
    away_team_fouls_committed INT,
    home_team_corners INT,
    away_team_corners INT,
    home_team_yellow_cards INT,
    away_team_yellow_cards INT,
    home_team_red_cards INT,
    away_team_red_cards INT,
    o25_odd DECIMAL(5,2),
    u25_odd DECIMAL(5,2),
    created_dt DATETIME,
    PRIMARY KEY t_results_pk (division_cd , match_dt , home_team_nm , away_team_nm),
    CONSTRAINT tresults_divisioncd_fk FOREIGN KEY (division_cd)
        REFERENCES t_division (division_cd)
);

CREATE INDEX tresults_divcdseason_ndx ON t_results (division_cd, season);

CREATE 
    TRIGGER  tresults_bi_trg
 BEFORE INSERT ON t_results FOR EACH ROW
    SET NEW . created_dt = NOW();

-- FIXTURES
CREATE TABLE t_fixtures (
    division_cd VARCHAR(10) NOT NULL,
    season INT,
    match_dt DATE NOT NULL,
    match_time TIME,
    home_team_nm VARCHAR(50) NOT NULL,
    away_team_nm VARCHAR(50) NOT NULL,
    o25_odd DECIMAL(5,2),
    u25_odd DECIMAL(5,2),
    created_dt DATETIME,
    PRIMARY KEY t_results_pk (division_cd , match_dt , home_team_nm , away_team_nm),
    CONSTRAINT tfixtures_divisioncd_fk FOREIGN KEY (division_cd)
        REFERENCES t_division (division_cd)
);

CREATE INDEX tfixtures_matchdt_ndx ON t_fixtures (match_dt desc);

CREATE INDEX tfixtures_hometeamnm_ndx ON t_fixtures (home_team_nm desc);

CREATE INDEX tfixtures_awayteamnm_ndx ON t_fixtures (away_team_nm desc);

CREATE 
    TRIGGER  tfixtures_bi_trg
 BEFORE INSERT ON t_fixtures FOR EACH ROW 
    SET NEW . created_dt = NOW();


-- TEAMS
CREATE TABLE t_teams (
  team_id INT NOT NULL AUTO_INCREMENT,
  team_nm varchar(50) UNIQUE NOT NULL,
  PRIMARY KEY t_teams_pk (team_id)
);

-- MONITORED EVENTS
CREATE TABLE t_selected_match (
    division_cd VARCHAR(10) NOT NULL,
    match_dt DATE NOT NULL,
    home_team_nm VARCHAR(50) NOT NULL,
    away_team_nm VARCHAR(50) NOT NULL,
    strategy_nm VARCHAR(100) NULL,
    forecast VARCHAR(50) NULL,
    user_nm VARCHAR(50) NOT NULL,
    created_dt DATETIME NULL,
    PRIMARY KEY t_selected_match_pk (division_cd, match_dt, home_team_nm, away_team_nm, user_nm)
);

CREATE 
    TRIGGER  tselectedmatch_bi_trg
 BEFORE INSERT ON t_selected_match FOR EACH ROW 
    SET NEW . created_dt = NOW();

-- TEAM STRENGTH
CREATE TABLE t_team_strength (
    season INT NOT NULL,
    division_cd VARCHAR(10) NOT NULL,
    team_nm VARCHAR(50) NOT NULL,
    home_attack_strength DECIMAL(8,4),
    home_defence_strength DECIMAL(8,4),
    away_attack_strength DECIMAL(8,4),
    away_defence_strength DECIMAL(8,4),
    league_home_scored_avg DECIMAL(8,4),
    league_away_scored_avg DECIMAL(8,4),
    league_home_conceded_avg DECIMAL(8,4),
    league_away_conceded_avg DECIMAL(8,4),
    calculated_dt DATE,
    created_dt DATETIME
);

ALTER TABLE t_team_strength
	ADD CONSTRAINT t_team_strength_pk
    PRIMARY KEY (season, division_cd, team_nm, calculated_dt);

CREATE 
    TRIGGER t_team_strength_bi_trg
 BEFORE INSERT ON t_team_strength FOR EACH ROW 
    SET NEW . created_dt = NOW();