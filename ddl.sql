-- DDL for FFBD
-- Code to create procedure adapted from sp_moviedb.sql in Assignment 4 draft submission page
DROP PROCEDURE IF EXISTS sp_load_fantasydb;
DELIMITER //
CREATE PROCEDURE sp_load_fantasydb()
BEGIN
  SET FOREIGN_KEY_CHECKS=0;
  
  DROP TABLE IF EXISTS `RosteredPlayers`;
  DROP TABLE IF EXISTS `WaiverTransactions`;
  DROP TABLE IF EXISTS `GamePlayed`;
  DROP TABLE IF EXISTS `NBAGames`;
  DROP TABLE IF EXISTS `NBAPlayers`;
  DROP TABLE IF EXISTS `FantasyTeams`;
  DROP TABLE IF EXISTS `FantasyLeagues`;
  DROP TABLE IF EXISTS `FantasyManagers`;
  
  CREATE TABLE `FantasyManagers` (
    `managerID` INT AUTO_INCREMENT PRIMARY KEY,
    `name` VARCHAR(45) NOT NULL,
    `leaguesWon` INT NOT NULL
  );
  
  CREATE TABLE `FantasyLeagues` (
    `leagueID` INT AUTO_INCREMENT PRIMARY KEY,
    `name` VARCHAR(45) NOT NULL
  );
  
  CREATE TABLE `FantasyTeams` (
    `teamID` INT AUTO_INCREMENT PRIMARY KEY,
    `name` VARCHAR(45) NOT NULL,
    `wins` INT NOT NULL,
    `losses` INT NOT NULL,
    `leagueID` INT NOT NULL,
    `managerID` INT NOT NULL,
    FOREIGN KEY (`leagueID`) REFERENCES FantasyLeagues(`leagueID`) ON DELETE CASCADE,
    FOREIGN KEY (`managerID`) REFERENCES FantasyManagers(`managerID`) ON DELETE CASCADE
  );
  
  CREATE TABLE `NBAPlayers` (
    `playerID` INT AUTO_INCREMENT PRIMARY KEY,
    `name` VARCHAR(45) NOT NULL,
    `points` INT,
    `threes` INT,
    `assists` INT,
    `blocks` INT,
    `steals` INT,
    `fgm` INT,
    `fga` INT,
    `ftm` INT,
    `fta` INT,
    `rebounds` INT,
    `turnovers` INT,
    `gamesPlayed` INT,
    `nbaTeam` VARCHAR(45),
    `position` VARCHAR(13)
  );
  
  CREATE TABLE `NBAGames` (
    `gameID` INT AUTO_INCREMENT PRIMARY KEY,
    `date` DATETIME NOT NULL,
    `homeTeam` VARCHAR(3),
    `awayTeam` VARCHAR(3)
  );
  
  CREATE TABLE `GamePlayed` (
    `id` INT AUTO_INCREMENT PRIMARY KEY,
    `gameID` INT NOT NULL,
    `playerID` INT NOT NULL,
    `points` INT,
    `threes` INT,
    `assists` INT,
    `blocks` INT,
    `steals` INT,
    `fgm` INT,
    `fga` INT,
    `ftm` INT,
    `fta` INT,
    `rebounds` INT,
    `turnovers` INT,
    FOREIGN KEY (`gameID`) REFERENCES `NBAGames`(`gameID`) ON DELETE CASCADE,
    FOREIGN KEY (`playerID`) REFERENCES `NBAPlayers`(`playerID`) ON DELETE CASCADE
  );
  
  CREATE TABLE `WaiverTransactions` (
    `transactionID` INT AUTO_INCREMENT PRIMARY KEY,
    `teamID` INT NOT NULL,
    `playerID` INT NOT NULL,
    `transactionType` VARCHAR(8) NOT NULL,
    `transactionDate` DATETIME NOT NULL,
    FOREIGN KEY (`teamID`) REFERENCES `FantasyTeams`(`teamID`) ON DELETE CASCADE,
    FOREIGN KEY (`playerID`) REFERENCES `NBAPlayers`(`playerID`) ON DELETE CASCADE
  );
  
  CREATE TABLE `RosteredPlayers` (
    `id` INT AUTO_INCREMENT PRIMARY KEY,
    `teamID` INT NOT NULL,
    `playerID` INT NOT NULL,
    `dateAdded` DATETIME NOT NULL,
    `isStarter` BOOLEAN DEFAULT FALSE,
    FOREIGN KEY (`teamID`) REFERENCES `FantasyTeams`(`teamID`) ON DELETE CASCADE,
    FOREIGN KEY (`playerID`) REFERENCES `NBAPlayers`(`playerID`) ON DELETE CASCADE
  );

  SET FOREIGN_KEY_CHECKS=0;
END//
DELIMITER ;
