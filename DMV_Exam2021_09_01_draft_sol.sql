12)
db.books.find(
    {
        tags:"Database",
        published:{
            $gte: new Date(2019)
            $lt: new Date(2020)
        },
        "details.hour_length": {$lte:10}
    },
    {
        title:1,
        category:1,
        price:1,
        _id:0
    }
)


13)
db.books.aggregate(
    {
        $match:{
            category:"ComputerScience",
            published:{
            $gte: new Date(2020)
            $lt: new Date(2021)
            }
        }
    },
    {
        $unwind:"$tags"
    },
    {
        $group:{
            _id:"$tags",
            avgPrice:{$avg:"$price"},
            maxStudent:{$max:"$enrolled_students"}
        }
    }
)