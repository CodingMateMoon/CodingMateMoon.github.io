---
layout  : wikiindex
title   : wiki
toc     : true
public  : true
comment : false
updated : 2023-04-23 00:02:32 +0900
regenerate: true
---

## [[vim]]
* [[vim/vimrc]]
---
## [[how-to]]

* [[mathjax-latex]]

## [[git]]
* [[git/git_checkout]]

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

