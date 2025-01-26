------------------------------------------------------------
--		        O T H E R    O B J E C T S                --
------------------------------------------------------------

REPLACE MACRO {{env}}_wrk.GET_CUSTOMER_SUMMARY (
    CUSTOMER_KEY INT
)
AS
(
    SELECT 
        CUSTOMER_KEY,
        CUSTOMER_NAME,
        GENDER,
        AGE,
        TOTAL_ORDERS,
        TOTAL_SPENT,
        START_DATE,
        END_DATE
    FROM {{env}}_sem_t.CUSTOMER_SUMMARY
    WHERE CUSTOMER_KEY = :CUSTOMER_KEY
    AND (END_DATE IS NULL OR END_DATE >= CURRENT_DATE)
    QUALIFY ROW_NUMBER() OVER (PARTITION BY CUSTOMER_KEY ORDER BY START_DATE DESC) = 1;
)
;
