WITH deposit_analysis as ( 		/* this CTE returns customers who hold both a savings and an investment plan along with 
								the sum and count of the total savings and investments made by each customer */
	SELECT
		s.owner_id,
		s.total_savings,
		s.savings_count,
		p.total_investment,
		p.investment_count
	FROM
		(SELECT		-- Retrieves the total value and frequency of savings plans grouped by customer
			owner_id ,
			SUM(confirmed_amount) AS total_savings,
			COUNT(confirmed_amount) AS savings_count
		FROM
		savings_savingsaccount
		WHERE 		-- Filters for savings accounts that are confirmed, operational, and active
			confirmed_amount > 1
			AND transaction_status = 'success'
		GROUP BY
			owner_id) s

	INNER JOIN
			
		(SELECT     -- Retrieves the total value and frequency of investment plans grouped by customer
			owner_id,
			SUM(amount) AS total_investment,
			COUNT(amount) AS investment_count
		FROM
			plans_plan 
		WHERE 		-- Filters for investment accounts that are confirmed, operational, and active
			amount > 1 AND is_a_fund = 1
		/* since using the filter is_regular_savings = 1 AND is_a_fund = 1 returns zero customer,
			the customers with a savings plan (is_regular_savings = 1) has been left out from the filter above. */
		GROUP BY 
			owner_id) p
		ON s.owner_id = p.owner_id
)
    
SELECT 	
	da.owner_id,
	CONCAT(u.first_name, ' ', u.last_name) AS name,
	da.savings_count,
	da.investment_count,
	ROUND((da.total_savings + da.total_investment), 2) AS total_deposit
FROM 
	deposit_analysis da
INNER JOIN 
	users_customuser u
ON 
	da.owner_id = u.id
ORDER BY 
	total_deposit;