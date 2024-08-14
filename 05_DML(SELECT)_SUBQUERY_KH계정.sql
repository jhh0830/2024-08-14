/*
    < SUBQUERY 서브쿼리 >
    
    하나의 주된 SQL 문 (SELECT, INSERTM UPDATE, DELETE, CREATE....)
    안에 "포함된 또 하나의 SELECT 문"
    즉, 메인 SQL 문을 위해 보조 역할을 하는 쿼리문
    
    하나의 주된 SQL 문 : 메인쿼리
    포함된 또 하나의 SELECT 문 : 서브쿼리 - 1 (먼저 실행)
    
*/

-- 서브쿼리 맛보기 수업
-- 간단 서브쿼리 예시 1
-- 권가영 사원과 같은 부서인 사원들
-- 1) 먼저 권가영 사원이 부서코드 조회
SELECT DEPT_CODE
FROM EMPLOYEE
WHERE EMP_NAME = '권가영';
--> 권가영 사원의 부서코드는 D9임!!
-- 2) 부서코드가 D9 인 사원들 조회
SELECT EMP_NAME
FROM EMPLOYEE
WHERE DEPT_CODE = 'D9';

-- 위의 두 단계를 하나의 쿼리문으로 합치기
SELECT EMP_NAME
FROM EMPLOYEE
WHERE DEPT_CODE = (SELECT DEPT_CODE
                    FROM EMPLOYEE
                    WHERE EMP_NAME = '권가영');

-- 간단 서브쿼리 예시 2
-- 전체 사원의 평균 급여보다 더 많은 급여를 받고 있는
-- 사원들의 사번, 이름, 직급코드를 조회
-- 1) 먼저 전체 사원들의 평균 급여 구하기
SELECT AVG(SALARY)
FROM EMPLOYEE;
--> 평균 급여가 대략 3047662 원 임!!

-- 2) 급여가 2047662 원 이상인 사원들을 조회
SELECT EMP_ID, EMP_NAME, JOB_CODE
FROM EMPLOYEE
WHERE SALARY >= 3047662;

-- 위의 두 단계를 하나의 쿼리문으로 합치기
SELECT EMP_ID, EMP_NAME, JOB_CODE
FROM EMPLOYEE
WHERE SALARY >=(SELECT AVG(SALARY)
FROM EMPLOYEE);

--------------------------------------------------------------


/*
    * 서브쿼리의 구분 (종류)
    서브쿼리 부분만 실행했을 때 그 결과가 몇행 명열이냐 에 따라서 구분됨
    
    사람에 따라서 ()를 생략하고 부르기도 함 / 다중행 다중열 서브쿼리는 아님
    - 단일행 (단일열) 서브쿼리 : 서브쿼리를 수행한 결과가 오로지 1개 일 때
    - 다중행 (단일열) 서브쿼리 : 서브쿼리를 수행한 결과가 여러 행일 때 (1열)
    - (단일행) 다중열 서브쿼리 : 서브쿼리를 수행한 결과가 여러 열일 때 (1행)
    - 다중행 다중열 서브쿼리 : 서브쿼리를 수행한 결과가 여러 행 여러 열일 때
    
    => 서브쿼리를 수행한 결과가 몇행 몇열이냐에 따라
       메인쿼리에서 사용할 수 있는 연산자가 달라진다!!
       
    
*/

/*
    1. 단일행 (단일열) 서브쿼리
    서브쿼리의 조회 결과값이 오로지 1개일 때 (1행 1열일 때)
    
    일반적인 연산자 사용 가능 (=, !=, <=, >, ...)
    
*/

-- 전 직원의 평균 급여보다 더 적게 받는 사원들의 사원명, 직급코드, 급여 조회
-- 1) 먼저 평균급여 구하기
SELECT AVG(SALARY)
FROM EMPLOYEE;

