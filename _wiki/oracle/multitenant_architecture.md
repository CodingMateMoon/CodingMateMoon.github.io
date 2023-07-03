[[---]]
layout  : wiki
title   : Oracle 멀티테넌트 아키텍처(Multi-Tenant Architecture. MTA)
summary : 
date    : 2023-06-28 08:23:25 +0900
updated : 2023-07-04 08:02:53 +0900
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
여러 개의 업무용 데이터베이스와 그것을 관리하는 관리 데이터베이스로 구성되어 있으며 관리 데이터베이스는 관리를 목적으로 하며 소속되어 있는 여러 업무 데이터베이스가 지금까지 해왔던 대로 각 시스템의 애플리케이션 등에서 커넥션을 받아 데이터 처리를 수행합니다. 또한 백업 및 복구, 패치 등 기본적인 관리를 관리 데이터베이스를 경유해서 내부적으로 수행할 수 있으므로 운영 비용을 절감하는 장점도 있습니다.
앞서 설명한 관리 데이터베이스를 CDB(Container Database), 업무용 데이터베이스를 PDB(Pluggable Database)라고 합니다. 
CDB는 데이터베이스 전체에 공유하는 오브젝트와 메타데이터를 관리합니다. 반면 PDB는 지금까지 사용했던 애플리케이션에서 접속하는 데이터베이스로 각각의 데이터를 가지고 있습니다. 접속하는 애플리케이션쪽에서는 데이터베이스를 PDB라고 신경 쓰지 않고 평소처럼 사용할 수 있습니다. 

Why?  
싱글 DB가 10개 있다고 가정할 때 각 서버의 CPU, 메모리 사용량을 보면 10~30% 등 나머지 70% 이상의 자원이 여유분으로 남는 경우를 볼 수 있습니다. 각 DB를 통합해서 관리할 경우 프로세스, 메모리와 같은 자원을 공유해서 사용함으로써 가용 자원을 효율적으로 활용하고 사용자 데이터는 개별로 저장해서 데이터의 독립성을 유지합니다.

### CDB 구성
![image]( /resource/94/38b3ab-328d-4e61-a2a5-14f602e7c601/250339325-0a711e07-a325-4858-8cfa-a44d3d08d6b7.png)

CDB$ROOT : 데이터베이스 전체에 공유하는 오브젝트와 메타데이터를 관리합니다. 
e.g, 오라클에서 제공하는 PL/SQL 패키지에 대한 소스 코드.(메타데이터)

PDB$SEED : 시스템에서 제공하는 기본 PDB로 1개만 존재하며 유저가 생성하는 PDB에 대한 템플릿으로 사용됩니다. PDB$SEED에 있는 오브젝트를 변경하거나 추가하는 작업은 할 수 없습니다.

Application Container : PDBs로 구성된 1개의 Application Root를 유일하게 가지고 있습니다.

Application Root : CDB root에만 속합니다.

PDB의 경우 초창기 비어있는 CDB에 PDB를 추가하며 Application Container에 속하지 않거나 1개의 Application Container에만 속합니다. PDB가 Application Container에 속하는 경우 Application PDBs 라고 합니다.

## 참고자료
- 그림으로 공부하는 오라클 구조(스기타아츠시 외 4명)
- 오라클 멀티테넌트 DB 기본개념 정리 (Oracle Multi-Tenant DB Basics) : <https://jack-of-all-trades.tistory.com/286>
- Introduction to the Multitenant Architecture : <https://docs.oracle.com/en/database/oracle/oracle-database/19/multi/introduction-to-the-multitenant-architecture.html#GUID-FC2EB562-ED31-49EF-8707-C766B6FE66B8>
