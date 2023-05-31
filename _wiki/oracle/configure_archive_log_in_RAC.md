---
layout  : wiki
title   : RAC 환경에서 archive log 저장 경로를 로컬 파일시스템으로 설정하는 방법
summary : 
date    : 2023-05-31 23:25:37 +0900
updated : 2023-05-31 23:33:14 +0900
tag     : 
resource: 30/0b1d63-03dc-4517-ae29-915cb6e27c37
toc     : true
public  : true
parent  : oracle
latex   : false
---
* TOC
{:toc}

## RAC 환경에서 archive log 저장 경로를 로컬 파일시스템으로 설정하는 방법 

### sid 확인
```console
SQL> SELECT NAME, DB_UNIQUE_NAME FROM V$DATABASE;

NAME               DB_UNIQUE_NAME
------------------ ------------------------------------------------------------
ORCL               ORCL

SQL> SELECT INSTANCE FROM V$THREAD;

INSTANCE
--------------------------------------------------------------------------------
ORCL1
ORCL2
```

### sid 바탕으로 archive log 저장 경로 설정
```console
SQL> show parameter log_archive_dest_state_1

NAME TYPE VALUE
------------------------------------
log_archive_dest_state_1 string enable


SQL> alter system set log_archive_dest_1='LOCATION=/arch' sid='ORCL1';

SQL> alter system set log_archive_dest_1='LOCATION=/arch' sid='ORCL2';

Check:
SQL> alter system archive log current;
```

## 참고자료
* Configuring Archive log in RAC environment : <https://forums.oracle.com/ords/apexds/post/configuring-archive-log-in-rac-environment-2608>
* 오라클(Oracle) SID 및 DB_NAME 확인 방법 : <https://pangate.com/665>
