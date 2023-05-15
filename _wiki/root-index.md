---
layout  : wikiindex
title   : wiki
toc     : true
public  : true
comment : false
updated : 2023-05-16 06:13:09 +0900
regenerate: true
---

## [[vim]]
* [[vim/vimrc_set]]
* [[vim/markdown_code_block]]

## [[how-to]]

* [[mathjax-latex]]

## [[linux]]
* [[linux/install_ruby_2.7]]

## [[/git]]
* [[/git/git_check_v]]
* [[/git/git_test]]

## [[oracle]]
* [[oracle/oracle_connection]]

## [[computer-architecture]]
* [[computer-architecture/FAT]]

## [[os]]
* [[os/raw_device]]
* [[os/FAT]]

## [[refactoring]]
* [[refactoring/basic]]
* [[refactoring/Encapsulation]]

---

## blog posts
<div>
    <ul>
{% for post in site.posts %}
    {% if post.public == true %}
        <li>
            <a class="post-link" href="{{ post.url | prepend: site.baseurl }}">
                {{ post.title }}
            </a>
        </li>
    {% endif %}
{% endfor %}
    </ul>
</div>

