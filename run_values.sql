-- creates the following tables:
--   # LeagueRunsPerOut
--    # RunValues
--    # RunValues1A
--    # RunValues2
--    # FIPConstant
--    # Subleague History Batting and Pitching
--    # Positions
--
--    # inserted a row into `teams` for Free Agents.  This makes it easier to find FA's through queries
--    # `players_career_batting` and `players_career_pitching` are updated to include a player's subleague in that table.  Makes stats calcs easier

INSERT INTO teams (team_id, name, nickname, abbr, league_id, level) VALUES (0,'Free Agent',NULL, 'FA', 100,1);
-- UPDATE parent_id for ML teams to be their own parents
UPDATE teams
SET parent_team_id=team_id
WHERE level=1;

-- Add subleague to players_career_batting_stats
ALTER TABLE players_career_batting_stats
ADD sub_league_id INT;

-- Populate sub_league column in players_career_batting_stats
UPDATE players_career_batting_stats AS b
INNER JOIN team_relations AS t ON b.league_id=t.league_id AND b.team_id=t.team_id
SET b.sub_league_id=t.sub_league_id;

-- Add subleague to players_career_pitching_stats
ALTER TABLE players_career_pitching_stats
ADD sub_league_id INT;

-- Same thing for players_career_pitching_stats

UPDATE players_career_pitching_stats AS b
INNER JOIN team_relations AS t ON b.league_id=t.league_id AND b.team_id=t.team_id
SET b.sub_league_id=t.sub_league_id;

-- Create LeagueRunsPerOut
DROP TABLE IF EXISTS LeagueRunsPerOut;
CREATE TABLE IF NOT EXISTS LeagueRunsPerOut AS
SELECT p.year
, p.league_id
, p.sub_league_id
, sum(p.r) AS "totR"
, sum(p.outs) AS "totOuts"
, sum(p.outs)+sum(p.ha)+sum(p.bb)+ sum(p.iw)+ sum(p.sh)
   + sum(p.sf) AS "totPA"
, IF(sum(p.outs)=0,sum(p.r),SUM(p.r)/sum(p.outs)) AS "RperOut"
, IF(sum(p.outs)+sum(p.ha)+sum(p.bb)+ sum(p.iw)+ sum(p.sh)
   + sum(p.sf)=0,sum(p.r), round(sum(p.r)/(sum(p.outs)+sum(p.ha)+sum(p.bb)+ sum(p.iw)+ sum(p.sh)
   + sum(p.sf)),8)) AS "RperPA"
FROM players_career_pitching_stats AS p
GROUP BY p.year, p.league_id, p.sub_league_id;

-- Create RunValues table
DROP TABLE IF EXISTS tblRunValues;
CREATE TABLE IF NOT EXISTS tblRunValues
AS SELECT year
, league_id
, sub_league_id
, RperOut
, @rb := round(RperOut+0.14,4) AS runBB
, round(@rb+0.025,4) AS runHB
, @rs := round(@rb+0.155,4) AS run1B
, @rd := round(@rs+0.3,4) AS run2B
, round(@rd+0.27,4) AS run3B
, 1.4 AS runHR
, 0.2 AS runSB
, 2*RperOut+0.075 AS runCS
FROM LeagueRunsPerOut;


-- Create RunValues1A table
-- Creating an intermediate table so AS not to have to write out formulae for rumMinus etc.
DROP TABLE IF EXISTS tblRunValues1A;
CREATE TABLE IF NOT EXISTS tblRunValues1A AS
SELECT r.year
, r.league_id
, r.sub_league_id
, r.RperOut
, r.runBB
, r.runHB
, r.run1B
, r.run2B
, r.run3B
, r.runHR
, r.runSB
, r.runCS
, SUM(runBB*(BB-IBB) + runHB * HP + run1B * s + run2B * d
   + run3B * t + 1.4 * HR + runSB * SB - runCS * CS)
   / SUM(AB - H + SF) AS runMinus

, SUM(runBB * (BB-IBB) + runHB * HP + run1B * s + run2B * d
   + run3B * t + 1.4 * HR + runSB * SB - runCS * CS)
   / SUM(BB-IBB + HP + H) AS runPlus

, SUM(H+BB-IBB+HP) / SUM(AB+BB-IBB+HP+SF) AS wOBA

FROM tblRunValues r
INNER JOIN (
      SELECT year
           , league_id
           , sub_league_id
           , sum(ab) AS ab
           , sum(bb) AS BB
           , sum(ibb) AS IBB
           , sum(hp) AS HP
           , sum(h) AS h
           , sum(h)-sum(d)-sum(t)-sum(hr) AS s
           , sum(d) AS d
           , sum(t) AS t
           , sum(hr) AS hr
           , sum(sb) AS SB
           , sum(cs) AS CS
           , sum(sf) AS SF
       FROM players_career_batting_stats
       GROUP BY year, league_id, sub_league_id
           ) AS x ON r.year=x.year AND r.league_id=x.league_id AND r.sub_league_id=x.sub_league_id

