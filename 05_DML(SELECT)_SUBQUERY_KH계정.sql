/*
    < SUBQUERY �������� >
    
    �ϳ��� �ֵ� SQL �� (SELECT, INSERTM UPDATE, DELETE, CREATE....)
    �ȿ� "���Ե� �� �ϳ��� SELECT ��"
    ��, ���� SQL ���� ���� ���� ������ �ϴ� ������
    
    �ϳ��� �ֵ� SQL �� : ��������
    ���Ե� �� �ϳ��� SELECT �� : �������� - 1 (���� ����)
    
*/

-- �������� ������ ����
-- ���� �������� ���� 1
-- �ǰ��� ����� ���� �μ��� �����
-- 1) ���� �ǰ��� ����� �μ��ڵ� ��ȸ
SELECT DEPT_CODE
FROM EMPLOYEE
WHERE EMP_NAME = '�ǰ���';
--> �ǰ��� ����� �μ��ڵ�� D9��!!
-- 2) �μ��ڵ尡 D9 �� ����� ��ȸ
SELECT EMP_NAME
FROM EMPLOYEE
WHERE DEPT_CODE = 'D9';

-- ���� �� �ܰ踦 �ϳ��� ���������� ��ġ��
SELECT EMP_NAME
FROM EMPLOYEE
WHERE DEPT_CODE = (SELECT DEPT_CODE
                    FROM EMPLOYEE
                    WHERE EMP_NAME = '�ǰ���');

-- ���� �������� ���� 2
-- ��ü ����� ��� �޿����� �� ���� �޿��� �ް� �ִ�
-- ������� ���, �̸�, �����ڵ带 ��ȸ
-- 1) ���� ��ü ������� ��� �޿� ���ϱ�
SELECT AVG(SALARY)
FROM EMPLOYEE;
--> ��� �޿��� �뷫 3047662 �� ��!!

-- 2) �޿��� 2047662 �� �̻��� ������� ��ȸ
SELECT EMP_ID, EMP_NAME, JOB_CODE
FROM EMPLOYEE
WHERE SALARY >= 3047662;

-- ���� �� �ܰ踦 �ϳ��� ���������� ��ġ��
SELECT EMP_ID, EMP_NAME, JOB_CODE
FROM EMPLOYEE
WHERE SALARY >=(SELECT AVG(SALARY)
FROM EMPLOYEE);

--------------------------------------------------------------


/*
    * ���������� ���� (����)
    �������� �κи� �������� �� �� ����� ���� ���̳� �� ���� ���е�
    
    ����� ���� ()�� �����ϰ� �θ��⵵ �� / ������ ���߿� ���������� �ƴ�
    - ������ (���Ͽ�) �������� : ���������� ������ ����� ������ 1�� �� ��
    - ������ (���Ͽ�) �������� : ���������� ������ ����� ���� ���� �� (1��)
    - (������) ���߿� �������� : ���������� ������ ����� ���� ���� �� (1��)
    - ������ ���߿� �������� : ���������� ������ ����� ���� �� ���� ���� ��
    
    => ���������� ������ ����� ���� ��̳Ŀ� ����
       ������������ ����� �� �ִ� �����ڰ� �޶�����!!
       
    
*/

/*
    1. ������ (���Ͽ�) ��������
    ���������� ��ȸ ������� ������ 1���� �� (1�� 1���� ��)
    
    �Ϲ����� ������ ��� ���� (=, !=, <=, >, ...)
    
*/

-- �� ������ ��� �޿����� �� ���� �޴� ������� �����, �����ڵ�, �޿� ��ȸ
-- 1) ���� ��ձ޿� ���ϱ�
SELECT AVG(SALARY)
FROM EMPLOYEE;

-- 2) �� ��� �޿����� ���Թ޴� ����� ���ϴ� ���� ¥��
SELECT EMP_NAME, JOB_CODE, SALARY
FROM EMPLOYEE
WHERE SALARY < (SELECT AVG(SALARY)
FROM EMPLOYEE); -- ����� 1�� 1��

--> �׻� ���������� ()�� ��� ǥ���Ѵ�!!

-- ���� �޿��� �޴� ����� ���, �����, �����ڵ�, �޿�, �Ի��� ��ȸ
-- 1) ���� �����޿� ���� �˾Ƴ���
SELECT MIN(SALARY)
FROM EMPLOYEE;

