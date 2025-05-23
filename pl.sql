DELIMITER //

CREATE PROCEDURE ResetDatabase()
BEGIN
    DROP TABLE IF EXISTS RosteredPlayers;
    DROP TABLE IF EXISTS WaiverTransactions;
    DROP TABLE IF EXISTS GamePlayed;
    DROP TABLE IF EXISTS NBAGames;
    DROP TABLE IF EXISTS NBAPlayers;
    DROP TABLE IF EXISTS FantasyTeams;
    DROP TABLE IF EXISTS FantasyLeagues;
    DROP TABLE IF EXISTS FantasyManagers;

    CREATE TABLE FantasyManagers (
        managerID INT AUTO_INCREMENT PRIMARY KEY,
        name VARCHAR(45) NOT NULL,
        leaguesWon INT NOT NULL
    );

    CREATE TABLE FantasyLeagues (
        leagueID INT AUTO_INCREMENT PRIMARY KEY,
        name VARCHAR(45) NOT NULL
    );

    CREATE TABLE FantasyTeams (
        teamID INT AUTO_INCREMENT PRIMARY KEY,
        name VARCHAR(45) NOT NULL,
        wins INT NOT NULL,
        losses INT NOT NULL,
        leagueID INT NOT NULL,
        managerID INT NOT NULL,
        FOREIGN KEY (leagueID) REFERENCES FantasyLeagues(leagueID) ON DELETE CASCADE,
        FOREIGN KEY (managerID) REFERENCES FantasyManagers(managerID) ON DELETE CASCADE
    );

    CREATE TABLE NBAPlayers (
        playerID INT AUTO_INCREMENT PRIMARY KEY,
        name VARCHAR(45) NOT NULL,
        points INT,
        threes INT,
        assists INT,
        blocks INT,
        steals INT,
        fgm INT,
        fga INT,
        ftm INT,
        fta INT,
        rebounds INT,
        turnovers INT,
        gamesPlayed INT,
        nbaTeam VARCHAR(45),
        position VARCHAR(13)
    );

    CREATE TABLE NBAGames (
        gameID INT AUTO_INCREMENT PRIMARY KEY,
        date DATETIME NOT NULL,
        homeTeam VARCHAR(3),
        awayTeam VARCHAR(3)
    );

    CREATE TABLE GamePlayed (
        id INT AUTO_INCREMENT PRIMARY KEY,
        gameID INT NOT NULL,
        playerID INT NOT NULL,
        points INT,
        threes INT,
        assists INT,
        blocks INT,
        steals INT,
        fgm INT,
        fga INT,
        ftm INT,
        fta INT,
        rebounds INT,
        turnovers INT,
        FOREIGN KEY (gameID) REFERENCES NBAGames(gameID) ON DELETE CASCADE,
        FOREIGN KEY (playerID) REFERENCES NBAPlayers(playerID) ON DELETE CASCADE
    );

    CREATE TABLE WaiverTransactions (
        transactionID INT AUTO_INCREMENT PRIMARY KEY,
        teamID INT NOT NULL,
        playerID INT NOT NULL,
        transactionType VARCHAR(8) NOT NULL,
        transactionDate DATETIME NOT NULL,
        FOREIGN KEY (teamID) REFERENCES FantasyTeams(teamID) ON DELETE CASCADE,
        FOREIGN KEY (playerID) REFERENCES NBAPlayers(playerID) ON DELETE CASCADE
    );

    CREATE TABLE RosteredPlayers (
        id INT AUTO_INCREMENT PRIMARY KEY,
        teamID INT NOT NULL,
        playerID INT NOT NULL,
        dateAdded DATETIME NOT NULL,
        isStarter BOOLEAN DEFAULT FALSE,
        FOREIGN KEY (teamID) REFERENCES FantasyTeams(teamID) ON DELETE CASCADE,
        FOREIGN KEY (playerID) REFERENCES NBAPlayers(playerID) ON DELETE CASCADE
    );

    -- Insert sample data
    INSERT INTO FantasyManagers (name, leaguesWon) VALUES
    ('John Smith', 2),
    ('Sarah Johnson', 1),
    ('Mike Williams', 0);

    INSERT INTO FantasyLeagues (name) VALUES
    ('Premier League'),
    ('Champions League'),
    ('Europa League');

    INSERT INTO FantasyTeams (name, wins, losses, leagueID, managerID) VALUES
    ('Thunder', 10, 2, 1, 1),
    ('Lakers', 8, 4, 1, 2),
    ('Celtics', 7, 5, 2, 3);

    INSERT INTO NBAPlayers (name, points, threes, assists, blocks, steals, fgm, fga, ftm, fta, rebounds, turnovers, gamesPlayed, nbaTeam, position) VALUES
    ('LeBron James', 25, 2, 7, 1, 1, 9, 18, 5, 7, 7, 3, 20, 'LAL', 'SF'),
    ('Stephen Curry', 30, 5, 6, 0, 1, 10, 20, 5, 5, 5, 2, 20, 'GSW', 'PG'),
    ('Giannis Antetokounmpo', 28, 1, 5, 2, 1, 10, 18, 8, 10, 12, 4, 20, 'MIL', 'PF');

    INSERT INTO NBAGames (date, homeTeam, awayTeam) VALUES
    ('2024-03-15 19:30:00', 'LAL', 'GSW'),
    ('2024-03-16 20:00:00', 'MIL', 'BOS'),
    ('2024-03-17 18:00:00', 'LAL', 'MIL');

    INSERT INTO GamePlayed (gameID, playerID, points, threes, assists, blocks, steals, fgm, fga, ftm, fta, rebounds, turnovers) VALUES
    (1, 1, 28, 3, 8, 1, 2, 10, 20, 5, 6, 8, 3),
    (2, 3, 32, 1, 6, 3, 1, 12, 22, 7, 9, 14, 4),
    (3, 2, 35, 7, 5, 0, 2, 12, 25, 4, 4, 6, 2);

    INSERT INTO WaiverTransactions (teamID, playerID, transactionType, transactionDate) VALUES
    (1, 1, 'ADD', '2024-03-01 10:00:00'),
    (2, 2, 'DROP', '2024-03-02 11:00:00'),
    (3, 3, 'ADD', '2024-03-03 12:00:00');

    INSERT INTO RosteredPlayers (teamID, playerID, dateAdded, isStarter) VALUES
    (1, 1, '2024-03-01 10:00:00', TRUE),
    (2, 2, '2024-03-02 11:00:00', TRUE),
    (3, 3, '2024-03-03 12:00:00', TRUE);
END //

DELIMITER ; 