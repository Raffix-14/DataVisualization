RENTALS
1.A)
SELECT ObjectID, ObjectType, COUNT(ObjectID) AS TotalRents, SUM(Price) AS TotalIncome
    RANK() OVER(ORDER BY COUNT(ObjectID)) AS RankTotalRents,
    RANK() OVER(ORDER BY SUM(Price)) AS RankTotalIncome
FROM OBJECTS O, RENTAL R
WHERE O.ObjectID = R.ObjectID
GROUP BY ObjectID, ObjectType

1.B)
SELECT ObjectID, ObjectType, Month, SUM(Price) AS Total_Month_Income
    RANK() OVER(PARTITION BY Month ORDER BY SUM(Price) DESC) AS RankTotalMonthIncome
FROM OBJECTS O, RENTAL R, TIME T
WHERE O.ObjectID = R.ObjectID
GROUP BY ObjectID, ObjectType, Month

2.A)
SELECT Province, Region, SUM(TotAmount) AS TotalIncome,
    RANK() OVER(PARTITION BY Region ORDER BY SUM(TotAmount) DESC) AS RankTotalRegionIncome
FROM CUSTOMER C, SALES S
WHERE C.CustomerID = S.CustomerID
GROUP BY Province, Region

2.B)
SELECT Region, Month, SUM(TotAmount) AS TotalIncome,
    SUM(SUM(TotAmount)) OVER(PARTITION BY Region 
                            ORDER BY Month 
                            ROWS UNBOUNDED PRECEDING) AS CumulativeAmount
FROM CUSTOMER C, SALES S, TIME T
WHERE C.CustomerID = S.CustomerID
AND S.TimeID = T.TimeID
GROUP BY Region, Month





CUSTOMERS
1)
SELECT CategoryName, SUM(TotAmount) AS TotalIncome, SUM(NumSoldItems) AS TotalSoldItems,
    RANK() OVER(PARTITION BY CategoryID ORDER BY SUM(TotAmount) DESC) AS RankTotalIncome,
    RANK() OVER(PARTITION BY CategoryID ORDER BY SUM(NumSoldItems) DESC) AS RankSoldItems
FROM CATEGORY C, SALES S
WHERE  C.CategoryID = S.CategoryID
GROUP BY CategoryID, CategoryName
ORDER BY TotalSoldItems

2)
SELECT Province, Region, SUM(TotAmount) AS TotalIncomeProvince,
    RANK() OVER(PARTITION BY Region ORDER BY SUM(TotAmount) DESC) AS RankTotalIncomeProvince,
FROM CUSTOMER C, SALES S
WHERE  C.CustomerID = S.CustomerID
GROUP BY Province, Region

3)
SELECT Province, Region, Month, SUM(TotAmount) AS TotalIncomeProvinceForMonth,
    RANK() OVER(PARTITION BY Month ORDER BY SUM(TotAmount) DESC) AS RankTotalIncomeProvinceForMonth,
FROM CUSTOMER C, SALES S, TIME T
WHERE  C.CustomerID = S.CustomerID
AND S.TimeID = T.TimeID
GROUP BY Province, Region, Month

4)
SELECT Region, Month, SUM(TotAmount) AS TotalIncomeProvince,
    SUM(SUM(TotAmount)) OVER(PARTITION BY Region
                            ORDER BY Month ASC
                            ROWS UNBOUNDED PRECEDING) AS CumulativeAmount,
FROM CUSTOMER C, SALES S
WHERE  C.CustomerID = S.CustomerID
AND S.TimeID = T.TimeID
GROUP BY Region, Month