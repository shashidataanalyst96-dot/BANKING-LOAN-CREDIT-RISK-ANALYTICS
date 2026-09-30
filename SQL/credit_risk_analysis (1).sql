CREATE DATABASE bank_risk;

USE bank_risk;

RENAME TABLE final_data TO loan_data;


-- Total Customers.

SELECT COUNT(*) AS Total_Customers
FROM loan_data;


-- Total Default Customers.

SELECT COUNT(*) AS Default_Customers
FROM loan_data
WHERE Loan_Status = 1;


-- Default Rate (%).

SELECT
    ROUND(
        COUNT(CASE WHEN Loan_Status = 1 THEN 1 END)
        * 100.0 / COUNT(*),
        2
    ) AS Default_Rate
FROM loan_data;


-- Default Customers by Loan Grade.

SELECT Loan_Grade, COUNT(*) AS Default_Customers
FROM loan_data
WHERE Loan_Status = 1
GROUP BY Loan_Grade
ORDER BY Default_Customers DESC;


-- Customers by Age Category.

SELECT Age_Category, COUNT(*) AS Total_Customers
FROM loan_data
GROUP BY Age_Category
ORDER BY Total_Customers DESC;


-- Customers by Income Category.

SELECT Income_Category, COUNT(*) AS Total_Customers
FROM loan_data
GROUP BY Income_Category
ORDER BY Total_Customers DESC;


-- Loan Distribution by Purpose.

SELECT Loan_Purpose, COUNT(*) AS Total_Loans
FROM loan_data
GROUP BY Loan_Purpose
ORDER BY Total_Loans DESC;


-- Default Customers by Previous Default History.

SELECT Previous_Default, COUNT(*) AS Default_Customers
FROM loan_data
WHERE Loan_Status = 1
GROUP BY Previous_Default
ORDER BY Default_Customers DESC;


-- Ranking Loan Grades by Default Customers.

SELECT
    Loan_Grade,
    COUNT(*) AS Default_Customers,
    RANK() OVER( ORDER BY COUNT(*) DESC ) AS Risk_Rank
FROM loan_data
WHERE Loan_Status = 1
GROUP BY Loan_Grade;


-- Ranking Loan Purposes by Total Loan Amount.

SELECT
    Loan_Purpose,
    SUM(Loan_Amount) AS Total_Loan_Amount,
    DENSE_RANK() OVER( ORDER BY SUM(Loan_Amount) DESC ) AS Loan_Rank
FROM loan_data
GROUP BY Loan_Purpose;


-- Top Risk Loan Grades.

WITH Loan_Risk AS
(
    SELECT
        Loan_Grade,
        COUNT(*) AS Default_Customers
    FROM loan_data
    WHERE Loan_Status = 1
    GROUP BY Loan_Grade
)

SELECT
    Loan_Grade,
    Default_Customers,
    RANK() OVER( ORDER BY Default_Customers DESC ) AS Risk_Rank
FROM Loan_Risk;
