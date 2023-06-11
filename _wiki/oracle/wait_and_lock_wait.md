---
layout  : wiki
title   : 대기와 Lock 대기
summary : 
date    : 2023-05-30 23:16:58 +0900
updated : 2023-06-12 08:47:08 +0900
tag     : oracle
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

#### alert, trace 파일
Deadlock 발생 시 한쪽의 처리가 오라클에 의해 자동으로 rollback 되며 alert, trace 파일에 해당 내역이 기록됩니다.

##### alert, trace 파일 위치 확인
```console
SQL> select value from v$diag_info where name='Diag Trace' ;

VALUE
--------------------------------------------------------------------------------
/opt/oracle/diag/rdbms/orclcdb/ORCLCDB/trace


bash-4.2$ pwd
/opt/oracle/diag/rdbms/orclcdb/ORCLCDB/trace
bash-4.2$ ls -al|grep -e 4562 -e alert
-rw-r-----  1 oracle dba 2165753 Jun  6 05:37 ORCLCDB_ora_4562.trc
-rw-r-----  1 oracle dba  535416 Jun  6 05:37 ORCLCDB_ora_4562.trm
-rw-r-----  1 oracle dba  351012 Jun  7 22:58 alert_ORCLCDB.log
```

##### alert_ORCLCDB.log

```console
2023-06-06T05:37:54.555428+00:00
Errors in file /opt/oracle/diag/rdbms/orclcdb/ORCLCDB/trace/ORCLCDB_ora_4562.trc:
2023-06-06T05:37:54.830624+00:00
ORA-00060: Deadlock detected. See Note 60.1 at My Oracle Support for Troubleshooting ORA-60 Errors. More info in file /opt/oracle/diag/rdbms/orclcdb/ORCLCDB/trace/ORCLCDB_ora_4562.trc.
2023-06-06T05:55:13.031479+00:00
```


##### ORCLCDB_ora_4562.trc (sed -n '12072,12118p' ORCLCDB_ora_4562.trc)

```console
*** 2023-06-06T05:37:54.554944+00:00 (CDB$ROOT(1))
DEADLOCK DETECTED ( ORA-00060 )
See Note 60.1 at My Oracle Support for Troubleshooting ORA-60 Errors

[Transaction Deadlock]
 
The following deadlock is not an ORACLE error. It is a
deadlock due to user error in the design of an application
or from issuing incorrect ad-hoc SQL. The following
information may aid in determining the deadlock:
 
Deadlock graph:
                                          ------------Blocker(s)-----------  ------------Waiter(s)------------
Resource Name                             process session holds waits serial  process session holds waits serial
TX-00030013-000003CD-00000001-00000000         73     136     X        39548      74     254           X  45859
TX-00060006-000003BB-00000001-00000000         74     254     X        45859      73     136           X  39548
 
----- Information for waiting sessions -----
Session 136:
  sid: 136 ser: 39548 audsid: 440036 user: 107/TEST
  pdb: 1/CDB$ROOT
    flags: (0x41) USR/- flags2: (0x40009) -/-/INC
    flags_idl: (0x1) status: BSY/-/-/- kill: -/-/-/-
  pid: 73 O/S info: user: oracle, term: UNKNOWN, ospid: 4562
    image: oracle@261d716abc02 (TNS V1-V3)
  client details:
    O/S info: user: oracle, term: pts/1, ospid: 4561
    machine: 261d716abc02 program: sqlplus@261d716abc02 (TNS V1-V3)
    application name: SQL*Plus, hash value=3669949024
  current SQL:
  update T set n1= 4 where id = 2
 
Session 254:
  sid: 254 ser: 45859 audsid: 440071 user: 107/TEST
  pdb: 1/CDB$ROOT
    flags: (0x41) USR/- flags2: (0x40009) -/-/INC
    flags_idl: (0x1) status: BSY/-/-/- kill: -/-/-/-
  pid: 74 O/S info: user: oracle, term: UNKNOWN, ospid: 5176
    image: oracle@261d716abc02 (TNS V1-V3)
  client details:
    O/S info: user: oracle, term: pts/3, ospid: 5175
    machine: 261d716abc02 program: sqlplus@261d716abc02 (TNS V1-V3)
    application name: SQL*Plus, hash value=3669949024
  current SQL:
  update T set n1 = 5 where id = 1
 
----- End of information for waiting sessions -----
```

## Latch

what? 
다중 처리를 구현하기 위한 Lock으로 오라클 내부에서 자동으로 얻으며 SQL 1회 실행을 위해 여러 Latch를 얻고 해제하는 것을 반복합니다. 

why?
Latch는 병렬 처리를 가능하게 하고 높은 처리량을 실현하기 위해 존재하는데 메모리나 데이터를 조작할 때 상호 배타적(mutual exclusive)으로 처리함으로써 데이터가 손상되는 것을 방지합니다. SGA 내부의 공유 데이터에 대한 배타적인 잠금을 보장하여 메모리 구조의 무결성을 유지합니다. 하나의 프로세스만이 Latch를 보유할 수 있으며 SGA에 접근하는 모든 프로세스는 해당 영역을 관장하는 Latch를 획득해야만 접근이 가능합니다.  Lock을 용도에 따라 나누고 Lock(latch)의 종류와 수를 늘림으로써 다른 세션들과 경합할 가능성을 줄일 수 있습니다.
![image]( /resource/87/498ebc-12b6-492e-82da-9adb3c5d1cb4/244839270-034d0d2c-4ec9-43cf-8849-a73189da2e65.png)

현실에서는 Latch 경합이 발생하는 경우가 많은데 CPU, OS와 관련이 있습니다. OS에서는 여러 처리를 동시에 실행하는 멀티태스킹이 존재하고 처리중인 CPU를 가로채는 동작인 선점(preemptive)이 존재합니다.
![image]( /resource/87/498ebc-12b6-492e-82da-9adb3c5d1cb4/244918962-b596ca00-e3f6-4e97-be05-29491cddadae.png)

![image]( /resource/87/498ebc-12b6-492e-82da-9adb3c5d1cb4/244919452-23bcf977-0e0d-4da0-972a-85a62ac41065.png)

위와 같은 OS의 동작으로 인해 Latch를 가진 세션의 CPU를 가로채는 상황이 발생할 경우 Latch를 가진 세션은 CPU를 사용할 수 없어서 처리를 진행하지 못하고 CPU를 사용할 수 있는 세션은 Latch를 얻지 못해 처리를 진행하지 못하는 상황이 발생할 수 있습니다. 또한 이러한 현상은 CPU의 스케줄링 외에도 OS의 페이징 등의 현상으로 Oracle 프로세스의 처리가 중단되는 경우에도 발생합니다. 

## 참고자료
- 그림으로 공부하는 오라클 구조(스기타아츠시 외 4명)
- 오라클의 대기와 Lock에 대해 알아보자:<https://loosie.tistory.com/525>
- 오라클 LOCK 걸린 개체 확인 및 LOCK 해제 : <https://hello-nanam.tistory.com/23>
- alert log 파일 위치 : <https://fliedcat.tistory.com/208>
- Oracle Lath 란?? : <https://otsteam.tistory.com/105>
- 오라클 래치와 락 (Latch & Lock) : <https://simpledb.tistory.com/3>
