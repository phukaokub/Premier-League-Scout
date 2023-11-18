USE eplScout;

-- League Table
CREATE VIEW leagueTable AS
SELECT
    t.teamName,
    COUNT(*) AS matchPlayed,
    COUNT(CASE WHEN result = 'WIN' THEN 1 END) AS wins,
    COUNT(CASE WHEN result = 'DRAW' THEN 1 END) AS draws,
    COUNT(CASE WHEN result = 'LOSE' THEN 1 END) AS losses,
    SUM(goalFor) AS goalFor,
    SUM(goalAgainst) AS goalAgainst,
    SUM(goalFor) - SUM(goalAgainst) AS goalDifference,
    (COUNT(CASE WHEN result = 'WIN' THEN 1 END) * 3) + (COUNT(CASE WHEN result = 'DRAW' THEN 1 END) * 1) AS points
FROM (
    SELECT
        homeTeamID AS teamID,
        homeTeamResult AS result,
        homeTeamScore AS goalFor,
        awayTeamScore AS goalAgainst
    FROM matchInfo

    UNION ALL

    SELECT
        awayTeamID AS teamID,
        awayTeamResult AS result,
        awayTeamScore AS goalFor,
        homeTeamScore AS goalAgainst
    FROM matchInfo
) AS combined_results
JOIN team t ON combined_results.teamID = t.id
GROUP BY t.teamName
ORDER BY points DESC, wins, draws;

-- Get last 5 matches
SELECT 
    home.teamName AS homeTeam,
    homeTeamScore,
    away.teamName AS awayTeam,
    awayTeamScore,
    m.gameweek
FROM matchInfo m
JOIN team home ON home.id = m.homeTeamID
JOIN team away ON away.id = m.awayTeamID
WHERE home.teamName = 'Manchester United' OR away.teamName = 'Manchester United'
ORDER BY m.gameweek DESC
LIMIT 5;
