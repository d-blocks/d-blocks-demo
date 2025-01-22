REPLACE PROCEDURE {{env}}_wrk.POPULATE_CUSTOMER_SUMMARY()
BEGIN
    -- Declare error handling for any SQL exceptions
    DECLARE EXIT HANDLER FOR SQLEXCEPTION 
    BEGIN
        ROLLBACK; -- Rollback any partial changes in case of error
    END;

    -- Populate the CUSTOMER_SUMMARY table with aggregated data
    INSERT INTO {{env}}_sem_t.CUSTOMER_SUMMARY (
        CUSTOMER_KEY,
        CUSTOMER_NAME,
        GENDER,
        AGE,
        TOTAL_ORDERS,
        TOTAL_SPENT,
        START_DATE,
        END_DATE,
        CREATED_AT,
        UPDATED_AT
    )
    SELECT
        c.CUSTOMER_KEY,
        c.CUSTOMER_NAME,
        c.GENDER,
        CAST(CURRENT_DATE - c.DATE_OF_BIRTH AS INT) AS AGE,
        COALESCE(SUM(o.QUANTITY), 0) AS TOTAL_ORDERS,
        COALESCE(SUM(o.TOTAL_AMOUNT), 0) AS TOTAL_SPENT,
        CURRENT_DATE AS START_DATE,
        NULL AS END_DATE,
        CURRENT_TIMESTAMP AS CREATED_AT,
        CURRENT_TIMESTAMP AS UPDATED_AT
    FROM
        {{env}}_tgt_v.CUSTOMER_DIM c
    LEFT JOIN
        {{env}}_tgt_v.ORDER_FACT o
    ON
        c.CUSTOMER_KEY = o.CUSTOMER_KEY
    WHERE
        c.END_DATE IS NULL -- Only include current customers
    GROUP BY
        c.CUSTOMER_KEY, c.CUSTOMER_NAME, c.GENDER, c.DATE_OF_BIRTH;

    -- Commit the transaction
    COMMIT;
END
;
