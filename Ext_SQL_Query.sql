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





HOTEL
1)
SELECT State, Month, Free, Reserved, Unavailable
FROM ROOMS R, TIME T, HOTEL H
WHERE R.TimeID = T.TimeID
AND H.HotelID = R.HotelID
AND T.Year = 2005
GROUP BY State, Month

2)
SELECT State, Reserved/Total * 100,
    RANK() OVER(ORDER BY Reserved/Total * 100 DESC) AS RankRes
FROM ROOMS R, TIME T, HOTEL H
WHERE R.TimeID = T.TimeID
AND H.HotelID = R.HotelID
AND T.Year = 2005
GROUP BY State
ORDER BY RankRes ASC

3)
SELECT State, Month, SUM(Income) AS TotalIncome, 
    SUM(SUM(Income)) OVER(PARTITION BY HotelID
                          ORDER BY Month
                          ROWS UNBOUNDED PRECEDING) AS Total_Month_Income
FROM ROOMS R, TIME T, HOTEL H
WHERE R.TimeID = T.TimeID
AND H.HotelID = R.HotelID
AND T.Year = 2005
AND H.Category = 4
GROUP BY State, Month

4)
SELECT State, Year, SUM(Income) AS TotalIncome
FROM ROOMS R, TIME T, HOTEL H
WHERE R.TimeID = T.TimeID
AND H.HotelID = R.HotelID
AND T.Holiday = True
GROUP BY State, Year

5)
SELECT HotelID, SUM(Income) AS TotalIncome
FROM ROOMS R, TIME T, HOTEL H, FEATURE F
WHERE R.TimeID = T.TimeID
AND H.HotelID = R.HotelID
AND T.Year = 2005
AND R.FeatureID = F.FeatureID
AND F.satelliteTV = 1
AND F.whirlpoolBath = 1
GROUP BY HotelID





STOREHOUSE
1)
SELECT StoreHouseID, SUM(TotalValue) AS TotalValue, Date,
    AVG(SUM(TotalValue)) OVER(PARTITION BY StoreHouseID 
                            ORDER BY Date ASC 
                            RANGE BETWEEN INTERVAL "6" day PRECEDING AND CURRENT ROW)
FROM STOREHOUSE S, TIME T, PRODUCTS P
WHERE T.Year = 2003
AND T.Trimester = 1
AND S.City = "Turin"
GROUP BY S.StoreHouseID, Date

2)
SELECT City, Date, (SUM(m2free) / SUM(m2tot) * 100) AS FreePercentage,
    RANK() OVER(ORDER BY (SUM(m2free) / SUM(m2tot) * 100) ASC) AS RankPercentage
FROM STOREHOUSE S, TIME T, SURFACE SF
WHERE SF.StoreHouseID = S.StoreHouseID
AND T.TimeID = SF.TimeID
AND T.Year = 2004
GROUP BY City, Date

3)
SELECT StoreHouseID, Date, (m2free / m2tot * 100) AS FreePercentage
FROM TIME T, STOREHOUSE S
WHERE T.TimeID = S.TimeID
AND T.Semester = 1/2004
GROUP BY StoreHouseID, Date

4)
SELECT StoreHouseID, Month, (SUM(TotalValue) / COUNT(DISTINCT Date)) AS AverageDailyIncome
FROM TIME T, STOREHOUSE S
WHERE T.TimeID = S.TimeID
AND T.Year = 2003
GROUP BY StoreHouseID, Month

5)
SELECT Region, (SUM(TotalValue) / COUNT(DISTINCT Date)) AS AverageDailyIncome
FROM TIME T, STOREHOUSE S
WHERE T.TimeID = S.TimeID
AND T.Year = 2003
GROUP BY Region

6)
SELECT Region, Month
    AVG(SUM(m2free) / SUM(m2tot)) OVER(PARTITION BY Region, Month) AS AverageDailyFreePercentage
FROM TIME T, STOREHOUSE S, SURFACE SF
WHERE T.TimeID = S.TimeID
AND SF.StoreHouseID = S.StoreHouseID
AND T.Year = 2004
GROUP BY Region, Month