-- 2) 그 평균 급여보다 적게받는 사원을 구하는 쿼리 짜기
SELECT EMP_NAME, JOB_CODE, SALARY
FROM EMPLOYEE
WHERE SALARY < (SELECT AVG(SALARY)
FROM EMPLOYEE); -- 결과값 1행 1열

--> 항상 서브쿼리는 ()로 묶어서 표현한다!!

-- 최저 급여를 받는 사원의 사번, 사원명, 직급코드, 급여, 입사일 조회
-- 1) 먼저 최저급여 부터 알아내기
SELECT MIN(SALARY)
FROM EMPLOYEE;

-- 2) 그 최저급여를 받는 사원의 정보 구하기
SELECT EMP_ID, EMP_NAME, JOB_CODE, SALARY, HIRE_DATE
FROM EMPLOYEE
WHERE SALARY  = (SELECT MIN(SALARY)
FROM EMPLOYEE); -- 결과값 1행 1열


-- 김동준 사원의 급여보다 더 많이 받는 사원들의 사번, 이름, 부서코드, 급여 조회

SELECT EMP_ID, EMP_NAME, DEPT_CODE, SALARY
FROM EMPLOYEE
WHERE SALARY >=(SELECT SALARY
FROM EMPLOYEE
WHERE EMP_NAME='김동준');

-- 김동준 사원의 급여보다 더 많이 받는 사원들의 사번, 이름, 부서코드, 급여 조회
-->> 오라클 전용 구문
SELECT EMP_ID, EMP_NAME, NVL(DEPT_TITLE, '미정'), SALARY
FROM EMPLOYEE, DEPARTMENT
WHERE DEPT_CODE = DEPT_ID(+) -- 연결고리에 대한 조건
AND SALARY >= (SELECT SALARY
FROM EMPLOYEE
WHERE EMP_NAME='김동준');-- 추가적인 조건

-->> ANSI 구문
SELECT EMP_ID, EMP_NAME,  NVL(DEPT_TITLE, '미정'), SALARY
FROM EMPLOYEE
LEFT JOIN DEPARTMENT ON ( DEPT_CODE = DEPT_ID) 
WHERE SALARY >= (SELECT SALARY
FROM EMPLOYEE
WHERE EMP_NAME='김동준');

--> 조인, 그동안 배웠던 연산자, 함수식 등 다양하게 조합 후 사용 가능!!

-- 정원섭 사원과 같은 부서의 사원들의 사번, 이름, 전화번호, 직급명
-->> 오라클 전용 구문
SELECT E.EMP_ID, E.EMP_NAME, E.PHONE, J.JOB_NAME
FROM EMPLOYEE E, JOB J
WHERE E.JOB_CODE = J.JOB_CODE AND DEPT_CODE = (SELECT DEPT_CODE
FROM EMPLOYEE
WHERE EMP_NAME='정원섭')AND EMP_NAME != '정원섭';
-->>ANSI 구문
SELECT E.EMP_ID, E.EMP_NAME, E.PHONE, J.JOB_NAME
FROM EMPLOYEE E
JOIN JOB J USING (JOB_CODE)
WHERE DEPT_CODE = (SELECT DEPT_CODE
FROM EMPLOYEE
WHERE EMP_NAME='정원섭') AND EMP_NAME != '정원섭';

-- 부서별 급여 합이 가장 큰 부서 하나만을 조회 (부서코드, 부서명, 급여합)
-- 1) 부서별 급여 합 먼저 구하기
SELECT DEPT_CODE, SUM(SALARY)
FROM EMPLOYEE
GROUP BY DEPT_CODE;
-- > DEPT_CODE 컬럼을 기준으로 그룹지어서 각 부서별 급여 합 먼저 구함
-- 2) 급여 합이 가장 큰 부서를 찾기
SELECT MAX(SUM(SALARY))
FROM EMPLOYEE
GROUP BY DEPT_CODE;
-- 3) 해당 급여액의 부서의 정보를 구하기
SELECT DEPT_CODE, DEPT_TITLE , SUM(SALARY)
FROM EMPLOYEE
JOIN DEPARTMENT ON (DEPT_CODE = DEPT_ID)
GROUP BY DEPT_CODE, DEPT_TITLE
HAVING SUM(SALARY) = (SELECT MAX(SUM(SALARY))
                        FROM EMPLOYEE
                    GROUP BY DEPT_CODE);-- SUM(SALARY) 가 17700000인 
