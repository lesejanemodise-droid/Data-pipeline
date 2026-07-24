USE [stg_brightlearn_sales]
GO

/****** Object:  StoredProcedure [dbo].[usp_Load_stg_brightlearn_sales_rawdata_Clean]    Script Date: 2026/07/24 21:10:26 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE   PROCEDURE [dbo].[usp_Load_stg_brightlearn_sales_rawdata_Clean]
AS
BEGIN
    SET NOCOUNT ON;

    -- Create clean staging table if it does not exist
    IF NOT EXISTS (
        SELECT 1
        FROM sys.tables
        WHERE name = 'usp_Load_stg_brightlearn_sales_rawdata_Clean'
    )
    BEGIN
        CREATE TABLE dbo.stg_brightlearn_sales_rawdata_Clean
        (
            transaction_date DATE,
            payment_method VARCHAR(50),
            cashier_name VARCHAR(100),
            transaction_amount DECIMAL(12,2),
            transaction_discount DECIMAL(12,2),
            customer_first_name VARCHAR(100),
            customer_last_name VARCHAR(100),
            customer_email VARCHAR(150),
            customer_phone VARCHAR(50),
            customer_city VARCHAR(100),
            customer_province VARCHAR(100),
            customer_loyalty_tier VARCHAR(50),
            customer_since DATE,
            store_name VARCHAR(100),
            store_city VARCHAR(100),
            store_province VARCHAR(100),
            store_region VARCHAR(100),
            store_manager VARCHAR(100),
            product_name VARCHAR(150),
            category VARCHAR(100),
            sub_category VARCHAR(100),
            sku VARCHAR(50),
            unit_price DECIMAL(12,2),
            cost_price DECIMAL(12,2),
            supplier VARCHAR(150),
            qty INT,
            line_amount DECIMAL(12,2),
            stock_on_hand INT,
            reorder_threshold INT
        );
        END;

    -- Clear existing clean data
    TRUNCATE TABLE dbo.stg_brightlearn_sales_rawdata_Clean;

    -- Clean and load data
    ;WITH CleanData AS
    (
        SELECT DISTINCT
            TRY_CONVERT(DATE, transaction_date) AS transaction_date,
            UPPER(LTRIM(RTRIM(payment_method))) AS payment_method,
            LTRIM(RTRIM(cashier_name)) AS cashier_name,
            ABS(ISNULL(transaction_amount,0)) AS transaction_amount,
            ISNULL(transaction_discount,0) AS transaction_discount,
            LTRIM(RTRIM(customer_first_name)) AS customer_first_name,
            LTRIM(RTRIM(customer_last_name)) AS customer_last_name,
            LOWER(LTRIM(RTRIM(customer_email))) AS customer_email,
            LTRIM(RTRIM(customer_phone)) AS customer_phone,
            LTRIM(RTRIM(customer_city)) AS customer_city,
            LTRIM(RTRIM(customer_province)) AS customer_province,
            UPPER(LTRIM(RTRIM(customer_loyalty_tier))) AS customer_loyalty_tier,
            TRY_CONVERT(DATE, customer_since) AS customer_since,
            LTRIM(RTRIM(store_name)) AS store_name,
            LTRIM(RTRIM(store_city)) AS store_city,
            LTRIM(RTRIM(store_province)) AS store_province,
            LTRIM(RTRIM(store_region)) AS store_region,
            LTRIM(RTRIM(store_manager)) AS store_manager,
            LTRIM(RTRIM(product_name)) AS product_name,
            LTRIM(RTRIM(category)) AS category,
            LTRIM(RTRIM(sub_category)) AS sub_category,
            UPPER(LTRIM(RTRIM(sku))) AS sku,
            unit_price,
            cost_price,
            LTRIM(RTRIM(supplier)) AS supplier,
            qty,
            ABS(ISNULL(line_amount,0)) AS line_amount,
            stock_on_hand,
            reorder_threshold,
            ROW_NUMBER() OVER
            (
                PARTITION BY
                    transaction_date,
                    customer_email,
                    sku,
                    qty,
                    line_amount
                ORDER BY transaction_date
            ) AS rn

        FROM [dbo].[stg_brightlearn_sales_rawdata]
    )

    INSERT INTO dbo.stg_brightlearn_sales_rawdata_Clean
    (
        transaction_date,
        payment_method,
        cashier_name,
        transaction_amount,
        transaction_discount,
        customer_first_name,
        customer_last_name,
        customer_email,
        customer_phone,
        customer_city,
        customer_province,
        customer_loyalty_tier,
        customer_since,
        store_name,
        store_city,
        store_province,
        store_region,
        store_manager,
        product_name,
        category,
        sub_category,
        sku,
        unit_price,
        cost_price,
        supplier,
        qty,
        line_amount,
        stock_on_hand,
        reorder_threshold
    )
    SELECT
        transaction_date,
        payment_method,
        cashier_name,
        transaction_amount,
        transaction_discount,
        customer_first_name,
        customer_last_name,
        customer_email,
        customer_phone,
        customer_city,
        customer_province,
        customer_loyalty_tier,
        customer_since,
        store_name,
        store_city,
        store_province,
        store_region,
        store_manager,
        product_name,
        category,
        sub_category,
        sku,
        unit_price,
        cost_price,
        supplier,
        qty,
        line_amount,
        stock_on_hand,
        reorder_threshold
    FROM CleanData
    WHERE rn = 1
      AND customer_email IS NOT NULL
      AND sku IS NOT NULL
      AND transaction_date IS NOT NULL;

    PRINT 'Staging data cleaned and loaded successfully.';
 END;
GO

