---
layout  : wiki
title   : wsl2에서 ruby 2.7 설치
summary : 
date    : 2023-05-10 00:59:26 +0900
updated : 2023-05-21 11:06:32 +0900
tag     : 
toc     : true
public  : true
parent  : linux
latex   : false
resource: dd90e174-255a-472c-b130-cff6522dc18c
---
* TOC
{:toc}

```viml 
jhmoon@jhmoon:~$ sudo apt update
Hit:1 http://security.ubuntu.com/ubuntu jammy-security InRelease
Hit:2 http://archive.ubuntu.com/ubuntu jammy InRelease
Hit:3 http://archive.ubuntu.com/ubuntu jammy-updates InRelease

jhmoon@jhmoon:~$ sudo apt install git curl autoconf bison build-essential libssl-dev libyaml-dev libreadline6-dev zlib1g-dev libncurses5-dev libffi-dev libgdbm6 libgdbm-dev libdb-dev

Reading package lists... Done
Building dependency tree... Done

jhmoon@jhmoon:~$ curl -fsSL https://github.com/rbenv/rbenv-installer/raw/HEAD/bin/rbenv-installer | bash
rbenv already seems installed in `/usr/bin/rbenv'.

Installing ruby-build with git...
Cloning into '/home/jhmoon/.rbenv/plugins/ruby-build'...

jhmoon@jhmoon:~$ echo 'export PATH="$HOME/.rbenv/bin:$PATH"' >> ~/.bashrc
jhmoon@jhmoon:~$ echo 'eval "$(rbenv init -)"' >> ~/.bashrc
source ~/.bashrc

jhmoon@jhmoon:~$ rbenv install -L
1.8.5-p52
1.8.5-p113
2.7.4

jhmoon@jhmoon:~$ rbenv install 2.7.4
To follow progress, use 'tail -f /tmp/ruby-build.20230507162417.1792.log' or pass --verbose
Downloading openssl-1.1.1t.tar.gz...

jhmoon@jhmoon:~$ rbenv global 2.7.4
jhmoon@jhmoon:~$ ruby -v
ruby 2.7.4p191 (2021-07-07 revision a21a3b7d23) [x86_64-linux]
```

## 참고자료
* How to Install Ruby on Ubuntu 22.04 : <https://linuxhint.com/install-ruby-ubuntu-2204/> 
