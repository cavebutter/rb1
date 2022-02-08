-- Overall split_id=1
DROP TABLE IF EXISTS CalcPitching;
CREATE TABLE IF NOT EXISTS CalcPitching (pit_id INT AUTO_INCREMENT PRIMARY KEY)
SELECT
    i.player_id
    , i.year
    , i.stint
    , i.team_id
    , i.level_id
    , i.league_id
    , i.sub_league_id
    , i.split_id
    , i.ip
    , i.ab
    , i.tb
    , i.ha
    , i.k
    , i.bf
    , i.rs
    , i.bb
    , i.r
    , i.er
    , i.gb
    , i.fb
    , i.pi
    , i.ipf
    , i.g
    , i.gs
    , i.w
    , i.l
    , i.s
    , i.sa
    , i.da
    , i.sh
    , i.sf
    , i.ta
    , i.hra
    , i.bk
    , i.ci
    , i.iw
    , i.wp
    , i.hp
    , i.gf
    , i.dp
    , i.qs
    , i.svo
    , i.bs
    , i.ra
    , i.cg
    , i.sho
    , i.sb
    , i.cs
    , i.hld
    , i.ir
    , i.irs
    , i.wpa
    , i.li
    , i.outs
    , i.war
    , @InnPitch := ((3*ip)+ipf)/3 AS InnPitch
    , IF(@InnPitch=0,0,round((9*i.k)/@InnPitch,1)) AS 'k9'
    , IF(@InnPitch=0,0, round((9*i.bb)/@InnPitch,1)) AS 'bb9'
    , IF(@InnPitch=0,0,round((9*i.hra)/@InnPitch,1)) AS 'HR9'
    , IF(@InnPitch=0,0, round((i.bb+i.ha)/@InnPitch,2)) AS WHIP
    , IF(i.bb=0,0,round(i.k/i.bb,2)) AS 'K/BB'
    , IF(i.fb=0,0,i.gb/i.fb) AS 'gb/fb'
    , IF(i.ab-i.k-i.hra-i.sh+i.sf=0,0,round((i.ha-i.hra)/(i.ab-i.k-i.hra-i.sh+i.sf),3)) AS BABIP
    , IF(@InnPitch=0,0,@ERA := round((i.er/@InnPitch)*9,2)) AS ERA
    , IF(@InnPitch=0,0,@FIP := round(((13*i.hra)+(3*(i.bb+i.hp))-(2*i.k))/@InnPitch+f.FIPConstant,2)) AS FIP
    , IF(@InnPitch=0,0,round(((13*(i.fb*f.hr_fb_pct))+(3*(i.bb+i.hp))-(2*i.k))/@InnPitch+f.FIPConstant,2)) AS xFIP
    , round(100*((@ERA + (@ERA - @ERA*(p.avg)))/slg.slgERA),0) AS ERAminus
    , IF(@ERA=0,0,round(100*(slg.slgERA/@ERA)*p.avg,0)) AS ERAplus
    , round(100*((@FIP + (@FIP - @FIP*(p.avg)))/slg.slgFIP),0) AS FIPminus
    FROM players_career_pitching_stats AS i
    INNER JOIN FIPConstant AS f ON i.year=f.year AND i.league_id=f.league_id
    INNER JOIN sub_league_history_pitching AS slg ON i.year=slg.year AND i.league_id=slg.league_id AND i.sub_league_id=slg.sub_league_id
    INNER JOIN teams AS t ON i.team_id=t.team_id
    INNER JOIN parks AS p ON t.park_id=p.park_id
WHERE i.split_id=1 AND i.league_id<>0 AND i.team_id<>0;

-- Adds INDEX
ALTER TABLE CalcPitching
ADD INDEX pit_ix1 (year),
ADD INDEX pit_ix2 (team_id),
ADD INDEX pit_ix3 (player_id);

-- VS Left split_id=2
DROP TABLE IF EXISTS CalcPitching_L;
CREATE TABLE IF NOT EXISTS CalcPitching_L (pit_id INT AUTO_INCREMENT PRIMARY KEY)

SELECT
    i.player_id
    , i.year
    , i.stint
    , i.team_id
    , i.level_id
    , i.league_id
    , i.sub_league_id
    , i.split_id
    , i.ip
    , i.ab
    , i.tb
    , i.ha
    , i.k
    , i.bf
    , i.rs
    , i.bb
    , i.r
    , i.er
    , i.gb
    , i.fb
    , i.pi
    , i.ipf
    , i.g
    , i.gs
    , i.w
    , i.l
    , i.s
    , i.sa
    , i.da
    , i.sh
    , i.sf
    , i.ta
    , i.hra
    , i.bk
    , i.ci
    , i.iw
    , i.wp
    , i.hp
    , i.gf
    , i.dp
    , i.qs
    , i.svo
    , i.bs
    , i.ra
    , i.cg
    , i.sho
    , i.sb
    , i.cs
    , i.hld
    , i.ir
    , i.irs
    , i.wpa
    , i.li
    , i.outs
    , i.war
    , @InnPitch := ((3*ip)+ipf)/3 AS InnPitch
    , IF(@InnPitch=0,0,round((9*i.k)/@InnPitch,1)) AS 'k9'
    , IF(@InnPitch=0,0, round((9*i.bb)/@InnPitch,1)) AS 'bb9'
    , IF(@InnPitch=0,0,round((9*i.hra)/@InnPitch,1)) AS 'HR9'
    , IF(@InnPitch=0,0, round((i.bb+i.ha)/@InnPitch,2)) AS WHIP
    , IF(i.bb=0,0,round(i.k/i.bb,2)) AS 'K/BB'
    , IF(i.fb=0,0,i.gb/i.fb) AS 'gb/fb'
    , IF(i.ab-i.k-i.hra-i.sh+i.sf=0,0,round((i.ha-i.hra)/(i.ab-i.k-i.hra-i.sh+i.sf),3)) AS BABIP
    , IF(@InnPitch=0,0,@ERA := round((i.er/@InnPitch)*9,2)) AS ERA
    , IF(@InnPitch=0,0,@FIP := round(((13*i.hra)+(3*(i.bb+i.hp))-(2*i.k))/@InnPitch+f.FIPConstant,2)) AS FIP
    , IF(@InnPitch=0,0,round(((13*(i.fb*f.hr_fb_pct))+(3*(i.bb+i.hp))-(2*i.k))/@InnPitch+f.FIPConstant,2)) AS xFIP
    , round(100*((@ERA + (@ERA - @ERA*(p.avg)))/slg.slgERA),0) AS ERAminus
    , IF(@ERA=0,0,round(100*(slg.slgERA/@ERA)*p.avg,0)) AS ERAplus
    , round(100*((@FIP + (@FIP - @FIP*(p.avg)))/slg.slgFIP),0) AS FIPminus
    FROM players_career_pitching_stats AS i
    INNER JOIN FIPConstant AS f ON i.year=f.year AND i.league_id=f.league_id
    INNER JOIN sub_league_history_pitching AS slg ON i.year=slg.year AND i.league_id=slg.league_id AND i.sub_league_id=slg.sub_league_id
    INNER JOIN teams AS t ON i.team_id=t.team_id
    INNER JOIN parks AS p ON t.park_id=p.park_id
