---
layout  : wiki
title   : git 특정 커밋 버전으로 되돌리기
summary : 
date    : 2023-04-23 02:41:15 +0900
updated : 2023-05-21 13:14:07 +0900
tag     : 
toc     : true
public  : true
parent  : git
latex   : false
resource: E401D44D-9D83-4C9E-8A65-877A7EE162D8
---
* TOC
{:toc}

1. Git log [file_name]
2. git checkout [commit-version(2c95ea~)] [file_name]

e.g)
* 특정 시점 파일로 checkout
```console
git checkout a0bfcc8a2d90c872ca62dbb4d33abe83a2777e4d a.sh
```

* stage에 들어가지 않은 수정한 파일을 수정 이전으로 되돌리기
```console
git checkout -- .
git checkout -- a.sh
```

## 참고자료
* git 수정 이전으로 내용 되돌리기 : <https://www.lesstif.com/gitbook/git-54952660.html>
* How can I revert uncommitted changes including files and folders : <https://stackoverflow.com/questions/5807137/how-can-i-revert-uncommitted-changes-including-files-and-folders>
