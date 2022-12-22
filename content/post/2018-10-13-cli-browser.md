---
categories: Linux
date: "2018-10-13T13:38:57Z"
title: Command Line Browser（命令行浏览器）
toc: true
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

### 基本操作：

* Tab: 让cursor跳转到下一个hyperlink，enter键就可以进入超链接的页面
* Shift-B: 回到超链接跳转前一个网页
* Shif-U: 打开一个地址栏提示，输入url可以跳转到新的网页
* Shift-H: 显示帮助页面，记录了更多的快捷键

### Image

显示image需要在xterm上打开w3m，使用`o`可以进入设置页面，找到display inline image选项来选择是否显示image。

你也可以使用`w3m <filename>`来展示一个本地的image文件。

![xterm](https://www.howtogeek.com/wp-content/uploads/2012/01/xscreenshot4.png.pagespeed.gp+jp+jw+pj+ws+js+rj+rp+rw+ri+cp+md.ic.HMlRdn0Rzf.png)

![image](https://www.howtogeek.com/wp-content/uploads/2012/01/xscreenshot5.png.pagespeed.gp+jp+jw+pj+ws+js+rj+rp+rw+ri+cp+md.ic.ZSpweFI8zr.png)

### Tab
w3m支持tab，你可以使用：

Shift-T: 打开一个新的Tab，你可以这时候使用shift-U输入新的网站的url

你可以使用鼠标来在不同的Tab之间进行选择，或者使用`{`和`}`在不同的tab之间前后切换。

### Bonus

在w3m的窗口中点击右键可以弹出菜单，快去试试吧。（GNOME Terminal）目前还不支持这个操作，但是xterm这些特性都是有效的。

![right_click](https://www.howtogeek.com/wp-content/uploads/2012/01/xscreenshot6.png.pagespeed.gp+jp+jw+pj+ws+js+rj+rp+rw+ri+cp+md.ic.6q0dQd2t-d.png)

### 常见问题

* 中文显示乱码？

使用``w3m -O utf8 <url>``。

## lynx

[Lynx](https://lynx.invisible-island.net/) 是另一款基于文本的命令行浏览器。Lynx 是 University of Kansas 的 Academic Computing Services 中 Distributed Computing Group 开发的产品，最早在 1992 年由学生和老师开发，在2021年仍然在维护，是仍然在维护的最古老的浏览器。

基本功能方面，Lynx 支持 SSL 和许多 HTML 功能，对于非文字的内容虽然不能直接显示但是可以启动外部程序比如图片浏览器和播放器打开。 Lynx 不支持 Javascript，只显示文本，不过因此它的速度快，对带宽要求很低，适合老型号的计算机或者用于远程机器访问网页，还适合被转换为可以阅读的内容。

配置方面，Lynx支持142个runtime选项和233个配置参数在``lynx.cfg``文件。

在隐私方法，lynx不会引入图形界面的问题和信息追踪，但是由于它支持 HTTP cookies，浏览历史和缓存，因此在这些方面需要注意。

自动化方面，Lynx可以从 text 文件读取按键，这对于自动填写数据，自动浏览网页，网络爬取。网页设计者可以用它查看搜索引擎和爬虫看到的页面的样子。Lynx还被用来测试网页性能，因为它方便在远端机器上使用，所以用户可以测试在不同位置的访问连接性能。

使用``lynx``打开一个网页使用命令：

```
lynx www.bing.com
```

基本操作：

* g 打开一个地址
* left 返回上个页面
* right 激活链接 / 下一个页面
* up/down 浏览页面

runtime 选项``--dump``可以讲浏览器的网页内容存储下来，可以结合``grep``工具查看网页是否包含需要的信息：

```
lynx -dump www.bing.com | grep "something"

lynx -dump www.bing.com | grep "something" && say "I find it"
```

### lynx 自动化web页面操作

lynx 可以讲按键操作转换成命令写入文件保存，在读取文件中的命令重复保存的操作。实现这个功能需要用到两个 runtime 参数 ``--cmd_log`` 和 ``--cmd_script``。

``--cmd_log``可以将按键转换成命令写入文件，进入浏览器后进行任何的按键都会被保存：

```
lyx --cmd_log log.lyx www.bing.com
```

重复执行刚才的按键可以使用命令：

```
lyx --cmd_script log.lyx www.bing.com
```

### 常见问题

刚装完 lynx 后打开网页会询问是否允许 cookie，如果不经过设置每次打开都会显示该提示。如果希望关掉这些提示，可以添加``--acept_all_cookies`` runtime 选项：

```
lynx -accept_all_cookies www.bing.com
```

或者配置``/etc/lynx/lynx.cfg``文件。使用你熟悉的编辑器打开该文件，然后搜索到下面内容修改为TRUE：

```
ACCEPT_ALL_COOKIES:FALSE
```

## Reference

* [3 web browsers for the Linux command line](https://opensource.com/article/16/12/web-browsers-linux-command-line)
* [How to Browse From the Linux Terminal With W3M](https://www.howtogeek.com/103574/how-to-browse-from-the-linux-terminal-with-w3m/)
* [Simple web automation with lynx text web browser](https://www.youtube.com/watch?v=IV2lyEzXbe4&t=18s)
* <https://en.wikipedia.org/wiki/Lynx_(web_browser)>
* [Lynx Users Guide](https://lynx.invisible-island.net/lynx_help/Lynx_users_guide.html)
* [Lynx(1) - Linux man page](https://linux.die.net/man/1/lynx)