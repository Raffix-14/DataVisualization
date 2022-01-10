9)
SELECT SongID, Month, SUM(NumberOfStreaming) AS TotStreaming,
    SUM(SUM(NumberOfStreaming)) OVER(PARTITION BY Year
                                    ORDER BY Month ASC
                                    ROWS UNBOUNDED PRECEDING) AS CumulativeStreaming,
    RANK() OVER(PARTITION BY Album
                ORDER BY SUM(NumberOfStreaming) DESC) AS RankStreamingInAlbum
FROM MusicStreaming MS, Song S
WHERE MS.SongID = S.SongID
GROUP BY SongID, Month, Year, Album

10)
SELECT SongID, Province,
    SUM(NumberOfLikes) / COUNT(DISTINCT Month),
    100 * SUM(NumberOfLikes) / SUM(SUM(NumberOfLikes)) OVER(PARTITION BY SongID, Country),
    SUM(SUM(NumberOfLikes)) OVER(PARTITION BY Album, Province)
FROM MusicStreaming MS, TIME T, Song S, UserLocation L
WHERE S.SongId = MS.SongId 
AND L.UserLocationId = MS.PlatformId 
AND T.TimeId = MS.TimeId
GROUP BY SongID, Province


db.shops.find(
    {   
        "address.city":"Rome",
        $or:[
                {sold_items:"TV"},
                {sold_items:"Smartphones"}
            ],
        "review.score":{$gt:8}
    },
    {name:1, _id:0}
)

db.shops.aggregate([
    {
        $unwind:"reviews"
    },
    {
        $group:{
            _id:"$address.city",
            max_review_score:{$max:"review.score"},
            avg_review_score:{$avg:"review.score"},
            tot_reviews:{$sum:1}
        }
    },
    {
        $sort:{"tot_reviews":-1}
    },
    {
        $limit:10
    }
])