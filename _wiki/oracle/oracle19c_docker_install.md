---
layout  : wiki
title   : Oracle19c Docker 설치
summary : 
date    : 2023-05-27 20:58:13 +0900
updated : 2023-05-29 12:44:33 +0900
tag     : 
resource: 42/44dc8b-b18c-47fc-af75-1fe47844407c
toc     : true
public  : true
parent  : [[oracle]]
latex   : false
---
* TOC
{:toc}
## Docker Oracle image 다운로드
```console
jhmoon@jhmoon-wsl:~$ git clone https://github.com/oracle/docker-images.git
Cloning into 'docker-images'...
remote: Enumerating objects: 16927, done.
remote: Counting objects: 100% (1569/1569), done.
remote: Compressing objects: 100% (284/284), done.
error: RPC failed; curl 56 GnuTLS recv error (-54): Error in the pull function.
error: 861 bytes of body are still expected
```

## Oracle 19c 바이너리 다운로드
<https://www.oracle.com/kr/database/technologies/oracle19c-linux-downloads.html>

## Oracle 19c 바이너리 Docker 디렉토리로 복사 
cp LINUX.X64_193000_db_home.zip docker-images/OracleDatabase/SingleInstance/dockerfiles/19.3.0

## Docker 세팅
### Docker Image Build 시도1 -> 실패(ERROR: failed to solve: error getting credentials) 
```console
jhmoon@jhmoon-wsl:~$ cd docker-images/OracleDatabase/SingleInstance/dockerfiles

jhmoon@jhmoon-wsl:~/docker-images/OracleDatabase/SingleInstance/dockerfiles/19.3.0$ ls
Checksum.ee   LINUX.X64_193000_db_home.zip  configTcps.sh      db_inst.rsp           relinkOracleBinary.sh  setPassword.sh
Checksum.se2  checkDBStatus.sh              createDB.sh        dbca.rsp.tmpl         runOracle.sh           setupLinuxEnv.sh
Dockerfile    checkSpace.sh                 createObserver.sh  installDBBinaries.sh  runUserScripts.sh      startDB.sh

jhmoon@jhmoon-wsl:~/docker-images/OracleDatabase/SingleInstance/dockerfiles$ ls
11.2.0.2  12.1.0.2  12.2.0.1  18.3.0  18.4.0  19.3.0  21.3.0  23.2.0  buildContainerImage.sh
jhmoon@jhmoon-wsl:~/docker-images/OracleDatabase/SingleInstance/dockerfiles$ ./buildContainerImage.sh -e -v 19.3.0
==========================
Building image 'oracle/database:19.3.0-ee' ...
[+] Building 1.6s (3/3) FINISHED                                                                                                                             
 => [internal] load build definition from Dockerfile                                                                                                    0.0s
 => => transferring dockerfile: 4.95kB                                                                                                                  0.0s
 => [internal] load .dockerignore                                                                                                                       0.0s
 => => transferring context: 2B                                                                                                                         0.0s
 => ERROR [internal] load metadata for docker.io/library/oraclelinux:7-slim                                                                             1.5s
------
 > [internal] load metadata for docker.io/library/oraclelinux:7-slim:
------
Dockerfile:23
--------------------
  21 |     # Pull base image
  22 |     # ---------------
  23 | >>> FROM oraclelinux:7-slim as base
  24 |     
  25 |     # Labels
--------------------
ERROR: failed to solve: error getting credentials - err: docker-credential-desktop.exe resolves to executable in current directory (./docker-credential-desktop.exe), out: ``

ERROR: Oracle Database container image was NOT successfully created.
ERROR: Check the output and correct any reported problems with the build operation.
```

### ~/.docker/config.json 파일 수정 (credsStore->credStore로 변경)
```console
jhmoon@jhmoon-wsl:~/docker-images/OracleDatabase/SingleInstance/dockerfiles$ vi ~/.docker/config.json 
```
![image]( /resource/42/44dc8b-b18c-47fc-af75-1fe47844407c/241389399-3330b53a-0161-4571-b625-a944e44d14db.png)

