SELECT
    m.[Date]
    ,m.HomeTeam
    ,m.AwayTeam
    ,m.FTHG
    ,m.FTAG
    ,FTR
FROM
    FootballMatch m;


SELECT -- final columns for the league table
    Team,
    COUNT(*) AS Played,
    SUM(Won) AS Won,
    SUM(Drawn) AS Drawn,
    SUM(Lost) AS Lost,
    SUM(GoalsFor) AS GoalsFor,
    SUM(GoalsAgainst) AS GoalsAgainst,
    SUM(GoalsFor) - SUM(GoalsAgainst) AS GoalDifference,
    SUM(Points) AS Points
FROM (
    -- subquery to calculate points and goals for the HOME team
    SELECT
        HomeTeam AS Team,
        CASE WHEN FTHG > FTAG THEN 1 ELSE 0 END AS Won,
        CASE WHEN FTHG = FTAG THEN 1 ELSE 0 END AS Drawn,
        CASE WHEN FTHG < FTAG THEN 1 ELSE 0 END AS Lost,
        FTHG AS GoalsFor,
        FTAG AS GoalsAgainst,
        CASE 
            WHEN FTHG > FTAG THEN 3
            WHEN FTHG = FTAG THEN 1
            ELSE 0
        END AS Points
    FROM FootballMatch

    UNION -- combine results of the home team with the away team

    -- subquery to calculate points and goals for the AWAY team
    SELECT
        AwayTeam AS Team,
        CASE WHEN FTAG > FTHG THEN 1 ELSE 0 END AS Won,
        CASE WHEN FTAG = FTHG THEN 1 ELSE 0 END AS Drawn,
        CASE WHEN FTAG < FTHG THEN 1 ELSE 0 END AS Lost,
        FTAG AS GoalsFor,
        FTHG AS GoalsAgainst,
        CASE 
            WHEN FTAG > FTHG THEN 3
            WHEN FTAG = FTHG THEN 1
            ELSE 0
        END AS Points
    FROM FootballMatch
) AS League
GROUP BY Team -- group by the team name
ORDER BY Points DESC, GoalDifference DESC, GoalsFor DESC;