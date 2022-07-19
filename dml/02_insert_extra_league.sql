insert into t_country (country_nm) values ('Mexico');
insert into t_country (country_nm) values ('Poland');
insert into t_country (country_nm) values ('Argentina');

-- Mexico --------------------------- 
insert into t_division (division_cd, division_nm, sport_id, country_id)
SELECT 
    'MEX',
    'Liga MX',
    (select sport_id from t_sport where sport_nm = 'Soccer'),
    (select country_id from t_country where country_nm = 'Mexico');

-- Poland --------------------------- 
insert into t_division (division_cd, division_nm, sport_id, country_id)
SELECT 
    'POL',
    'Ekstraklasa',
    (select sport_id from t_sport where sport_nm = 'Soccer'),
    (select country_id from t_country where country_nm = 'Poland');
-- Argentina --------------------------- 
insert into t_division (division_cd, division_nm, sport_id, country_id)
SELECT 
    'ARG',
    'Liga Profesional',
    (select sport_id from t_sport where sport_nm = 'Soccer'),
    (select country_id from t_country where country_nm = 'Argentina');
