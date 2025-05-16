const express = require('express');
const { engine } = require('express-handlebars');
const db = require('./db-connector');

const app = express();            
const PORT = 9192;                 

app.engine('hbs', engine({ extname: '.hbs', defaultLayout: 'main' }));
app.set('view engine', 'hbs');
app.use(express.static('public'));
app.use(express.urlencoded({ extended: true }));

app.get('/', (req, res) => {
  res.render('index', { title: 'Home' });
});

// FantasyManagers
app.get('/managers', async (req, res) => {
  try {
    const [rows] = await db.query(
      'SELECT managerID, name, leaguesWon FROM FantasyManagers;'
    );
    res.render('fantasyManagers', { title: 'Managers', managers: rows });
  } catch (err) {
    console.error(err);
    res.status(500).send('Error loading managers');
  }
});
app.post('/managers/add', async (req, res) => {
  try {
    const { name, leaguesWon } = req.body;
    await db.query(
      'INSERT INTO FantasyManagers (name, leaguesWon) VALUES (?, ?)',
      [name, leaguesWon]
    );
    res.redirect('/managers');
  } catch (err) {
    console.error(err);
    res.status(500).send('Error adding manager');
  }
});
app.post('/managers/update', async (req, res) => {
  try {
    const { managerID, leaguesWon } = req.body;
    await db.query(
      'UPDATE FantasyManagers SET leaguesWon = ? WHERE managerID = ?',
      [leaguesWon, managerID]
    );
    res.redirect('/managers');
  } catch (err) {
    console.error(err);
    res.status(500).send('Error updating manager');
  }
});
app.post('/managers/delete', async (req, res) => {
  try {
    const { managerID } = req.body;
    await db.query(
      'DELETE FROM FantasyManagers WHERE managerID = ?',
      [managerID]
    );
    res.redirect('/managers');
  } catch (err) {
    console.error(err);
    res.status(500).send('Error deleting manager');
  }
});

// FantasyLeagues
app.get('/leagues', async (req, res) => {
  try {
    const [rows] = await db.query(
      'SELECT leagueID, name FROM FantasyLeagues;'
    );
    res.render('fantasyLeagues', { title: 'Leagues', leagues: rows });
  } catch (err) {
    console.error(err);
    res.status(500).send('Error loading leagues');
  }
});
app.post('/leagues/add', async (req, res) => {
  try {
    const { name } = req.body;
    await db.query(
      'INSERT INTO FantasyLeagues (name) VALUES (?)',
      [name]
    );
    res.redirect('/leagues');
  } catch (err) {
    console.error(err);
    res.status(500).send('Error adding league');
  }
});
app.post('/leagues/update', async (req, res) => {
  try {
    const { leagueID, name } = req.body;
    await db.query(
      'UPDATE FantasyLeagues SET name = ? WHERE leagueID = ?',
      [name, leagueID]
    );
    res.redirect('/leagues');
  } catch (err) {
    console.error(err);
    res.status(500).send('Error updating league');
  }
});
app.post('/leagues/delete', async (req, res) => {
  try {
    const { leagueID } = req.body;
    await db.query(
      'DELETE FROM FantasyLeagues WHERE leagueID = ?',
      [leagueID]
    );
    res.redirect('/leagues');
  } catch (err) {
    console.error(err);
    res.status(500).send('Error deleting league');
  }
});

// FantasyTeams
app.get('/teams', async (req, res) => {
    try {
      const [teams] = await db.query(`
        SELECT
          t.teamID,
          t.name        AS name,
          t.wins,
          t.losses,
          t.leagueID,
          l.name        AS leagueName,
          t.managerID,
          m.name        AS managerName
        FROM FantasyTeams t
        JOIN FantasyLeagues l ON t.leagueID = l.leagueID
        JOIN FantasyManagers m ON t.managerID = m.managerID;
      `);
  
      const [leagues]  = await db.query('SELECT leagueID, name FROM FantasyLeagues;');
      const [managers] = await db.query('SELECT managerID, name FROM FantasyManagers;');
  
      res.render('fantasyTeams', {
        title:    'Teams',
        teams,
        leagues,
        managers
      });
    } catch (err) {
      console.error(err);
      res.status(500).send('Error loading teams');
    }
  });
  
app.post('/teams/add', async (req, res) => {
  try {
    const { name, wins, losses, leagueID, managerID } = req.body;
    await db.query(
      'INSERT INTO FantasyTeams (name, wins, losses, leagueID, managerID) VALUES (?, ?, ?, ?, ?)',
      [name, wins, losses, leagueID, managerID]
    );
    res.redirect('/teams');
  } catch (err) {
    console.error(err);
    res.status(500).send('Error adding team');
  }
});
app.post('/teams/update', async (req, res) => {
  try {
    const { teamID, wins, losses } = req.body;
    await db.query(
      'UPDATE FantasyTeams SET wins = ?, losses = ? WHERE teamID = ?',
      [wins, losses, teamID]
    );
    res.redirect('/teams');
  } catch (err) {
    console.error(err);
    res.status(500).send('Error updating team');
  }
});
app.post('/teams/delete', async (req, res) => {
  try {
    const { teamID } = req.body;
    await db.query(
      'DELETE FROM FantasyTeams WHERE teamID = ?',
      [teamID]
    );
    res.redirect('/teams');
  } catch (err) {
    console.error(err);
    res.status(500).send('Error deleting team');
  }
});

