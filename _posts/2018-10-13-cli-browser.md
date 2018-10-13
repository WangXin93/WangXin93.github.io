---
layout: post
title:  "Command Line Browser（命令行浏览器）"
date: 2018-10-13 13:38:57 +0800
categories: Linux
---

## 前言

今天我们有了强大的美观的浏览器比如Chrome，FireFox，Safari，你可能会觉得现在命令行下的浏览器还有什么用呢？实际上，出于一些原因和场景，比如你想在一个远程机器上使用ssh测试网络，浏览资料，这时候命令行浏览器就会非常方便。时至今日，命令行浏览器的开发也没有停止，并且它们也在发挥着自己的作用。

我推荐尝试的命令行浏览器有：

* links2: <https://en.wikipedia.org/wiki/Lynx_(web_browser)>: links2是[links](https://en.wikipedia.org/wiki/Links_%28web_browser%29)下一代，它的特点是可以选择text模式或者graphical模式，你可以使用``links2 <url>``来在text模式下访问一个站点，使用``links2 -g <url>``来在graphical模式下访问站点。它支持基本的javascript和鼠标命令。
* elinks: <http://elinks.or.cz/>: elinks是links的另一个分支，它的特色是`<ecs>`出发的顶端菜单栏。它支持tables和frames和鼠标命令，但是不支持javascripts，但是你可以在图片链接上使用`v`键来通过外部程序打开图片。elinks渲染的网页可以保留颜色。
* w3m: <http://w3m.sourceforge.net/>：w3m渲染的网页比前两者都整洁，它更像一个`more`命令的输出结果。可以在w3m程序中使用`shift+H`键获取帮助。
* lynx: <http://lynx.browser.org/>：它是最古老的text-based浏览器，从1992年开发到至今仍在广泛使用。
* curl: 如果只是想测试一下网络连接，用``curl google.com``更简单直接。

## w3m

![w3m](https://www.howtogeek.com/wp-content/uploads/2012/01/xscreenshot8.png.pagespeed.gp+jp+jw+pj+ws+js+rj+rp+rw+ri+cp+md.ic.j-DDUhNL5k.png)

w3m是一个非常漂亮的命令行浏览器，它支持images，tabs，tables，frames。安装w3m可以使用命令：

```
$ sudo apt-get install w3m w3m-img
```

其中w3m是主程序，w3m-img是一个帮助内嵌图片浏览的包。在你的X server失效的时候，w3m提供了另一个在服务器浏览网页图片的方案。

# 基本操作：

* Tab: 让cursor跳转到下一个hyperlink，enter键就可以进入超链接的页面
* Shift-B: 回到超链接跳转前一个网页
* Shif-U: 打开一个地址栏提示，输入url可以跳转到新的网页
* Shift-H: 显示帮助页面，记录了更多的快捷键

# Image

显示image需要在xterm上打开w3m，使用`o`可以进入设置页面，找到display inline image选项来选择是否显示image。

你也可以使用`w3m <filename>`来展示一个本地的image文件。

![xterm](https://www.howtogeek.com/wp-content/uploads/2012/01/xscreenshot4.png.pagespeed.gp+jp+jw+pj+ws+js+rj+rp+rw+ri+cp+md.ic.HMlRdn0Rzf.png)

![image](https://www.howtogeek.com/wp-content/uploads/2012/01/xscreenshot5.png.pagespeed.gp+jp+jw+pj+ws+js+rj+rp+rw+ri+cp+md.ic.ZSpweFI8zr.png)

# Tab
w3m支持tab，你可以使用：

Shift-T: 打开一个新的Tab，你可以这时候使用shift-U输入新的网站的url

你可以使用鼠标来在不同的Tab之间进行选择，或者使用`{`和`}`在不同的tab之间前后切换。

# Bonus

在w3m的窗口中点击右键可以弹出菜单，快去试试吧。（GNOME Terminal）目前还不支持这个操作，但是xterm这些特性都是有效的。

![right_click](https://www.howtogeek.com/wp-content/uploads/2012/01/xscreenshot6.png.pagespeed.gp+jp+jw+pj+ws+js+rj+rp+rw+ri+cp+md.ic.6q0dQd2t-d.png)

# 常见问题

* 中文显示乱码？

使用``w3m -O utf8 <url>``。

## Reference

* [3 web browsers for the Linux command line](https://opensource.com/article/16/12/web-browsers-linux-command-line)
* [How to Browse From the Linux Terminal With W3M](https://www.howtogeek.com/103574/how-to-browse-from-the-linux-terminal-with-w3m/)
