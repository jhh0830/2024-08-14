
/*
    * DDL (DATA DEFINITION LANGUAGE)
    
    데이터 정의 언어
    오라클에서 제공하는 객체  (OBJECT) 를 
    새로이 만들고 (CREATE) , 구조를 변경하고 (ALTER),
    구조 자체를 삭제한 (DROP) 하는 명령문
    즉, 데이터베이스를 이루고 있는 구조물 자체를 정의하는 언어로,
    주로 DB 관리자, 설계자 사용함
    
    * 오라클의 객체 (OBJECT)
    오라클 데이터베이스를 이루고 있는 "구조물"
    
    [ 종류 ]
    테이블 (TABLE), 뷰 (VIEW), 시퀀스 (SEQUENCE),
    인덱스 (INDEX), 패키지 (PACKAGE), 트리거 (TRIGGER),
    프로시저 (PROCEDURE), 함수 (FUNCTION)
    동의어 (SYNONYM), 사용자 (USER)
        
*/

/*
    < CREATE TABLE>
    * 테이블 (TABLE)
    행 (ROW), 열 (COLUMN) 로 구성되는
    "가장 기본적인" 데이터베이스의 객체 (구조물)
    모든 데이터는 항상 테이블을 통해서 테이블에 저장됨
    즉, 데이터를 보관하고자 한다면 테이블을 무조건 만들어야 함!!
    
    [ 표현법 ]
    CREATE TABLE 테이블명 (
        컬럼명 자료형,
        컬럼명 자료형,
        ...
    );
        
   < 자료형 >
   - 문자 (CHAR(크기) / VARCHAR2(크기))
   : 크기는 BYTE 단위로 지정한다.
     숫자, 영문자, 특수문자 => 한글자 당 1BYTE 로 취급
     한글                 => 한글자 당 3BYTE 로 취급
     CHAR(바이트수) : 최대 2000BYTE 까지 지정 가능
                     고정길이 (아무리 적은 값이 들어와도 공백으로 채워서
                     처음 할당한 크리를 유지하겠다.)
                     주로 들오올 값의 글자수가 딱 정해져 있을 경우
                     예) 성별 : '남' / '여' 또는 'M' / 'F'
                        전화번호 : 010-XXXX-XXXX
                        주민번호 : YYMMDD-GXXXXXX
                                            
     VARCHAR2(바이트수) : 최대 4000BYTE 까지 지정 가능
                         가변길이
                         (적은 값이 들어오면 그 담긴 값에 맞춰서
                          저장 공간의 크기가 줄어둠)
                        주로 글자 수 또는 데이터의 용량이 가늠이 되지 않을 경우
                        예) 게시글 제목, 게시글 내용
                        (VAR 는 가변, 2 는 사이즈 2배를 의미함)
                        
     
   - 숫자 (NUMBER)
   : 정수, 실수 상관없이 모두 다 보관 가능
   
   - 날짜 (DATE)
   : 년, 월, 일, 시, 분, 초를 모두 다 포함한 자료형
   
        
*/

-->> 회원들의 데이터 (아이디, 비밀번호, 이름, 회원가입일)
--   를 담기 위한 테이블 MEMBER 테이블 생성하기
CREATE TABLE MEMBER(
    MEMBER_ID VARCHAR2(20),
    MEMBER_PWD VARCHAR2(20),
    MEMBER_NAME VARCHAR2(20),
    MEMBER_DATE DATE
    
);
--> 대소문자 구분 X, 낙타표기법 사용 불가!! (언다바로 구분)
--> VARCHAR2 라도 사이즈를 오버해서 담을수는 없기 때문에
-- 다소 넉넉하게 사이즈 지정하는게 좋다!!

-- 테이블이 잘 만들어졌나 확인
SELECT * FROM MEMBER;
--> 단순 SELECT 문을 활용하거나 접속탭에서 확인 가능

