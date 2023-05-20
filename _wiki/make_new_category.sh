#!/bin/bash

# set file name
filename="${1}.md"
today=$(date +"%Y-%m-%d %H:%M:%S %z")
# set content
content="---
layout : category
title : Enter a title.
summary :
date : ${today}
updated : ${today}
tag :
toc : true
public : true
parent : index
latex: false
---

*TOC
{:toc}"

# create file with content
echo "$content" > "$filename"

# confirmation message
echo "File created: $filename"
