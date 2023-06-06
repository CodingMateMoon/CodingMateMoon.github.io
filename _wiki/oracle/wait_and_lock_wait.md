---
layout  : wiki
title   : 대기와 Lock 대기
summary : 
date    : 2023-05-30 23:16:58 +0900
updated : 2023-06-06 23:11:30 +0900
tag     : 
resource: 87/498ebc-12b6-492e-82da-9adb3c5d1cb4
toc     : true
public  : true
parent  : [[oracle]]
latex   : false
---
* TOC
{:toc}

## 대기와 Lock 대기

### Idle 대기
what? 
처리할 것이 없어서 쉬는 대기
 e.g, 서버 프로세스가 SQL문이 도착하기 전까지 Idle 대기 이벤트인 'SQL*Net message from client'  상태로 대기, 'smon timer', 'pmon timer', 'rdbms ipc message', 'wakeup time manager', 'Queue Monitor Wait' 등

### Non Idle 대기
(1) 이유가 있어서 어쩔 수 없이 하는 대기. 

Why? SQL 처리를 위해 필요한 대기가 존재합니다. SQL 처리 도중 데이터가 필요할 때 디스크에서 블록을 읽어오며 대기가 발생할 수 있습니다.

e.g, 데이터 파일에서 데이터를 읽어오는 'db file sequential read', 'db file scattered read', Lock을 기다리는 'enqueue', 내부 Lock을 기다리는 'latch free'

(2) 이상 상태 등 쓸데없이 SQL을 기다리게 하는 대기.

Why? 사용자가 특정 테이블에 Lock을 걸어두고는 계속 잡고 놓아주지 않는 경우 발생할 수 있습니다. 

### Lock에 의한 대기
Lock에 의한 대기는 Lock 걸려있는 대상에 다시 Lock을 걸려고 할 때 대기가 발생합니다.
![image]( /resource/87/498ebc-12b6-492e-82da-9adb3c5d1cb4/242753488-5776d139-4ad2-4635-8e72-e381800d4af6.png)

### Deadlock
![image]( /resource/87/498ebc-12b6-492e-82da-9adb3c5d1cb4/243568315-bd8cb08e-b769-47e5-9b64-78dacd2e7d88.png)

Deadlock(고장난 열쇠)의 경우 서로가 상대방이 보유하고 있는 Lock을 기다리느라 영원히 작업을 진행할 수 없는 상태를 의미합니다.

#### 사용자1 SQL 수행

```sql
SQL> update T set n1 = 2 where id = 1;

1 row updated.

SQL> update T set n1= 4 where id = 2;
```

#### 사용자2 SQL 수행

```sql
SQL> update T set n1 = 3 where id = 2;

1 row updated.

SQL> update T set n1 = 5 where id = 1;
```

#### 사용자1 세션에서 ORA-00060 deadlock 발생

```sql
update T set n1= 4 where id = 2
             *
ERROR at line 1:
ORA-00060: deadlock detected while waiting for resource
```

#### Lock 걸린 테이블의 sid, serial 조회

```sql
SQL>
SELECT A.SID
     , A.SERIAL#
     , C.OBJECT_ID
     , c.OBJECT_NAME
  FROM V$SESSION A
 INNER JOIN V$LOCK B
    ON A.SID = B.SID
 INNER JOIN DBA_OBJECTS C
    ON B.ID1 = C.OBJECT_ID
 WHERE B.TYPE  = 'TM'
    ;

       SID    SERIAL#  OBJECT_ID OBJECT_NAME
---------- ---------- ---------- --------------------------------------------------------------------------------------------------------------------------------
       136	39548	   73348 T
       254	45859	   73348 T
```

#### Lock 상세 정보 조회

```sql
SELECT /*+ ORDERED */
     S.USERNAME
     , S.SID
     , S.SERIAL#
     , S.PROGRAM
     , L.TYPE "LOCK TYPE"
     , L.ID1
     , L.CTIME
     , DECODE(L.LMODE, 0, 'NONE', 1, 'NULL', 2, 'RS', 3, 'RX', 4,  'S', 5, 'SRX', 6, 'X', '?') AS HELD
     , DECODE(L.REQUEST, 0, 'NONE', 1, 'NULL', 2, 'RS', 3, 'RX', 4, 'S', 5, 'SRX', 6, 'X', '?') AS REQUESTED
  FROM V$LOCK L, V$SESSION S
WHERE L.SID = S.SID
  AND S.USERNAME LIKE '%'
  AND L.TYPE IN ('TM', 'TX')
ORDER BY S.SID, L.TYPE
;
```

| USERNAME | SID | SERIAL# | PROGRAM                          | LOCK TYPE | ID1    | CTIME | HELD | REQUESTED |
|----------|-----|---------|----------------------------------|-----------|--------|-------|------|-----------|
| TEST     | 136 | 39458   | sqlplus@261d716abc02 (TNS V1-V3) | TM        | 73348  | 2831  | RX   | NONE      |
| TEST     | 136 | 39548   | sqlplus@261d716abc02 (TNS V1-V3) | TX        | 196627 | 2831  | X    | NONE      |
| TEST     | 254 | 45859   | sqlplus@261d716abc02 (TNS V1-V3) | TM        | 73348  | 2806  | RX   | NONE      |
| TEST     | 254 | 45859   | sqlplus@261d716abc02 (TNS V1-V3) | TX        | 393222 | 2806  | X    | NONE      |
| TEST     | 254 | 45859   | sqlplus@261d716abc02 (TNS V1-V3) | TX        | 196627 | 2776  | NONE | X         |


##### LOCK TYPE 종류

| LOCK TYPE | 특징                                                                                         | LMODE        |
|-----------|----------------------------------------------------------------------------------------------|--------------|
| TX        | row에 거는 lock. 같은 row에 대하여 다른 MODE의 Lock을 허용하지 않음                          | X(Exclusive) |
| TM        | 테이블에 거는 lock. 테이블의 정의를 변경하는 작업(DROP, ALTER) 불가. 여러 트랜잭션 수행 가능 | RX, RS       |

#### sid, serial 번호로 세션 해제
```sql
ALTER SYSTEM KILL SESSION '136,39548';
```

#### 사용자1 세션 해제 후 Lock 상세 정보 재조회

| USERNAME | SID | SERIAL# | PROGRAM                          | LOCK TYPE | ID1    | CTIME | HELD | REQUESTED |
|----------|-----|---------|----------------------------------|-----------|--------|-------|------|-----------|
| TEST     | 254 | 45859   | sqlplus@261d716abc02 (TNS V1-V3) | TM        | 73348  | 5361  | RX   | NONE      |
| TEST     | 254 | 45859   | sqlplus@261d716abc02 (TNS V1-V3) | TX        | 393222 | 5361  | X    | NONE      |

#### 사용자1 세션 상태
```sql
SQL> select * from t;
select * from t
             *
ERROR at line 1:
ORA-00028: your session has been killed
```

#### 사용자2 세션 상태
```sql
SQL> update T set n1 = 5 where id = 1;

1 row updated.

SQL> select * from T;

	ID	     N1
---------- ----------
	 1	     5
	 2	     3
```

## 참고자료
- 그림으로 공부하는 오라클 구조(스기타아츠시 외 4명)
- 오라클의 대기와 Lock에 대해 알아보자:<https://loosie.tistory.com/525>
- 오라클 LOCK 걸린 개체 확인 및 LOCK 해제 : <https://hello-nanam.tistory.com/23>
