---
layout  : wiki
title   : 백그라운드 프로세스의 동작과 역할
summary : 
date    : 2023-07-08 00:28:07 +0900
updated : 2023-07-14 20:56:40 +0900
tag     : oracle
resource: 6e/bcfbd3-c2b8-4645-9f4a-d59e2f32b24c
toc     : true
public  : true
parent  : [[oracle]]
latex   : false
---
* TOC
{:toc}

# 백그라운드 프로세스와 서버프로세스의 관계

## 백그라운드 프로세스의 동작

| 개념              | 비유                            |
|-------------------|---------------------------------|
| 오라클            | 창고 회사                       |
| 오라클 클라이언트 | 물건을 맡기거나 찾아가는 고객   |
| 서버 프로세스     | 의뢰를 처리하는 사원            |
| 디스크            | 창고                            |
| 캐시              | 짐을 일시적으로 보관하는 작업장 |

### 오라클 19c 프로세스
```console
bash-4.2$ ps -ef|grep _ORCL
oracle      57     1  0 15:35 ?        00:00:00 ora_pmon_ORCLCDB
oracle      59     1  0 15:35 ?        00:00:00 ora_clmn_ORCLCDB
oracle      61     1  0 15:35 ?        00:00:00 ora_psp0_ORCLCDB
oracle      63     1  1 15:35 ?        00:00:00 ora_vktm_ORCLCDB
oracle      67     1  0 15:35 ?        00:00:00 ora_gen0_ORCLCDB
oracle      69     1  2 15:35 ?        00:00:00 ora_mman_ORCLCDB
oracle      73     1  0 15:35 ?        00:00:00 ora_gen1_ORCLCDB
oracle      76     1  0 15:35 ?        00:00:00 ora_diag_ORCLCDB
oracle      78     1  0 15:35 ?        00:00:00 ora_ofsd_ORCLCDB
oracle      81     1  0 15:35 ?        00:00:00 ora_dbrm_ORCLCDB
oracle      83     1  0 15:35 ?        00:00:00 ora_vkrm_ORCLCDB
oracle      85     1  0 15:35 ?        00:00:00 ora_svcb_ORCLCDB
oracle      87     1  0 15:35 ?        00:00:00 ora_pman_ORCLCDB
oracle      89     1  0 15:35 ?        00:00:00 ora_dia0_ORCLCDB
oracle      91     1  0 15:35 ?        00:00:00 ora_dbw0_ORCLCDB
oracle      93     1  0 15:35 ?        00:00:00 ora_lgwr_ORCLCDB
oracle      95     1  0 15:35 ?        00:00:00 ora_ckpt_ORCLCDB
oracle      97     1  0 15:35 ?        00:00:00 ora_lg00_ORCLCDB
oracle      99     1  0 15:35 ?        00:00:00 ora_smon_ORCLCDB
oracle     101     1  0 15:35 ?        00:00:00 ora_lg01_ORCLCDB
oracle     103     1  0 15:35 ?        00:00:00 ora_smco_ORCLCDB
oracle     105     1  0 15:35 ?        00:00:00 ora_reco_ORCLCDB
oracle     107     1  0 15:35 ?        00:00:00 ora_w000_ORCLCDB
oracle     109     1  0 15:35 ?        00:00:00 ora_lreg_ORCLCDB
oracle     111     1  0 15:35 ?        00:00:00 ora_w001_ORCLCDB
oracle     113     1  0 15:35 ?        00:00:00 ora_pxmn_ORCLCDB
oracle     117     1  0 15:35 ?        00:00:00 ora_mmon_ORCLCDB
oracle     119     1  0 15:35 ?        00:00:00 ora_mmnl_ORCLCDB
oracle     121     1  0 15:35 ?        00:00:00 ora_d000_ORCLCDB
oracle     123     1  0 15:35 ?        00:00:00 ora_s000_ORCLCDB
oracle     125     1  0 15:35 ?        00:00:00 ora_tmon_ORCLCDB
```

