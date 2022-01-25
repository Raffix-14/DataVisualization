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