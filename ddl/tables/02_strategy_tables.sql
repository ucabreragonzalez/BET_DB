-- Strategy
-- CREATE TABLE t_strategy (
--     strategy_nm VARCHAR(100) NOT NULL UNIQUE,
--     strategy_query TEXT,
--     created_dt DATETIME
-- );

-- CREATE 
--     TRIGGER  t_strategy_bi_trg
--  BEFORE INSERT ON t_strategy FOR EACH ROW 
--     SET NEW . created_dt = NOW();

-- Strategy Results
CREATE TABLE t_strategy_results (
    strategy_nm VARCHAR(100) NOT NULL,
    division_cd VARCHAR(10) NOT NULL,
    match_dt DATE NOT NULL,
    match_time TIME,
    home_team_nm VARCHAR(50) NOT NULL,
    away_team_nm VARCHAR(50) NOT NULL,
    score DECIMAL,
    forecast VARCHAR(50),
    matches_analized DECIMAL,
    percentage_passed DECIMAL,
    description VARCHAR(100),
    created_dt DATETIME
);

ALTER TABLE t_strategy_results
	ADD CONSTRAINT t_strategy_results_pk
    PRIMARY KEY (strategy_nm, division_cd , match_dt , home_team_nm , away_team_nm);

CREATE INDEX tstrategy_res_matchdt_ndx ON t_strategy_results (match_dt desc);

CREATE 
    TRIGGER  t_strategy_res_bi_trg
 BEFORE INSERT ON t_strategy_results FOR EACH ROW 
    SET NEW . created_dt = NOW();
