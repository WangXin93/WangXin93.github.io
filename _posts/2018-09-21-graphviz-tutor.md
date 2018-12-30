---
layout: post
title:  "Graphviz使用教程"
date: 2018-09-21 23:53:21 +0800
categories: Linux
toc: true
---

## 前言

[Graphviz](http://graphviz.org/about/)是一个“所见即所想”的绘制有向图，无向图的工具。它使用了布局算法对节点位置进行自动排版，可以导出为jpg，svg，pdf等不同格式，使用dot语言作为绘图指令。

## 安装

Mac 系统使用：``$ brew install graphviz``
Ubuntu 系统使用：``$ sudo apt-get install graphviz``

## 快速开始

创建一个dot语言脚本文件并命名为`demo.dot`：

```dot
graph graphname {
        a -- b;
        b -- c;
        b -- d;
        d -- a;
};
```

我们将使用该脚本绘制一个无向图，创建一个Makefile文件：

```
demo.jpg:demo.dot
	dot -Tjpg demo.dot -o demo.jpg

clean:
	rm demo.jpg
```

然后在同一个目录下执行``make``指令，可以看到graphviz为我们输出了一个jpg格式的文件。

再来绘制一个有向图，需要注意的是无向图使用``graph``关键字来定义，而有向图使用``digraph``关键字来定义：

```dot
digraph demo {
    T [label="Teacher", color=Blue, fontcolor=Red, fontsize=24, shape=box]
    P [label="Pupil", color=Blue, fontcolor=Red, fontsize=24, shape=box]
    T -> P [label="Instructions", fontcolor=darkgreen]
}
```

## 参考链接
* [graphviz教程](https://blog.csdn.net/mcgrady_tracy/article/details/47132485)