기본적으로 모든 사원(프로세스)은 잠들어 있는 상태로 업무가 생기면 눈을 뜨고 끝나면 다시 잠드는 형태로 동작합니다. 서버 프로세스는 일이 생기기 전까지 'SQL*Net message from client'를 띄우고 대기하며 OS상에서 슬립 상태로 대기합니다. 메시지가 도착하면 눈을 뜨고 처리를 시작하며 SQL을 처리하는 도중 백그라운드 프로세스에 의뢰할 일이 생길 경우 작업을 의뢰하고 잠듭니다. 의뢰를 받은 백그라운드 프로세스도 일을 받기 전에는 잠들어 있다가 처리가 끝나면 필요한 서버 프로세스를 깨우고 다시 잠듭니다. 슬립 상태의 경우 CPU를 소비하지 않으므로 프로세스 수는 크게 중요하지 않습니다. 급여(비용)를 사무실에 있는 시간(슬립 포함)에 비례해서 지급하는 것이 아니라 일을 하는 시간(슬립 미포함)에 비례해서 지급하는 것과 비슷합니다. 
![image]( /resource/6e/bcfbd3-c2b8-4645-9f4a-d59e2f32b24c/252124224-b781fe4c-a407-4289-9a67-726baa028db9.png)

## 슬립과 대기의 관계
슬립한 상태는 대기와 유사합니다. e.g, 'SQL*Net Messagefrom client'는 서버 프로세스가 오라클 클라이언트로부터 통신(메시지)을 기다리고 있는 상태이며 OS상에서는 슬립하고 있습니다. 디스크에서 읽어오는 대기 이벤트인 'db file sequential(scattered) read'일 때도 디스크에서 읽어오는 것을 기다리며 OS상에서는 슬립하고 있습니다. 'Idle 대기 이벤트' 역시 대기 안에서도 SQL의 처리와 관계없이 쉬고 있는 대기를 의미합니다.  
 하지만 백그라운드 프로세스 중 일부는 쉬지 않고 정기적으로 작업을 하는 경우도 있습니다. 이것은 OS의 웨이크 업(wake up) 기능을 사용합니다. 초,분, 길게는 몇 시간마다 눈을 뜨도록 설정되어 있으며 눈을 뜰 때마다 작업을 수행합니다. v$session_wait를 보면 Idle 대기 이벤트로 얼마나 슬립하고 있었는지 확인할 수 있습니다. 이 중 유명한 것들로 'rdbms ipc message', 'smon timer', 'pmon timer' 등이 있습니다.
