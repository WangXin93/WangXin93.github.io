---
layout: post
title:  "这是我的第一篇博客"
date:   2018-01-25 20:26:46 +0800
categories: Jekyll
---

这是我的第一篇博客。 这里记录Jekyll中Markdown的语法, Source file 在[这里](https://github.com/WangXin93/WangXin93.github.io/blob/master/_posts/2018-01-25-my-first-blog.md)。

## Header 2 (H1 is reserved for post titles)##

### Header 3

#### Header 4

A link to [Jekyll Now](http://github.com/barryclark/jekyll-now/). A big ass literal link <http://github.com/barryclark/jekyll-now/>

![an image alt text]({{ site.baseurl }}/favicon.ico "an image title")

```
居中插入图片，同时改变图像尺寸比例
<div align="center">
<img src="/assets/2018-10-21-naive-bayes/bayesian_rule.png" style="width:80%"/>
</div>
```

```
居中嵌入视频
<div align="center">
<iframe width="420" height="315" src="http://www.youtube.com/embed/stgYW6M5o4k" frameborder="0" allowfullscreen></iframe>
</div>
```

* A bulletted list
- alternative syntax 1
+ alternative syntax 2
  - an indented list item

1. An
2. ordered
3. list

Inline markup styles: 

- _italics_
- **bold**
- `code()` 

> Blockquote
>> Nested Blockquote 
 
Syntax highlighting can be used by wrapping your code in a liquid tag like so:

{% highlight javascript %}
/* Some pointless Javascript */
var rawr = ["r", "a", "w", "r"];
{% endhighlight %}
 
Use two trailing spaces  
on the right  
to create linebreak tags  
 
Finally, horizontal lines

---

## 在jekyll的markdown文件中使用公式

参考：[cs231n blogs](https://github.com/cs231n/cs231n.github.io)

行内公式

```
text \\( E = MC^2 \\) text
text \\( P(A \| B) \\) text # 行内公式的|符号需要在前面添加反斜杠，不然会导致格式混乱
```

行间公式

```
$$ E = MC^2 $$
$$ P(A|B) $$ # 行外公式可以直接使用|符号
```

***

## Jekyll 链接

Jekyll usage [documentation](https://jekyllrb.com/)

You can find the source code for Minima at GitHub:
[jekyll][jekyll-organization] /
[minima](https://github.com/jekyll/minima)

You can find the source code for Jekyll at GitHub:
[jekyll][jekyll-organization] /
[jekyll](https://github.com/jekyll/jekyll)


[jekyll-organization]: https://github.com/jekyll

---

## Search Bar

Add similar search bar powered by [Algolia](https://www.algolia.com/):

* Step1: [Getting started, build algolia application, upload website data](https://community.algolia.com/jekyll-algolia/getting-started.html)
* Step2: [Frontend design, add searchbar](https://community.algolia.com/jekyll-algolia/blog.html)

---

## 参考

* [quick-ref-jekyll-markdown.md](https://gist.github.com/roachhd/779fa77e9b90fe945b0c)
* [Jekyll: Markdown Basics](http://simpleprimate.com/blog/markdown-basics)
* Jeklly使用Liquid模板语言来控制模板的格式，这里可以学习Liquid基础：[Jekyll: Liquid Syntax Basics](http://simpleprimate.com/blog/liquid-syntax)
* 这个博客的TOC使用[jekyll-toc](https://github.com/allejo/jekyll-toc)生成。
* [Make your Static Site Searchable with Jekyll-Algolia](https://dev.to/adrienjoly/make-your-static-site-searchable-with-jekyll-algolia-edh)
