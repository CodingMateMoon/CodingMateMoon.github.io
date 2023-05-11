---
layout  : wiki
title   : Raw Device 개념
summary : 
date    : 2023-05-11 08:34:15 +0900
updated : 2023-05-11 08:46:18 +0900
tag     : 
toc     : true
public  : true
parent  : 
latex   : false
resource: 93759dca-45cf-47d4-8d22-760e31046dd8
---
* TOC
{:toc}

#Raw Device
"Raw device"는 디스크 또는 다른 저장 장치에서 데이터를 직접 읽거나 쓰기 위해 사용되는 디바이스입니다. 일반적으로 파일 시스템이 존재하지 않는, 즉 형식화되지 않은 디스크를 가리키며, 디스크의 모든 부분을 포함합니다.


Raw device는 일반 파일 시스템과 달리, 파일 시스템의 메타데이터가 없기 때문에 더 높은 성능을 제공하고, 데이터 손상 가능성이 적습니다. 따라서 일부 데이터베이스 또는 백업 애플리케이션에서는 Raw device를 사용하여 데이터를 더욱 안전하게 저장하고 관리합니다.

Storage Device를 Access 하는 방법은 Block Device와 Raw Device로 구분하는데 Block Device의 Block은 파일시스템의 Block을 의미합니다. Raw Device 위에 파일시스템이 얹어있는 것으로 볼 수 있습니다. Raw Device는 파일시스템이 없기 때문에 파일, 디렉토리, Access 컨트롤 등을 어플리케이션에서 직접 관리해야합니다. 블록 장치로 구성되는 것이 아닌 문자 장치로 구성되는 방식으로 포맷을 지정하지 않고 디스크를 구성한 방식으로 문자 단위로 입출력이 이뤄지며 커널이 제공하는 버퍼를 사용하지 않고 입출력 장치의 버퍼 또는 큐를 사용합니다. File System에서 사용하는 운영체제를 거치지 않고 바로 데이터 I/O가 일어나기 때문에 I/O 성능이 좋습니다.

#참고자료
* <https://milhouse93.tistory.com/173>
* <https://doosil87.github.io/linux/2019/07/29/rawdevicefilesystem.html>
