WITH clv_estimation AS (
	SELECT
		owner_id AS customer_id,
		TIMESTAMPDIFF(MONTH, DATE(MIN(s.created_on)), '2025-04-18') AS tenure_months, 	
			/*	2025-04-18 is assumed as the last day where transaction_date
				information was collected for each customer	*/
		COUNT(s.transaction_date) AS total_transactions,
        ROUND(AVG(s.confirmed_amount * 0.001), 2) AS avg_profit_per_transaction
	FROM
		savings_savingsaccount s
	WHERE
		confirmed_amount >= 1
		AND transaction_status = 'success'
	GROUP BY
		owner_id
)

SELECT 
    c.customer_id,
	CONCAT(u.first_name, ' ', u.last_name) AS name,
	c.tenure_months,
	c.total_transactions,
	ROUND(((total_transactions/tenure_months) * 12 * avg_profit_per_transaction), 2) AS estimated_clv_naira
FROM
    clv_estimation c
LEFT JOIN 
	users_customuser u
ON
	c.customer_id = u.id
GROUP BY
    customer_id
ORDER BY
    estimated_clv_naira DESC;    
