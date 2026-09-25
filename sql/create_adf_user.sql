-- ============================================================
-- Script : create_adf_user.sql
-- Project : Gender-Based Sales KPI Dashboard
-- Author  : Hicham ERRIHANI
-- Purpose : Create dedicated SQL login for Azure Data Factory
-- ============================================================

-- STEP 1 : Run on master database
USE master;
GO

IF NOT EXISTS (SELECT * FROM sys.server_principals WHERE name = 'adf_user')
BEGIN
    CREATE LOGIN adf_user WITH PASSWORD = 'YourStrongPassword2026!';
    PRINT 'Login adf_user created.';
END
ELSE
BEGIN
    PRINT 'Login adf_user already exists.';
END
GO

-- STEP 2 : Run on AdventureWorksDW2022
USE AdventureWorksDW2022;
GO

IF NOT EXISTS (SELECT * FROM sys.database_principals WHERE name = 'adf_user')
BEGIN
    CREATE USER adf_user FOR LOGIN adf_user;
    PRINT 'User adf_user created.';
END
GO

ALTER ROLE db_datareader ADD MEMBER adf_user;
GO

PRINT 'adf_user granted db_datareader on AdventureWorksDW2022.';
GO

-- STEP 3 : Verify
SELECT dp.name, r.name AS Role
FROM sys.database_role_members drm
JOIN sys.database_principals dp ON drm.member_principal_id = dp.principal_id
JOIN sys.database_principals r ON drm.role_principal_id = r.principal_id
WHERE dp.name = 'adf_user';
GO