```sql

SQL> select sid, program, event, p1, p2, p3, state, seconds_in_wait from v$session;

       SID PROGRAM                        EVENT                                  P1         P2         P3 STATE               SECONDS_IN_WAIT                                                           
---------- ------------------------------ ------------------------------ ---------- ---------- ---------- ------------------- ---------------                                                           
         2 oracle@261d716abc02 (SVCB)     wait for unread message on bro 1933587304 1933296712          0 WAITING                           1                                                           
                                          adcast channel                                                                                                                                                
         3 oracle@261d716abc02 (LG01)     LGWR worker group idle                  1          0          0 WAITING                          49                                                           
         4 oracle@261d716abc02 (MMON)     rdbms ipc message                     300          0          0 WAITING                           1                                                           
         6 oracle@261d716abc02 (TT01)     Data Guard: Timer                       0          0          0 WAITING                          23                                                           
         7 oracle@261d716abc02 (CJQ0)     rdbms ipc message                     500          0          0 WAITING                           4                                                           
         8 oracle@261d716abc02 (M003)     class slave wait                        0          0          0 WAITING                          49                                                           
        12 oracle@261d716abc02 (W004)     Space Manager: slave idle wait          4          0          0 WAITING                           1                                                           
        14 sqlplus@261d716abc02 (TNS V1-V SQL*Net message to client      1650815232          1          0 WAITED SHORT TIME                 0                                                           
           3)                                                                                                                                                                                           

       SID PROGRAM                        EVENT                                  P1         P2         P3 STATE               SECONDS_IN_WAIT                                                           
---------- ------------------------------ ------------------------------ ---------- ---------- ---------- ------------------- ---------------                                                           
                                                                                                                                                                                                        
       124 oracle@261d716abc02 (GEN1)     rdbms ipc message                     100          0          0 WAITING                           1                                                           
       125 oracle@261d716abc02 (PMAN)     pman timer                              0          0          0 WAITING                           2                                                           
       126 oracle@261d716abc02 (SMCO)     rdbms ipc message                     300          0          0 WAITING                           0                                                           
       127 oracle@261d716abc02 (MMNL)     rdbms ipc message                     100          0          0 WAITING                           1                                                           
       128 oracle@261d716abc02 (AQPC)     AQPC idle                               0          0          0 WAITING                          11                                                           
       130 oracle@261d716abc02 (W007)     Space Manager: slave idle wait          7          0          0 WAITING                           1                                                           
       133 oracle@261d716abc02 (QM02)     Streams AQ: qmn coordinator id          0          0          0 WAITING                          18                                                           
                                          le wait                                                                                                                                                       
                                                                                                                                                                                                        
       247 oracle@261d716abc02 (PMON)     pmon timer                            300          0          0 WAITING                           2                                                           

       SID PROGRAM                        EVENT                                  P1         P2         P3 STATE               SECONDS_IN_WAIT                                                           
---------- ------------------------------ ------------------------------ ---------- ---------- ---------- ------------------- ---------------                                                           
       248 oracle@261d716abc02 (SCMN)     watchdog main loop                      0          8          0 WAITING                           2                                                           
       249 oracle@261d716abc02 (DIA0)     DIAG idle wait                          3          1          0 WAITING                           1                                                           
       250 oracle@261d716abc02 (RECO)     rdbms ipc message                  180000          0          0 WAITING                         532                                                           
       251 oracle@261d716abc02 (ARC1)     rdbms ipc message                   30000          0          0 WAITING                         233                                                           
       252 oracle@261d716abc02 (M002)     class slave wait                        0          0          0 WAITING                          49                                                           
       257 oracle@261d716abc02 (Q001)     Streams AQ: qmn slave idle wai          1          0          0 WAITING                          18                                                           
                                          t                                                                                                                                                             
       370 oracle@261d716abc02 (CLMN)     pmon timer                            300          0          0 WAITING                           2                                                           
       371 oracle@261d716abc02 (DIAG)     DIAG idle wait                          3          1          0 WAITING                           1                                                           
       372 oracle@261d716abc02 (DBW0)     rdbms ipc message                     300          0          0 WAITING                           1                                                           

       SID PROGRAM                        EVENT                                  P1         P2         P3 STATE               SECONDS_IN_WAIT                                                           
---------- ------------------------------ ------------------------------ ---------- ---------- ---------- ------------------- ---------------                                                           
       373 oracle@261d716abc02 (W000)     Space Manager: slave idle wait          0          0          0 WAITING                           0                                                           
       375 oracle@261d716abc02 (TMON)     rdbms ipc message                    3000          0          0 WAITING                          23                                                           
       376 oracle@261d716abc02 (ARC2)     rdbms ipc message                   30000          0          0 WAITING                         233                                                           
       493 oracle@261d716abc02 (PSP0)     rdbms ipc message                     100          0          0 WAITING                           0                                                           
       494 oracle@261d716abc02 (OFSD)     OFS idle                                0          0          0 WAITING                           1                                                           
       495 oracle@261d716abc02 (LGWR)     rdbms ipc message                     300          0          0 WAITING                           1                                                           
       496 oracle@261d716abc02 (LREG)     lreg timer                              1          0          0 WAITING                           3                                                           
       497 oracle@261d716abc02 (TT00)     Data Guard: Gap Manager                 0          0          0 WAITING                          52                                                           
       500 oracle@261d716abc02 (ARC3)     rdbms ipc message                   30000          0          0 WAITING                         233                                                           
       616 oracle@261d716abc02 (VKTM)     VKTM Logical Idle Wait                  0          0          0 WAITING                         539                                                           
       617 oracle@261d716abc02 (SCMN)     watchdog main loop                      0         10          0 WAITING                           2                                                           

       SID PROGRAM                        EVENT                                  P1         P2         P3 STATE               SECONDS_IN_WAIT                                                           
---------- ------------------------------ ------------------------------ ---------- ---------- ---------- ------------------- ---------------                                                           
       618 oracle@261d716abc02 (CKPT)     rdbms ipc message                     300          0          0 WAITING                           1                                                           
       619 oracle@261d716abc02 (W001)     Space Manager: slave idle wait          1          0          0 WAITING                           0                                                           
       621 oracle@261d716abc02 (M000)     class slave wait                        0          0          0 WAITING                          49                                                           
       623 oracle@261d716abc02 (TT02)     heartbeat redo informer                 0          0          0 WAITING                           1                                                           
       628 oracle@261d716abc02 (Q004)     Streams AQ: waiting for time m          0          0          0 WAITING                         427                                                           
                                          anagement or cleanup tasks                                                                                                                                    
       739 oracle@261d716abc02 (GEN0)     rdbms ipc message                     300          0          0 WAITING                           1                                                           
       740 oracle@261d716abc02 (DBRM)     rdbms ipc message                     300          0          0 WAITING                           1                                                           
       741 oracle@261d716abc02 (LG00)     LGWR worker group idle                  0          0          0 WAITING                          47                                                           
       742 oracle@261d716abc02 (PXMN)     rdbms ipc message                     300          0          0 WAITING                           0                                                           

       SID PROGRAM                        EVENT                                  P1         P2         P3 STATE               SECONDS_IN_WAIT                                                           
---------- ------------------------------ ------------------------------ ---------- ---------- ---------- ------------------- ---------------                                                           
       743 oracle@261d716abc02 (M001)     class slave wait                        0          0          0 WAITING                          49                                                           
       746 oracle@261d716abc02 (W002)     Space Manager: slave idle wait          2          0          0 WAITING                           3                                                           
       752 oracle@261d716abc02 (W005)     Space Manager: slave idle wait          5          0          0 WAITING                           0                                                           
       863 oracle@261d716abc02 (MMAN)     rdbms ipc message                     300          0          0 WAITING                           1                                                           
       864 oracle@261d716abc02 (VKRM)     VKRM Idle                               0          0          0 WAITING                         539                                                           
       865 oracle@261d716abc02 (SMON)     smon timer                            300          0          0 WAITING                         230                                                           
       866 oracle@261d716abc02 (W006)     Space Manager: slave idle wait          6          0          0 WAITING                           3                                                           
       867 oracle@261d716abc02 (ARC0)     rdbms ipc message                    6000          0          0 WAITING                          53                                                           
       869 oracle@261d716abc02 (W003)     Space Manager: slave idle wait          3          0          0 WAITING                           0                                                           

54 rows selected.

SQL> 
```

