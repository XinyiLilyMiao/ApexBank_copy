# Apexbank

# Code Map


# SQL queries for main data transformation

Models--feature

Average_daily_transactions.sql 
1. Calculate average daily transactions from transaction table for each customer

users_final.sql
1. Calculate Avg days of inactivity,days to first transaction, days since last transaction for each customer.
2. Define whether the customer has churned based on transactions_cleaned
3. Make a complete table for all users attributes so that it is ready for further analysis


# SQL queries for data cleaning 

Models--stg

users_cleaned.sql
1. Correct the wrong spellings and capitalize the first letter for city column
2. Categorize cities into top 5 cities and others (end with 6 category) as 99% of transactions are in top 5 cities
3. Add a column of country name based on country code in the initial users table though joins

transactions_cleaned.sql
1. Put various cryto currencies under one single category
2. Define whether a transaction is the last transaction of an user

nortifications_cleaned.sql
1. Cast user-id into the same format as in other tables
2. Categorize nortifications into 5 groups

device_cleaned.sql 
1. Change column names
2. Cast user-id into the same format as in other tables
