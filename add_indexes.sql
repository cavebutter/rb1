-- add indexes to ootp tables

ALTER TABLE `sub_leagues` DROP PRIMARY KEY;
ALTER TABLE `sub_leagues` ADD PRIMARY KEY (`league_id`, `sub_league_id`);

ALTER TABLE `teams` ADD INDEX `teams_ix1` (`park_id`);
ALTER TABLE `teams` ADD INDEX `teams_ix2` (`league_id`);
ALTER TABLE `teams` ADD INDEX `teams_ix3` (`sub_league_id`);
ALTER TABLE `teams` ADD INDEX `teams_ix4` (`division_id`);

ALTER TABLE `players` ADD INDEX `players_ix1` (`team_id`);
ALTER TABLE `players` ADD INDEX `players_ix2` (`league_id`);

ALTER TABLE `players_career_batting_stats` ADD INDEX `pcbs_ix1` (`league_id`);

ALTER TABLE `players_career_fielding_stats` ADD INDEX `pcfs_ix1` (`league_id`);

ALTER TABLE `games` ADD INDEX `gix1` (`home_team`);
ALTER TABLE `games` ADD INDEX `gix2` (`away_team`);

ALTER TABLE `coaches` ADD INDEX `c_ix1` (`team_id`);
ALTER TABLE `coaches` ADD INDEX `c_ix2` (`former_player_id`);
ALTER TABLE `coaches` ADD INDEX `c_ix3` (`occupation`);

-- create additional tables
DROP TABLE IF EXISTS `mgr_occupation`;
CREATE TABLE IF NOT EXISTS `mgr_occupation` (
    `occupation` TINYINT NOT NULL PRIMARY KEY
    , `occupation_name` VARCHAR (50)
    );

INSERT INTO `mgr_occupation` VALUES (1, 'GM'), (2, 'Mgr'), (3, 'BC'), (4, 'PC'), (5, 'HC'), (6, 'Scout'), (12, 'Trainer'), (13, 'Owner');

DROP TABLE IF EXISTS `mgr_personality`;
CREATE TABLE IF NOT EXISTS `mgr_personality` (
    `personality` TINYINT NOT NULL PRIMARY KEY,
    `personality_name` VARCHAR (30)
    );

INSERT INTO `mgr_personality` VALUES (0, 'Personable'), (1, 'Easy Going'), (2, 'Normal'), (3, 'Tempermental'), (4, 'Controlling');

DROP TABLE IF EXISTS `management_style`;
CREATE TABLE IF NOT EXISTS `management_style` (
    `management_style` INT NOT NULL PRIMARY KEY
    , `management_style_name` VARCHAR (30)
    );

INSERT INTO `management_style` VALUES (0, '-'), (1, 'Conventional'), (2, 'Sabermetric'), (3, 'Smallball'), (4, 'Unorthodox'), (5, 'Tactician');

DROP TABLE IF EXISTS `hitting_focus`;
CREATE TABLE IF NOT EXISTS `hitting_focus` (
    `hitting_focus` INT NOT NULL PRIMARY KEY
    , `hitting_focus_name` VARCHAR (30)
    );

INSERT INTO `hitting_focus` VALUES (0, 'Contact'), (1, 'Power'), (2, 'Patience'), (3, 'Neutral');

DROP TABLE IF EXISTS `pitching_focus`;
CREATE TABLE IF NOT EXISTS `pitching_focus` (
    `pitching_focus` INT NOT NULL PRIMARY KEY
    , `pitching_focus_name` VARCHAR (30)
    );

INSERT INTO `pitching_focus` VALUES (0, 'Power'), (1, 'Finesse'), (2, 'Groundball'), (3, 'Neutral');

ALTER TABLE players_game_batting ADD INDEX `pgb_ix_1` (`team_id`);
ALTER TABLE players_game_batting ADD INDEX `pgb_ix_2` (`year`);
ALTER TABLE players_game_batting ADD INDEX `pgb_ix_3` (`player_id`);


-- Create positions table
DROP TABLE IF EXISTS positions;
CREATE TABLE IF NOT EXISTS positions
   (
     position   TINYINT,
     pos_name   VARCHAR (10),
     PRIMARY KEY (position)
    );

   INSERT INTO positions VALUES (1,'P'),  (2,'C'), (3,'1B'), (4,'2B'), (5,'3B'), (6,'SS'), (7,'LF'), (8,'CF'), (9,'RF'), (10,'DH')
   ;

DROP TABLE IF EXISTS players_league_leader_map;
CREATE TABLE IF NOT EXISTS players_league_leader_map
    (
        category    INT,
        b_p         VARCHAR (1),
        stat_short  VARCHAR (10),
        stat_long   VARCHAR (30)
        PRIMARY KEY (category)
    );
INSERT INTO players_league_leader_map VALUES
    (2,'B','AB', 'At Bats')
    , (3, 'B', 'H', 'Hits')
    , (4,'B','K','Strike Outs')
    , (5,'B','TB','Total Bases')
    , (6,'B','2B','Doubles')
    , (7,'B','3B','Triples')
    , (8,'B','HR', 'Home Runs')
    , (9,'B','SB', 'Stolen Bases')
    , (10,'B','RBI','Runs Batted In')
    , (11,'B','R','Runs')
    , (12,'B','BB','Walks')
    , (13,'B','IBB','Intentional Walks')
    , (14,'B','HBP','Hit By Pitch')
    , (15,'B','SH','Sacrifice Hits')
    , (16,'B','SF','Sacrifice Flies')
    , (18,'B','AVG','Batting Average')
    , (19,'B','OBP','On Base Percentage')
    , (20,'B','SLG','Slugging Percentage')
    , (22,'B','RC/27','Runs Created / 27 Outs')
    , (23,'B','ISO','Isolated Power')
    , (25,'B','OPS','On Base Plus Slugging')
    , (26, 'B','wRC+','wRC+')
    , (27,'P','G','Games')
    , (28,'P','GS','Games Started')
    , (30,'P','L'.'Losses')
    , (31,'P','W%','Win Percentage')
    , (32,'P','SV','Saves')
    , (34,'P','IP','Innings Pitched')
    , (36, 'P','HR','Home Runs Allowed')
    , (37,'P','BB','Walks')
    , (38,'P','K','Strikeouts')
    , (40,'P','ERA','Earned Run Average')
    , (41,'P','BABIP','Batting Average on Balls in Play')
    , (42,'P','WHIP','Walks and Hits per Inning Pitched')
    , (43,'P','K/BB','K/BB')
    , (46,'P','H9','Hits per 9 Innings')
    , (47,'P','BB9','Walks per 9 Innings')
    , (48, 'P','K9','Strikeouts per 9 Innings')
    , (49,'P','W','Wins')
    , (54,'P','CG','Complete Games')
    , (56,'P','SHO','Shutouts')
    , (58,'B','WAR', 'Wins Above Replacement')
    , (59,'P','WAR', 'Wins Above Replacement');
