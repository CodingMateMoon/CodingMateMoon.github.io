---
layout  : wiki
title   : markdown 코드 블록(code block)
summary : 
date    : 2023-04-23 15:09:29 +0900
updated : 2023-04-23 18:39:33 +0900
tag     : 
toc     : true
public  : true
parent  : vim
latex   : false
resource: C1DF1BDA-87EE-4AB7-A3E8-B0D4FCB8ED52
---
* TOC
{:toc}

# [markdown] 코드 블록 (code block)
markdown에서 ```를 이용해 코드를 감싸서 코드 블록을 만들 수 있습니다.
<img width="447" alt="image" src=" /resource//233828006-f7031b60-4c08-45f6-98a0-efc5d993b123.png ">

* js
```js
function () { return "This code is highlighted as Javascript!"}
```

* viml
```viml
Plug
```

* json
```json
{ "id": "hi"}
```

* sh
```sh
$ python3
```

* bash
```bash
$ sudo pip3 install --upgrade neovim
```

* console
```console
foo@bar:~$ whoami
foo
```
# 참고자료
* how to highlight bash/shell commands in markdown?: <https://stackoverflow.com/questions/20303826/how-to-highlight-bash-shell-commands-in-markdown>
* [공통] 마크다운 markdown 작성법 : [ihoneymon markdown 작성법](https://gist.github.com/ihoneymon/652be052a0727ad59601 )
