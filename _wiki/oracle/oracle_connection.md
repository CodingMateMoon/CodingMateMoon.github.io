---
layout  : wiki
title   : 커넥션과 서버 프로세스의 생성
summary : 
date    : 2023-05-09 05:37:45 +0900
updated : 2023-07-26 07:11:21 +0900
tag     : oracle
toc     : true
public  : true
parent  : [[oracle]]
latex   : false
resource: 9a01bcc9-7e1e-4cbb-9235-4189eb5302cb
---
* TOC
{:toc}

## 오라클의 접속 동작

### 소켓의 동작 이미지
오라클은 TCP/IP의 소켓(socket)을 네트워크 통신 수단으로 사용하고 있습니다. 소켓을 사용 시 전화처럼 다른 장비에 있는 프로그램과 통신할 수 있습니다. 한번 소켓을 만들어 두면 소켓을 읽고 쓰는 것으로 송수신을 구현할 수 있으므로 프로세스의 측면에서 편리한 기능이라고 볼 수 있습니다. 네트워크의 드라이버와 OS의 라이브러리가 송수신을 수행하며 네트워크 안에는 여러 개의 소켓이 존재합니다. 소켓은 주소(address)와 포트(port)번호라고 불리는 번호의 조합으로 식별할 수 있습니다. 연락이 오기만을 기다리고 있는 프로세스가 존재하고 연결할 때는 송신 측에서 '주소'와 '포트'를 반드시 지정하는 것이 필요합니다.

### 오라클에서 소켓의 동작
오라클에서는 수신을 기다리는 프로세스를 '리스너(listener'라고 부릅니다. 리스너로 접속하려는 프로세스는 업무 애플리케이션의 프로세스입니다.

