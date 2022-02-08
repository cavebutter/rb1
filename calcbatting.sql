--Calculated batting stats for OOTP
--Overall stats - split_id=1
    DROP TABLE IF EXISTS CalcBatting;
    CREATE TABLE IF NOT EXISTS CalcBatting (
    bat_id INT AUTO_INCREMENT PRIMARY KEY)
    SELECT b.year
    , b.level_id
    , b.league_id
    , b.player_id
    , b.stint
    , b.split_id
    , b.team_id
    , b.sub_league_id
    , b.g
    , b.ab
    , @PA := b.ab+b.bb+b.sh+b.sf+b.hp AS PA
    , b.r
    , b.h
    , b.d
    , b.t
    , b.hr
    , b.rbi
    , b.sb
    , b.cs
    , b.bb
    , b.k
    , b.ibb
    , b.hp
    , b.sh
    , b.sf
    , b.gdp
    , b.ci
    , b.war
    , @BA := round(b.h/b.ab,3) AS ba
    , IF(@PA=0,NULL,round(b.k/@PA,3)) as krate
    , IF(@PA=0,NULL,round((b.bb)/@PA,3)) as bbrate
    , @OBP := IF(@PA-b.sh-b.ci=0,NULL, round((b.h + b.bb + b.hp)/(@PA-b.sh-b.ci),3)) AS obp
    , IF(r.woba=0,NULL,round(100*(@OBP/r.woba),0)) as OBPplus
    , @SLG := round((b.h+b.d+2*b.t+3*b.hr)/b.ab,3) as slg
    , round(@OBP+@SLG,3) as ops
    , round(@SLG-@BA,3) as iso
    , IF(b.ab-b.k-b.hr+b.sf=0,0, round((b.h-b.hr)/(b.ab-b.k-b.hr+b.sf),3)) as babip
    , @woba := round((r.wobaBB*(b.bb-b.ibb) + r.wobaHB*b.hp + r.woba1B*(b.h-b.d-b.t-b.hr) + r.woba2B*b.d + r.woba3B*b.t + r.wobaHR*b.hr) / (b.ab+b.bb-b.ibb+b.sf+b.hp),3) as woba
    , @wRAA := round(((@woba-r.woba)/r.wOBAscale)*@PA,1) as wRAA
    , round((((@woba-r.woba)/r.wOBAscale)+(lro.totr/lro.totpa))*@PA,1) as wRC
    , ROUND((((@wRAA/@PA + lro.RperPA) + (lro.RperPA - p.avg*lro.RperPA))/(slg.slg_r/slg.slg_pa))*100,0) as 'wRC+'

    FROM
      players_career_batting_stats b
      INNER JOIN teams t ON b.team_id=t.team_id
      --INNER JOIN team_relations AS tr ON b.team_id=tr.team_id AND b.league_id=tr.league_id
      INNER JOIN tblRunValues2 r ON b.year=r.year AND b.league_id=r.league_id AND b.sub_league_id=r.sub_league_id
      INNER JOIN LeagueRunsPerOut lro ON b.year=lro.year AND b.league_id=lro.league_id AND b.sub_league_id=lro.sub_league_id
      INNER JOIN parks p ON t.park_id=p.park_id
      INNER JOIN sub_league_history_batting slg ON b.sub_league_id=slg.sub_league_id AND b.league_id=slg.league_id AND b.year=slg.year
    WHERE b.ab<>0 AND b.split_id=1 AND b.league_id<>0 AND b.team_id<>0
    ORDER BY b.player_id, b.year;
ALTER TABLE CalcBatting
    ADD INDEX cb_ix1 (year),
    ADD INDEX cb_ix2 (team_id),
    ADD INDEX cb_ix3 (player_id),
    ADD INDEX cb_ix4 (league_id)
    ;


--Vs Left stats - split_id=2
    DROP TABLE IF EXISTS CalcBatting_L;
    CREATE TABLE IF NOT EXISTS CalcBatting_L (
    bat_id INT AUTO_INCREMENT PRIMARY KEY)
    SELECT b.year
    , b.level_id
    , b.league_id
    , b.player_id
    , b.stint
    , b.split_id
    , b.team_id
    , b.sub_league_id
    , b.g
    , b.ab
    , @PA := b.ab+b.bb+b.sh+b.sf+b.hp AS PA
    , b.r
    , b.h
    , b.d
    , b.t
    , b.hr
    , b.rbi
    , b.sb
    , b.cs
    , b.bb
    , b.k
    , b.ibb
    , b.hp
    , b.sh
    , b.sf
    , b.gdp
    , b.ci
    , b.war
    , @BA := round(b.h/b.ab,3) AS ba
    , IF(@PA=0,NULL,round(b.k/@PA,3)) as krate
    , IF(@PA=0,NULL,round((b.bb)/@PA,3)) as bbrate
    , @OBP := IF(@PA-b.sh-b.ci=0,NULL, round((b.h + b.bb + b.hp)/(@PA-b.sh-b.ci),3)) AS obp
    , IF(r.woba=0,NULL,round(100*(@OBP/r.woba),0)) as OBPplus
    , @SLG := round((b.h+b.d+2*b.t+3*b.hr)/b.ab,3) as slg
    , round(@OBP+@SLG,3) as ops
    , round(@SLG-@BA,3) as iso
    , IF(b.ab-b.k-b.hr+b.sf=0,0, round((b.h-b.hr)/(b.ab-b.k-b.hr+b.sf),3)) as babip
    , @woba := round((r.wobaBB*(b.bb-b.ibb) + r.wobaHB*b.hp + r.woba1B*(b.h-b.d-b.t-b.hr) + r.woba2B*b.d + r.woba3B*b.t + r.wobaHR*b.hr) / (b.ab+b.bb-b.ibb+b.sf+b.hp),3) as woba
    , @wRAA := round(((@woba-r.woba)/r.wOBAscale)*@PA,1) as wRAA
    , round((((@woba-r.woba)/r.wOBAscale)+(lro.totr/lro.totpa))*@PA,1) as wRC
    , ROUND((((@wRAA/@PA + lro.RperPA) + (lro.RperPA - p.avg*lro.RperPA))/(slg.slg_r/slg.slg_pa))*100,0) as 'wRC+'
    FROM
      players_career_batting_stats b
      INNER JOIN teams t ON b.team_id=t.team_id
      --INNER JOIN team_relations AS tr ON b.team_id=tr.team_id AND b.league_id=tr.league_id
      INNER JOIN tblRunValues2 r ON b.year=r.year AND b.league_id=r.league_id AND b.sub_league_id=r.sub_league_id
      INNER JOIN LeagueRunsPerOut lro ON b.year=lro.year AND b.league_id=lro.league_id AND b.sub_league_id=lro.sub_league_id
      INNER JOIN parks p ON t.park_id=p.park_id
      INNER JOIN sub_league_history_batting slg ON b.sub_league_id=slg.sub_league_id AND b.league_id=slg.league_id AND b.year=slg.year
    WHERE b.ab<>0 AND b.split_id=2 AND b.league_id<>0 AND b.team_id<>0
    ORDER BY b.player_id, b.year;
