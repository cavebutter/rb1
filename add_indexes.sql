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
ALTER TABLE `coahces` ADD INDEX `c_ix2` (`former_player_id`);
ALTER TABLE `coahces` ADD INDEX `c_ix3` (`occupation`);

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

ALTER TABLE players_games_batting ADD INDEX 'pgb_ix_1' ('team_id');
ALTER TABLE players_games_batting ADD INDEX 'pgb_ix_2' ('year');
ALTER TABLE players_games_batting ADD INDEX 'pgb_ix_3' ('player_id');



