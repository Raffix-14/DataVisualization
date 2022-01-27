9)
SELECT plantSpecies, month,
    SUM(numberOfPlants) / COUNT(DISTINCT TimeID) AS A,
    100 * SUM(numberOfPlants) / SUM(SUM(numberOfPlants)) OVER(PARTITION BY month, genus) AS B,
    SUM(SUM(numberOfPlants)) OVER(PARTITION BY plantId, plantSpecies, year ORDER BY month ASC ROWS UNBOUNDED PRECEDING)
FROM GARDENS G, TIME T, PLANT P
WHERE G.TimeID = T.TimeID
AND G.PlantID = P.PlantID
GROUP BY plantID, plantSpecies, month, genus, year


10)
SELECT GardenCenterId, genus,
    SUM(revenue) / SUM(numberOfPlants) AS A,
    SUM(revenue) OVER(PARTITION BY family, GardenCenterId) AS B,
    RANK() OVER(PARTITION BY province, genus ORDER BY SUM(revenue) DESC) AS C
FROM GARDENS G, GARDENCENTERS GC, PLANT P
WHERE GC.GardenCenterId = G.GardenCenterId
AND G.PlantID = P.PlantID
AND GS.parking = True
GROUP BY GardenCenterId, genus, family, province





11)
db.temperatures.updateOne(
    {
        _id:1000,
        start: new Date("2021-02-02"),
    },
    {
        $inc:{ nTemp: 1, sumTemp: 16},
        $push: { 
            temperature: { ts: new Date(“2021-02-20 10:00”), value: 16}
        }
    }
)


12)
db.temperatures.aggregate([
    {
        $unwind:temperatures
    },
    {
        $match:{
            "sensor.country":"Italy",
            ts: {$gte: new Date ("2021-01-01")},
            ts: {$lte: new Date ("2021-01-31")}, 
            }
    },
    {
        $group:{
            _id:{$dayOfMonth:"temperatures.ts"}
            avg:{$avg:"temperatures.value"}
            day:{$dayOfMonth:"temperatures.ts"}
            month:{$month:"temperatures.ts"}
            year:{$year:"temperatures.ts"}
        }
    },
    {
        $match:{
            avg:{$gte:15}
        }
    },
    {
        $project:{
            "sensor.id":1,
            "sensor.city":1
            day:1
            month:1
            year:1
        }
    }
])