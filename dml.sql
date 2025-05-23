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
SELECT t.teamID, t.name AS name, t.wins, t.losses, t.leagueID, l.name AS leagueName, t.managerID, m.name AS managerName
  FROM FantasyTeams t
  JOIN FantasyLeagues l ON t.leagueID = l.leagueID
  JOIN FantasyManagers m ON t.managerID = m.managerID;
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
SELECT gp.id, gp.gameID, p.name AS playerName, gp.points, gp.threes, gp.assists, gp.blocks,
    gp.steals, gp.fgm, gp.fga, gp.ftm, gp.fta, gp.rebounds, gp.turnovers
  FROM GamePlayed gp
  JOIN NBAPlayers p ON gp.playerID = p.playerID;
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
SELECT r.id, r.teamID, r.playerID, r.dateAdded, r.isStarter, p.name AS playerName, t.name AS teamName
  FROM RosteredPlayers r
  JOIN NBAPlayers p ON r.playerID = p.playerID
  JOIN FantasyTeams t ON r.teamID = t.teamID;
INSERT INTO RosteredPlayers (teamID, playerID, dateAdded, isStarter) VALUES (:teamID, :playerID, :dateAdded, :isStarter);
UPDATE RosteredPlayers SET isStarter = :isStarter WHERE id = :id;
DELETE FROM RosteredPlayers WHERE id = :id;