-- 2) �� �����޿��� �޴� ����� ���� ���ϱ�
SELECT EMP_ID, EMP_NAME, JOB_CODE, SALARY, HIRE_DATE
FROM EMPLOYEE
WHERE SALARY  = (SELECT MIN(SALARY)
FROM EMPLOYEE); -- ����� 1�� 1��


-- �赿�� ����� �޿����� �� ���� �޴� ������� ���, �̸�, �μ��ڵ�, �޿� ��ȸ

SELECT EMP_ID, EMP_NAME, DEPT_CODE, SALARY
FROM EMPLOYEE
WHERE SALARY >=(SELECT SALARY
FROM EMPLOYEE
WHERE EMP_NAME='�赿��');

-- �赿�� ����� �޿����� �� ���� �޴� ������� ���, �̸�, �μ��ڵ�, �޿� ��ȸ
-->> ����Ŭ ���� ����
SELECT EMP_ID, EMP_NAME, NVL(DEPT_TITLE, '����'), SALARY
FROM EMPLOYEE, DEPARTMENT
WHERE DEPT_CODE = DEPT_ID(+) -- ������� ���� ����
AND SALARY >= (SELECT SALARY
FROM EMPLOYEE
WHERE EMP_NAME='�赿��');-- �߰����� ����

-->> ANSI ����
SELECT EMP_ID, EMP_NAME,  NVL(DEPT_TITLE, '����'), SALARY
FROM EMPLOYEE
LEFT JOIN DEPARTMENT ON ( DEPT_CODE = DEPT_ID) 
WHERE SALARY >= (SELECT SALARY
FROM EMPLOYEE
WHERE EMP_NAME='�赿��');

--> ����, �׵��� ����� ������, �Լ��� �� �پ��ϰ� ���� �� ��� ����!!

-- ������ ����� ���� �μ��� ������� ���, �̸�, ��ȭ��ȣ, ���޸�
-->> ����Ŭ ���� ����
SELECT E.EMP_ID, E.EMP_NAME, E.PHONE, J.JOB_NAME
FROM EMPLOYEE E, JOB J
WHERE E.JOB_CODE = J.JOB_CODE AND DEPT_CODE = (SELECT DEPT_CODE
FROM EMPLOYEE
WHERE EMP_NAME='������')AND EMP_NAME != '������';
-->>ANSI ����
SELECT E.EMP_ID, E.EMP_NAME, E.PHONE, J.JOB_NAME
FROM EMPLOYEE E
JOIN JOB J USING (JOB_CODE)
WHERE DEPT_CODE = (SELECT DEPT_CODE
FROM EMPLOYEE
WHERE EMP_NAME='������') AND EMP_NAME != '������';

-- �μ��� �޿� ���� ���� ū �μ� �ϳ����� ��ȸ (�μ��ڵ�, �μ���, �޿���)
-- 1) �μ��� �޿� �� ���� ���ϱ�
SELECT DEPT_CODE, SUM(SALARY)
FROM EMPLOYEE
GROUP BY DEPT_CODE;
-- > DEPT_CODE �÷��� �������� �׷���� �� �μ��� �޿� �� ���� ����
-- 2) �޿� ���� ���� ū �μ��� ã��
SELECT MAX(SUM(SALARY))
FROM EMPLOYEE
GROUP BY DEPT_CODE;
-- 3) �ش� �޿����� �μ��� ������ ���ϱ�
SELECT DEPT_CODE, DEPT_TITLE , SUM(SALARY)
FROM EMPLOYEE
JOIN DEPARTMENT ON (DEPT_CODE = DEPT_ID)
GROUP BY DEPT_CODE, DEPT_TITLE
HAVING SUM(SALARY) = (SELECT MAX(SUM(SALARY))
                        FROM EMPLOYEE
                    GROUP BY DEPT_CODE);-- SUM(SALARY) �� 17700000�� 