## DBWR의 동작과 역할
DBWR은 변경된 데이터를 캐시에서 디스크로 기록하는 역할을 합니다. 커밋한 시점에 바로 기록하는 것이 아니라 나중에 한번에 수행하는데 LGWR가 커밋한 시점의 REDO 로그(데이터 변경 정보)를 디스크에 기록합니다. LGWR는 REDO 로그 파일에 REDO 로그를 기록하며 ARCH는 아카이브 REDO 로그 파일에 기록합니다.

### I/O 동작 방식
동기 I/O는 서버 프로세스가 수행하는 'db file sequential read'와 같은 I/O를 말합니다. 기본적인 I/O로서 한 개의 I/O 처리가 끝나기 전까지 다음 처리를 할 수 없습니다. 반면 비동기 I/O는 I/O가 종료하기 전에 다음 처리를 실행할 수 있는 I/O를 말합니다. 비동기 I/O를 사용 시 여러 I/O를 동시에 처리할 수 있기 때문에 디스크를 효율적으로 사용할 수 있습니다. 이러한 비동기 I/O 방식이 없다면 디스크는 여유가 넘쳐도 I/O에 병목 현상이 발생할 수 있지만 비동기 I/O라도 부하가 커지면 SQL을 처리하기 위해 데이터를 읽는 속도가 느려질 수 있으므로 디스크에 너무 많은 부하를 주지 않도록 해야합니다. 그래서 DBWR는 부하가 너무 집중되지 않도록 긴 시간에 걸쳐 가능한 부하를 균일하게 줄 수 있도록 동작합니다. 이는 '(SQL) 응답시간을 중시한다'를 지키기 위해 만든 좋은 구조라고 할 수 있습니다. DBWR의 대기 이벤트 'rdbms ipc message'는 Idle 상태를 나타내며 'db file parallel write'는 동시에 병렬로 데이터를 디스크에 기록하고 있다는 것을 의미합니다(기록하고 있는 도중 시점에 따라 이런 대기 이벤트가 표시되지 않기도 합니다). 단 OS에 따라 비동기 I/O를 사용하기 위한 조건이 있어서 실제로는 한 개의 I/O가 끝나고 다음 I/O를 처리하는 형태로 수행할 수도 있습니다.
DBWR 프로세스는 OS상에서 'DBWn'이라고 표시됩니다(n은 정수. e.g, DBW0, DBW1, DBW2). 대형 시스템이나 디스크에 기록하는 속도가 느린 환경에서 DBWR을 여러 개 기동할 경우 성능을 향상시킬 수 있으며 비동기 I/O를 사용할 수 없는 환경에서 효과적입니다. DBWR 수는 초기화 파라미터 'DB_WRITER_PROCESSES'를 통해 조정할 수 있습니다.