--------------------------------------------------------------------------------
/*
    2. 다중행 (단일열) 서브쿼리 (MULTI ROW SUBQUERY)
    서브쿼리의 조회 결과값이 여러행 1열짜리일 때
    
    - IN (서브쿼리) : 여러개의 결과값 중에서 한개라도 일치할 경우
      NOT IN (서브쿼리) : "없으면" 이라는 의미 
      
      
    - > ANY(서브쿼리) : 여러개의 결과값 중에서 "하나라도" 클 경우
                       즉, 여러개의 결과값 중에서 가장 작은값보다 클 경우
    - < ANY(서브쿼리) : 여러개의 결과값 중에서 "하나라도" 작을 경우
                       즉, 여러개의 결과값 중에서 가장 큰값보다 작을 경우
                         
    
    
    
    - > ALL (서브쿼리) : 여러개의 결과값의 "모든" 값보다 클 경우
                        즉, 여러개의 결과값 중에서 가장 큰값보다 클 경우
    - < ALL (서브쿼리) : 여러개의 결과값의 "모든" 값 보다 작을 경우
                        즉, 여러개의 결과값 중에서 가장 작은값보다 작을 경우
  
  <=, >= 또한 ANY, ALL 에서 사용 가능함!!  
*/
-- 각 부서별 최고급여를 받는 사원의 이름, 직급코드, 급여 조회   
-- 1) 각 부서별 최고급여 먼저 구하기
SELECT MAX(SALARY)
FROM EMPLOYEE
GROUP BY DEPT_CODE;
--> (289000,3660000, 8000000, 3760000, 3900000, 2490000, 2550000)

--2) 위의 급여액을 받는 사원들 조회
SELECT EMP_NAME, JOB_CODE, SALARY
FROM EMPLOYEE
WHERE SALARY IN (2890000 ,3660000, 8000000, 3760000, 3900000, 2490000, 2550000);
                    
-- 위의 두 퀴리를 합치기
SELECT EMP_NAME, JOB_CODE, SALARY
FROM EMPLOYEE
WHERE SALARY IN (SELECT MAX(SALARY)
                FROM EMPLOYEE
                GROUP BY DEPT_CODE); -- 결과값 7행 1열
-- 김민석 또는 윤예원 사원과 같은 부서인 사원들 조회 (사원명, 부서코드, 급여)
-- 1) 김민석, 윤예원 사원의 부서코드 먼저 구하기
SELECT DEPT_CODE
FROM EMPLOYEE
--WHERE EMP_NAME = '김민석' OR EMP_NAME = '윤예원'
WHERE EMP_NAME IN ('김민석','윤예원');
--2) 위의 부서에 소속된 사원을 구하기
SELECT EMP_NAME, DEPT_CODE, SALARY
FROM EMPLOYEE
WHERE EMP_NAME IN ('D6','D8');

SELECT EMP_NAME, DEPT_CODE, SALARY
FROM EMPLOYEE
WHERE EMP_NAME IN (
SELECT EMP_NAME 
FROM EMPLOYEE
WHERE EMP_NAME IN ('김민석','윤예원'));

-- 사원< 대리<과장<차장<부장
-- 대리직급임에도 불구하고 과장직급의 급여보다 더 많이 받는 직원 조회
-- (사번, 이름, 직급명, 급여)

-- 1) 과장 직급들의 급여 먼저 조회
SELECT SALARY
FROM EMPLOYEE E, JOB J
WHERE E.JOB_CODE = J.JOB_CODE -- 연결고리에 대한 조건
AND JOB_NAME  = '과장'; -- 추가적인 조건
--> (2200000, 2500000,3760000)

