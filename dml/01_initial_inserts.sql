insert into t_country (country_nm) values ('England'), ('Spain');
insert into t_country (country_nm) values ('Scotland'), ('Germany');
insert into t_country (country_nm) values ('Italy'), ('France'), ('Netherlands'), ('Belgium'), ('Portugal'), ('Turkey'), ('Greece');

insert into t_sport (sport_nm) values ('Soccer');

insert into t_division (division_cd, division_nm, sport_id, country_id)
SELECT 
    'E0',
    'Premier League',
    (select sport_id from t_sport where sport_nm = 'Soccer'),
    (select country_id from t_country where country_nm = 'England');
    
insert into t_division (division_cd, division_nm, sport_id, country_id)
SELECT 
    'E1',
    'Championship',
    (select sport_id from t_sport where sport_nm = 'Soccer'),
    (select country_id from t_country where country_nm = 'England');

insert into t_division (division_cd, division_nm, sport_id, country_id)
SELECT 
    'E2',
    'League 1',
    (select sport_id from t_sport where sport_nm = 'Soccer'),
    (select country_id from t_country where country_nm = 'England');
    
insert into t_division (division_cd, division_nm, sport_id, country_id)
SELECT 
    'E3',
    'League 2',
    (select sport_id from t_sport where sport_nm = 'Soccer'),
    (select country_id from t_country where country_nm = 'England');
    
insert into t_division (division_cd, division_nm, sport_id, country_id)
SELECT 
    'EC',
    'Conference',
    (select sport_id from t_sport where sport_nm = 'Soccer'),
    (select country_id from t_country where country_nm = 'England');
    
-- Scotland --------------------------- 
insert into t_division (division_cd, division_nm, sport_id, country_id)
SELECT 
    'SC0',
    'Premier League',
    (select sport_id from t_sport where sport_nm = 'Soccer'),
    (select country_id from t_country where country_nm = 'Scotland');
    
insert into t_division (division_cd, division_nm, sport_id, country_id)
SELECT 
    'SC1',
    'Division 1',
    (select sport_id from t_sport where sport_nm = 'Soccer'),
    (select country_id from t_country where country_nm = 'Scotland');

insert into t_division (division_cd, division_nm, sport_id, country_id)
SELECT 
    'SC2',
    'Division 2',
    (select sport_id from t_sport where sport_nm = 'Soccer'),
    (select country_id from t_country where country_nm = 'Scotland');
    
insert into t_division (division_cd, division_nm, sport_id, country_id)
SELECT 
    'SC3',
    'Division 3',
    (select sport_id from t_sport where sport_nm = 'Soccer'),
    (select country_id from t_country where country_nm = 'Scotland');

-- Germany --------------------------- 
insert into t_division (division_cd, division_nm, sport_id, country_id)
SELECT 
    'D1',
    'Bundesliga 1',
    (select sport_id from t_sport where sport_nm = 'Soccer'),
    (select country_id from t_country where country_nm = 'Germany');
    
insert into t_division (division_cd, division_nm, sport_id, country_id)
SELECT 
    'D2',
    'Bundesliga 2',
    (select sport_id from t_sport where sport_nm = 'Soccer'),
    (select country_id from t_country where country_nm = 'Germany');
    
-- Italy --------------------------- 
insert into t_division (division_cd, division_nm, sport_id, country_id)
SELECT 
    'I1',
    'Serie A',
    (select sport_id from t_sport where sport_nm = 'Soccer'),
    (select country_id from t_country where country_nm = 'Italy');
    
insert into t_division (division_cd, division_nm, sport_id, country_id)
SELECT 
    'I2',
    'Serie B',
    (select sport_id from t_sport where sport_nm = 'Soccer'),
    (select country_id from t_country where country_nm = 'Italy');
    
-- Spain --------------------------- 
insert into t_division (division_cd, division_nm, sport_id, country_id)
SELECT 
    'SP1',
    'La Liga Primera Division',
    (select sport_id from t_sport where sport_nm = 'Soccer'),
    (select country_id from t_country where country_nm = 'Spain');
    
insert into t_division (division_cd, division_nm, sport_id, country_id)
SELECT 
    'SP2',
    'La Liga Segunda Division',
    (select sport_id from t_sport where sport_nm = 'Soccer'),
    (select country_id from t_country where country_nm = 'Spain');
    
-- France --------------------------- 
insert into t_division (division_cd, division_nm, sport_id, country_id)
SELECT 
    'F1',
    'Le Championnat',
    (select sport_id from t_sport where sport_nm = 'Soccer'),
    (select country_id from t_country where country_nm = 'France');
    
insert into t_division (division_cd, division_nm, sport_id, country_id)
SELECT 
    'F2',
    'Division 2',
    (select sport_id from t_sport where sport_nm = 'Soccer'),
    (select country_id from t_country where country_nm = 'France');
    
-- Netherlands --------------------------- 
insert into t_division (division_cd, division_nm, sport_id, country_id)
SELECT 
    'N1',
    'Eredivisie',
    (select sport_id from t_sport where sport_nm = 'Soccer'),
    (select country_id from t_country where country_nm = 'Netherlands');
    
-- Belgium --------------------------- 
insert into t_division (division_cd, division_nm, sport_id, country_id)
SELECT 
    'B1',
    'Jupiler League',
    (select sport_id from t_sport where sport_nm = 'Soccer'),
    (select country_id from t_country where country_nm = 'Belgium');

-- Portugal --------------------------- 
insert into t_division (division_cd, division_nm, sport_id, country_id)
SELECT 
    'P1',
    'Liga I',
    (select sport_id from t_sport where sport_nm = 'Soccer'),
    (select country_id from t_country where country_nm = 'Portugal');

-- Turkey --------------------------- 
insert into t_division (division_cd, division_nm, sport_id, country_id)
SELECT 
    'T1',
    'Futbol Ligi 1',
    (select sport_id from t_sport where sport_nm = 'Soccer'),
    (select country_id from t_country where country_nm = 'Turkey');
    
-- Greece --------------------------- 
insert into t_division (division_cd, division_nm, sport_id, country_id)
SELECT 
    'G1',
    'Ethniki Katigoria',
    (select sport_id from t_sport where sport_nm = 'Soccer'),
    (select country_id from t_country where country_nm = 'Greece');