### 커넥션 처리 (1): 리스너 기동
커넥션 처리를 창고 회사 오라클로 비유할 경우 리스너는 창고 회사 오라클의 접수 데스크입니다. listener.ora 파일은 접수 데스크가 가지고 있는 '회사의 대표 번호' 및 '내선 전화번호부'이며 하나의 리스너는 여러 개의 데이터베이스에 안내할 수 있습니다. 일반적으로 하나의 리스너는 하나의 데이터베이스를 담당합니다.
![image]( /resource//253782987-79127f06-437b-42a3-b35c-ff74ad28417d.png)
오라클은 기본적으로 리스너의 포트 번호로 1521을 사용하지만 다른 애플리케이션 포트와 중복될 경우 다른 번호를 사용해도 상관없습니다. 리스너 설정이 끝나면 lsnrctl 도구를 사용해서 리스너를 기동합니다. 리스너가 자신이 안내해야 하는 데이터베이스를 인식하는 방법으로는 listener.ora 파일에 기록되어 있는 설정을 읽거나, 데이터베이스가 자동으로 등록하는 방법이 있습니다. 일반적으로 간편한 자동 등록을 사용합니다. 

### 리스너 상태 확인 및 stop, start

* 리스너 상태 확인

```console
bash-4.2$ lsnrctl status

LSNRCTL for Linux: Version 19.0.0.0.0 - Production on 16-JUL-2023 03:06:33

Copyright (c) 1991, 2019, Oracle.  All rights reserved.

Connecting to (DESCRIPTION=(ADDRESS=(PROTOCOL=IPC)(KEY=EXTPROC1)))
STATUS of the LISTENER
------------------------
Alias                     LISTENER
Version                   TNSLSNR for Linux: Version 19.0.0.0.0 - Production
Start Date                16-JUL-2023 03:06:28
Uptime                    0 days 0 hr. 0 min. 5 sec
Trace Level               off
Security                  ON: Local OS Authentication
SNMP                      OFF
Listener Parameter File   /opt/oracle/product/19c/dbhome_1/network/admin/listener.ora
Listener Log File         /opt/oracle/diag/tnslsnr/261d716abc02/listener/alert/log.xml
Listening Endpoints Summary...
  (DESCRIPTION=(ADDRESS=(PROTOCOL=ipc)(KEY=EXTPROC1)))
  (DESCRIPTION=(ADDRESS=(PROTOCOL=tcp)(HOST=0.0.0.0)(PORT=1521)))
Services Summary...
Service "ORCLCDB" has 1 instance(s).
  Instance "ORCLCDB", status BLOCKED, has 1 handler(s) for this service...
The command completed successfully
```

* 리스너 stop

```console
bash-4.2$ lsnrctl stop

LSNRCTL for Linux: Version 19.0.0.0.0 - Production on 16-JUL-2023 03:06:49

Copyright (c) 1991, 2019, Oracle.  All rights reserved.

Connecting to (DESCRIPTION=(ADDRESS=(PROTOCOL=IPC)(KEY=EXTPROC1)))
The command completed successfully
```

* 리스너 start

```console
bash-4.2$ lsnrctl start

LSNRCTL for Linux: Version 19.0.0.0.0 - Production on 16-JUL-2023 03:06:54

Copyright (c) 1991, 2019, Oracle.  All rights reserved.

Starting /opt/oracle/product/19c/dbhome_1/bin/tnslsnr: please wait...

TNSLSNR for Linux: Version 19.0.0.0.0 - Production
System parameter file is /opt/oracle/product/19c/dbhome_1/network/admin/listener.ora
Log messages written to /opt/oracle/diag/tnslsnr/261d716abc02/listener/alert/log.xml
Listening on: (DESCRIPTION=(ADDRESS=(PROTOCOL=ipc)(KEY=EXTPROC1)))
Listening on: (DESCRIPTION=(ADDRESS=(PROTOCOL=tcp)(HOST=0.0.0.0)(PORT=1521)))

Connecting to (DESCRIPTION=(ADDRESS=(PROTOCOL=IPC)(KEY=EXTPROC1)))
STATUS of the LISTENER
------------------------
Alias                     LISTENER
Version                   TNSLSNR for Linux: Version 19.0.0.0.0 - Production
Start Date                16-JUL-2023 03:06:54
Uptime                    0 days 0 hr. 0 min. 0 sec
Trace Level               off
Security                  ON: Local OS Authentication
SNMP                      OFF
Listener Parameter File   /opt/oracle/product/19c/dbhome_1/network/admin/listener.ora
Listener Log File         /opt/oracle/diag/tnslsnr/261d716abc02/listener/alert/log.xml
Listening Endpoints Summary...
  (DESCRIPTION=(ADDRESS=(PROTOCOL=ipc)(KEY=EXTPROC1)))
  (DESCRIPTION=(ADDRESS=(PROTOCOL=tcp)(HOST=0.0.0.0)(PORT=1521)))
The listener supports no services
The command completed successfully
```
### 커넥션 처리 (3): 서버 프로세스의 생성
 마지막 과정은 서버 프로세스를 생성하고 소켓을 인계받는 것입니다. 소켓 생성 후 리스너가 그대로 SQL 처리를 해도 될 것처럼 보이지만 한번 SQL 처리를 시작하면 요청받은 SQL을 처리하느라 다른 처리를 할 수 없게 되므로 전담 영업 담당자인 서버 프로세스를 생성하고 SQL 처리를 인계합니다. 서버 프로세스의 생성은 창고 회사 영업 담당자의 출근으로 비유할 수 있습니다. 영업 담당자의 출근이 고객의 요청이 온 시점에 하는 것이 현실에서의 회사와 다른 부분입니다. 
서버 프로세스를 생성하기 위해서 OS상에서 프로세스를 생성하고 서버 프로세스가 사용할 수 있는 공유 메모리를 확보해야 합니다. 또한 서버 프로세스용 전용 메모리(PGA)도 확보가 필요합니다. 따라서 서버 프로세스를 한번 생성하는 것은 가벼운 SQL문을 처리할 때 사용하는 CPU 시간보다 훨씬 더 많은 CPU 시간을 사용합니다. 
 리스너는 서버 프로세스 생성이 끝나면 소켓을 서버 프로세스에 인계합니다. 창고 회사로 비유하면 회사의 대표 전화번호로 받은 전화를 접수 데스크가 담당자에게 돌려주는 과정과 같습니다. 리스너가 인계한 후부터 서버 프로세스와 오라클 클라이언트는 직접 송수신하므로 리스너는 자유로워집니다.
![image]( /resource//254427194-34c3d55a-eded-4aff-9e53-8b68d4345eee.png)

## 접속 동작의 확인

### tnsnames.ora 파일을 사용하지 않으면 어떻게 되는가?

일반적으로 커넥션 디스크립터를 일일이 작성해서 사용하는 것은 번거로우므로 다음과 같이 단축 다이얼로 작성되어 있는 tnsnames.ora 파일을 사용합니다. 빈번하게 접속하지 않는 환경이라면 EZCONNECT(Eazy Connect)라는 방법을 사용하는 것도 가능합니다.

* tnsnames.ora 파일을 사용하지 않고 접속할 때  
```sql
SQL> connect scott/tiger@(DESCRIPTION=(ADDRESS=(PROTOCOL=TCP)(HOST=192.168.1.11)(PORT=1521))(CONNECT_DATA=(SERVER=DEDICATED)(SERVICE_NAME=ORCLCDB)))
connected
```

* tnsnames.ora 파일을 사용해서 접속할 때  
```sql
SQL> connect test/test@O19  <- 커넥션 식별자
Connected.
```  

* tnsnames.ora 설정  
```sql
O19=
(DESCRIPTION =
  (ADDRESS = (PROTOCOL = TCP)(HOST = 0.0.0.0)(PORT = 1521))
  (CONNECT_DATA =
    (SERVER = DEDICATED)
    (SERVICE_NAME = ORCLCDB)
  )
)
```  

* Service Name 조회  

```sql
SQL> SELECT NAME, DB_UNIQUE_NAME FROM V$DATABASE;

NAME               DB_UNIQUE_NAME
------------------ ------------------------------------------------------------
ORCL               ORCL
```

* SID 조회(RAC 예시)  

```sql
SQL> SELECT INSTANCE FROM V$THREAD;

INSTANCE
--------------------------------------------------------------------------------
ORCL1
ORCL2
```

* EZCONNECT를 사용한 접속 예  
```sql
SQL> connect test/test@0.0.0.0:1521/ORCLCDB
Connected.
```

* tnsnames.ora 파일에 해당하는 데이터가 없을 때  
```sql
SQL> connect test/test@O20
ERROR:
ORA-12154: TNS:could not resolve the connect identifier specified
```

### JDBC URL

* SID  
```console
jdbc:oracle:thin:@IP:Port:SID
jdbc:oracle:thin:@//hostname:port:sid
```

* Service Name  
```console
jdbc:oracle:thin:@IP:Port:ServiceName
jdbc:oracle:thin:@//hostname:port/serviceName
```

* Thin 사용  
```console
jdbc:oracle:thin:@(DESCRIPTION=(ADDRESS_LIST=(ADDRESS=(PROTOCOL=TCP)(HOST=서버IP)(PORT=서버Port)))(CONNECT_DATA=(SERVICE_NAME=ServiceName)))
```

### 데이터베이스에 접속하지 못할 때 확인해볼 만한 실수들
'ORA-12154: TNS xxxx' 에러가 발생하면서 접속하지 못하는 경우가 있습니다. 에러의 원인은 다양하지만 그 중 설정 실수인 경우가 의외로 많습니다.

접속할 호스트명(IP)을 잘못 입력한 경우
tnsnames.ora 파일을 보면 접속할 호스트의 IP를 'HOST = 192.168.56.xxx(통신할 수 없는 호스트)' 부분에서 확인할 수 있습니다. ping, telnet 등 호스트와 통신이 가능한지 확인합니다.

tnsnames.ora가 올바르지 않은 경로에 위치한 경우
오라클은 기본적으로 $ORACLE_HOME/network/admin 경로의 파일을 확인하는데 올바른 경로에 tnsnames.ora 파일이 있는지 확인합니다. TNS_ADMIN 환경 변수를 설정하여 임의의 경로로 tnsnames.ora의 경로를 설정할 수 있습니다. 

tnsnames.ora에 정의된 내용과 다른 커넥션 식별자를 사용해서 접속을 시도하는 경우
sqlplus  scott/tiger@ORA18C <- ORA19C의 오타이며 tnsnames.ora에는 존재하지 않습니다. 명령어의 커넥션 식별자가 tnsnames.ora에 존재하고 있는지 확인합니다.

리스너가 기동되어 있지 않은 경우
접속할 호스트의 리스너가 기동되어 있는지 여부를 확인합니다.

리스너에 서비스명을 등록하지 않은 경우
리스너가 기동한 직후 서비스명이 자동으로 등록되지 않을 때가 있습니다. 1분 정도 기다리거나 데이터베이스에서 서비스명 등록 명령어를 실행합니다. 

## 참고자료
- 그림으로 공부하는 오라클 구조(스기타아츠시 외 4명)
- Oracle® Database JDBC Java API Reference, Release 21c : <https://docs.oracle.com/en/database/oracle/oracle-database/21/jajdb/index.html>
- SID, Service Name (thin) 용어 정리 : <https://tyboss.tistory.com/entry/Oracle-SID-Service-Name-%EC%9A%A9%EC%96%B4-%EC%A0%95%EB%A6%AC>
- Oracle Docs tnsnames : <https://docs.oracle.com/cd/B12037_01/network.101/b10776/tnsnames.htm>
- Oracle Docs Data Sources and URLs : <https://docs.oracle.com/cd/B28359_01/java.111/b31224/urls.htm#BEIDHCBA>