-- 데이터 딕셔너리를 이용하여 테이블 확인 가능
-- 데이터 딕셔너리 : 다양한 객체들의 정보를 저장하고 있는
--                 시스템 테이블 (오직 조회 용도)
-- USER_TABLES : 현재 이 계정이 가지고 있는 테이블들의 
--               전반적인 구조를 확인할 수 있는 데이터 딕셔너리
SELECT* FROM USER_TABLES;

-- USER_TAB_COLUMNS : 현재 이 계정이 가지고 있는 테이블들의
--                    모든 컬럼의 정보들을 조회할 수 있는 데이터 딕셔너리
SELECT * FROM USER_TAB_COLUMNS;
--------------------------------------------------------

/*
     * 컬럼에 주석 달기 (컬럼에 대한 설명)
     
     COMMENT ON COLUMN 테이블명.컬럼명 IS '주석내용';
     
     
*/

COMMENT ON COLUMN MEMBER.MEMBER_ID IS '회원아이디';
-- 회원비밀번호, 회원이름, 회원가입일
COMMENT ON COLUMN MEMBER.MEMBER_PWD IS '회원비밀번호';
COMMENT ON COLUMN MEMBER.MEMBER_NAME IS '회원이름';
COMMENT ON COLUMN MEMBER.MEMBER_DATE IS '회원가입일';
--> 권장사항!! 가독성이 좋아지고 분업이나 다른사람들이 테이블을 볼때 더 편해짐

-- 만들어진 MEMBER 테이블에 데이터 넣어보기
-- 데이터를 추가할 수 있는 구문 : INSERT문 
-- (한 행 단위로 추가, 값의 순서가 중요!!)
-- INSERT INTO 테이블명 VALUES (첫번째 컬럼값,두번째 컬럼값....마지막 컬럼값)
INSERT INTO MEMBER VALUES('user01'
                        , 'pass01'
                        , '홍길동'
                        , '2021-02-01');
INSERT INTO MEMBER VALUES('user02'
                        , 'pass02'
                        , '김말똥'
                        , ' 21/02/02');
INSERT INTO MEMBER VALUES('user03'
                        , 'pass03'
                        , '김갑생'
                        , SYSDATE);
INSERT INTO MEMBER VALUES(NULL
                        , NULL
                        , NULL
                        , SYSDATE);
-- 아이디, 비밀번호, 이름에 NULL 값이 존재해서는 안됨

INSERT INTO MEMBER VALUES('user03'
                        , 'pass04'
                        , '박말순'
                        , SYSDATE);
-- 중복된 아이디는 존재해서는 안됨

-- 위의 NULL 값이나 중복된 아이디값은 유효하지 않은 값들이다.
-- 유효한 데이터값들을 유지하기 위해서 "제약조건" 을 걸어줘야 한다.
-----------------------------------------------------------
/*
    < 제약조건 CONSTRACINTS>
    원하는 데이터값만 항상 유지하기 위해서 (보관하기 위해서)
    특정 컬럼마다 설정하는 제약 (데이터 무결성 보장을 목적으로)
    => 제약조건이 부여된 컬럼에 들어올 데이터에
    문제가 있는지 없는지 자동으로 검사할 목적
    (애초에 데이터에 문제가 있다면 INSERT 되지 않음)
    
    [ 종류 ]
    NOT NULL, UNIQUE, CHECK, PRIMARY KEY, FOREIGH KEY

    - 컬럼에 제약조건을 부여하는 방식
    : 컬럼레벨방식 / 테이블레벨방식
    
*/

/*
    1. NOT NULL 제약조건
    해당 컬럼에 반드시 값이 존재해야 하는 경우 사용
    (즉, NULL 값이 절대 들어와서는 안되는 컬럼에 부여)
    
    단,  NOT NULL 제약조건은 컬럼레벨방식밖에 안됨!1
*/

