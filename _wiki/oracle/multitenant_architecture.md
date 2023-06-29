---
layout  : wiki
title   : Oracle 멀티테넌트 아키텍처(Multi-Tenant Architecture. MTA)
summary : 
date    : 2023-06-28 08:23:25 +0900
updated : 2023-06-29 09:04:48 +0900
tag     : oracle
resource: 94/38b3ab-328d-4e61-a2a5-14f602e7c601
toc     : true
public  : true
parent  : [[oracle]]
latex   : false
---
* TOC
{:toc}

## Oracle 멀티테넌트 아키텍처(Multi-Tenant Architecture. MTA) 
what?
여러 개의 데이터베이스를 관리하면서도 시스템의 독립성을 확보하고 운영 비용을 절감하기 위한 시스템 아키텍쳐로 Oracle 12c R1부터 제공되었습니다. Tenant는 세입자라는 의미가 있는데 여러 세입자(DB)가 큰 집에 모여사는 것과 비슷한 개념입니다.
여러 개의 업무용 데이터베이스와 그것을 관리하는 관리 데이터베이스로 구성되어 있으며 관리 데이터베이스는 관리를 목적으로 하며 소속되어 있는 여러 업무 데이터베이스가 지금까지 해왔던 대로 각 시스템의 애플리케이션 등에서 커넥션을 받아 데이터 처리를 수행합니다. 


## 참고자료
- 그림으로 공부하는 오라클 구조(스기타아츠시 외 4명)
- 오라클 멀티테넌트 DB 기본개념 정리 (Oracle Multi-Tenant DB Basics) : <https://jack-of-all-trades.tistory.com/286>