// NBAPlayers
app.get('/players', async (req, res) => {
  try {
    const [rows] = await db.query(
      'SELECT playerID, name, points, threes, assists, blocks, steals, fgm, fga, ftm, fta, rebounds, turnovers, gamesPlayed, nbaTeam, position ' +
      'FROM NBAPlayers;'
    );
    res.render('nbaPlayers', { title: 'Players', players: rows });
  } catch (err) {
    console.error(err);
    res.status(500).send('Error loading players');
  }
});
app.post('/players/add', async (req, res) => {
  try {
    const {
      name, points, threes, assists, blocks, steals,
      fgm, fga, ftm, fta, rebounds, turnovers,
      gamesPlayed, nbaTeam, position
    } = req.body;
    await db.query(
      'INSERT INTO NBAPlayers ' +
      '(name, points, threes, assists, blocks, steals, fgm, fga, ftm, fta, rebounds, turnovers, gamesPlayed, nbaTeam, position) ' +
      'VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)',
      [name, points, threes, assists, blocks, steals, fgm, fga, ftm, fta, rebounds, turnovers, gamesPlayed, nbaTeam, position]
    );
    res.redirect('/players');
  } catch (err) {
    console.error(err);
    res.status(500).send('Error adding player');
  }
});
app.post('/players/update', async (req, res) => {
  try {
    const { playerID, points, threes, assists, blocks, steals, fgm, fga, ftm, fta, rebounds, turnovers } = req.body;
    await db.query(
      'UPDATE NBAPlayers SET ' +
      'points = ?, threes = ?, assists = ?, blocks = ?, steals = ?, fgm = ?, fga = ?, ftm = ?, fta = ?, rebounds = ?, turnovers = ? ' +
      'WHERE playerID = ?',
      [points, threes, assists, blocks, steals, fgm, fga, ftm, fta, rebounds, turnovers, playerID]
    );
    res.redirect('/players');
  } catch (err) {
    console.error(err);
    res.status(500).send('Error updating player');
  }
});
app.post('/players/delete', async (req, res) => {
  try {
    const { playerID } = req.body;
    await db.query(
      'DELETE FROM NBAPlayers WHERE playerID = ?',
      [playerID]
    );
    res.redirect('/players');
  } catch (err) {
    console.error(err);
    res.status(500).send('Error deleting player');
  }
});

// NBAGames
app.get('/games', async (req, res) => {
  try {
    const [rows] = await db.query(
      'SELECT gameID, date, homeTeam, awayTeam FROM NBAGames;'
    );
    res.render('nbaGames', { title: 'Games', games: rows });
  } catch (err) {
    console.error(err);
    res.status(500).send('Error loading games');
  }
});
app.post('/games/add', async (req, res) => {
  try {
    const { date, homeTeam, awayTeam } = req.body;
    await db.query(
      'INSERT INTO NBAGames (date, homeTeam, awayTeam) VALUES (?, ?, ?)',
      [date, homeTeam, awayTeam]
    );
    res.redirect('/games');
  } catch (err) {
    console.error(err);
    res.status(500).send('Error adding game');
  }
});
app.post('/games/update', async (req, res) => {
  try {
    const { gameID, date } = req.body;
    await db.query(
      'UPDATE NBAGames SET date = ? WHERE gameID = ?',
      [date, gameID]
    );
    res.redirect('/games');
  } catch (err) {
    console.error(err);
    res.status(500).send('Error updating game');
  }
});
app.post('/games/delete', async (req, res) => {
  try {
    const { gameID } = req.body;
    await db.query(
      'DELETE FROM NBAGames WHERE gameID = ?',
      [gameID]
    );
    res.redirect('/games');
  } catch (err) {
    console.error(err);
    res.status(500).send('Error deleting game');
  }
});

// GamePlayed
app.get('/gameplayed', async (req, res) => {
    try {
      const [stats] = await db.query(
        `SELECT
           gp.id,
           gp.gameID,
           p.name       AS playerName,
           gp.points,
           gp.threes,
           gp.assists,
           gp.blocks,
           gp.steals,
           gp.fgm,
           gp.fga,
           gp.ftm,
           gp.fta,
           gp.rebounds,
           gp.turnovers
         FROM GamePlayed gp
         JOIN NBAPlayers p ON gp.playerID = p.playerID;`
      );
  
      const [games]   = await db.query(
        `SELECT gameID, DATE_FORMAT(date, '%Y-%m-%d') AS date
           FROM NBAGames;`
      );
      const [players] = await db.query(
        `SELECT playerID, name FROM NBAPlayers;`
      );
  
      res.render('gamePlayed', { title: 'Games Played', stats, games, players });
    } catch (err) {
      console.error(err);
      res.status(500).send('Error loading Games Played');
    }
  });
  
