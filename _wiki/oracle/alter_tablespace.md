---
layout  : wiki
title   : tablespace 확인, 변경
summary : 
date    : 2023-05-31 23:39:27 +0900
updated : 2023-05-31 23:53:18 +0900
tag     : 
resource: 48/3d1a77-ff63-48a2-bfd8-b0ee30853698
toc     : true
public  : true
parent  : 
latex   : false
---
* TOC
{:toc}

## tablespace 사용량 확인 
```console
SQL> select  
       a.tablespace_name "TS NAME", 
       a.bytes "TOTAL SIZE(MB)",
       (a.bytes-b.bytes) "USED SIZE(MB)",
       b.bytes "FREE SIZE(MB)",  
       (a.bytes-b.bytes)/(a.bytes)*100 "USED(%)"
from ( select sum(bytes)/1024/1024 bytes, tablespace_name
       from dba_data_files
       group by tablespace_name ) a,
     ( select nvl(sum(bytes)/1024/1024,0) bytes, nvl(max(bytes)/1024/1024,0) max_free, tablespace_name
       from dba_free_space
       group by tablespace_name )  b
where a.tablespace_name = b.tablespace_name(+)
order by a.tablespace_name;


TS NAME 		       TOTAL SIZE(MB) USED SIZE(MB) FREE SIZE(MB)
------------------------------ -------------- ------------- -------------
   USED(%)
----------
SYSAUX					  540	    507.125	   32.875
 93.912037

SYSTEM					  910	    900.875	    9.125
98.9972527

UNDOTBS1				  340	      205.5	    134.5
60.4411765


TS NAME 		       TOTAL SIZE(MB) USED SIZE(MB) FREE SIZE(MB)
------------------------------ -------------- ------------- -------------
   USED(%)
----------
USERS					    5	     2.6875	   2.3125
     53.75

```

## tablespace file 경로 확인
```console
SQL> select tablespace_name, file_name from dba_data_files;

TABLESPACE_NAME
------------------------------
FILE_NAME
--------------------------------------------------------------------------------
USERS
/opt/oracle/oradata/ORCLCDB/users01.dbf

UNDOTBS1
/opt/oracle/oradata/ORCLCDB/undotbs01.dbf

SYSTEM
/opt/oracle/oradata/ORCLCDB/system01.dbf


TABLESPACE_NAME
------------------------------
FILE_NAME
--------------------------------------------------------------------------------
SYSAUX
/opt/oracle/oradata/ORCLCDB/sysaux01.dbf

```

## tablespace에 datafile 추가

alter tablespace users add datafile '/path' size [file size : 10M/1G];
 
```console
SQL>  alter tablespace users add datafile '/opt/oracle/oradata/ORCLCDB/users02.dbf' size 10M;

Tablespace altered.

SQL> select tablespace_name, file_name from dba_data_files order by tablespace_name;

TABLESPACE_NAME
------------------------------
FILE_NAME
--------------------------------------------------------------------------------
SYSAUX
/opt/oracle/oradata/ORCLCDB/sysaux01.dbf

SYSTEM
/opt/oracle/oradata/ORCLCDB/system01.dbf

UNDOTBS1
/opt/oracle/oradata/ORCLCDB/undotbs01.dbf


TABLESPACE_NAME
------------------------------
FILE_NAME
--------------------------------------------------------------------------------
USERS
/opt/oracle/oradata/ORCLCDB/users01.dbf

USERS
/opt/oracle/oradata/ORCLCDB/users02.dbf


SQL> select  
       a.tablespace_name "TS NAME", 
       a.bytes "TOTAL SIZE(MB)",
       (a.bytes-b.bytes) "USED SIZE(MB)",
       b.bytes "FREE SIZE(MB)",  
       (a.bytes-b.bytes)/(a.bytes)*100 "USED(%)"
from ( select sum(bytes)/1024/1024 bytes, tablespace_name
       from dba_data_files
       group by tablespace_name ) a,
     ( select nvl(sum(bytes)/1024/1024,0) bytes, nvl(max(bytes)/1024/1024,0) max_free, tablespace_name
       from dba_free_space
       group by tablespace_name )  b
where a.tablespace_name = b.tablespace_name(+)
order by a.tablespace_name;


TS NAME 		       TOTAL SIZE(MB) USED SIZE(MB) FREE SIZE(MB)
------------------------------ -------------- ------------- -------------
   USED(%)
----------
SYSAUX					  540	    507.125	   32.875
 93.912037

SYSTEM					  910	    900.875	    9.125
98.9972527

UNDOTBS1				  340	      205.5	    134.5
60.4411765

USERS					   15	     3.6875	  11.3125
24.5833333

```