### DBWR에 장애가 발생하는 경우
디스크의 성능이 한계에 다다랐을 때나 기록하는 속도가 따라가지 못할 때 발생할 수 있습니다. DBWR이 버퍼 캐시의 변경된 블록을 디스크에 기록하는 속도가 느려지면 서버 프로세스가 사용할 수 있는 빈 버퍼가 확보되지 못하므로 'free buffer waits'라는 대기 이벤트를 띄우고 기다립니다. I/O가 일시적으로 행에 걸리면 DBWR도 일시적으로 행에 걸립니다. 그러면 'free buffer waits'가 되거나 해당 블록이 사용중(이 경우 기록 중)이라는 'write complete waits'나 'buffer busy waits'에 의해 서버 프로세스가 대기합니다.
![image]( /resource/6e/bcfbd3-c2b8-4645-9f4a-d59e2f32b24c/252388776-40a95224-4f69-4080-a3f9-0e5ee2699010.png)

## LGWR의 동작과 역할
LGWR은 'rdbms ipc message' 상태로 슬립하고 있습니다. LGWR는 커밋 시 REDO 로그를 기록하고 커밋을 하지 않아도 3초에 한 번 'rdbms ipc message'에서 깨어나서 로그 버퍼의 데이터를 기록하며 기록할 때 'log file parallel write' 상태로 대기합니다. 또한 서버 프로세스가 LGWR의 REDO 로그 기록을 기다릴 때 'log file sync'라는 대기 이벤트로 기다립니다.

### LGWR에 장애가 발생하는 경우
성능이 부족하거나 REDO 로그의 생성량이 많을 때 아카이브를 받는 디스크가 가득 찼을 때, 로그 버퍼의 용량이 작은 경우에 장애가 발생합니다. 성능이 부족한 경우라 했지만 여러 개의 REDO 로그 정보를 한꺼번에 모아서 내려쓰기 때문에 성능이 쉽게 부족해지진 않습니다. 흔히 발생하는 상황은 아카이브를 내려받는 디스크가 가득 차서 발생하는 장애입니다. 또한 로그 버퍼의 용량이 작을 때는 'log buffer space' 대기 이벤트 등으로 대기합니다. 최근에는 메모리 크기가 커졌기 때문에 로그 버퍼를 128MB 이상으로 설정하는 경우도 있습니다.

