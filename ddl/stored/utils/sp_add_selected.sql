DELIMITER $$
DROP PROCEDURE IF EXISTS sp_add_selected;
CREATE PROCEDURE sp_add_selected(in_data varchar(250))
BEGIN

    DECLARE l_division_cd VARCHAR(10);
    DECLARE l_match_dt VARCHAR(10);
    DECLARE l_home_team_nm VARCHAR(50);
    DECLARE l_away_team_nm VARCHAR(50);
    DECLARE l_strategy_nm VARCHAR(100);
    DECLARE l_forecast VARCHAR(50);
    DECLARE l_user_nm VARCHAR(50);
    
    SET l_division_cd = 	fnSplitString(in_data, '|', 1);
    SET l_match_dt = 		fnSplitString(in_data, '|', 2);
    SET l_home_team_nm = 	fnSplitString(in_data, '|', 3);
    SET l_away_team_nm = 	fnSplitString(in_data, '|', 4);
    SET l_strategy_nm = 	fnSplitString(in_data, '|', 5);
    SET l_forecast = 		fnSplitString(in_data, '|', 6);
    SET l_user_nm = 		fnSplitString(in_data, '|', 7);

    insert into t_selected_match (division_cd,match_dt,home_team_nm,away_team_nm,strategy_nm,forecast,user_nm)
    values (l_division_cd, STR_TO_DATE(l_match_dt,'%d/%m/%Y'), l_home_team_nm, l_away_team_nm, l_strategy_nm, l_forecast, l_user_nm);
    
    Commit;
    
    Select Concat('[Success] match added => ', l_home_team_nm, ' vs ', l_away_team_nm) as Result;
    
end$$
DELIMITER ;