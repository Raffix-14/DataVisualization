1.A)

SELECT ObjectID, ObjectType, COUNT(ObjectID) AS TotalRents, SUM(Price) AS TotalIncome
    RANK() OVER ORDER BY TotalRents,
    RANK() OVER ORDER BY TotalIncome
FROM OBJECTS O, RENTAL R
WHERE O.ObjectID = R.ObjectID
GROUP BY ObjectID, ObjectType