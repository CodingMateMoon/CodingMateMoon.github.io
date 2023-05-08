---
layout  : wikiindex
title   : wiki
toc     : true
public  : true
comment : false
updated : 2023-05-09 06:06:44 +0900
regenerate: true
---

## [[vim]]
* [[vim/vimrc_set]]
* [[vim/markdown_code_block]]

## [[how-to]]

* [[mathjax-latex]]

## [[/git]]
* [[/git/git_check_v]]
* [[/git/git_test]]

## [[oracle]]
* [[oracle/oracle_connection]]

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

