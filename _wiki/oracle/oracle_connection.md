---
layout  : wiki
title   : oracle 접속 동작
summary : 
date    : 2023-05-09 05:37:45 +0900
updated : 2023-05-09 06:03:45 +0900
tag     : 
toc     : true
public  : true
parent  : [[oracle]]
latex   : false
resource: 9a01bcc9-7e1e-4cbb-9235-4189eb5302cb
---
* TOC
{:toc}

oracle에서는 소켓을 사용해서 전화의 송수신과 같은 형태로 연결을 요청하고 상대가 이에 응답하면 데이터를 주고받을 수 있습니다. 오라클에서는 수신을 기다리는 프로세스를 리스너(listener)라고 합니다.
