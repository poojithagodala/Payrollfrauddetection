
> 💼 Payroll Fraud Detection System (SQL-Only)

> Theme: HR/Payroll Security
A robust, real-time SQL-based fraud detection system built to uncover anomalies in employee salary processing — **no external tools, just pure SQL logic**.

---

> Why It’s Unique?
- ✅ **No ML or external apps** — 100% SQL logic  
- ✅ Works with existing **HR & Payroll systems**  
- ✅ Supports **real-time alerts** using triggers  
- ✅ Logs all events in a centralized **audit table**  

---

> Problem Statement

Organizations are vulnerable to payroll fraud such as:  
- Employees sharing bank accounts (proxy payouts)  
- Ghost employees on payroll  
- Sudden, unjustified salary hikes  

This system automates detection of such patterns using SQL Server's built-in features.

---

> Fraud Types Detected

| Fraud Type             | Description                                                                 |
|------------------------|-----------------------------------------------------------------------------|
| Duplicate Accounts | Multiple employees linked to the same bank account                          |
| Ghost Employees   | No salary transaction for 3+ months                                         |
| Salary Spikes      | Salary increase > $2000 from previous payout                                |

---

> Schema Overview

> `EMPLOYEES`
| Column      | Type      |
|-------------|-----------|
| EMP_ID      | INT       |
| NAME        | VARCHAR   |
| BANK_ACC_NO | VARCHAR   |
| DEPT_ID     | INT       |
| JOIN_DATE   | DATE      |

> `SALARY_TRANSACTIONS`
| Column      | Type      |
|-------------|-----------|
| TRANS_ID    | INT       |
| EMP_ID      | INT       |
| AMOUNT      | DECIMAL   |
| TRANS_DATE  | DATE      |

> `AUDIT_LOGS`
| Column      | Type           |
|-------------|----------------|
| LOG_ID      | INT (IDENTITY) |
| EVENT_TYPE  | VARCHAR        |
| EMP_ID      | INT            |
| DETAILS     | VARCHAR        |
| LOG_DATE    | DATE           |

---

> Components

>> 1. `DetectPayrollFraud` (Stored Procedure)
- Scans all employees for anomalies  
- Logs results to `AUDIT_LOGS`  
- Can be scheduled via SQL Server Agent  

>> 2. `DetectSalaryFraud` (Trigger)
- Fires on salary insert  
- Checks for salary spikes and ghost employee behavior in real-time  

---

>> Sample Query: View Detected Fraud

```sql
SELECT * FROM AUDIT_LOGS
ORDER BY LOG_DATE DESC, EVENT_TYPE;
```

---

>> How to Use

1. Run the schema & sample inserts  
2. Deploy stored procedure and trigger  
3. Insert transactions normally  
4. Watch `AUDIT_LOGS` populate!  

---

>> Tech Stack

- SQL Server 2019+  
- T-SQL (Window Functions, Triggers, Procedures)  

---

>> - Poojitha Godala
