USE [dwh_brightlearn_sales]
GO

/****** Object:  StoredProcedure [dbo].[sp_Create_Fact_Sales]    Script Date: 2026/07/24 21:18:33 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE   PROCEDURE [dbo].[sp_Create_Fact_Sales]
AS
BEGIN
    SET NOCOUNT ON;

    IF NOT EXISTS
    (
        SELECT 1
        FROM sys.tables
        WHERE name = 'dwh_fact_sales'
          AND schema_id = SCHEMA_ID('dbo')
    )
    BEGIN
        CREATE TABLE dbo.dwh_fact_sales
        (
            sales_ID BIGINT IDENTITY(1,1) PRIMARY KEY,

            date_ID INT,
            customer_ID INT,
            store_ID INT,
            product_ID INT,
            payment_ID INT,
            cashier_ID INT,

            qty INT,
            line_amount DECIMAL(12,2),
            transaction_amount DECIMAL(12,2),
            transaction_discount DECIMAL(12,2),

            CONSTRAINT FK_FactSales_Date
                FOREIGN KEY (date_ID)
                REFERENCES dbo.dwh_dim_date(date_id),

            CONSTRAINT FK_FactSales_Customer
                FOREIGN KEY (customer_ID)
                REFERENCES dbo.dwh_dim_customer(customer_id),

            CONSTRAINT FK_FactSales_Store
                FOREIGN KEY (store_ID)
                REFERENCES dbo.dwh_dim_store(store_id),

            CONSTRAINT FK_FactSales_Product
                FOREIGN KEY (product_ID)
                REFERENCES dbo.dwh_dim_product(product_id),

            CONSTRAINT FK_FactSales_Payment
                FOREIGN KEY (payment_ID)
                REFERENCES dbo.dwh_dim_payment(payment_id),

            CONSTRAINT FK_FactSales_Cashier
                FOREIGN KEY (cashier_ID)
                REFERENCES dbo.dwh_dim_cashier(cashier_id)
        );

        PRINT 'dwh_fact_sales table created successfully.';
    END
    ELSE
    BEGIN
        PRINT 'dwh_fact_sales table already exists.';
    END
END;
GO

