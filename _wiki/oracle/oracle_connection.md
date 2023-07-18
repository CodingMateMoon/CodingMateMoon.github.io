---
layout  : wiki
title   : oracle 접속 동작
summary : 
date    : 2023-05-09 05:37:45 +0900
updated : 2023-07-19 08:41:43 +0900
tag     : 
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

## 참고자료
- 그림으로 공부하는 오라클 구조(스기타아츠시 외 4명)
- Oracle® Database JDBC Java API Reference, Release 21c : <https://docs.oracle.com/en/database/oracle/oracle-database/21/jajdb/index.html>
