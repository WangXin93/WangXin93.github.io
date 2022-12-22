---
categories: Jekyll
date: "2018-01-25T20:26:46Z"
title: 这是我的第一篇博客
---

这是我的第一篇博客。 这里记录Jekyll中Markdown的语法, 代码源文件在[这里](https://github.com/WangXin93/WangXin93.github.io/blob/master/_posts/2018-01-25-my-first-blog.md)。

我的一些博客会用中文，一些博客会用英文，我会尽量避免两种语言混合使用，因为读者在阅读中切换不同的语言会增加额外的负担。

---

## 文字格式

## Header 2 (H1 is reserved for post titles)

### Header 3

#### Header 4

A link to [Jekyll Now](http://github.com/barryclark/jekyll-now/). A big ass literal link <http://github.com/barryclark/jekyll-now/>

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

{{< highlight javascript >}}
/* Some pointless Javascript */
var rawr = ["r", "a", "w", "r"];
{{< / highlight >}}
 
Use two trailing spaces  
on the right  
to create linebreak tags  
 
Finally, horizontal lines

---

## 插入图片

![an image alt text]({{ site.baseurl }}/favicon.ico "an image title")

```
居中插入图片，同时改变图像尺寸比例
<div align="center">
<img src="/assets/2018-10-21-naive-bayes/bayesian_rule.png" style="width:80%"/>
</div>
```

Image gallery with [jeykll collections](https://alligator.io/jekyll/collections/).

* <https://stackoverflow.com/questions/46500871/jekyll-photo-gallery-without-plugins>

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

## News Letter Subscription

当博客内容更新时候，给订阅用户发送邮件提醒，使用FeedBurner实现，参考教程：

* [How to add a newsletter to a Jekyll blog](https://medium.com/@davideiaiunese/the-problem-why-a-newsletter-baae4409a526)

---

## 嵌入视频音频

```
居中嵌入视频
<div align="center">
<iframe width="560" height="315" src="https://www.youtube.com/embed/enjhlnqaXOE" frameborder="0" allow="accelerometer; autoplay; encrypted-media; gyroscope; picture-in-picture" allowfullscreen></iframe>
</div>
```

<div align="center">
<iframe width="560" height="315" src="https://www.youtube.com/embed/enjhlnqaXOE" frameborder="0" allow="accelerometer; autoplay; encrypted-media; gyroscope; picture-in-picture" allowfullscreen></iframe>
</div>

```
插入音频
<audio controls>
<source src="https://files.freemusicarchive.org/storage-freemusicarchive-org/music/Creative_Commons/Paper_Navy/All_Grown_Up/Paper_Navy_-_08_-_Swan_Song.mp3" type="audio/mpeg">
"Your browser does not support the audio element."
</audio>
```

<audio controls>
<source src="https://files.freemusicarchive.org/storage-freemusicarchive-org/music/Creative_Commons/Paper_Navy/All_Grown_Up/Paper_Navy_-_08_-_Swan_Song.mp3" type="audio/mpeg">
"Your browser does not support the audio element."
</audio>

---

Ruby 术语简介

Jekyll使用Ruby编写的。为了很好的理解Jekyll的配置，下面的一些术语会有帮助。

* Gems：RubyGems 是 Ruby 的一个包管理器，它提供了一个分发 Ruby 程序和库的标准格式，Gem 是 Ruby 程序的标准包，每个 gem 都有特殊的功能，你可以在不同的项目使用共同的 gem，这些 gem 的功能有比如：转化 Ruby 对象成 JSON 格式，分页，和 GitHub API 进行交互等。Jekyll 是一个 gem，其它的 Jekyll 插件也是 gem，比如jekyll-feed，jekyll-seo-tag，jekyll-archives。
* Gemfile：一个``Gemfile``是你的站点要用的一系列的 gem。每个站点在主文件夹都有一个``Gemfile``，一个简单的Jekyll站点的``Gemfile``如下。
* Bundle: [``Bundle``](https://rubygems.org/gems/bundler)是一个用来安装``Gemfile``中所有gem的gem。你可以使用``gem install bundler``来安装bundler，你只需要安装它一次，不是每次创建 Jekyll 项目都要安装。你可以使用``bundle install``来安装Gemfile中所有的gem，使用``bundle exec jekyll serve``来其中本地的jekyll服务。

```gemfile
source "https://rubygems.org"

gem "jekyll"

group :jekyll_plugins do
  gem "jekyll-feed"
  gem "jekyll-seo-tag"
end
```

---

## 参考

* [Ruby 101](https://jekyllrb.com/docs/ruby-101/)
* [quick-ref-jekyll-markdown.md](https://gist.github.com/roachhd/779fa77e9b90fe945b0c)
* [Jekyll: Markdown Basics](http://simpleprimate.com/blog/markdown-basics)
* Jeklly使用Liquid模板语言来控制模板的格式，这里可以学习Liquid基础：[Jekyll: Liquid Syntax Basics](http://simpleprimate.com/blog/liquid-syntax)
* 这个博客的TOC使用[jekyll-toc](https://github.com/allejo/jekyll-toc)生成。
* [Make your Static Site Searchable with Jekyll-Algolia](https://dev.to/adrienjoly/make-your-static-site-searchable-with-jekyll-algolia-edh)
* <https://github.com/nathancy/jekyll-embed-video>
* [Embed vidoe without jekyll plugin]<https://jekyllcodex.org/without-plugin/open-embed/#>
* [minima v2.5.0 customization](https://github.com/jekyll/minima/tree/v2.5.0)
* [How to add a newsletter to a Jekyll blog](https://medium.com/@davideiaiunese/the-problem-why-a-newsletter-baae4409a526)
