-- DML for FFBD (placeholders use :var)

-- FantasyManagers
SELECT managerID, name, leaguesWon FROM FantasyManagers;
INSERT INTO FantasyManagers (name, leaguesWon) VALUES (:name, :leaguesWon);
UPDATE FantasyManagers SET leaguesWon = :leaguesWon WHERE managerID = :managerID;
DELETE FROM FantasyManagers WHERE managerID = :managerID;

-- FantasyLeagues
SELECT leagueID, name FROM FantasyLeagues;
INSERT INTO FantasyLeagues (name) VALUES (:name);
UPDATE FantasyLeagues SET name = :name WHERE leagueID = :leagueID;
DELETE FROM FantasyLeagues WHERE leagueID = :leagueID;

-- FantasyTeams
SELECT teamID, name, wins, losses, leagueID, managerID FROM FantasyTeams;
INSERT INTO FantasyTeams (name, wins, losses, leagueID, managerID) VALUES (:name, :wins, :losses, :leagueID, :managerID);
UPDATE FantasyTeams SET wins = :wins, losses = :losses WHERE teamID = :teamID;
DELETE FROM FantasyTeams WHERE teamID = :teamID;

-- NBAPlayers
SELECT playerID, name, points, threes, assists, blocks, steals, fgm, fga, ftm, fta, rebounds, turnovers, gamesPlayed, nbaTeam, position FROM NBAPlayers;
INSERT INTO NBAPlayers (name, points, threes, assists, blocks, steals, fgm, fga, ftm, fta, rebounds, turnovers, gamesPlayed, nbaTeam, position)
VALUES (:name,:points,:threes,:assists,:blocks,:steals,:fgm,:fga,:ftm,:fta,:rebounds,:turnovers,:gamesPlayed,:nbaTeam,:position);
UPDATE NBAPlayers SET points=:points, threes=:threes, assists=:assists WHERE playerID=:playerID;
DELETE FROM NBAPlayers WHERE playerID = :playerID;

-- NBAGames
SELECT gameID, date, homeTeam, awayTeam FROM NBAGames;
INSERT INTO NBAGames (date, homeTeam, awayTeam) VALUES (:date, :homeTeam, :awayTeam);
UPDATE NBAGames SET date = :date WHERE gameID = :gameID;
DELETE FROM NBAGames WHERE gameID = :gameID;

-- GamePlayed
SELECT id, gameID, playerID, points, threes, assists, blocks, steals, fgm, fga, ftm, fta, rebounds, turnovers FROM GamePlayed;
INSERT INTO GamePlayed (gameID, playerID, points, threes, assists, blocks, steals, fgm, fga, ftm, fta, rebounds, turnovers)
VALUES (:gameID, :playerID, :points, :threes, :assists, :blocks, :steals, :fgm, :fga, :ftm, :fta, :rebounds, :turnovers);
UPDATE GamePlayed SET points=:points, threes=:threes WHERE id=:id;
DELETE FROM GamePlayed WHERE id = :id;

-- WaiverTransactions
SELECT transactionID, teamID, playerID, transactionType, transactionDate FROM WaiverTransactions;
INSERT INTO WaiverTransactions (teamID, playerID, transactionType, transactionDate) VALUES (:teamID, :playerID, :transactionType, :transactionDate);
UPDATE WaiverTransactions SET transactionType = :transactionType WHERE transactionID = :transactionID;
DELETE FROM WaiverTransactions WHERE transactionID = :transactionID;

-- RosteredPlayers
SELECT id, teamID, playerID, dateAdded, isStarter FROM RosteredPlayers;
INSERT INTO RosteredPlayers (teamID, playerID, dateAdded, isStarter) VALUES (:teamID, :playerID, :dateAdded, :isStarter);
UPDATE RosteredPlayers SET isStarter = :isStarter WHERE id = :id;
DELETE FROM RosteredPlayers WHERE id = :id;