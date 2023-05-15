---
layout  : wiki
title   : 파일 할당 테이블(File Allocation Table, FAT)
summary : 
date    : 2023-05-16 06:13:09 +0900
updated : 2023-05-16 06:32:43 +0900
tag     : 
toc     : true
public  : true
parent  : 
latex   : false
resource: a436155b-11b7-40fb-8ae0-47bcd6337ef4
---
* TOC
{:toc}

# FAT 개념
* 디지털 카메라 등에 장착되는 대부분의 메모리 카드와 수많은 컴퓨터 시스템에 널리 쓰이는 컴퓨터 파일 시스템 구조(architecture)입니다. 어느 영역에 파일이 속해 있는지, 공간에 여유가 있는지 또 어디에 각 파일이 디스크에 저장되어 있는지에 대한 정보를 테이블 형식으로 관리합니다. 테이블의 크기를 제한하기 위해 클러스터라 불리는 하드웨어 섹터에 인접한 그룹에서 디스크 공간이 파일에 할당됩니다. 아파트의 몇동 몇호에 누가 있는지와 같이 Track, Sector, 파일명 등의 형식으로 데이터를 기록하고 관리하며 데이터를 지울 때는 디스크에서 Sector의 내용 전체를 overwrite하기 보다 파일명만 a.jpg -> x 등으로 바꾸고 delete 상태를 Y로 바꾼 뒤에 overwrite가 가능한 상태로 변경합니다. 그래서 데이터 복구 프로그램을 사용했을 때 실제 Sector의 내용은 그대로 남은 상태일 경우 복구가 가능합니다.

# 참고자료
* [인프런] 넓고 얕게 외워서 컴공 전공자 되기 강의-<https://www.inflearn.com/course/%EB%84%93%EA%B3%A0%EC%96%95%EA%B2%8C-%EC%BB%B4%EA%B3%B5-%EC%A0%84%EA%B3%B5%EC%9E%90/>
* [위키백과] 파일 할당 테이블-<https://ko.wikipedia.org/wiki/%ED%8C%8C%EC%9D%BC_%ED%95%A0%EB%8B%B9_%ED%85%8C%EC%9D%B4%EB%B8%94>
