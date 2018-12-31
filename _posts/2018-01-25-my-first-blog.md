---
layout: post
title:  "这是我的第一篇博客"
date:   2018-01-25 20:26:46 +0800
categories: Jekyll
---

这是我的第一篇博客。 这里记录Jekyll中Markdown的语法。

## Header 2 (H1 is reserved for post titles)##

### Header 3

#### Header 4

A link to [Jekyll Now](http://github.com/barryclark/jekyll-now/). A big ass literal link <http://github.com/barryclark/jekyll-now/>

![an image alt text]({{ site.baseurl }}/favicon.ico "an image title")

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
***

## Source file 在[这里](https://github.com/WangXin93/WangXin93.github.io/blob/master/_posts/2018-01-25-my-first-blog.md)

## 参考

* [quick-ref-jekyll-markdown.md](https://gist.github.com/roachhd/779fa77e9b90fe945b0c)
* [Jekyll: Markdown Basics](http://simpleprimate.com/blog/markdown-basics)
* Jeklly使用Liquid模板语言来控制模板的格式，这里可以学习Liquid基础：[Jekyll: Liquid Syntax Basics](http://simpleprimate.com/blog/liquid-syntax)
* 这个博客的TOC使用[jekyll-toc](https://github.com/allejo/jekyll-toc)生成。