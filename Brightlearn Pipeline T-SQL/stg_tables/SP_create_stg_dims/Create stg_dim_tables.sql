USE [stg_brightlearn_sales]
GO

/****** Object:  StoredProcedure [dbo].[sp_Create_stg_dimensions]    Script Date: 2026/07/24 21:07:26 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO




CREATE   PROCEDURE [dbo].[sp_Create_stg_dimensions]
AS
BEGIN
    SET NOCOUNT ON;

    -- Customer Dimension
    IF NOT EXISTS (
        SELECT 1
        FROM sys.tables
        WHERE name = 'stg_dim_customer'
          AND schema_id = SCHEMA_ID('dbo')
    )
    BEGIN
        CREATE TABLE dbo.stg_dim_customer
        (
            customer_ID INT IDENTITY(1,1) PRIMARY KEY,
            customer_email VARCHAR(150) UNIQUE,
            first_name VARCHAR(100),
            last_name VARCHAR(100),
            phone VARCHAR(50),
            city VARCHAR(100),
            province VARCHAR(100),
            loyalty_tier VARCHAR(50),
            customer_since DATE
        );
    END;

    -- Date Dimension
    IF NOT EXISTS (
        SELECT 1
        FROM sys.tables
        WHERE name = 'stg_dim_date'
          AND schema_id = SCHEMA_ID('dbo')
    )
    BEGIN
        CREATE TABLE dbo.stg_dim_date
        (
            date_ID INT PRIMARY KEY,
            full_date DATE,
            day_num INT,
            month_num INT,
            month_name VARCHAR(20),
            quarter_num INT,
            year_num INT
        );
    END;

    -- Store Dimension
    IF NOT EXISTS (
        SELECT 1
        FROM sys.tables
        WHERE name = 'stg_dim_store'
          AND schema_id = SCHEMA_ID('dbo')
    )
    BEGIN
        CREATE TABLE dbo.stg_dim_store
        (
            store_ID INT IDENTITY(1,1) PRIMARY KEY,
            store_name VARCHAR(100),
            store_city VARCHAR(100),
            store_province VARCHAR(100),
            store_region VARCHAR(100),
            store_manager VARCHAR(100)
        );
    END;

    -- Product Dimension
    IF NOT EXISTS (
        SELECT 1
        FROM sys.tables
        WHERE name = 'stg_dim_product'
          AND schema_id = SCHEMA_ID('dbo')
    )
    BEGIN
        CREATE TABLE dbo.stg_dim_product
        (
            product_ID INT IDENTITY(1,1) PRIMARY KEY,
            sku VARCHAR(50) UNIQUE,
            product_name VARCHAR(150),
            category VARCHAR(100),
            sub_category VARCHAR(100),
            supplier VARCHAR(150),
            unit_price DECIMAL(10,2),
            cost_price DECIMAL(10,2),
            stock_on_hand INT,
            reorder_threshold INT
        );
    END;

    -- Payment Dimension
    IF NOT EXISTS (
        SELECT 1
        FROM sys.tables
        WHERE name = 'stg_dim_payment'
          AND schema_id = SCHEMA_ID('dbo')
    )
    BEGIN
        CREATE TABLE dbo.stg_dim_payment
        (
            payment_ID INT IDENTITY(1,1) PRIMARY KEY,
            payment_method VARCHAR(50)
        );
    END;

    -- Cashier Dimension
    IF NOT EXISTS (
        SELECT 1
        FROM sys.tables
        WHERE name = 'stg_dim_cashier'
          AND schema_id = SCHEMA_ID('dbo')
    )
    BEGIN
        CREATE TABLE dbo.stg_dim_cashier
        (
            cashier_ID INT IDENTITY(1,1) PRIMARY KEY,
            cashier_name VARCHAR(100)
        );
    END;

    PRINT 'Dimension tables created successfully.';
END;
GO

