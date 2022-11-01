DELIMITER $$
DROP PROCEDURE IF EXISTS sp_delete_selected;
CREATE PROCEDURE sp_delete_selected(in_data varchar(250))
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

    delete from t_selected_match
    where
        division_cd = l_division_cd
        and match_dt = STR_TO_DATE(l_match_dt,'%d/%m/%Y')
        and home_team_nm = l_home_team_nm
        and away_team_nm = l_away_team_nm
        and strategy_nm = l_strategy_nm
        and forecast = l_forecast
        and user_nm = l_user_nm;
    
    Commit;
    
    Select Concat('[Success] match deleted => ', l_home_team_nm, ' vs ', l_away_team_nm) as Result;
    
end$$
DELIMITER ;