## SMON의 동작과 역할
 SMON(System MONitor)은 주로 공간 전문 청소 업체 역할을 하며 테이블스페이스 안의 빈공간들을 합치거나 처리 도중 종료된 트랜잭션을 롤백, 임시 세그먼트를 청소하는 일 등을 합니다. 평소에는 'smon timer'라는 대기 이벤트 상태로 슬립하고 있습니다.
 또한 데이터베이스가 비정상 종료(서버 장비 정지, 강제 종료)된 후 재기동할 때 인스턴스 복구라고 불리는 처리를 수행합니다. 온라인 REDO 로그 파일과 데이터 파일을 사용해서 일관성을 보장할 수 있도록 처리합니다.

## PMON의 동작과 역할
 PMON(Process MONitor)은 주로 메모리와 프로세스 전문 청소 업체로 서버 프로세스가 비정상 종료했을 때 메모리나 프로세스를 정리합니다. 필요할 때는 세션이나 프로세스를 청소하거나 정리된 프로세스가 내부 Lock이나 메모리를 보유하고 있다면 그것을 해제합니다. 
 PMON은 필요할 경우 약 1분에 한 번 청소를 수행합니다. 평상시에는 'pmon timer'라는 대기 이벤트 상태로 슬립하고 있습니다. PMON은 다른 프로세스들을 감시해주지만 자신이 비정상 종료된다면 인스턴스가 정지될 수 있습니다. PMON에 문제가 발생할 경우 다른 프로세스를 감시할 수 없으며 데이터베이스 전체가 불안정한 상태로 빠질 가능성이 큽니다. 최악의 경우 기록한 데이터임에도 불구하고 반영되지 않는 등의 사태를 피하기 위해 MMAN 프로세스가 PMON의 이상을 감지하고 인스턴스를 정지하도록 합니다.

## LREG의 동작과 역할

LREG(Listener REGistration)이라는 프로세스는 인스턴스의 정보, 현재 프로세스의 수, 인스턴스의 부하를 리스너에게 등록하는 작업을 합니다. 오라클 11g까지는 PMON이 담당했지만 12c 이후부터 LREG라는 전용 프로세스가 역할을 이어받았습니다. listener.ora 파일에 인스턴스의 정보를 등록하지 않아도 리스너가 인스턴스의 정보를 알고 있는 경우가 있는데 LREG가 리스너에 정보를 등록했기 때문입니다. 또한 초기화 파라미터로 커넥션 수의 상한을 설정했을 때 리스너가 현재의 커넥션 수를 알고 있는 것은 LREG이 정기적으로 리스너에게 알려주기 때문입니다.
![image]( /resource/6e/bcfbd3-c2b8-4645-9f4a-d59e2f32b24c/253022760-c3b56a76-3cfe-4ab5-a257-3051e25c96c5.png)

## ARCH의 동작과 역할
 ARCH(ARCHiver) 프로세스는 OS상에서 'ARCn'라고 표시됩니다(n에는 숫자가 들어갑니다). 아카이버 프로세스는 REDO 로그 파일을 아카이브(보관)하는 프로세스로 ARCH에 의해 보관된 REDO 로그 파일을 아카이브 REDO 로그 파일이라고 부릅니다. 아카이브 로그 모드(REDO 로그를 아카이브해서 남기는 모드)일 때는 아카이브 REDO 로그가 생성될 때까지는 해당 REDO 로그 파일을 다시 사용할 수 없습니다. 
 평상시에는 대기 이벤트 'rdbms ipc message' 상태로 슬립하고 있지만 로그 스위치(LGWR가 내려쓸 REDO 로그 파일을 전환하는 작업)가 수행되어 아카이브를 생성할 필요가 있을 때 동작을 시작합니다.
 ARCH 프로세스는 노 아카이브 로그 모드에서는 생성되지 않으며 아카이브 로그 모드에서만 생성됩니다. 프로세스는 처리 부하량에 따라 여러 개가 기동되지만 'LOG_ARCHIVE_MAX_PROCESSES' 파라미터를 통해 최초에 기동해둘 프로세스 수를 제어할 수 있습니다.
