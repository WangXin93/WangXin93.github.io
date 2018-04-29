---
layout: post
title:  "Linux pipeline介绍"
date: 2018-04-29 10:34:47 +0800
categories: Linux
---

## 前言
Linux命令行工具中的管线可以帮助：将一个命令行的输出导入为另一个命令的输入。这可以帮助我们联合多个命令行工具构建更强大的应用。本文将通过实例来介绍管线和一些常用命令行工具的使用。

## 文件准备
首先需要准备即将用于解析的csv文件，可以命名它为`tools.csv`，它的内容如下：
```
name,price,quantity
drill,99,5
hammer,10,50
brush,5,100
lamp,25,30
brush,5,100
screwdriver,5,23
table-saw,1099,3
```
这是一个记录工具名称，价格，数量的csv文件。准备工作完毕！

## 使用管线（Pipeline）
首先可以使用`cat tools.csv`来查看文件内容，但是这样文件第一行的标题也会被打印出来。为了解决这个问题可以使用`grep`工具，像这样：
```bash
$ grep -v name tools.csv

drill,99,5
hammer,10,50
brush,5,100
lamp,25,30
brush,5,100
screwdriver,5,23
table-saw,1099,3
```
现在文件第一行标题已经被过滤掉了。接着，如果希望只只打印文件第一列的工具名称，可以将`grep`的输出导入为`cut`命令的输入：
```bash
$ grep -v name tools.csv | cut -d, -f1

drill
hammer
brush
lamp
brush
screwdriver
table-saw
```
这里`-d,`选项意味着使用`,`作为解析时候的定界符号，`-f1`表示选择第1列字段。
酷！现在，只有工具名称被保留且打印出来。继续使用管线，我们可以通过`sort`命令对它们按字母排序：
```bash
$ grep -v name tools.csv | cut -d, -f1 | sort

brush
brush
drill
hammer
lamp
screwdriver
table-saw
```
现在，工具名称已经按字母名称排好序。可以发现这里brush出现了两次。我们可以使用`uniq`工具进行去重：
```bash
$ grep -v name tools.csv | cut -d, -f1 | sort | uniq -c

2 brush
1 drill
1 hammer
1 lamp
1 screwdriver
1 table-saw
```
可以发现`uniq`还帮助我们统计了每个条目的数量，我们可以按照数量将它们从小到大排序：
```bash
grep -v name tools.csv | cut -d, -f1 | sort | uniq -c | sort 
1 drill
1 hammer
1 lamp
1 screwdriver
1 table-saw
2 brush
```
当文件过长的时候，可以将这些内容输入到`less`中浏览，就像这样：
```bash
grep -v name tools.csv | cut -d, -f1 | sort | uniq -c | sort | less
```
现在，相信你已经掌握了管线的概念与应用，并且迫不及待地希望使用它来解决实际遇到的问题了吧！

