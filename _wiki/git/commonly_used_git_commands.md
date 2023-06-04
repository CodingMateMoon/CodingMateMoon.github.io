---
layout  : wiki
title   : git 명령어 모음
summary : 
date    : 2023-06-04 13:34:55 +0900
updated : 2023-06-04 13:44:41 +0900
tag     : 
resource: ef/a9e7c1-b76c-494c-8360-47eb6f4ec1d7
toc     : true
public  : true
parent  : git
latex   : false
---
* TOC
{:toc}

## git push <저장소명> <브랜치명>
```console
jhmoon@jhmoon:~/CodingMateMoon.github.io$ git status
On branch main
Your branch is up to date with 'origin/main'.

Changes not staged for commit:
  (use "git add <file>..." to update what will be committed)
  (use "git restore <file>..." to discard changes in working directory)
	modified:   _wiki/oracle/ORA-12162.md
	modified:   data/metadata/oracle/ORA-12162.json

no changes added to commit (use "git add" and/or "git commit -a")
jhmoon@jhmoon:~/CodingMateMoon.github.io$ git add .
jhmoon@jhmoon:~/CodingMateMoon.github.io$ git commit -m "Fix json parsing error"
jhmoon@jhmoon:~/CodingMateMoon.github.io$ git push origin main
Enumerating objects: 17, done.
Counting objects: 100% (17/17), done.
Delta compression using up to 8 threads
Compressing objects: 100% (9/9), done.
Writing objects: 100% (9/9), 859 bytes | 859.00 KiB/s, done.
Total 9 (delta 7), reused 0 (delta 0), pack-reused 0
remote: Resolving deltas: 100% (7/7), completed with 7 local objects.
```


## 참고자료
git push 사용법/팁 : <https://www.daleseo.com/git-push/>
