12)
db.cameras.find(
    {
        releaseDate:{
            $gte: new Date(2021)
            $lt: new Date(2022)
        },
        category:"laser",
        "scores.overall":{
            $gte: 70
            $lte: 90
        }
    },
    {
        model:1,
        price:1,
        "brand.name":1,
        _id:0
    }
)


13)
db.cameras.aggregate([
    {
        $match:{
            releaseDate:{$gte:new Date(2015)}
        }
    },
    {
        $sort:{
            scores.overall:1
        }
    },
    {
        $group:{
            _id:{
                year_id: {$year:releaseDate},
                category_id: $category
            },
            overallScoreList: {$push:"scores.overall"}
        }
    },
    {
        $project:{
            id:1,
            median: {$arrayElemAt:
                [
                    overallScoreList,
                    {$floor:{$multiply:
                            [
                                0.5,
                                {$size:"$overallScoreList"}
                            ]}
                    }
                ]}
        }
    }
])