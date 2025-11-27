-- MTN Nigeria Customer Churn Database Schema
-- Database: MTN_Nigeria_Customer_Churn
-- Created: November 2024
-- Purpose: Customer churn analysis and retention intelligence


-- DATABASE CREATION

CREATE DATABASE [MTN Nigeria Customer Churn];
GO

USE [MTN Nigeria Customer Churn];
GO


-- MAIN ANALYSIS TABLE


CREATE TABLE [dbo].['MTN Nigeria Customer Churn$'] (
    -- Customer Identification
    Customer_ID INT PRIMARY KEY,
    
    -- Demographics
    State VARCHAR(50) NOT NULL,
    Age INT NOT NULL CHECK (Age BETWEEN 16 AND 100),
    Gender VARCHAR(10) NOT NULL CHECK (Gender IN ('Male', 'Female')),
    
    -- Subscription Information
    [Subscription Plan] VARCHAR(50) NOT NULL,
    [MTN Device] VARCHAR(50),
    [Customer Tenure in months] INT NOT NULL CHECK ([Customer Tenure in months] >= 0),
    
    -- Financial Metrics
    [Total Revenue] DECIMAL(12,2) NOT NULL CHECK ([Total Revenue] >= 0),
    [Unit Price] DECIMAL(10,2) NOT NULL CHECK ([Unit Price] >= 0),
    
    -- Behavioral Metrics
    [Number of Times Purchased] INT NOT NULL CHECK ([Number of Times Purchased] >= 0),
    [Data Usage] DECIMAL(10,2) NOT NULL CHECK ([Data Usage] >= 0),
    
    -- Experience Metrics
    [Satisfaction Rate] DECIMAL(3,1) NOT NULL CHECK ([Satisfaction Rate] BETWEEN 1.0 AND 5.0),
    
    -- Churn Information
    [Customer Churn Status] VARCHAR(3) NOT NULL CHECK ([Customer Churn Status] IN ('Yes', 'No')),
    [Reasons for Churn] VARCHAR(200) NULL
);
GO


  
-- INDEXES FOR QUERY PERFORMANCE

  
-- Index on Churn Status (most frequently queried)
CREATE NONCLUSTERED INDEX IX_Churn_Status 
ON [dbo].['MTN Nigeria Customer Churn$'] ([Customer Churn Status])
INCLUDE ([Total Revenue], [Satisfaction Rate], [Customer Tenure in months]);
GO

-- Index on State for geographic analysis
CREATE NONCLUSTERED INDEX IX_State 
ON [dbo].['MTN Nigeria Customer Churn$'] (State)
INCLUDE ([Customer Churn Status], Age, Gender);
GO

-- Index on Age for demographic segmentation
CREATE NONCLUSTERED INDEX IX_Age 
ON [dbo].['MTN Nigeria Customer Churn$'] (Age)
INCLUDE ([Customer Churn Status], Gender);
GO

-- Index on Subscription Plan for product analysis
CREATE NONCLUSTERED INDEX IX_Subscription_Plan 
ON [dbo].['MTN Nigeria Customer Churn$'] ([Subscription Plan])
INCLUDE ([Customer Churn Status], [MTN Device], [Total Revenue]);
GO

-- Index on Tenure for lifecycle analysis
CREATE NONCLUSTERED INDEX IX_Tenure 
ON [dbo].['MTN Nigeria Customer Churn$'] ([Customer Tenure in months])
INCLUDE ([Customer Churn Status], [Satisfaction Rate]);
GO

-- Composite index for satisfaction analysis
CREATE NONCLUSTERED INDEX IX_Satisfaction_Churn 
ON [dbo].['MTN Nigeria Customer Churn$'] ([Satisfaction Rate], [Customer Churn Status]);
GO


  
-- SAMPLE DATA INSERT FOR TESTING (Optional)

  
-- Uncomment to insert sample records
/*
INSERT INTO [dbo].['MTN Nigeria Customer Churn$'] VALUES
(1001, 'Lagos', 28, 'Male', 'Standard', 'MTN Router', 18, 45000.00, 2500.00, 18, 85.5, 4.2, 'No', NULL),
(1002, 'Kano', 22, 'Female', 'Basic', 'None', 6, 8500.00, 1700.00, 5, 15.2, 2.8, 'Yes', 'Better Competitor Offer'),
(1003, 'Rivers', 45, 'Male', 'Premium', 'MTN MiFi', 36, 125000.00, 3500.00, 36, 280.0, 4.8, 'No', NULL);
-- Add more sample records as needed
*/


  
-- VERIFICATION QUERIES


-- Check table structure
EXEC sp_help ['MTN Nigeria Customer Churn$'];
GO

-- Verify indexes
SELECT 
    i.name AS IndexName,
    i.type_desc AS IndexType,
    COL_NAME(ic.object_id, ic.column_id) AS ColumnName
FROM sys.indexes i
INNER JOIN sys.index_columns ic ON i.object_id = ic.object_id AND i.index_id = ic.index_id
WHERE i.object_id = OBJECT_ID('[dbo].[''MTN Nigeria Customer Churn$'']')
ORDER BY i.name, ic.key_ordinal;
GO



-- NOTES


/*
Database Design Decisions:

1. Primary Key: Customer_ID ensures uniqueness
2. Constraints: CHECK constraints validate data integrity
3. Indexes: Strategically placed for query performance
4. Column Names: Preserved original structure with brackets for spaces
5. Data Types: Appropriate precision for Nigerian Naira and usage metrics

Performance Considerations:
- Indexes include commonly queried columns
- Covering indexes reduce lookup operations
- Composite indexes support multi-column queries

Data Integrity:
- NOT NULL constraints on critical fields
- CHECK constraints validate value ranges
- Referential integrity through primary key

Maintenance:
- Regular index rebuilding recommended for large datasets
- Statistics updates for query optimization
- Periodic data validation checks
*/