WHERE i.split_id=2 AND i.league_id<>0 AND i.team_id<>0;

-- Adds INDEX
ALTER TABLE CalcPitching_L
ADD INDEX pit_ix1 (year),
ADD INDEX pit_ix2 (team_id),
ADD INDEX pit_ix3 (player_id);

-- Right split_id=3
DROP TABLE IF EXISTS CalcPitching_R;
CREATE TABLE IF NOT EXISTS CalcPitching_R (pit_id INT AUTO_INCREMENT PRIMARY KEY)
SELECT
    i.player_id
    , i.year
    , i.stint
    , i.team_id
    , i.level_id
    , i.league_id
    , i.sub_league_id
    , i.split_id
    , i.ip
    , i.ab
    , i.tb
    , i.ha
    , i.k
    , i.bf
    , i.rs
    , i.bb
    , i.r
    , i.er
    , i.gb
    , i.fb
    , i.pi
    , i.ipf
    , i.g
    , i.gs
    , i.w
    , i.l
    , i.s
    , i.sa
    , i.da
    , i.sh
    , i.sf
    , i.ta
    , i.hra
    , i.bk
    , i.ci
    , i.iw
    , i.wp
    , i.hp
    , i.gf
    , i.dp
    , i.qs
    , i.svo
    , i.bs
    , i.ra
    , i.cg
    , i.sho
    , i.sb
    , i.cs
    , i.hld
    , i.ir
    , i.irs
    , i.wpa
    , i.li
    , i.outs
    , i.war
    , @InnPitch := ((3*ip)+ipf)/3 AS InnPitch
    , IF(@InnPitch=0,0,round((9*i.k)/@InnPitch,1)) AS 'k9'
    , IF(@InnPitch=0,0, round((9*i.bb)/@InnPitch,1)) AS 'bb9'
    , IF(@InnPitch=0,0,round((9*i.hra)/@InnPitch,1)) AS 'HR9'
    , IF(@InnPitch=0,0, round((i.bb+i.ha)/@InnPitch,2)) AS WHIP
    , IF(i.bb=0,0,round(i.k/i.bb,2)) AS 'K/BB'
    , IF(i.fb=0,0,i.gb/i.fb) AS 'gb/fb'
    , IF(i.ab-i.k-i.hra-i.sh+i.sf=0,0,round((i.ha-i.hra)/(i.ab-i.k-i.hra-i.sh+i.sf),3)) AS BABIP
    , IF(@InnPitch=0,0,@ERA := round((i.er/@InnPitch)*9,2)) AS ERA
    , IF(@InnPitch=0,0,@FIP := round(((13*i.hra)+(3*(i.bb+i.hp))-(2*i.k))/@InnPitch+f.FIPConstant,2)) AS FIP
    , IF(@InnPitch=0,0,round(((13*(i.fb*f.hr_fb_pct))+(3*(i.bb+i.hp))-(2*i.k))/@InnPitch+f.FIPConstant,2)) AS xFIP
    , round(100*((@ERA + (@ERA - @ERA*(p.avg)))/slg.slgERA),0) AS ERAminus
    , IF(@ERA=0,0,round(100*(slg.slgERA/@ERA)*p.avg,0)) AS ERAplus
    , round(100*((@FIP + (@FIP - @FIP*(p.avg)))/slg.slgFIP),0) AS FIPminus
    FROM players_career_pitching_stats AS i
    INNER JOIN FIPConstant AS f ON i.year=f.year AND i.league_id=f.league_id
    INNER JOIN sub_league_history_pitching AS slg ON i.year=slg.year AND i.league_id=slg.league_id AND i.sub_league_id=slg.sub_league_id
    INNER JOIN teams AS t ON i.team_id=t.team_id
    INNER JOIN parks AS p ON t.park_id=p.park_id
WHERE i.split_id=3 AND i.league_id<>0 AND i.team_id<>0;

-- Adds INDEX
ALTER TABLE CalcPitching_R
ADD INDEX pit_ix1 (year),
ADD INDEX pit_ix2 (team_id),
ADD INDEX pit_ix3 (player_id);