-- 2) 위의 급여들보다 높은 급여를 받는 직원들 조회
-- (그냥 과장보다만 급여 많이 받으면 됨)
SELECT EMP_ID, EMP_NAME, JOB_NAME, SALARY
FROM EMPLOYEE E, JOB J
WHERE E.JOB_CODE = J.JOB_CODE--연결고리에 대한 조건 기술 
AND SALARY > ANY (2200000, 2500000,3760000);

-- 3) 위의 내용들을 하나로 합쳐기 + 대리들만 조회
SELECT EMP_ID, EMP_NAME, JOB_NAME, SALARY
FROM EMPLOYEE E, JOB J
WHERE E.JOB_CODE = J.JOB_CODE
AND SALARY > ANY(SELECT SALARY
FROM EMPLOYEE E, JOB J
WHERE E.JOB_CODE = J.JOB_CODE -- 연결고리에 대한 조건
AND JOB_NAME  = '과장')AND J.JOB_NAME = '대리';
-- > 시간 날때 ANSI 구문으로도 바꿔보기

-- 사원 < 대리 < 과장 < 차장 < 부장
-- 과장직급임에도 불구하고 모든 차장직급의 급여보다도 더 많이 받는 직원들 조회
-- (사번, 이름, 직급명, 급여)
-- 1) 차장직급들의 급여 먼저 조회
SELECT SALARY
FROM EMPLOYEE
JOIN JOB USING (JOB_CODE)
WHERE JOB_NAME= '차장';
-- > (2800000,1550000,2490000,2480000)

-- 2) 위의 모든 급여보다도 더 많이받는 사람들만 조회
SELECT EMP_ID, EMP_NAME, JOB_NAME, SALARY
FROM EMPLOYEE
JOIN JOB USING (JOB_CODE)
WHERE SALARY > ALL (2800000,1550000,2490000,2480000);

-- 3) 위의 두 단계 합치기 + 과장직급만 조회
SELECT EMP_ID, EMP_NAME, JOB_NAME, SALARY
FROM EMPLOYEE
JOIN JOB USING (JOB_CODE)
WHERE SALARY > ALL (SELECT SALARY
FROM EMPLOYEE
JOIN JOB USING (JOB_CODE)
WHERE JOB_NAME= '차장') -- 결과값 4행 1열
AND JOB_NAME = '과장';
-- > 오라클 전용 구문으로 바꿔보기
------------------------------------------------------------
/*
    3. (단일행) 다중열 서브쿼리
    조회 결과값은 한행이지만 나열된 컬럼 수가 여러개일 때
    (상황에 따라서 단일행 서브쿼리로 대체 가능하다)
    
    
*/
  
  
-- 김동현 사원과 같은 부서코드, 같은 직급코드에 해당하는 사원들 조회
-- 김동현 사원의 부서코드와 직급코드 
SELECT DEPT_CODE ,JOB_CODE
FROM EMPLOYEE
WHERE EMP_NAME = '김동현'; -- 'D6'/ 'J3'

-- 부서코드가 D6이면서 직급코드가 J3인 사원들 조회
-- (이름, 부서코드, 직급코드, 입사일)

SELECT EMP_NAME,DEPT_CODE,JOB_CODE, HIRE_DATE
FROM EMPLOYEE
WHERE DEPT_CODE = 'D6'
AND JOB_CODE = 'J3';

-- 위의 내용들을 하나의 쿼리문으로 합치기
-- 단일행 단일열 서브쿼리 버전으로
SELECT EMP_NAME, DEPT_CODE, JOB_CODE, HIRE_DATE
FROM EMPLOYEE
WHERE DEPT_CODE = (SELECT DEPT_CODE
                    FROM EMPLOYEE
                    WHERE EMP_NAME = '김동현')
                    AND JOB_CODE=(SELECT JOB_CODE
                                    FROM EMPLOYEE
                                    WHERE EMP_NAME = '김동현');

