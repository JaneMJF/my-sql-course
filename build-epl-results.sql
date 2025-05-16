SELECT TOP 5
    m.[Date]
    ,m.[HomeTeam]
    ,m.[AwayTeam]
    ,m.[FTHG]
    ,m.[FTAG]
    ,m.[FTR]
FROM
    FootballMatch m
ORDER BY
    m.[Date] DESC;

-----------------------------------------------------------------------------------------------------------------------------------------



DROP TABLE IF EXISTS #EPLResults;

-- results from home team perspective
    SELECT
        m.HomeTeam  AS Team
    ,m.FTHG AS GoalsFor
    ,m.FTAG  AS GoalsAgainst
    ,CASE WHEN m.FTHG > m.FTAG THEN 'W' WHEN M.FTHG = M.FTAG THEN 'D' ELSE 'L' END AS Result
    INTO #EPLResults
    FROM
        FootballMatch m

UNION ALL

    -- results from away team perspective
    SELECT
        m.AwayTeam  AS Team
    ,m.FTAG AS GoalsFor
    ,m.FTHG  AS GoalsAgainst
    ,CASE m.FTR WHEN 'A' THEN 'W' WHEN 'D' THEN 'D' ELSE 'L' END AS Result

    FROM
        FootballMatch m



-- group by team and result
SELECT
    r.team
    ,count(*) AS Played
    ,SUM(CASE WHEN r.Result = 'W' THEN 1 ELSE 0 END) AS Wins
    ,SUM(CASE WHEN r.Result = 'D' THEN 1 ELSE 0 END) AS Draws
    ,SUM(CASE WHEN r.Result = 'L' THEN 1 ELSE 0 END) AS Losses
    ,SUM(r.GoalsFor) AS GoalsFor
    ,SUM(r.GoalsAgainst) AS GoalsAgainst
    ,SUM(GoalsFor) - SUM(GoalsAgainst) AS GD
    ,SUM(CASE WHEN r.Result = 'W' THEN 3 WHEN r.Result = 'D' THEN 1 ELSE 0 END) AS Points
FROM
    #EPLResults r
GROUP BY
    Team
ORDER BY points DESC, GD DESC, Team ASC;