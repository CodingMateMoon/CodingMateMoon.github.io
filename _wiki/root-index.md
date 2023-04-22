---
layout  : wikiindex
title   : wiki
toc     : true
public  : true
comment : false
updated : 2023-04-22 23:20:14 +0900
regenerate: true
---

## [[vim]]
* [[vim/vimrc]]
* [[fzf]]
* [[test]] 
---
## [[how-to]]

* [[mathjax-latex]]

## [[git]]


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