--------------------------------------------------------------------------------
/*
    2. ������ (���Ͽ�) �������� (MULTI ROW SUBQUERY)
    ���������� ��ȸ ������� ������ 1��¥���� ��
    
    - IN (��������) : �������� ����� �߿��� �Ѱ��� ��ġ�� ���
      NOT IN (��������) : "������" �̶�� �ǹ� 
      
      
    - > ANY(��������) : �������� ����� �߿��� "�ϳ���" Ŭ ���
                       ��, �������� ����� �߿��� ���� ���������� Ŭ ���
    - < ANY(��������) : �������� ����� �߿��� "�ϳ���" ���� ���
                       ��, �������� ����� �߿��� ���� ū������ ���� ���
                         
    
    
    
    - > ALL (��������) : �������� ������� "���" ������ Ŭ ���
                        ��, �������� ����� �߿��� ���� ū������ Ŭ ���
    - < ALL (��������) : �������� ������� "���" �� ���� ���� ���
                        ��, �������� ����� �߿��� ���� ���������� ���� ���
  
  <=, >= ���� ANY, ALL ���� ��� ������!!  
*/
-- �� �μ��� �ְ�޿��� �޴� ����� �̸�, �����ڵ�, �޿� ��ȸ   
-- 1) �� �μ��� �ְ�޿� ���� ���ϱ�
SELECT MAX(SALARY)
FROM EMPLOYEE
GROUP BY DEPT_CODE;
--> (289000,3660000, 8000000, 3760000, 3900000, 2490000, 2550000)

--2) ���� �޿����� �޴� ����� ��ȸ
SELECT EMP_NAME, JOB_CODE, SALARY
FROM EMPLOYEE
WHERE SALARY IN (2890000 ,3660000, 8000000, 3760000, 3900000, 2490000, 2550000);
                    
-- ���� �� ������ ��ġ��
SELECT EMP_NAME, JOB_CODE, SALARY
FROM EMPLOYEE
WHERE SALARY IN (SELECT MAX(SALARY)
                FROM EMPLOYEE
                GROUP BY DEPT_CODE); -- ����� 7�� 1��
-- ��μ� �Ǵ� ������ ����� ���� �μ��� ����� ��ȸ (�����, �μ��ڵ�, �޿�)
-- 1) ��μ�, ������ ����� �μ��ڵ� ���� ���ϱ�
SELECT DEPT_CODE
FROM EMPLOYEE
--WHERE EMP_NAME = '��μ�' OR EMP_NAME = '������'
WHERE EMP_NAME IN ('��μ�','������');
--2) ���� �μ��� �Ҽӵ� ����� ���ϱ�
SELECT EMP_NAME, DEPT_CODE, SALARY
FROM EMPLOYEE
WHERE EMP_NAME IN ('D6','D8');

SELECT EMP_NAME, DEPT_CODE, SALARY
FROM EMPLOYEE
WHERE EMP_NAME IN (
SELECT EMP_NAME 
FROM EMPLOYEE
WHERE EMP_NAME IN ('��μ�','������'));

-- ���< �븮<����<����<����
-- �븮�����ӿ��� �ұ��ϰ� ���������� �޿����� �� ���� �޴� ���� ��ȸ
-- (���, �̸�, ���޸�, �޿�)

-- 1) ���� ���޵��� �޿� ���� ��ȸ
SELECT SALARY
FROM EMPLOYEE E, JOB J
WHERE E.JOB_CODE = J.JOB_CODE -- ������� ���� ����
AND JOB_NAME  = '����'; -- �߰����� ����
--> (2200000, 2500000,3760000)

-- 2) ���� �޿��麸�� ���� �޿��� �޴� ������ ��ȸ
-- (�׳� ���庸�ٸ� �޿� ���� ������ ��)
SELECT EMP_ID, EMP_NAME, JOB_NAME, SALARY
FROM EMPLOYEE E, JOB J
WHERE E.JOB_CODE = J.JOB_CODE--������� ���� ���� ��� 
AND SALARY > ANY (2200000, 2500000,3760000);

-- 3) ���� ������� �ϳ��� ���ı� + �븮�鸸 ��ȸ
SELECT EMP_ID, EMP_NAME, JOB_NAME, SALARY
FROM EMPLOYEE E, JOB J
WHERE E.JOB_CODE = J.JOB_CODE
AND SALARY > ANY(SELECT SALARY
FROM EMPLOYEE E, JOB J
WHERE E.JOB_CODE = J.JOB_CODE -- ������� ���� ����
AND JOB_NAME  = '����')AND J.JOB_NAME = '�븮';
-- > �ð� ���� ANSI �������ε� �ٲ㺸��

-- ��� < �븮 < ���� < ���� < ����
-- ���������ӿ��� �ұ��ϰ� ��� ���������� �޿����ٵ� �� ���� �޴� ������ ��ȸ
-- (���, �̸�, ���޸�, �޿�)
-- 1) �������޵��� �޿� ���� ��ȸ
SELECT SALARY
FROM EMPLOYEE
JOIN JOB USING (JOB_CODE)
WHERE JOB_NAME= '����';
-- > (2800000,1550000,2490000,2480000)

