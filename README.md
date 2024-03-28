# Apexbank
# Code Map:

# Models--feature:
# SQL queries for main data transformation:

# Average_daily_transactions: 
1. calculate average daily transactions from transaction table for each customer

# users_final:
1.Calculate Avg days of inactivity,days to first transaction, days since last transaction for each customer.
2.Define whether the customer has churned based on transaction_cleaned 

# Models--stg:
# SQL queries for data cleaning 

# users_cleaned:
1.Correct the wrong spellings and capitalize the first letter for city column
2.Categorize cities into top 5 cities and others (end with 6 category) as 99% of transactions are in top 5 cities
3.Add a column of country name based on country code in the initial users table though joins

# transactions_cleaned:
1.Put various cryto currencies under one single category
2.Define whether a transaction is the last transaction of an user

# nortifications_cleaned:
1.cast user-id into the same format as in other tables
2.categorize nortifications into 5 groups

# device_cleaned: 
1. change column names
2. cast user-id into the same format as in other tables