-- 단일행 다중열 서브쿼리 버전으로
SELECT EMP_NAME, DEPT_CODE, JOB_CODE, HIRE_DATE
FROM EMPLOYEE
WHERE (DEPT_CODE, JOB_CODE)= (SELECT DEPT_CODE ,JOB_CODE
FROM EMPLOYEE
WHERE EMP_NAME = '김동현'); -- 결과값 1행 2열


-- 김형문 사원과 같은 부서코드, 같은 직급코를 가진 사원들
-- 사번, 이름, 직급코드, 사수사번
SELECT EMP_ID, EMP_NAME, JOB_CODE, MANAGER_ID
FROM EMPLOYEE
WHERE (DEPT_CODE,JOB_CODE) = (SELECT DEPT_CODE, JOB_CODE
                                FROM EMPLOYEE
                                WHERE EMP_NAME ='김형문');
-- 박진홍 사원과 직급코드, 같은 사수 사번을 가진 사원들
-- 사번, 이름, 직급코드, 사수 사번
SELECT EMP_ID, EMP_NAME, JOB_CODE, MANAGER_ID
FROM EMPLOYEE
WHERE (JOB_CODE , MANAGER_ID) = (SELECT JOB_CODE, MANAGER_ID
                                  FROM EMPLOYEE
                                  WHERE EMP_NAME='박진홍');

-------------------------------------------------
/*
    4. 다중행 다중열 서브쿼리
    서브쿼리 조회 결과가 여러행 여러컬림일 경우
*/

-- 각 직급별 최소 급여를 받는 사원들 조회
-- 사번, 이름, 직급코드, 급여

--각 직급별 최소 급여 조회
SELECT JOB_CODE, MIN(SALARY)
FROM EMPLOYEE
GROUP BY JOB_CODE;

/*
    J2	3700000
    J7	1380000
    J3	3400000
    J6	2000000
    J5	2200000
    J1	8000000
    J4	1550000

*/

-- 위의 목록중에 일치하는 사원들
SELECT EMP_ID, EMP_NAME, JOB_CODE, SALARY
FROM EMPLOYEE
/*
WHERE (JOB_CODE, SALARY) = ('J2', 3700000)
    OR(JOB_CODE, SALARY) = ('J7', 1380000)
    OR(JOB_CODE, SALARY) = ('J3', 3400000)
    OR(JOB_CODE, SALARY) = ('J6', 2000000)
    OR(JOB_CODE, SALARY) = ('J5', 2200000)
    OR(JOB_CODE, SALARY) = ('J1', 8000000)
    OR(JOB_CODE, SALARY) = ('J4', 1550000);
*/

--> 컬럼값 여러개를 한번에 묶어서 동등비교 불가!!(문법에 맞지 않음)
WHERE  (JOB_CODE, SALARY) IN (('J2', 3700000),
                                ('J7', 1380000),
                                ('J3', 3400000),
                                ('J6', 2000000),
                                ('J5', 2200000),
                                ('J1', 8000000),
                                ('J4', 1550000));
--> IN 연산자는  가능 함(한번에 묵어서 동등비교)

-- 다중행 다중열 서브쿼리 버전으로
SELECT EMP_ID, EMP_NAME, JOB_CODE, SALARY
FROM EMPLOYEE
WHERE (JOB_CODE, SALARY) IN (SELECT JOB_CODE, MIN(SALARY)
FROM EMPLOYEE
GROUP BY JOB_CODE);


-- 각 부서별 최고 급여를 받는 사원들의 사번, 이름, 부서코드, 급여
-- 먼저 각 부서별 최고급 조회
SELECT DEPT_CODE, MAX(SALARY)
FROM EMPLOYEE
GROUP BY DEPT_CODE;
/*
    NULL	2890000
    D1	    3660000
    D9	    8000000
    D5	    3760000
    D6	    3900000
    D2	    2490000
    D8	    2550000
*/
    