app.post('/gameplayed/add', async (req, res) => {
  try {
    const { gameID, playerID, points, threes, assists, blocks, steals, fgm, fga, ftm, fta, rebounds, turnovers } = req.body;
    await db.query(
      'INSERT INTO GamePlayed (gameID, playerID, points, threes, assists, blocks, steals, fgm, fga, ftm, fta, rebounds, turnovers) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)',
      [gameID, playerID, points, threes, assists, blocks, steals, fgm, fga, ftm, fta, rebounds, turnovers]
    );
    res.redirect('/gameplayed');
  } catch (err) {
    console.error(err);
    res.status(500).send('Error adding stat');
  }
});
app.post('/gameplayed/update', async (req, res) => {
  try {
    const { id, points, threes, assists } = req.body;
    await db.query(
      'UPDATE GamePlayed SET points = ?, threes = ?, assists = ? WHERE id = ?',
      [points, threes, assists, id]
    );
    res.redirect('/gameplayed');
  } catch (err) {
    console.error(err);
    res.status(500).send('Error updating stat');
  }
});
app.post('/gameplayed/delete', async (req, res) => {
  try {
    const { id } = req.body;
    await db.query(
      'DELETE FROM GamePlayed WHERE id = ?',
      [id]
    );
    res.redirect('/gameplayed');
  } catch (err) {
    console.error(err);
    res.status(500).send('Error deleting stat');
  }
});

// RosteredPlayers
app.get('/rostered', async (req, res) => {
  try {
    const [rows] = await db.query(
      'SELECT id, teamID, playerID, dateAdded, isStarter FROM RosteredPlayers;'
    );
    res.render('rosteredPlayers', { title: 'Rostered Players', roster: rows });
  } catch (err) {
    console.error(err);
    res.status(500).send('Error loading roster');
  }
});
app.post('/rostered/add', async (req, res) => {
    try {
      const { teamID, playerID, dateAdded } = req.body;
      let isStarter = req.body.isStarter;
      if (Array.isArray(isStarter)) {
        isStarter = isStarter[isStarter.length - 1];
      }
      await db.query(
        'INSERT INTO RosteredPlayers (teamID, playerID, dateAdded, isStarter) VALUES (?, ?, ?, ?)',
        [teamID, playerID, dateAdded, isStarter]
      );
      res.redirect('/rostered');
    } catch (err) {
      console.error('Error adding rostered player:', err);
      res.status(500).send('Error adding rostered player');
    }
  });
  
  app.post('/rostered/update', async (req, res) => {
    try {
      const { id } = req.body;
      let isStarter = req.body.isStarter;
      if (Array.isArray(isStarter)) {
        isStarter = isStarter[isStarter.length - 1];
      }
      await db.query(
        'UPDATE RosteredPlayers SET isStarter = ? WHERE id = ?',
        [isStarter, id]
      );
      res.redirect('/rostered');
    } catch (err) {
      console.error('Error updating rostered player:', err);
      res.status(500).send('Error updating rostered player');
    }
  });
  
app.post('/rostered/delete', async (req, res) => {
  try {
    const { id } = req.body;
    await db.query(
      'DELETE FROM RosteredPlayers WHERE id = ?',
      [id]
    );
    res.redirect('/rostered');
  } catch (err) {
    console.error(err);
    res.status(500).send('Error deleting roster entry');
  }
});

// WaiverTransactions
app.get('/waivers', async (req, res) => {
  try {
    const [rows] = await db.query(
      'SELECT transactionID, teamID, playerID, transactionType, transactionDate FROM WaiverTransactions;'
    );
    res.render('waiverTransactions', { title: 'Waiver Transactions', waivers: rows });
  } catch (err) {
    console.error(err);
    res.status(500).send('Error loading waivers');
  }
});
app.post('/waivers/add', async (req, res) => {
  try {
    const { teamID, playerID, transactionType, transactionDate } = req.body;
    await db.query(
      'INSERT INTO WaiverTransactions (teamID, playerID, transactionType, transactionDate) VALUES (?, ?, ?, ?)',
      [teamID, playerID, transactionType, transactionDate]
    );
    res.redirect('/waivers');
  } catch (err) {
    console.error(err);
    res.status(500).send('Error adding waiver');
  }
});
app.post('/waivers/update', async (req, res) => {
  try {
    const { transactionID, transactionType } = req.body;
    await db.query(
      'UPDATE WaiverTransactions SET transactionType = ? WHERE transactionID = ?',
      [transactionType, transactionID]
    );
    res.redirect('/waivers');
  } catch (err) {
    console.error(err);
    res.status(500).send('Error updating waiver');
  }
});
app.post('/waivers/delete', async (req, res) => {
  try {
    const { transactionID } = req.body;
    await db.query(
      'DELETE FROM WaiverTransactions WHERE transactionID = ?',
      [transactionID]
    );
    res.redirect('/waivers');
  } catch (err) {
    console.error(err);
    res.status(500).send('Error deleting waiver');
  }
});

app.listen(PORT, () => {
  console.log(`UI at http://classwork.engr.oregonstate.edu:${PORT}`);
});