-- 2) ���� ��� �޿����ٵ� �� ���̹޴� ����鸸 ��ȸ
SELECT EMP_ID, EMP_NAME, JOB_NAME, SALARY
FROM EMPLOYEE
JOIN JOB USING (JOB_CODE)
WHERE SALARY > ALL (2800000,1550000,2490000,2480000);

-- 3) ���� �� �ܰ� ��ġ�� + �������޸� ��ȸ
SELECT EMP_ID, EMP_NAME, JOB_NAME, SALARY
FROM EMPLOYEE
JOIN JOB USING (JOB_CODE)
WHERE SALARY > ALL (SELECT SALARY
FROM EMPLOYEE
JOIN JOB USING (JOB_CODE)
WHERE JOB_NAME= '����') -- ����� 4�� 1��
AND JOB_NAME = '����';
-- > ����Ŭ ���� �������� �ٲ㺸��
------------------------------------------------------------
/*
    3. (������) ���߿� ��������
    ��ȸ ������� ���������� ������ �÷� ���� �������� ��
    (��Ȳ�� ���� ������ ���������� ��ü �����ϴ�)
    
    
*/
  
  
-- �赿�� ����� ���� �μ��ڵ�, ���� �����ڵ忡 �ش��ϴ� ����� ��ȸ
-- �赿�� ����� �μ��ڵ�� �����ڵ� 
SELECT DEPT_CODE ,JOB_CODE
FROM EMPLOYEE
WHERE EMP_NAME = '�赿��'; -- 'D6'/ 'J3'

-- �μ��ڵ尡 D6�̸鼭 �����ڵ尡 J3�� ����� ��ȸ
-- (�̸�, �μ��ڵ�, �����ڵ�, �Ի���)

SELECT EMP_NAME,DEPT_CODE,JOB_CODE, HIRE_DATE
FROM EMPLOYEE
WHERE DEPT_CODE = 'D6'
AND JOB_CODE = 'J3';

-- ���� ������� �ϳ��� ���������� ��ġ��
-- ������ ���Ͽ� �������� ��������
SELECT EMP_NAME, DEPT_CODE, JOB_CODE, HIRE_DATE
FROM EMPLOYEE
WHERE DEPT_CODE = (SELECT DEPT_CODE
                    FROM EMPLOYEE
                    WHERE EMP_NAME = '�赿��')
                    AND JOB_CODE=(SELECT JOB_CODE
                                    FROM EMPLOYEE
                                    WHERE EMP_NAME = '�赿��');

-- ������ ���߿� �������� ��������
SELECT EMP_NAME, DEPT_CODE, JOB_CODE, HIRE_DATE
FROM EMPLOYEE
WHERE (DEPT_CODE, JOB_CODE)= (SELECT DEPT_CODE ,JOB_CODE
FROM EMPLOYEE
WHERE EMP_NAME = '�赿��'); -- ����� 1�� 2��


-- ������ ����� ���� �μ��ڵ�, ���� �����ڸ� ���� �����
-- ���, �̸�, �����ڵ�, ������
SELECT EMP_ID, EMP_NAME, JOB_CODE, MANAGER_ID
FROM EMPLOYEE
WHERE (DEPT_CODE,JOB_CODE) = (SELECT DEPT_CODE, JOB_CODE
                                FROM EMPLOYEE
                                WHERE EMP_NAME ='������');
-- ����ȫ ����� �����ڵ�, ���� ��� ����� ���� �����
-- ���, �̸�, �����ڵ�, ��� ���
SELECT EMP_ID, EMP_NAME, JOB_CODE, MANAGER_ID
FROM EMPLOYEE
WHERE (JOB_CODE , MANAGER_ID) = (SELECT JOB_CODE, MANAGER_ID
                                  FROM EMPLOYEE
                                  WHERE EMP_NAME='����ȫ');

-------------------------------------------------
/*
    4. ������ ���߿� ��������
    �������� ��ȸ ����� ������ �����ø��� ���
*/

-- �� ���޺� �ּ� �޿��� �޴� ����� ��ȸ
-- ���, �̸�, �����ڵ�, �޿�

--�� ���޺� �ּ� �޿� ��ȸ
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

-- ���� ����߿� ��ġ�ϴ� �����
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