-- 위의 부서별 급여를 받는 사원들 조회
SELECT EMP_ID, EMP_NAME, NVL(DEPT_CODE,'없음'), SALARY
FROM EMPLOYEE
WHERE (NVL(DEPT_CODE,'없음'), SALARY) IN (SELECT NVL(DEPT_CODE,'없음'), MAX(SALARY)
FROM EMPLOYEE
GROUP BY DEPT_CODE)
ORDER BY SALARY DESC;


--> IN 연산자를 통해 동등비교 시 주의할점
--  NULL 은 비교연산이 불가능함!! 해결하려면 NVL 함수 등을 활용하자


---------------------------------------------------------------------------

/*
    (결이 조금 다름)
    5. 인라인 뷰 (INLINE VIEW)
    FROM 절에 서브쿼리를 제시하는 것 (테이블명 대신에)
    
    FROM 테이블명
    FROM (서브쿼리)
    => 서브쿼리를 수행한 결과 (RESULT SET) 를 테이블 대신 사용하겠다.
    
       
*/
-- 보너스 포함 연봉이 3000만원 이상인 사원들의 
-- 사번, 이름, 보너스포함연봉, 부서코드를 조회
--> 인라인뷰를 안쓸 경우
SELECT EMP_ID
     , EMP_NAME
     , (SALARY + SALARY * NVL(BONUS,0)) * 12 "보너스 포함 연봉"
     , DEPT_CODE
     FROM EMPLOYEE
     WHERE(SALARY+SALARY *BONUS) *12 >= 30000000;

-->> 인라인뷰를 쓸경우
SELECT EMP_ID,EMP_NAME, "보너스 포함 연봉", DEPT_CODE
FROM (SELECT EMP_ID
           , EMP_NAME
           , (SALARY+ SALARY * NVL(BONUS, 0)) * 12"보너스 포함 연봉"
           , DEPT_CODE
           FROM EMPLOYEE)
     WHERE "보너스 포함 연봉" >= 30000000;
--> FROM 절의 서브쿼리 (인라인 뷰) 에서
-- 이미 컬럼에 별칭을 부여하고 조회를 시작하기 때문에
-- WHERE 절의 조건식에서도 별칭 사용 가능!!


-->> 인라인 뷰를 주로 사용하는 예시
--   TOP-N 분석 : 데이터베이스 상의 데이터들 중
--               "최상위 몇개의 자료" 를 보기 위해 사용하는 기법
--      예) 급여가 가장 높은 3명
--      근속 년수가 가장 긴 5명
--      입사일이 제일 최근인 10명


-- 전 직원 중 급여가 가장 높은 상위 5명
-- ROWNUM : 오르칼에서 기본적으로 제공해주는 컬럼
--          조회된 순서대로 1에서 부터 순번을 부여해줌!!

SELECT ROWNUM, EMP_NAME, SALARY -- 3
FROM EMPLOYEE                   -- 1
WHERE ROWNUM <= 5               -- 2
ORDER BY SALARY DESC;           -- 4
--> TOP-N 분석의 핵심은 ORDER BY 로 먼저 정렬 후
-- ROWNUM으로 위에서부터 N개를 잘라내야함
--> 인라인뷰를 쓰지 않으면 항상 ORDER BY 절이 마지막에 실행되기 때문에
--  제대로 된 TOP-N 분석을 할 수 없게됨!!


--  ORDER BY 로 정렬한 RESULT SET 을 가지고
-- 메인 쿼리에서 상위 N 개만 추려내기
SELECT ROWNUM"순번", EMP_NAME "사원명",SALARY"급여" -- 5
FROM (SELECT *                                   -- 2  
        FROM EMPLOYEE                            -- 1
        ORDER BY SALARY DESC)                    -- 3
        WHERE ROWNUM <= 5;                       -- 4
