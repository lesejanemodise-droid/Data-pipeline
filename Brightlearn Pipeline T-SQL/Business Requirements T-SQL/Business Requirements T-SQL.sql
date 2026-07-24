--What were the top 5 best-selling products by total revenue between January and June 2024?
SELECT TOP 5
       p.product_name,
       p.category,
       SUM(fs.line_amount) AS total_revenue
FROM [dwh_brightlearn_sales].dbo.dwh_fact_sales fs
INNER JOIN stg_dim_product p
    ON fs.product_ID = p.product_ID
INNER JOIN stg_dim_date d
    ON fs.date_ID = d.date_ID
WHERE d.full_date BETWEEN '2024-01-01' AND '2024-06-30'AND p.category IS NOT NULL
GROUP BY
       p.product_name,
       p.category
ORDER BY
       total_revenue DESC;

----------------------------------------------------------------------------------------------

--What was the total revenue per store, broken down by month, for the January–June 2024 period?


SELECT
    s.store_name,
    SUM(CASE WHEN d.month_num = 1 THEN fs.line_amount ELSE 0 END) AS January,
    SUM(CASE WHEN d.month_num = 2 THEN fs.line_amount ELSE 0 END) AS February,
    SUM(CASE WHEN d.month_num = 3 THEN fs.line_amount ELSE 0 END) AS March,
    SUM(CASE WHEN d.month_num = 4 THEN fs.line_amount ELSE 0 END) AS April,
    SUM(CASE WHEN d.month_num = 5 THEN fs.line_amount ELSE 0 END) AS May,
    SUM(CASE WHEN d.month_num = 6 THEN fs.line_amount ELSE 0 END) AS June,
    SUM(fs.line_amount) AS Total_Revenue
FROM [dwh_brightlearn_sales].dbo.dwh_fact_sales fs
INNER JOIN stg_dim_store s
    ON fs.store_ID = s.store_ID
INNER JOIN stg_dim_date d
    ON fs.date_ID = d.date_ID
WHERE d.full_date BETWEEN '2024-01-01' AND '2024-06-30'
GROUP BY s.store_name
ORDER BY Total_Revenue DESC;

---------------------------------------------------------------------------------------------------------
--What is the month-over-month revenue growth rate across all stores combined?

WITH MonthlyRevenue AS
(
    SELECT
        d.year_num,
        d.month_num,
        d.month_name,
        SUM(fs.line_amount) AS total_revenue
    FROM [dwh_brightlearn_sales].dbo.dwh_fact_sales fs
    INNER JOIN stg_dim_date d
        ON fs.date_id = d.date_id
    WHERE d.full_date BETWEEN '2024-01-01' AND '2024-06-30'
    GROUP BY
        d.year_num,
        d.month_num,
        d.month_name
)
SELECT
    year_num,
    month_num,
    month_name,
    total_revenue,
    LAG(total_revenue) OVER (ORDER BY year_num, month_num) AS previous_month_revenue,

    ROUND(
        (
            (total_revenue -
             LAG(total_revenue) OVER (ORDER BY year_num, month_num))
            * 100.0
        ) /
        NULLIF(
            LAG(total_revenue) OVER (ORDER BY year_num, month_num),
            0
        ),
        2
    ) AS revenue_growth_rate_pct

FROM MonthlyRevenue
ORDER BY year_num, month_num;

----------------------------------------------------------------------------------------------------------------
--Who are the top 10 loyalty customers ranked by total spend over the reporting period?

SELECT TOP 10
       c.customer_id,
       c.first_name + ' ' + c.last_name AS customer_name,
       c.customer_email,
       c.loyalty_tier,
       SUM(fs.transaction_amount) AS total_spend
FROM [dwh_brightlearn_sales].dbo.dwh_fact_sales fs
INNER JOIN stg_dim_customer c
    ON fs.customer_id = c.customer_id
INNER JOIN stg_dim_date d
    ON fs.date_id = d.date_id
WHERE d.full_date BETWEEN '2024-01-01' AND '2024-06-30'
  AND c.loyalty_tier IS NOT NULL
GROUP BY
       c.customer_id,
       c.first_name,
       c.last_name,
       c.customer_email,
       c.loyalty_tier
ORDER BY
       total_spend DESC;

-----------------------------------------------------------------------------------------------------------
--Which registered loyalty customers have not made a purchase since 28 April 2024? These customers must be flagged for a targeted win-back campaign.

SELECT
    c.customer_id,
    c.first_name + ' ' + c.last_name AS customer_name,
    c.customer_email,
    c.loyalty_tier,
    MAX(d.full_date) AS last_purchase_date
FROM [dwh_brightlearn_sales].dbo.dwh_fact_sales fs
INNER JOIN stg_dim_customer c
    ON fs.customer_id = c.customer_id
INNER JOIN stg_dim_date d
    ON fs.date_id = d.date_id
WHERE c.loyalty_tier IS NOT NULL
GROUP BY
    c.customer_id,
    c.first_name,
    c.last_name,
    c.customer_email,
    c.loyalty_tier
HAVING MAX(d.full_date) <= '2024-04-28'
ORDER BY last_purchase_date ASC;

----------------------------------------------------------------------------------------------------------------
--What is the average transaction value broken down by customer loyalty tier (Bronze, Silver, Gold)?

SELECT
    c.loyalty_tier,
    COUNT(DISTINCT fs.sales_key) AS total_transactions,
    SUM(fs.transaction_amount) AS total_revenue,
    AVG(fs.transaction_amount) AS average_transaction_value
FROM [dwh_brightlearn_sales].dbo.dwh_fact_sales fs
INNER JOIN stg_dim_customer c
    ON fs.customer_id = c.customer_id
WHERE c.loyalty_tier IN ('BRONZE', 'SILVER', 'GOLD')
GROUP BY
    c.loyalty_tier
ORDER BY
    CASE c.loyalty_tier
        WHEN 'GOLD' THEN 1
        WHEN 'SILVER' THEN 2
        WHEN 'BRONZE' THEN 3
    END;

----------------------------------------------------------------------------------------------------------
--What is the total quantity sold per product category, per store, for the reporting period?


SELECT
    s.store_name,
    p.category,
    SUM(fs.qty) AS total_quantity_sold
FROM [dwh_brightlearn_sales].dbo.dwh_fact_sales fs
INNER JOIN stg_dim_store s
    ON fs.store_id = s.store_id
INNER JOIN stg_dim_product p
    ON fs.product_id = p.product_id
INNER JOIN stg_dim_date d
    ON fs.date_id = d.date_id
WHERE d.full_date BETWEEN '2024-01-01' AND '2024-06-30' AND Category IS NOT NULL
GROUP BY
    s.store_name,
    p.category
ORDER BY
    s.store_name,
    total_quantity_sold DESC;

-------------------------------------------------------------------------------------------------------------

--Based on the June 2024 inventory snapshot embedded in the source data, which store-product combinations currently have stock levels below their reorder threshold?


SELECT  DISTINCT
       s.store_name,
       p.sku,
       p.product_name,
       p.category,
       p.stock_on_hand,
       p.reorder_threshold,
       (p.reorder_threshold - p.stock_on_hand) AS units_to_reorder
FROM [dwh_brightlearn_sales].dbo.dwh_fact_sales fs
INNER JOIN stg_dim_store s
       ON fs.store_id = s.store_id
INNER JOIN stg_dim_product p
       ON fs.product_id = p.product_id
WHERE p.stock_on_hand < p.reorder_threshold
ORDER BY
       s.store_name,
       units_to_reorder DESC;

