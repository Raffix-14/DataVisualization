SELECT CourierAgencyId, CourierAgencyName, City,
    100 * SUM(#packages) / SUM(SUM(#packages)) OVER (PARTITION BY CourierAgencyId, Region) AS A,
    SUM(total_weight) / SUM(#packages) AS B,
    RANK() OVER(PARTITION BY CorporateGroup, City
                ORDER BY SUM(#packages) DESC) AS C
FROM COURIERAGENCY CA, LOCATION L, SHIPPINGS S
WHERE S.CourierAgencyId = CA.CourierAgencyId
AND L.LocationId = S.DepartureLocationId
GROUP BY CourierAgencyId, CourierAgencyName, City, Region, CorporateGroup


SELECT month, province,
        SUM(#packages) / COUNT(DISTINCT TimeID) AS A,
        SUM(SUM(total_weight)) OVER(PARTITION BY L1.province, L2.province, semester ORDER BY month ASC ROWS UNBOUNDED PRECEDING) AS B
FROM TIME T, LOCATION L1, LOCATION L2, SHIPPINGS S
WHERE L1.LocationId = S.DepartureLocationId
AND L2.LocationId = S.ArrivalLocationId
AND T.TimeID = S.TimeID
GROUP BY month, L1.province, L2.province, semester





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