-- 위에서생선한 MEMBER 테이블을 보완 MEM_NOTNULL 테이블 생성
-- NOT NULL 제약조건을 추가한 형태로 새로 생성해보기
-- 컬럼레벨방식
-- : 컬럼명 자료형 제약조건
--   제약조건을 부여하고자 하는 컬럼 뒤에 곧바로 기술함
CREATE TABLE MEM_NOTNULL (
    MEM_NO NUMBER NOT NULL,
    MEM_ID VARCHAR2(20) NOT NULL,
    MEM_PWD VARCHAR2(20) NOT NULL,
    MEM_NAME VARCHAR2(20) NOT NULL,
    GENDER CHAR(3),
    PHONE VARCHAR2(15),
    EMAIL VARCHAR2(30)
);
--> 테이블명은 한 계정 내에서 중복 불가
--> 컬럼명은 한 테이블 내에서 중복 불가

SELECT * FROM MEM_NOTNULL;

-- 회원 정보 INSERT 해보기
INSERT INTO MEM_NOTNULL VALUES(1
                            , 'user01'
                            , 'pass01'
                            , '홍길동'
                            , '남'
                            , '010-1234-1234'
                            , 'user01@naver.com');
INSERT INTO MEM_NOTNULL VALUES(2
                            , NULL
                            , NULL
                            , NULL
                            , NULL
                            , NULL
                            , NULL);    
                            
-- NOT NULL 제약조건에 위배되어 오류 발생

INSERT INTO MEM_NOTNULL VALUES(2
                            , 'user02'
                            , 'pass02'
                            , '김갑생'
                            , NULL
                            , NULL
                            , NULL);
-- NOT NULL 제약조건이 부여되어있는 컬럼에는 반드시 값이 존재해야함                            

INSERT INTO MEM_NOTNULL VALUES(3
                            , 'user01'
                            , 'pass03'
                            , '박말순'
                            , '여'
                            , NULL
                            , NULL);
---------------------------------------------------------------
/*
    2. UNIQUE 제약조건
    
    컬럼에 중복값을 제한하는 제약조건
    삽입 / 수정 시 기존에 해당 컬럼값 중에 중복값이 있을 경우
    추가 또는 수정이 되지 않게 제약
    
    컬럼레벨 / 테이블레벨방식 둘 다 가능
    
*/

-- 위의 MEM_NOTNULL 테이블을 보완한 테이블 MEM_UNIQUE 테이블 생성
CREATE TABLE MEM_UNIQUE(
    MEM_NO NUMBER NOT NULL,
    MEM_ID VARCHAR2(20) NOT NULL UNIQUE, -- 컬럼레벨방식
    MEM_PWD VARCHAR2(20) NOT NULL,
    MEM_NAME VARCHAR2(20) NOT NULL,
    GENDER CHAR(3),
    PHONE VARCHAR2(15),
    EMAIL VARCHAR2(30)
);
--> 한 컬럼에 여러개의 제약조건을 걸 수 있다.
--  컬럼레벨방식의 경우 띄어쓰기 (공백) 으로 구분하여 나열한다.

SELECT * FROM MEM_UNIQUE;

-- MEM_UNIQUE 테이블 삭제 후 테이블레벨방식으로 재생성
-- DROP TABLE 테이블명;
DROP TABLE MEM_UNIQUE;

-- 테이블레벨방식
-- 컬럼명들을 모두 나열 후 마지막에 어느 컬럼에 어느 제약조건을 걸건지
-- 계속 연이어서 나열하는 방식

CREATE TABLE MEM_UNIQUE(
    MEM_NO NUMBER NOT NULL,
    MEM_ID VARCHAR2(20) NOT NULL,
    MEM_PWD VARCHAR2(20) NOT NULL,
    MEM_NAME VARCHAR2(20) NOT NULL,
    GENDER CHAR(3),
    PHONE VARCHAR2(15),
    EMAIL VARCHAR2(30), -- 여기까지는 컬럼을 나열한 부분
    UNIQUE(MEM_ID) -- 테이블레벨 방식
    
);
INSERT INTO MEM_UNIQUE VALUES(1
                            , 'user01'
                            , 'pass01'
                            , '홍길동'
                            , '남'
                            , '010-1234-1234'
                            , 'user01@naver.com');