--> �÷��� �������� �ѹ��� ��� ����� �Ұ�!!(������ ���� ����)
WHERE  (JOB_CODE, SALARY) IN (('J2', 3700000),
                                ('J7', 1380000),
                                ('J3', 3400000),
                                ('J6', 2000000),
                                ('J5', 2200000),
                                ('J1', 8000000),
                                ('J4', 1550000));
--> IN �����ڴ�  ���� ��(�ѹ��� ��� �����)

-- ������ ���߿� �������� ��������
SELECT EMP_ID, EMP_NAME, JOB_CODE, SALARY
FROM EMPLOYEE
WHERE (JOB_CODE, SALARY) IN (SELECT JOB_CODE, MIN(SALARY)
FROM EMPLOYEE
GROUP BY JOB_CODE);


-- �� �μ��� �ְ� �޿��� �޴� ������� ���, �̸�, �μ��ڵ�, �޿�
-- ���� �� �μ��� �ְ�� ��ȸ
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
    
-- ���� �μ��� �޿��� �޴� ����� ��ȸ
SELECT EMP_ID, EMP_NAME, NVL(DEPT_CODE,'����'), SALARY
FROM EMPLOYEE
WHERE (NVL(DEPT_CODE,'����'), SALARY) IN (SELECT NVL(DEPT_CODE,'����'), MAX(SALARY)
FROM EMPLOYEE
GROUP BY DEPT_CODE)
ORDER BY SALARY DESC;


--> IN �����ڸ� ���� ����� �� ��������
--  NULL �� �񱳿����� �Ұ�����!! �ذ��Ϸ��� NVL �Լ� ���� Ȱ������


---------------------------------------------------------------------------

/*
    (���� ���� �ٸ�)
    5. �ζ��� �� (INLINE VIEW)
    FROM ���� ���������� �����ϴ� �� (���̺�� ��ſ�)
    
    FROM ���̺��
    FROM (��������)
    => ���������� ������ ��� (RESULT SET) �� ���̺� ��� ����ϰڴ�.
    
       
*/
-- ���ʽ� ���� ������ 3000���� �̻��� ������� 
-- ���, �̸�, ���ʽ����Կ���, �μ��ڵ带 ��ȸ
--> �ζ��κ並 �Ⱦ� ���
SELECT EMP_ID
     , EMP_NAME
     , (SALARY + SALARY * NVL(BONUS,0)) * 12 "���ʽ� ���� ����"
     , DEPT_CODE
     FROM EMPLOYEE
     WHERE(SALARY+SALARY *BONUS) *12 >= 30000000;

-->> �ζ��κ並 �����
SELECT EMP_ID,EMP_NAME, "���ʽ� ���� ����", DEPT_CODE
FROM (SELECT EMP_ID
           , EMP_NAME
           , (SALARY+ SALARY * NVL(BONUS, 0)) * 12"���ʽ� ���� ����"
           , DEPT_CODE
           FROM EMPLOYEE)
     WHERE "���ʽ� ���� ����" >= 30000000;
--> FROM ���� �������� (�ζ��� ��) ����
-- �̹� �÷��� ��Ī�� �ο��ϰ� ��ȸ�� �����ϱ� ������
-- WHERE ���� ���ǽĿ����� ��Ī ��� ����!!


-->> �ζ��� �並 �ַ� ����ϴ� ����
--   TOP-N �м� : �����ͺ��̽� ���� �����͵� ��
--               "�ֻ��� ��� �ڷ�" �� ���� ���� ����ϴ� ���
--      ��) �޿��� ���� ���� 3��
--      �ټ� ����� ���� �� 5��
--      �Ի����� ���� �ֱ��� 10��


-- �� ���� �� �޿��� ���� ���� ���� 5��
-- ROWNUM : ����Į���� �⺻������ �������ִ� �÷�
--          ��ȸ�� ������� 1���� ���� ������ �ο�����!!

SELECT ROWNUM, EMP_NAME, SALARY -- 3
FROM EMPLOYEE                   -- 1
WHERE ROWNUM <= 5               -- 2
ORDER BY SALARY DESC;           -- 4
--> TOP-N �м��� �ٽ��� ORDER BY �� ���� ���� ��
-- ROWNUM���� ���������� N���� �߶󳻾���
--> �ζ��κ並 ���� ������ �׻� ORDER BY ���� �������� ����Ǳ� ������
--  ����� �� TOP-N �м��� �� �� ���Ե�!!


