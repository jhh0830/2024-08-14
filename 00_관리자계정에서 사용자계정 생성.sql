-- 한줄짜리 주석
/*
    여러줄
    짜리
    주석
 
*/

-- 데이터베이스는 "계정" 이라는 개념이 있음
-- 계정을 여러개 만들 수 있으며, 각 계정마다 필요한 권한을 부여할 수 있다.
-- 오라클의 기본 제공 관리자 계정명 : SYS AS SYSDBA
-- 관리자 계정에는 모든 권한이 다 부여되어있다!!
-- (보안 상 관리자 계정에서 모든 작업을 하는걸 권장하지 않음)

-- 일반 사용자 계정을 생성 후 거기서 작업 예정!!
-- 일반 사용자 계정을 만들 수 있는 권한은 "관리자 계정" 에 있음
-- 사용자 계정을 생성하는 방법
-- [ 표현법 ]
-- CREATE USER 계정명 IDENTIFIED BY 비밀번호;
CREATE USER KH IDENTIFIED BY KH;

-- 계정을 생성했다고 해서 바로 사용할 수 있는 것은 아님!!
-- 생성된 사용자 계정에게 최소한의 권한 (접속, 데이터관리) 부여
-- [ 표현법 ]
-- GRANT 권한명1, 권한명2,.... TO 계정명;

-- 접속할 수 있는 권한 (롤) : CONNECT
-- 데이터 관리용 권한 (롤) : RESOURCE


GRANT CONNECT, RESOURCE TO KH;

-----------------------------------------

-- 춘기술대학 연습문제 계정 생성
CREATE USER CNS IDENTIFIED BY CNS;
--> 계정명 중복 불가!!


-- 최소한의 권한 부여 : CONNECT , RESOURCE
GRANT CONNECT, RESOURCE TO CNS;

-----------------------------------------

-- DDL 공부할 새로운 계정 생성
CREATE USER DDL IDENTIFIED BY DDL;

-- 최소한의 권한 부여 (DCL)
GRANT CONNECT, RESOURCE TO DDL;
