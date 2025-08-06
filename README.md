\# Data Analysis Assessment

This repository contains my responses to the \*\*ADASHI assessment\*\*, developed to support different arms of the organisation with insights that address various business needs. Each question is solved using queries designed to reflect thoughtful logic, efficient use of SQL functions, and a practical understanding of relational databases.

\---

\#\# Per-Question Explanations

\#\#\# Question 1: High-Value Customers with Multiple Products    
\*\*Scenario:\*\* The business wants to identify customers who have both a savings and an investment plan (cross-selling opportunity).    
\*\*Approach:\*\*    
I created a CTE to identify customers who possess both a savings and an investment plan. Within the CTE, I calculated the total amount and count of savings and investments made by each customer by performing an inner join between the \`savings\_savingsaccount\` and \`plans\_plan\` tables. The final output was derived by joining this CTE with the \`users\_customuser\` table to include the customers' personal details.

\---

\#\#\# Question 2: Transaction Frequency Analysis    
\*\*Scenario:\*\* The finance team wants to analyze how often customers transact to segment them (e.g., frequent vs. occasional users).    
\*\*Approach:\*\*    
I created a CTE to compute the average transaction amount and monthly transaction count for each customer using an inner join between the \`savings\_savingsaccount\` and \`users\_customuser\` tables. Based on the results, I used a \`CASE\` expression to classify customers into three frequency segments:  
\- \*\*High Frequency\*\* (≥10 transactions/month)    
\- \*\*Medium Frequency\*\* (3–9 transactions/month)    
\- \*\*Low Frequency\*\* (≤2 transactions/month)  

The final output included each customer's transaction metrics and frequency category.

\---

\#\#\# Question 3: Account Inactivity Alert    
\*\*Scenario:\*\* The ops team wants to flag accounts with no inflow transactions for over one year.    
\*\*Approach:\*\*    
I wrote two separate queries to identify inactive accounts from both the \`plans\_plan\` and \`savings\_savingsaccount\` tables.    
\- For investments, I selected customers with either a savings or investment plan that hasn’t had a charge in over 365 days, using \`DATEDIFF\` between the most recent \`last\_charge\_date\` and each plan's \`last\_charge\_date\` or \`start\_date\` if no charge exists.    
\- For savings, I selected customers whose last successful transaction was more than 365 days ago.  

I then merged both queries using a \`UNION\` and ordered the results by customer ID.

\---

\#\#\# Question 4: Customer Lifetime Value (CLV) Estimation    
\*\*Scenario:\*\* Marketing wants to estimate CLV based on account tenure and transaction volume (simplified model).    
\*\*Approach:\*\*    
I created a CTE that returns each customer’s account tenure in months, total number of successful transactions, and average profit per transaction using the \`savings\_savingsaccount\` table. I then selected the expected output by joining the CTE with the \`users\_customuser\` table and applied a simplified CLV formula:  

\> (Monthly transaction rate × 12 × average profit per transaction)  

The result was rounded to two decimal places and ordered by the highest CLV.

\---

\#\# Challenges

\- \*\*Query Optimization:\*\*    
  My first solution had slow execution. I optimized it by using a Common Table Expression (CTE).

\- \*\*Handling Missing Charge Dates:\*\*    
  Some records had \`NULL\` values in \`last\_charge\_date\`. I handled this using \`CASE WHEN\` statements to avoid errors in \`DATEDIFF\`.

\- \*\*New Accounts Being Incorrectly Flagged:\*\*    
  Some accounts were not charged in the \`plans\_plan\` table, and their \`start\_date\` indicated they were created less than 365 days ago. This made it difficult to calculate inactivity accurately, as these accounts were being incorrectly flagged as inactive despite being recently opened. It took several revisions to adjust the logic, specifically, to ensure that \`DATEDIFF\` calculations only applied when the account was older than one year, using \`start\_date\` as a fallback only when needed.