--> 핵심은 ORDER BY 절이 WHERE 절보다 먼저 실행되게 유도하는것!!

-- 인라인 뷰 사용 시 노하우
SELECT ROWNUM,E.EMP_ID, E.EMP_NAME, E.SALARY --E.*
FROM (SELECT *
        FROM EMPLOYEE
        ORDER BY SALARY DESC) E
WHERE ROWNUM <= 5;
--> 인라인 뷰에도 별칭 부여 가능!!
-- 별칭 부여 후 별칭.컬럼명 제시 가능,
-- 별칭.* 제시 시 해당 RESULT SET의 모든컬럼을 다 조회하겠다. 의미

-- 각 부서별 평균 급여가 높은 3개의 부서의 부서코드, 평균 급여 조회
SELECT ROWNUM, DEPT_CODE, "평균 급여"
FROM(SELECT DEPT_CODE, AVG(SALARY) "평균 급여"
     FROM EMPLOYEE
     GROUP BY DEPT_CODE
     ORDER BY AVG(SALARY) DESC)
 WHERE ROWNUM <= 3;
 
--> 인라인 뷰 내부에 함수식이 포함되어있다면
-- 컬럼에 별칭을 반드시 붙여줘야 한다!!

-- 가장 최근에 입사한 사원 5명 조회 (사원명, 급여, 입사일)
SELECT ROWNUM, E.*
FROM (SELECT EMP_NAME, SALARY, HIRE_DATE
        FROM EMPLOYEE
        ORDER BY HIRE_DATE DESC) E
    WHERE ROWNUM <= 5;
--> SELECT * 에 다른 컬럼명을 추가해서 나열 불가능!!
-- 즉, SELECT 컬럼명, * (X)
-- 단, SELECT 별칭.* , 다른 컬럼명 (O)


--> 인라인뷰가 많이 쓰이는 예시 : 게시판

----------------------------------------------
/*
    * 순위 매기는 함수
    
    RANK() OVER(정렬기준) : 공동 1위가 3명이라고 한다면 그 다음 순위가 4위
    DENSE_RNAK() OVER(정렬기준) : 공동 1위가 3명이라고 해도 그 다음 순위는 여전히 2위
    
    => 순위를 매기는 함수를 WINDOW FUNCTION 이라고 부른다.
    단, WINDOW FUNCTION 은 SELECT 절에서만 사용 가능!!
    
*/

-- 사원들의 급여가 높은 순대로 매겨서 사원명, 급여, 순위 조회
SELECT ROWNUM, EMP_NAME, SALARY
FROM EMPLOYEE
ORDER BY SALARY DESC;
--> ORDER BY 절이 마지막에 실행되기 때문에 순위가 뒤죽박죽임!!

SELECT RANK() OVER(ORDER BY SALARY DESC) "순위"
     , EMP_NAME
     , SALARY 
     FROM EMPLOYEE;
--> 공동 19 위 2명, 그 다음 순위는 21위

SELECT DENSE_RANK() OVER(ORDER BY SALARY DESC) "순위"
        , EMP_NAME
        , SALARY
        FROM EMPLOYEE;
--> 공동 19위 2명, 그 다음 순위는 20위

-- 순위를 매기는 함수를 이용해서 TOP-N 분석 또한 가능하다.
-- 급여가 가장 높은 5명만 조회
SELECT EMP_NAME
     , SALARY
     , RANK() OVER(ORDER BY SALARY DESC) "순위"
FROM EMPLOYEE
WHERE RANK() OVER(ORDER BY SALARY DESC) <= 5;
--> 오류 : 왼도우 함수는 SELECT 절에서만 사용 가능
--          WHERE 절에 기술해서 오류남!!
-- 인라인뷰를 사용하면 바로 해결 가능함

SELECT *
FROM (SELECT  RANK() OVER(ORDER BY SALARY DESC) "순위"
     , SALARY
     , EMP_NAME
     FROM EMPLOYEE)
 WHERE  순위 <= 5;   
 
