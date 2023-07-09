---
layout  : wiki
title   : 백그라운드 프로세스의 동작과 역할
summary : 
date    : 2023-07-08 00:28:07 +0900
updated : 2023-07-09 12:39:31 +0900
tag     : 
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
