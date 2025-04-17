CREATE PROCEDURE DetectPayrollFraud
AS
BEGIN
  SET NOCOUNT ON;

  DECLARE @today DATE = GETDATE();

  -- 1. Duplicate Bank Accounts
  INSERT INTO AUDIT_LOGS (EVENT_TYPE, EMP_ID, DETAILS, LOG_DATE)
  SELECT 
    'Duplicate Bank Account',
    E.EMP_ID,
    'Bank account ' + E.BANK_ACC_NO + ' is shared by multiple employees.',
    @today
  FROM EMPLOYEES E
  WHERE E.BANK_ACC_NO IN (
    SELECT BANK_ACC_NO
    FROM EMPLOYEES
    GROUP BY BANK_ACC_NO
    HAVING COUNT(DISTINCT EMP_ID) > 1
  );

  -- 2. Ghost Employees (No salary in last 3 months)
  INSERT INTO AUDIT_LOGS (EVENT_TYPE, EMP_ID, DETAILS, LOG_DATE)
  SELECT 
    'Ghost Employee',
    E.EMP_ID,
    'No salary transactions in the last 3 months.',
    @today
  FROM EMPLOYEES E
  LEFT JOIN SALARY_TRANSACTIONS S 
    ON E.EMP_ID = S.EMP_ID 
    AND S.TRANS_DATE > DATEADD(MONTH, -3, GETDATE())
  WHERE S.TRANS_ID IS NULL;

  -- 3. Salary Spikes
  WITH SalaryDiffs AS (
    SELECT EMP_ID, 
           TRANS_DATE, 
           AMOUNT,
           LAG(AMOUNT) OVER (PARTITION BY EMP_ID ORDER BY TRANS_DATE) AS PREV_SAL
    FROM SALARY_TRANSACTIONS
  )
  INSERT INTO AUDIT_LOGS (EVENT_TYPE, EMP_ID, DETAILS, LOG_DATE)
  SELECT 
    'Salary Spike',
    EMP_ID,
    'Salary increased by ' + CAST(ABS(AMOUNT - PREV_SAL) AS NVARCHAR) + ' on ' + CAST(TRANS_DATE AS NVARCHAR),
    @today
  FROM SalaryDiffs
  WHERE ABS(AMOUNT - PREV_SAL) > 2000;

END;