INSERT INTO MEM_UNIQUE VALUES(2
                            , 'user02'
                            , 'pass02'
                            , '김갑생'
                            , NULL
                            , NULL
                            , NULL);                            
                            
INSERT INTO MEM_UNIQUE VALUES(3
                            , 'user02'
                            , 'pass03'
                            , '박말순'
                            , NULL
                            , NULL
                            , NULL);   
-- UNIQUE 제약조건에 위배되었으므로 INSERT 실패
-- ORA-00001: unique constraint (DDL.SYS_C007060) violated
-- 오류 구문으로 제약조건에 위배되었다고 알려주는 주지만
-- 아까 NOT NULL 제약조건이 위배됬을 때 처럼
-- 정확하게 어느 계정의 어느 테이블의 어느 컬럼에서 제약조건이
-- 위배되었는지는 안알려줌!!
-- 단, 제약조건 명을 통해서 어느 부분에서 오류가 났는지는 알려줌
-- DDL.SYS_C007060 (DDL 계정을 SYS_C007060 이름의 제약조건)
-- => 제약조건 부여 시 직접 제약조건 명을 지정해주지 않으면
--    오라클 시스템에서 알아서 임의의 제약조건명을 부여해줌
--    SYS_C~

/*
    * 제약조건 부여 시 제약조건명도 지정하는 표현식
    
    > 컬럼레벨방식
    CREATE TABLE 테이블명 (
        컬럼명 자료형 CONSTRAINT 제약조건명 제약조건,
        컬럼명 자료형,
        ...
    }'
    
    > 테이블레벨방식
    CREATE TABLE 테이블명(
        컬럼명 자료형,
        컬럼명 자료형,
        CONSTRAINT 제약조건명 제약조건(컬럼명)
    
    
    );
    
    이 때, 두 방식 모두  CONSTRAINT 제약조건명은 생략 가능
    단, 생략 시 제약조건명이 임의로 SYS_C~로 붙음!!
    
    제약조건명 지을때 팁!!
    테이블명_컬럼명_제약조건약자
*/

-- 위의 MEM_UNIQUE 테이블을 보완한 테이블 MEM_COM_NM 테이블 생성
-- MEM_UNIQUE 테이블의 구조는 그대로되,
-- 제약조건에 이름을 붙이는 형식으로 보완!!
CREATE TABLE MEM_COM_NM(
    MEM_NO NUMBER NOT NULL,
    MEM_ID VARCHAR2(20) NOT NULL,
    MEM_PWD VARCHAR2(20) NOT NULL,
    MEM_NAME VARCHAR2(20) CONSTRAINT MEM_NAME_NN NOT NULL,
    GENDER CHAR(3),
    PHONE VARCHAR2(15),
    EMAIL VARCHAR2(30),
    CONSTRAINT MEM_ID_UQ UNIQUE(MEM_ID)
);
INSERT INTO MEM_COM_NM VALUES(1
                            , 'user01'
                            , 'pass01'
                            , '홍길동'
                            , NULL
                            , NULL
                            , NULL);   
                            
INSERT INTO MEM_COM_NM VALUES(2
                            , 'user01'
                            , 'pass02'
                            , '박말순'
                            , NULL
                            , NULL
                            , NULL);  
-- ORA-00001: unique constraint (DDL.MEM_ID_UQ) violated
-- 제약조건명을 지정한 후 오류 구문을 보면
-- 컬럼명 + 제약조건 키워드 등을 조합해서 지었기 때문에
-- 어디서 오류가 발생했는지 대강 바로 알아차릴 수 있음!!

SELECT * FROM MEM_COM_NM;
