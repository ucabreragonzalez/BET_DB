DELIMITER $$
drop procedure if exists sp_run_strategy;
create procedure sp_run_strategy(in in_date_from date, in in_date_to date)
begin
    declare ld_date_from date;
	declare ld_date_to date;
    
    declare lv_division_cd varchar(10);
    declare ld_match_dt date;
    declare lv_home_team_nm varchar(50);
    declare lv_away_team_nm varchar(50);
    
    set ld_date_from = coalesce(in_date_from, current_date());
    set ld_date_to = coalesce(in_date_to, ld_date_from);
    
    begin
		DECLARE exit_loop BOOLEAN DEFAULT false;
		declare cur_fixtures cursor for
        -- ----------------------------
			SELECT x.division_cd, x.match_dt, x.home_team_nm, x.away_team_nm
			FROM
				(SELECT division_cd, match_dt, match_time, home_team_nm, away_team_nm
				FROM t_fixtures
				WHERE match_dt BETWEEN ld_date_from AND ld_date_to
				UNION
				SELECT division_cd, match_dt, match_time, home_team_nm, away_team_nm
				FROM t_results
				WHERE match_dt BETWEEN ld_date_from AND ld_date_to) x
			ORDER BY x.match_dt , x.match_time;
		-- ----------------------------
		DECLARE CONTINUE HANDLER FOR NOT FOUND SET exit_loop = true;
        
        OPEN cur_fixtures;
        
        fixtures_loop: LOOP
			FETCH cur_fixtures INTO lv_division_cd, ld_match_dt, lv_home_team_nm, lv_away_team_nm;
            IF exit_loop THEN
				CLOSE cur_fixtures;
                LEAVE fixtures_loop;
			END IF;
            
            -- List of strategies below
            call sp_strategy_vicent_o25('Vincent''s >2.5 G' ,lv_division_cd, ld_match_dt, lv_home_team_nm, lv_away_team_nm);
            call sp_whalebets_o25('Whalebets >2.5 G' ,lv_division_cd, ld_match_dt, lv_home_team_nm, lv_away_team_nm);
            call sp_andreas_h2h_o25('Andreas h2h >2.5 G' ,lv_division_cd, ld_match_dt, lv_home_team_nm, lv_away_team_nm);
        END LOOP fixtures_loop;

        call sp_goals_expected_o25(ld_date_from, ld_date_to);

    end;
end$$
DELIMITER ;