---
layout  : wiki
title   : 대기와 Lock 대기
summary : 
date    : 2023-05-30 23:16:58 +0900
updated : 2023-06-02 09:15:04 +0900
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
