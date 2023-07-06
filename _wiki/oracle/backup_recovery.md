---
layout  : wiki
title   : 기본적인 복구의 종류와 동작
summary : 
date    : 2023-07-02 20:19:50 +0900
updated : 2023-07-06 09:19:34 +0900
tag     : oracle
resource: f9/cc6e03-7f8c-49d2-b639-c51bc8022ac1
toc     : true
public  : true
parent  : [[oracle]]
latex   : false
---
* TOC
{:toc}

## 기본적인 복구의 종류와 동작
 충돌(인스턴스) 복구, 미디어 복구
완전 복구, 불완전 복구
데이터베이스/테이블스페이스/데이터 파일/블록의 복구

### 인스턴스 복구와 미디어복구
인스턴스 복구라고 불리는 충돌 복구(crash recovery)는 인스턴스가 비정상 종료된 후 다시 기동할 때 자동으로 수행하는 복구를 의미합니다.
미디어 복구는 디스크의 데이터가 손상되었을 때 사용자가 명시적으로 수행하는 복구입니다. 또한 백업본을 복원한 후 복구하는 것이 아닌 현재 데이터 파일만을 사용하는 방식도 있습니다.

### 완전 복구와 불완전 복구의 차이
완전 복구는 데이터베이스를 최신 데이터까지 복구한다는 것을 의미하고 불완전 복구는 어떤 시점(도중)까지만 복구하는 것을 의미합니다. 일반적으로 완전 복구를 선택하며 아카이브 REDO 로그 유실 등 사정이 있어서 특정 시점의 데이터로 바꾸는 것이 필요할 때 불완전 복구를 수행합니다.

### 데이터베이스/테이블스페이스/데이터 파일/블록의 복구
데이터베이스 복구는 'RECOVER DATABASE'를 입력해서 데이터베이스 전체를 복구하는 것을 의미합니다. 데이터베이스를 중단하지 않고 정상적인 테이블스페이스는 계속 운영하며 손상된 테이블스페이스만을 복구하고 싶은 경우 복구할 테이블스페이스를 사용할 수 없는 상태(오프라인)로 변경하고 테이블스페이스를 복구합니다. 다만 SYSTEM 테이블스페이스 같은 주요 테이블스페이스의 경우 오프라인 상태로 만들면 데이터베이스를 운영할 수 없기 때문에 이러한 복구 방법을 쓸 수는 없습니다.
좀 더 좁은 범위로는 'RECOVER DATAFILE < 데이터 파일명 >'이라고 입력해서 데이터 파일에 대한 복구를 수행할 수 있습니다.
RMAN을 사용할 경우 특정 블록을 지정해서 복구하는 것도 가능합니다. 특정 블록만을 백업된 데이터로 돌려놓고 해당 블록에 관한 REDO 로그만을 사용해서 복구하는 방식으로 해당 블록 외에는 사용 가능한 상태이기 때문에 장애가 국소적으로 발생했을 때 유용합니다.

### RMAN
'Recovery MANager'의 약어로 백업 및 복구를 수행할 수 있는 관리 도구입니다. 변경한 부분만을 백업하는 기능(체인지 트래킹, change tracking)과 백업한 파일의 갱신 기능(증분 백업, incremental backup) 기능 등이 존재합니다. 
증분 백업 기능을 사용할 경우 이전에 받은 풀 백업에 변경된 데이터를 적용할 수 있습니다. 체인지 트래킹과 증분 백업을 합쳐 사용함으로써 필요한 부분만을 읽어 와 풀백업을 항상 최신 데이터로 유지하는 것이 가능합니다. 

## 기본적인 복구의 흐름 (데이터베이스 전체의 복구)
데이터베이스 전체를 복구할 경우 모든 데이터 파일을 복원하고 업무를 정지한 후 복구합니다.
1. 데이터베이스가 손상되었는 지 확인  
2. 재작업할 수 있도록 현재 상태를 백업  
3. 필요한 데이터 파일과 아카이브 REDO 로그 파일을 복원 
4. 복구 실행 


### (1) 데이터베이스가 손상되었는지 확인
컨트롤 파일이 손상되었을 경우 MOUNT 상태가 되기 전에 오라클이 정지할 것이며 초기화 파라미터 파일이 손상되었다면 인스턴스의 기동 자체가 수행되지 않을 것입니다. 데이터 파일에만 발생한 장애라면 MOUNT까지는 성공하고 OPEN에서 실패할 수 있습니다.
데이터 파일에 장애가 발생했을 경우 이를 복구하기 위해서는 MOUNT 상태여야 합니다. 컨트롤 파일을 읽어오지 않은 상태에서는 데이터 파일의 위치를 알 수 없기 때문입니다. MOUNT 상태에서 오라클이 제공해주는 v$recover_file, v$datafile_header와 같은 뷰(view)를 확인할 경우 복구가 필요하다가 인식한 데이터 파일을 확인할 수 있습니다.

