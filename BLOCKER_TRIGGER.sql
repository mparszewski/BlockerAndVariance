create or replace TRIGGER NEGATTIVE_SALARY_BLOCKER
BEFORE INSERT OR UPDATE ON EMPLOYEES
FOR EACH ROW
DECLARE
    NEGATIVE_SALARY_EXCEPTION EXCEPTION;
BEGIN
    IF :NEW.SALARY < 0 THEN
        RAISE NEGATIVE_SALARY_EXCEPTION;
    END IF;

EXCEPTION
WHEN NEGATIVE_SALARY_EXCEPTION THEN
    RAISE_APPLICATION_ERROR(-20092, 'Podano ujemna wartosc wynagrodzenia');
END;
/
SHOW ERROR
        
--POPRAWNY UPDATE
UPDATE EMPLOYEES
SET SALARY = 1234
WHERE EMPLOYEE_ID = 543;

--NIEPOPRAWNY UPDATE
UPDATE EMPLOYEES
SET SALARY = -5800
WHERE EMPLOYEE_ID = 543;

--POPRAWNY INSERT
INSERT INTO EMPLOYEES(EMPLOYEE_ID, FIRST_NAME, LAST_NAME, EMAIL, PHONE_NUMBER, HIRE_DATE, JOB_ID, SALARY, COMMISSION_PCT, MANAGER_ID, DEPARTMENT_ID)
VALUES(544, 'Tomasz', 'Nowak','tnowak', '314234', '12/12/12', 'NoJob', 10000, 0, 120, 280); 

--NIEPOPRAWNY INSERT
INSERT INTO EMPLOYEES(EMPLOYEE_ID, FIRST_NAME, LAST_NAME, EMAIL, PHONE_NUMBER, HIRE_DATE, JOB_ID, SALARY, COMMISSION_PCT, MANAGER_ID, DEPARTMENT_ID)
VALUES(544, 'Tomasz', 'Nowak','tnowak', '314234', '12/12/12', 'NoJob', -5000, 0, 120, 280); 

SELECT * FROM EMPLOYEES;