-- ============================================================
-- Script : exploratory_queries.sql
-- Project : Gender-Based Sales KPI Dashboard
-- Author  : Hicham ERRIHANI
-- Purpose : Exploratory queries on AdventureWorksDW2022
-- ============================================================

-- 1. Total sales by gender
SELECT 
    c.Gender,
    SUM(f.SalesAmount) AS TotalSales,
    COUNT(DISTINCT f.SalesOrderNumber) AS OrderCount
FROM dbo.FactInternetSales f
JOIN dbo.DimCustomer c ON f.CustomerKey = c.CustomerKey
GROUP BY c.Gender
ORDER BY TotalSales DESC;

-- 2. Sales by year and gender
SELECT 
    d.CalendarYear,
    c.Gender,
    SUM(f.SalesAmount) AS TotalSales
FROM dbo.FactInternetSales f
JOIN dbo.DimCustomer c ON f.CustomerKey = c.CustomerKey
JOIN dbo.DimDate d ON f.OrderDateKey = d.DateKey
GROUP BY d.CalendarYear, c.Gender
ORDER BY d.CalendarYear, c.Gender;

-- 3. Top 10 products by sales
SELECT TOP 10
    p.EnglishProductName,
    SUM(f.SalesAmount) AS TotalSales
FROM dbo.FactInternetSales f
JOIN dbo.DimProduct p ON f.ProductKey = p.ProductKey
GROUP BY p.EnglishProductName
ORDER BY TotalSales DESC;

-- 4. Sales by country
SELECT 
    g.EnglishCountryRegionName AS Country,
    SUM(f.SalesAmount) AS TotalSales
FROM dbo.FactInternetSales f
JOIN dbo.DimCustomer c ON f.CustomerKey = c.CustomerKey
JOIN dbo.DimGeography g ON c.GeographyKey = g.GeographyKey
GROUP BY g.EnglishCountryRegionName
ORDER BY TotalSales DESC;
