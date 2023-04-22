---
layout  : wikiindex
title   : wiki
toc     : true
public  : true
comment : false
updated : 2023-04-23 02:41:15 +0900
regenerate: true
---

## [[vim]]
* [[vim/vimrc_set]]

## [[how-to]]

* [[mathjax-latex]]

## [[/git]]
* [[/git/git_check_v]]
* [[/git/git_test]]

## [[temp]]
* [[temp/temp1]]
* [[temp/temp2]]

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

