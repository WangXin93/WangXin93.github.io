---
layout: post
title:  "Handy GNUPlot"
date: 2018-12-31 10:53:00 +0800
categories: linux
toc: true
---

## 前言

Linux下有非产多的用于绘制图表的工具，比如使用python语言的matplotlib。但是如果希望快速了解一个函数的情况，gnuplot是一个更方便的选择。

## Get started

```gnuplot
plot sin(x)
```

```gnuplot
set xrange [-pi:pi]
replot
reset
```

## 从文档获得帮助

使用``help <command>``来从命令行获得关于指令的帮助，比如``help reset``，查询完成后使用``q``键退出。


## Reference

* [gnuplot 让您的数据可视化](https://www.ibm.com/developerworks/cn/linux/l-gnuplot/index.html)
* 要大概了解如何从命令行使用 ImageMagick， 参考[通过命令行处理图形](https://www.ibm.com/developerworks/cn/linux/l-graf/)
* [GNUPLOT 4.2 - A Brief Manual and Tutorial - Duke University](https://people.duke.edu/~hpgavin/gnuplot.html)