--Add indexes
ALTER TABLE CalcBatting_L
    ADD INDEX cb_ix1 (year),
    ADD INDEX cb_ix2 (team_id),
    ADD INDEX cb_ix3 (player_id),
    ADD INDEX cb_ix4 (league_id)
    ;

--VS Right stats - split_id=3
    DROP TABLE IF EXISTS CalcBatting_R;
    CREATE TABLE IF NOT EXISTS CalcBatting_R (
    bat_id INT AUTO_INCREMENT PRIMARY KEY)
    SELECT b.year
    , b.level_id
    , b.league_id
    , b.player_id
    , b.stint
    , b.split_id
    , b.team_id
    , b.sub_league_id
    , b.g
    , b.ab
    , @PA := b.ab+b.bb+b.sh+b.sf+b.hp AS PA
    , b.r
    , b.h
    , b.d
    , b.t
    , b.hr
    , b.rbi
    , b.sb
    , b.cs
    , b.bb
    , b.k
    , b.ibb
    , b.hp
    , b.sh
    , b.sf
    , b.gdp
    , b.ci
    , b.war
    , @BA := round(b.h/b.ab,3) AS ba
    , IF(@PA=0,NULL,round(b.k/@PA,3)) as krate
    , IF(@PA=0,NULL,round((b.bb)/@PA,3)) as bbrate
    , @OBP := IF(@PA-b.sh-b.ci=0,NULL, round((b.h + b.bb + b.hp)/(@PA-b.sh-b.ci),3)) AS obp
    , IF(r.woba=0,NULL,round(100*(@OBP/r.woba),0)) as OBPplus
    , @SLG := round((b.h+b.d+2*b.t+3*b.hr)/b.ab,3) as slg
    , round(@OBP+@SLG,3) as ops
    , round(@SLG-@BA,3) as iso
    , IF(b.ab-b.k-b.hr+b.sf=0,0, round((b.h-b.hr)/(b.ab-b.k-b.hr+b.sf),3)) as babip
    , @woba := round((r.wobaBB*(b.bb-b.ibb) + r.wobaHB*b.hp + r.woba1B*(b.h-b.d-b.t-b.hr) + r.woba2B*b.d + r.woba3B*b.t + r.wobaHR*b.hr) / (b.ab+b.bb-b.ibb+b.sf+b.hp),3) as woba
    , @wRAA := round(((@woba-r.woba)/r.wOBAscale)*@PA,1) as wRAA
    , round((((@woba-r.woba)/r.wOBAscale)+(lro.totr/lro.totpa))*@PA,1) as wRC
    , ROUND((((@wRAA/@PA + lro.RperPA) + (lro.RperPA - p.avg*lro.RperPA))/(slg.slg_r/slg.slg_pa))*100,0) as 'wRC+'
    FROM
      players_career_batting_stats b
      INNER JOIN teams t ON b.team_id=t.team_id
      --INNER JOIN team_relations AS tr ON b.team_id=tr.team_id AND b.league_id=tr.league_id
      INNER JOIN tblRunValues2 r ON b.year=r.year AND b.league_id=r.league_id AND b.sub_league_id=r.sub_league_id
      INNER JOIN LeagueRunsPerOut lro ON b.year=lro.year AND b.league_id=lro.league_id AND b.sub_league_id=lro.sub_league_id
      INNER JOIN parks p ON t.park_id=p.park_id
      INNER JOIN sub_league_history_batting slg ON b.sub_league_id=slg.sub_league_id AND b.league_id=slg.league_id AND b.year=slg.year    WHERE b.ab<>0 AND b.split_id=3 AND b.league_id<>0 AND b.team_id<>0
    ORDER BY b.player_id, b.year;

--Add indexes
ALTER TABLE CalcBatting_R
    ADD INDEX cb_ix1 (year),
    ADD INDEX cb_ix2 (team_id),
    ADD INDEX cb_ix3 (player_id),
    ADD INDEX cb_ix4 (league_id)
    ;

