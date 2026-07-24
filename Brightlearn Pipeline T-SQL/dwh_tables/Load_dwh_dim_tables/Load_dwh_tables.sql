USE [dwh_brightlearn_sales]
GO

/****** Object:  StoredProcedure [dbo].[sp_dwh_Load_Dimensions]    Script Date: 2026/07/24 21:13:47 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE   PROCEDURE [dbo].[sp_dwh_Load_Dimensions]
AS
BEGIN
    SET NOCOUNT ON;

    BEGIN TRY

        -- Customer Dimension
        INSERT INTO dbo.dwh_dim_customer
        (
            customer_email,
            first_name,
            last_name,
            phone,
            city,
            province,
            loyalty_tier,
            customer_since
        )
        SELECT DISTINCT
            s.customer_email,
            s.first_name,
            s.last_name,
            s.phone,
            s.city,
            s.province,
            s.loyalty_tier,
            TRY_CONVERT(DATE, s.customer_since)
        FROM [stg_brightlearn_sales].dbo.stg_dim_customer s
        WHERE NOT EXISTS
        (
            SELECT 1
            FROM dbo.dwh_dim_customer d
            WHERE d.customer_email = s.customer_email
        );

                -- Store Dimension
        INSERT INTO dbo.dwh_dim_store
        (
            store_name,
            store_city,
            store_province,
            store_region,
            store_manager
        )
        SELECT DISTINCT
            s.store_name,
            s.store_city,
            s.store_province,
            s.store_region,
            s.store_manager
        FROM [stg_brightlearn_sales].dbo.stg_dim_store s
        WHERE NOT EXISTS
        (
            SELECT 1
            FROM dbo.dwh_dim_store d
            WHERE d.store_name = s.store_name
              AND d.store_city = s.store_city
              AND d.store_province = s.store_province
        );

                -- Payment Dimension
         INSERT INTO dbo.dwh_dim_payment
        (
            payment_method
        )
        SELECT DISTINCT
            s.payment_method
        FROM [stg_brightlearn_sales].dbo.stg_dim_payment s
        WHERE NOT EXISTS
        (
            SELECT 1
            FROM dbo.dwh_dim_payment p
            WHERE p.payment_method = s.payment_method
        );
       
        -- Cashier Dimension
        INSERT INTO dbo.dwh_dim_cashier
        (
            cashier_name
        )
        SELECT DISTINCT
            s.cashier_name
        FROM [stg_brightlearn_sales].dbo.stg_dim_cashier s
        WHERE NOT EXISTS
        (
            SELECT 1
            FROM dbo.DWH_dim_cashier c
            WHERE c.cashier_name = s.cashier_name
        );

        -- Date Dimension
        INSERT INTO dbo.dwh_dim_date
        (
            date_id,
            full_date,
            day_num,
            month_num,
            month_name,
            quarter_num,
            year_num
        )
        SELECT
            s.date_id,
            s.full_date,
            s.day_num,
            s.month_num,
            s.month_name,
            s.quarter_num,
            s.year_num
        FROM [stg_brightlearn_sales].dbo.stg_dim_date s
        WHERE NOT EXISTS
        (
            SELECT 1
            FROM dbo.dwh_dim_date d
            WHERE d.date_id = s.date_id
        );

        -- Product Dimension
        INSERT INTO dbo.dwh_dim_product
        (
            sku,
            product_name,
            category,
            sub_category,
            supplier,
            unit_price,
            cost_price,
            stock_on_hand,
            reorder_threshold
        )
        SELECT
            s.sku,
            MAX(s.product_name),
            MAX(s.category),
            MAX(s.sub_category),
            MAX(s.supplier),
            MAX(TRY_CONVERT(DECIMAL(10,2), s.unit_price)),
            MAX(TRY_CONVERT(DECIMAL(10,2), s.cost_price)),
            MAX(TRY_CONVERT(INT, s.stock_on_hand)),
            MAX(TRY_CONVERT(INT, s.reorder_threshold))
        FROM [stg_brightlearn_sales].dbo.stg_dim_product s
        WHERE s.sku IS NOT NULL
        GROUP BY s.sku
        HAVING NOT EXISTS
        (
            SELECT 1
            FROM dbo.dwh_dim_product p
            WHERE p.sku = s.sku
        );

        PRINT 'Dimension load completed successfully.';

    END TRY
    BEGIN CATCH

        PRINT 'Error occurred while loading dimensions.';
        PRINT ERROR_MESSAGE();

    END CATCH
END;
GO

