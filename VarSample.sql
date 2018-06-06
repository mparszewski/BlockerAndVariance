CREATE OR REPLACE TYPE VarSample AS OBJECT (
    suma NUMBER,
    kwadrat_sumy NUMBER,
    licznik NUMBER,
  STATIC FUNCTION ODCIAggregateInitialize(actx IN OUT VarSample) 
    RETURN NUMBER,
  MEMBER FUNCTION ODCIAggregateIterate(self IN OUT VarSample, 
    val IN NUMBER) 
    RETURN NUMBER,
  MEMBER FUNCTION ODCIAggregateMerge(self IN OUT VarSample, 
        ctx2 IN VarSample) 
    RETURN NUMBER,
  MEMBER FUNCTION ODCIAggregateTerminate(self IN VarSample, 
    returnValue OUT NUMBER, flags IN NUMBER) 
    RETURN NUMBER
);
/
SHOW ERRORS


CREATE OR REPLACE TYPE BODY VarSample AS 
STATIC FUNCTION ODCIAggregateInitialize(actx IN OUT VarSample) 
    RETURN NUMBER IS 
    BEGIN
        IF actx IS NULL THEN
            actx := VarSample(0,0,0);
        ELSE
            actx.suma := 0;
            actx.kwadrat_sumy := 0;
            actx.licznik := 0;
        END IF;
    RETURN ODCIConst.Success;
END;

MEMBER FUNCTION ODCIAggregateIterate(self IN OUT VarSample, vaL IN NUMBER) RETURN NUMBER IS
    BEGIN
        self.suma := self.suma + val;
        self.kwadrat_sumy := self.kwadrat_sumy + (val*val);
        self.licznik := self.licznik + 1;
        RETURN ODCIConst.Success;
END;

MEMBER FUNCTION ODCIAggregateMerge(self IN OUT VarSample, ctx2 IN VarSample) RETURN NUMBER IS
    BEGIN
        self.suma := self.suma + ctx2.suma;
        self.kwadrat_sumy := self.kwadrat_sumy + ctx2.kwadrat_sumy;
        self.licznik := self.licznik + ctx2.licznik;
    RETURN ODCIConst.Success;
END;

MEMBER FUNCTION ODCIAggregateTerminate(self IN VarSample, 
    returnValue OUT NUMBER, flags IN NUMBER)RETURN NUMBER IS
    BEGIN
        IF licznik > 1 THEN
            returnValue := TO_NUMBER((self.kwadrat_sumy - ((self.suma*self.suma)/self.licznik))/(self.licznik-1));
        ELSE
            returnValue := NULL;
        END IF;
    RETURN ODCIConst.Success;
END;
END;
/
SHOW ERRORS


CREATE OR REPLACE FUNCTION VarSample2(input NUMBER)
RETURN NUMBER
AGGREGATE USING VarSample;
/
SHOW ERRORS;



DROP AGGREGATE FUNCTION VarSample;
DROP TYPE VarSample;


SELECT DEPARTMENT_ID, VAR_SAMP(SALARY) 
FROM EMPLOYEES
GROUP BY DEPARTMENT_ID 
ORDER BY DEPARTMENT_ID;

SELECT DEPARTMENT_ID, VarSample2(SALARY) 
FROM EMPLOYEES
GROUP BY DEPARTMENT_ID 
ORDER BY DEPARTMENT_ID;

