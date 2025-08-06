WITH transaction_analysis_per_month AS (	/* this CTE returns the average transaction amount and count per month for each 
												customer */
		SELECT
			u.id  AS owner_id,
			ROUND(AVG(s.confirmed_amount), 2) AS avg_transaction_per_month,
			COUNT(s.confirmed_amount) AS customer_count
		FROM
			savings_savingsaccount s
		JOIN
			users_customuser u
		ON 
			u.id = s.owner_id
		WHERE 
			confirmed_amount >= 1
            AND transaction_status = 'success'
		GROUP BY
			u.id, MONTH(transaction_date)
		ORDER BY
			u.id)

SELECT
	CASE 
		WHEN customer_count <= 2 THEN 'Low Frequency'
		WHEN customer_count BETWEEN 3 AND 9 THEN 'Medium Frequency'
		ELSE 'High Frequency'
	END AS frequency_category,
    avg_transaction_per_month,
    customer_count
FROM 
	transaction_analysis_per_month;