그 외에 데이터 가드(Data Guard)라는 데이터베이스의 복제/동기화를 수행하는 기능을 사용할 때도 ARCH 프로세스가 사용됩니다. 데이터 가드는 복제할 원본 데이터베이스에서 대상 데이터베이스에 REDO 로그를 전송하고 적용함으로써 데이터를 동기화합니다. REDO 전송이 늦어지거나 어떤 이유로 인해 REDO를 전송하지 못했을 때는 원본 데이터베이스와 대상 데이터베이스 간에 정보(동기화)가 맞지 않게 되므로 아카이브 REDO 로그를 전송합니다(설정에 따라 다르지만 REDO의 정보는 TMON이나 NSS와 같은 프로세스가 보내며 RFS 프로세스가 수신을 담당합니다). 이때 복제 대상 데이터베이스에 통신이 되는지 확인과 아카이브 REDO의 전송 같은 작업을 ARCH가 담당하며 아카이브 REDO 로그를 생성하는 작업도 병행해서 수행합니다.

## 그 외의 백그라운드 프로세스

### CKPT
 체크포인트(버퍼 캐시의 변경된 데이터를 데이터 파일에 반영하는 작업)를 할 때 데이터 파일의 헤더에 관리 정보를 기록하는 프로세스입니다. 체크포인트를 수행할 때 데이터 파일에 기록하지 못하는 상황이 발생할 경우 오라클은 데이터의 정합성을 확보하기 위해 인스턴스를 정지시키거나 데이터 파일을 오프라인으로 변경합니다.
 
### 그 외의 여러 프로세스 

프로세스명의 'XXX', 'X'에는 숫자가 들어갑니다.

| 프로세스         | 설명                                                                                                                                   |
|------------------|----------------------------------------------------------------------------------------------------------------------------------------|
| SXXX             | 공유 서버 구성(오라클 클라이언트와 서버 프로세스가 1:1로 대응하지 않는 구성)용 프로세스                                                |
| DXXX             | 디스패처. 공유 서버 구성을 위한 프로세스. 오라클 클라이언트에서 요청을 받아 공유 서버 프로세스에게 보내는 (dispatch) 일을 합니다.      |
| JXXX             | 오라클의 '잡(job)'을 위한 프로세스. 잡 코디네이터에 의해 기동합니다.                                                                   |
| CJQX             | 잡의 코디네이터입니다. JXXX를 늘리거나 줄이며 오라클 기동 시에 함께 기동합니다.                                                        |
| PXXX             | 슬레이브 프로세스. 병렬 쿼리(대량의 데이터를 병렬로 처리해서 결과를 빠르게 가져오기 위한 쿼리)를 위한 프로세스입니다.                  |
|                  | 병렬 쿼리를 사용할 때는 여러 개의 슬레이브 프로세스가 손발이 되어 데이터를 읽어오거나 정렬 등을 수행하지만 반드시 빨라지지는 않습니다. |
| QMNX, QXXX       | AQ(Advanced Queuing: 비동기 방식으로 메시지를 주고받는 기능)을 위한 프로세스. 메시지를 관리하고 통보하는 등의 작업을 수행합니다.       |
| QMNC             | QMNX, QXXX와 마찬가지로 AQ를 위한 프로세스입니다. 코디네이터의 역할을 수행합니다.                                                      |
| MMAN             | Memory MANager 프로세스. SGA 안의 메모리를 조정합니다. 오라클 10g에서부터 존재하며 기본적으로 오라클과 함께 기동합니다.                |
| MMON, MMNL, MXXX | AWR을 수집하고 기록하기 위한 프로세스. 오라클 10g 이후부터는 기본적으로 오라클과 함께 기동합니다.                                      |
| LMSX, LMD0, LCKX | RAC용 프로세스. LMSX는 캐시 퓨전(Cache Fusion, 장비 간 데이터를 주고받는 것)을 수행. DIAG는 장애가 발생했을 때 정보 수집               |
| LCKX, LMON, DIAG | DIAG는 v$session_wait에서 처리하는 중으로 보이더라도 실제로는 슬립하고 있는 경우도 있습니다. 그 외 프로세스는 장비 간 Lock 등을 관리.  |
| RECO             | 분산 트랜잭션(여러 데이터베이스에 걸친 트랜잭션)에 발생하는 문제를 해결하기 위한 프로세스.                                             |
