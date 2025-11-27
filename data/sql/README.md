# SQL Analysis Queries

This folder contains all SQL queries used in the MTN Nigeria Customer Churn Analysis.

## Query Files

## 01_demographic_analysis.sql
Analysis of churn patterns by state, age group, and gender.
- State-wise churn rates
- Age cohort analysis
- Gender-based patterns

## 02_subscription_device.sql
Evaluation of subscription plans and device impact on retention.
- Churn by subscription plan
- Device correlation analysis
- Plan-device combinations

## 03_revenue_analysis.sql
Financial impact assessment and customer value analysis.
- Revenue comparison (churned vs retained)
- Revenue bracket segmentation
- Data usage correlation

## 04_tenure_satisfaction.sql
Customer lifecycle and satisfaction analysis.
- Tenure-based churn patterns
- Satisfaction-churn correlation
- Critical intervention points

## 05_churn_reasons.sql
Root cause analysis of customer attrition.
- Top churn drivers
- Demographic-specific reasons
- Addressable vs structural issues

## 06_purchase_frequency.sql
Behavioral pattern analysis.
- Purchase frequency impact
- Engagement correlation
- Transaction patterns

## 07_price_sensitivity.sql
Pricing impact assessment.
- Unit price analysis
- Plan-specific pricing issues
- Price differential analysis

## 08_executive_dashboard.sql
High-level KPI consolidation.
- Summary metrics
- Executive reporting
- Overall business health

## Usage

All queries are designed for Microsoft SQL Server. To run:

1. Create database using `schema.sql` in the data folder
2. Import dataset
3. Execute queries in numerical order
4. Results can be exported for visualization

## Technical Highlights

- Advanced CTEs for comparative analysis
- Window functions for percentage calculations
- Multi-dimensional segmentation
- Statistical analysis functions