GROUP BY
r.year
, r.league_id
, r.sub_league_id
, r.RperOut
, r.runBB
, r.runHB
, r.run1B
, r.run2B
, r.run3B
, r.runHR
, r.runSB
, r.runCS

ORDER BY
r.year DESC;

-- Create RunValues2 table
-- The lASt Run Values table, returning fields from RunValues1A, defining wOBAScale
-- AS a variable, and giving us the weighted factors by league year for batting events

DROP TABLE IF EXISTS tblRunValues2;
CREATE TABLE tblRunValues2 AS
SELECT year
, league_id
, sub_league_id
, RperOut
, runBB
, runHB
, run1B
, run2B
, run3B
, runHR
, runSB
, runCS
, runMinus
, runPlus
, wOBA
, @ws := 1/(runPlus+runMinus) AS wOBAScale
, (runBB+runMinus)*@ws AS wobaBB
, (runHB+runMinus)*@ws AS wobaHB
, (run1B+runMinus)*@ws AS woba1B
, (run2B+runMinus)*@ws AS woba2B
, (run3B+runMinus)*@ws AS woba3B
, (runHR+runMinus)*@ws AS wobaHR
, runSB*@ws AS wobASB
, runCS*@ws AS wobaCS
FROM tblRunValues1A;

-- Create FIPConstant
DROP TABLE IF EXISTS FIPConstant;
CREATE TABLE IF NOT EXISTS FIPConstant AS

SELECT
      year
    , league_id
    , hra_totals/fb_totals AS hr_fb_pct
    , @HRAdj := 13*hra_totals AS Adjusted_HR
    , @BBAdj := 3*bb_totals AS Adjusted_BB
    , @HPAdj := 3*hp_totals AS Adjusted_HP
    , @KAdj  := 2*k_totals AS Adjusted_K
    , @InnPitch := ((ip_totals*3)+ipf_totals)/3 AS InnPitch
    , @lgERA := round((er_totals/@InnPitch)*9,2) AS lgERA
    , round(@lgERA - ((@HRAdj+@BBAdj+@HPAdj-@KAdj)/@InnPitch),2) AS FIPConstant
FROM (
         SELECT year
                , league_id
                , sum(hra) AS hra_totals
                , sum(bb) AS bb_totals
                , sum(hp) AS hp_totals
                , sum(k) AS k_totals
                , sum(er) AS er_totals
                , sum(ip) AS ip_totals
                , sum(ipf) AS ipf_totals
                , sum(fb) AS fb_totals
          FROM players_career_pitching_stats
          WHERE league_id<>0
          GROUP BY year, league_id
      ) AS x;

-- Create sub_league_history_batting
DROP TABLE IF EXISTS sub_league_history_batting;
CREATE TABLE IF NOT EXISTS sub_league_history_batting AS

SELECT
       year
     , league_id
     , sub_league_id
     , slg_PA
     , slg_r

     FROM  (
     SELECT p.year
          , p.league_id
          , p.sub_league_id
          , sum(pa) AS slg_PA
          , sum(r) AS slg_r
     FROM players_career_batting_stats AS p INNER JOIN players ON p.player_id=players.player_id
     WHERE p.split_id=1 AND players.position<>1
     GROUP BY year, league_id, sub_league_id
      ) AS x ;

-- Create sub_league_history_pitching
DROP TABLE IF EXISTS sub_league_history_pitching;
CREATE TABLE IF NOT EXISTS sub_league_history_pitching AS

SELECT
       x.year
     , x.league_id
     , x.sub_league_id
     , IF(x.totIP=0,x.totER*9,round((x.totER/x.totIP)*9,2)) AS slgERA
     , IF(x.totIP=0,x.adjHRA + x.adjBB + x.adjHP - x.adjK, round((x.adjHRA + x.adjBB + x.adjHP - x.adjK)/x.totIP+f.FIPConstant,2)) AS slgFIP

FROM  (
     SELECT p.year
          , p.league_id
          , p.sub_league_id
          , ((sum(ip)*3)+sum(ipf))/3 AS totIP
          , sum(er) AS totER
          , 13*sum(hra) AS adjHRA
          , 3*sum(bb) AS adjBB
          , 3*sum(hp) AS adjHP
          , 2*sum(k) AS adjK
      FROM players_career_pitching_stats AS p
      WHERE p.league_id<>0
     GROUP BY year, league_id, sub_league_id
      ) AS x
        INNER JOIN FIPConstant AS f ON x.year=f.year AND x.league_id=f.league_id;