--  ORDER BY �� ������ RESULT SET �� ������
-- ���� �������� ���� N ���� �߷�����
SELECT ROWNUM"����", EMP_NAME "�����",SALARY"�޿�" -- 5
FROM (SELECT *                                   -- 2  
        FROM EMPLOYEE                            -- 1
        ORDER BY SALARY DESC)                    -- 3
        WHERE ROWNUM <= 5;                       -- 4
--> �ٽ��� ORDER BY ���� WHERE ������ ���� ����ǰ� �����ϴ°�!!

-- �ζ��� �� ��� �� ���Ͽ�
SELECT ROWNUM,E.EMP_ID, E.EMP_NAME, E.SALARY --E.*
FROM (SELECT *
        FROM EMPLOYEE
        ORDER BY SALARY DESC) E
WHERE ROWNUM <= 5;
--> �ζ��� �信�� ��Ī �ο� ����!!
-- ��Ī �ο� �� ��Ī.�÷��� ���� ����,
-- ��Ī.* ���� �� �ش� RESULT SET�� ����÷��� �� ��ȸ�ϰڴ�. �ǹ�

-- �� �μ��� ��� �޿��� ���� 3���� �μ��� �μ��ڵ�, ��� �޿� ��ȸ
SELECT ROWNUM, DEPT_CODE, "��� �޿�"
FROM(SELECT DEPT_CODE, AVG(SALARY) "��� �޿�"
     FROM EMPLOYEE
     GROUP BY DEPT_CODE
     ORDER BY AVG(SALARY) DESC)
 WHERE ROWNUM <= 3;
 
--> �ζ��� �� ���ο� �Լ����� ���ԵǾ��ִٸ�
-- �÷��� ��Ī�� �ݵ�� �ٿ���� �Ѵ�!!

-- ���� �ֱٿ� �Ի��� ��� 5�� ��ȸ (�����, �޿�, �Ի���)
SELECT ROWNUM, E.*
FROM (SELECT EMP_NAME, SALARY, HIRE_DATE
        FROM EMPLOYEE
        ORDER BY HIRE_DATE DESC) E
    WHERE ROWNUM <= 5;
--> SELECT * �� �ٸ� �÷����� �߰��ؼ� ���� �Ұ���!!
-- ��, SELECT �÷���, * (X)
-- ��, SELECT ��Ī.* , �ٸ� �÷��� (O)


--> �ζ��κ䰡 ���� ���̴� ���� : �Խ���

----------------------------------------------
/*
    * ���� �ű�� �Լ�
    
    RANK() OVER(���ı���) : ���� 1���� 3���̶�� �Ѵٸ� �� ���� ������ 4��
    DENSE_RNAK() OVER(���ı���) : ���� 1���� 3���̶�� �ص� �� ���� ������ ������ 2��
    
    => ������ �ű�� �Լ��� WINDOW FUNCTION �̶�� �θ���.
    ��, WINDOW FUNCTION �� SELECT �������� ��� ����!!
    
*/

-- ������� �޿��� ���� ����� �Űܼ� �����, �޿�, ���� ��ȸ
SELECT ROWNUM, EMP_NAME, SALARY
FROM EMPLOYEE
ORDER BY SALARY DESC;
--> ORDER BY ���� �������� ����Ǳ� ������ ������ ���׹�����!!

SELECT RANK() OVER(ORDER BY SALARY DESC) "����"
     , EMP_NAME
     , SALARY 
     FROM EMPLOYEE;
--> ���� 19 �� 2��, �� ���� ������ 21��

SELECT DENSE_RANK() OVER(ORDER BY SALARY DESC) "����"
        , EMP_NAME
        , SALARY
        FROM EMPLOYEE;
--> ���� 19�� 2��, �� ���� ������ 20��

-- ������ �ű�� �Լ��� �̿��ؼ� TOP-N �м� ���� �����ϴ�.
-- �޿��� ���� ���� 5�� ��ȸ
SELECT EMP_NAME
     , SALARY
     , RANK() OVER(ORDER BY SALARY DESC) "����"
FROM EMPLOYEE
WHERE RANK() OVER(ORDER BY SALARY DESC) <= 5;
--> ���� : �޵��� �Լ��� SELECT �������� ��� ����
--          WHERE ���� ����ؼ� ������!!
-- �ζ��κ並 ����ϸ� �ٷ� �ذ� ������

SELECT *
FROM (SELECT  RANK() OVER(ORDER BY SALARY DESC) "����"
     , SALARY
     , EMP_NAME
     FROM EMPLOYEE)
 WHERE  ���� <= 5;   
 
