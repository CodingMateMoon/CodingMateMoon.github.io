---
layout  : wikiindex
title   : wiki
toc     : true
public  : true
comment : false
updated : 2023-03-01 21:32:51 +0900
regenerate: true
---

## [[vim]]
* [[vim/vimrc]]
---
## [[how-to]]

* [[mathjax-latex]]


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