### Docker Image Build 시도2 -> 성공
```console
jhmoon@jhmoon-wsl:~/docker-images/OracleDatabase/SingleInstance/dockerfiles$ ./buildContainerImage.sh -e -v 19.3.0
  ...
  Oracle Database container image for 'ee' version 19.3.0 is ready to be extended: 
    
    --> oracle/database:19.3.0-ee

  Build completed in 286 seconds.

jhmoon@jhmoon-wsl:~/docker-images/OracleDatabase/SingleInstance/dockerfiles$ docker ps -a
CONTAINER ID   IMAGE     COMMAND   CREATED   STATUS    PORTS     NAMES
```
### Docker run 
```console
jhmoon@jhmoon-wsl:~/docker-images/OracleDatabase/SingleInstance/dockerfiles$ docker run --name oracle -p 1521:1521 -p 5500:5500 -e ORACLE_PWD=oracle -v oracle19c:/opt/oracle/oradata oracle/database:19.3.0-ee
ORACLE EDITION: ENTERPRISE

LSNRCTL for Linux: Version 19.0.0.0.0 - Production on 27-MAY-2023 11:32:37

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
Start Date                27-MAY-2023 11:32:37
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
[WARNING] [DBT-06208] The 'SYS' password entered does not conform to the Oracle recommended standards.
   CAUSE: 
a. Oracle recommends that the password entered should be at least 8 characters in length, contain at least 1 uppercase character, 1 lower case character and 1 digit [0-9].
b.The password entered is a keyword that Oracle does not recommend to be used as password
   ACTION: Specify a strong password. If required refer Oracle documentation for guidelines.
[WARNING] [DBT-06208] The 'SYSTEM' password entered does not conform to the Oracle recommended standards.
   CAUSE: 
a. Oracle recommends that the password entered should be at least 8 characters in length, contain at least 1 uppercase character, 1 lower case character and 1 digit [0-9].
b.The password entered is a keyword that Oracle does not recommend to be used as password
   ACTION: Specify a strong password. If required refer Oracle documentation for guidelines.
[WARNING] [DBT-06208] The 'PDBADMIN' password entered does not conform to the Oracle recommended standards.
   CAUSE: 
a. Oracle recommends that the password entered should be at least 8 characters in length, contain at least 1 uppercase character, 1 lower case character and 1 digit [0-9].
b.The password entered is a keyword that Oracle does not recommend to be used as password
   ACTION: Specify a strong password. If required refer Oracle documentation for guidelines.
Prepare for db operation
8% complete
Copying database files
31% complete
Creating and starting Oracle instance
32% complete
36% complete
40% complete
43% complete
46% complete
Completing Database Creation
51% complete
54% complete
Creating Pluggable Databases
58% complete
77% complete
Executing Post Configuration Actions
100% complete
Database creation complete. For details check the logfiles at:
 /opt/oracle/cfgtoollogs/dbca/ORCLCDB.
Database Information:
Global Database Name:ORCLCDB
System Identifier(SID):ORCLCDB
Look at the log file "/opt/oracle/cfgtoollogs/dbca/ORCLCDB/ORCLCDB.log" for further details.

SQL*Plus: Release 19.0.0.0.0 - Production on Sat May 27 11:44:53 2023
Version 19.3.0.0.0

Copyright (c) 1982, 2019, Oracle.  All rights reserved.


Connected to:
Oracle Database 19c Enterprise Edition Release 19.0.0.0.0 - Production
Version 19.3.0.0.0

SQL> 
System altered.
...
```

### Oracle 접속 테스트
```console
jhmoon@jhmoon:~$ docker ps -a
CONTAINER ID   IMAGE                       COMMAND                  CREATED        STATUS                      PORTS                                            NAMES
261d716abc02   oracle/database:19.3.0-ee   "/bin/sh -c 'exec $O…"   40 hours ago   Exited (255) 1 second ago   0.0.0.0:1521->1521/tcp, 0.0.0.0:5500->5500/tcp   oracle
jhmoon@jhmoon:~$ docker start oracle
oracle
jhmoon@jhmoon:~$ docker ps -a
CONTAINER ID   IMAGE                       COMMAND                  CREATED        STATUS                            PORTS                                            NAMES
261d716abc02   oracle/database:19.3.0-ee   "/bin/sh -c 'exec $O…"   40 hours ago   Up 3 seconds (health: starting)   0.0.0.0:1521->1521/tcp, 0.0.0.0:5500->5500/tcp   oracle
jhmoon@jhmoon:~$ docker exec -it oracle sqlplus sys/oracle@//localhost:1521/ORCLCDB as sysdba

SQL*Plus: Release 19.0.0.0.0 - Production on Sun May 28 13:13:42 2023
Version 19.3.0.0.0

Copyright (c) 1982, 2019, Oracle.  All rights reserved.


Connected to:
Oracle Database 19c Enterprise Edition Release 19.0.0.0.0 - Production
Version 19.3.0.0.0

SQL>
```

## 참고자료 
* Oracle19c Docker 설치: <https://growupcoding.tistory.com/18>
* exec: "docker-credential-desktop.exe": executable file not found in $PATH : <https://stackoverflow.com/questions/65896681/exec-docker-credential-desktop-exe-executable-file-not-found-in-path>