### (2) 재작업할 수 있도록 현재 상태 백업
데이터베이스를 정지하고 현재 상태를 백업함으로써 다시 재작업할 수 있도록 준비할 수 있고 나중에 데이텁이스를 조사할 수도 있습니다. 장애가 이중으로 발생하는 것을 막고 다시 복구할 수 있는 기회를 얻기 위해 현재 상태의 백업은 반드시 필요합니다. 현재 상태의 백업을 받을 때 데이터 파일, 컨트롤 파일, REDO 로그 파일, 아카이브 REDO 로그 파일 모두를 백업하는 것이 좋습니다.

### (3) 필요한 데이터 파일과 아카이브 REDO 로그 파일 복원
일시적인 I/O 장애 등으로 데이터를 기록하지 못하고 데이터베이스가 가동 중인 상태에서 데이터 파일만 오프라인이 되는 경우도 있습니다. 이때 v$ 뷰를 조회하면 복구가 필요하다가 표시되지만 복원하지 않고 복구할 수 있는 경우도 많습니다. 
반면 실제로 데이터 파일이 손상되었거나 없어졌을 경우에는 복원이 반드시 필요합니다. 기본적으로 alert 파일이나 v$ 뷰에서 표시한 것들을 복원하지만 표시되어 있지 않은 다른 데이터 파일도 장애가 의심될 경우 복원할 수 있습니다. 
필요한 파일들을 복원한 후에는 바로 복구를 시작하지 않고 MOUNT한 뒤 v$datafile_header를 확인하는 것이 좋습니다. 여기서 복원한 파일의 시점이 장애 발생 이전(백업을 받은 시점)인지 확인하는 것이 좋습니다.

```sql
SQL> select tablespace_name, name, status, recover, to_char(checkpoint_time, 'MM-DD HH24:MI:SS') as chk_time from v$datafile_header;

TABLESPACE_NAME      NAME				      STATUS  REC CHK_TIME
-------------------- ---------------------------------------- ------- --- --------------
SYSTEM		     /opt/oracle/oradata/ORCLCDB/system01.dbf ONLINE  NO  07-04 14:05:41
SYSAUX		     /opt/oracle/oradata/ORCLCDB/sysaux01.dbf ONLINE  NO  07-04 14:05:41
UNDOTBS1	     /opt/oracle/oradata/ORCLCDB/undotbs01.dbf ONLINE  NO  07-04 14:05:41
		     

SYSTEM		     /opt/oracle/oradata/ORCLCDB/pdbseed/syst ONLINE	  05-27 11:44:19
		     em01.dbf

SYSAUX		     /opt/oracle/oradata/ORCLCDB/pdbseed/sysa ONLINE	  05-27 11:44:19
		     ux01.dbf

USERS		     /opt/oracle/oradata/ORCLCDB/users01.dbf  ONLINE  NO  07-04 14:05:41
UNDOTBS1	     /opt/oracle/oradata/ORCLCDB/pdbseed/undo ONLINE	  05-27 11:44:19
		     tbs01.dbf

SYSTEM		     /opt/oracle/oradata/ORCLCDB/ORCLPDB1/sys ONLINE  NO  07-04 14:05:41
		     tem01.dbf

SYSAUX		     /opt/oracle/oradata/ORCLCDB/ORCLPDB1/sys ONLINE  NO  07-04 14:05:41
		     aux01.dbf

UNDOTBS1	     /opt/oracle/oradata/ORCLCDB/ORCLPDB1/und ONLINE  NO  07-04 14:05:41
		     otbs01.dbf

USERS		     /opt/oracle/oradata/ORCLCDB/ORCLPDB1/use ONLINE  NO  07-04 14:05:41
		     rs01.dbf

USERS		     /opt/oracle/oradata/ORCLCDB/users02.dbf  ONLINE  NO  07-04 14:05:41

12 rows selected.

```

복구에 필요한 아카이브 REDO 로그 파일을 복원합니다. 필요한 아카이브 파일들이 디스크에 모두 있다면 복원하지 않아도 상관없습니다. 또한 온라인 백업을 복구하는 데는 백업하는 중에 생성된 REDO 로그 역시 필요하므로 평소 아카이브 REDO 로그가 누락되지 않도록 주의하는 것이 좋습니다.

### (4) 복구 실행
 완전 복구를 수행하기 위해 MOUNT 상태에서 'RECOVER DATABASE;' 라고 입력하면 복구가 시작됩니다. 복구 프로세스는 아카이브 REDO 로그를 읽고 어느 곳의 데이터(블록)를 변경해야 하는지 파악하고 블록이 캐시에 올라와 있지 않은 경우 디스크에서 블록을 읽어 와서 캐시에 올려놓는 동작을 합니다. 복구할 때의 동작은 DML문에 의한 데이터 변경 작업과 거의 같습니다.

## 참고자료
- 그림으로 공부하는 오라클 구조(스기타아츠시 외 4명)
