	SELECT
		id AS plan_id,
		owner_id,
		CASE
			WHEN is_regular_savings = 1 THEN 'Savings'
			WHEN is_a_fund = 1 THEN 'Investment'
			ELSE 'Uknown'
			END AS type,
		CASE 
			WHEN last_charge_date IS NOT NULL THEN MAX(last_charge_date)
			ELSE 'No charge' 
			END AS last_transaction_date,
		CASE
			WHEN  last_charge_date IS NULL THEN DATEDIFF((SELECT MAX(last_charge_date) FROM plans_plan), MAX(start_date))
			ELSE DATEDIFF((SELECT MAX(last_charge_date) FROM plans_plan), MAX(last_charge_date)) END AS activity_days
	FROM
		plans_plan
	WHERE
		(is_regular_savings = 1 OR
		is_a_fund = 1)   -- this boolean expression determines if each plan is either a regular savings or investment plan
		AND 
		(is_archived = 0 OR  
		is_deleted = 0)  -- this boolean expression determines if each plan is active, i.e assuming, if equal to zero means active
	GROUP BY 
		owner_id, id, type, last_charge_date
	HAVING
		DATEDIFF((SELECT MAX(last_charge_date) FROM plans_plan), MAX(last_charge_date)) > 365 OR
		DATEDIFF((SELECT MAX(last_charge_date) FROM plans_plan), MAX(start_date)) > 365 AND last_charge_date IS NULL
        
UNION

	SELECT 
		plan_id,
		owner_id,
		'Savings' AS type,
		MAX(transaction_date) AS last_transaction_date,
		DATEDIFF((SELECT MAX(transaction_date) FROM savings_savingsaccount), MAX(transaction_date)) AS inactivity_days
			/* 	MAX(transaction_date) was used in calculating date difference, as opposed to CURDATE() because it was assumed
				as the last day where transaction information was collected	*/
	FROM 
		savings_savingsaccount   
	WHERE
		confirmed_amount > 1 
		AND transaction_status = 'success'
	GROUP BY 
		owner_id, plan_id
	HAVING
		DATEDIFF((SELECT MAX(transaction_date) FROM savings_savingsaccount), MAX(transaction_date)) > 365
	ORDER BY
		owner_id;    