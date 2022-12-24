---
categories: Python Excel
date: "2021-06-10T20:52:42Z"
draft: true
title: Python 网络关系数据分析
toc: true
---

> 这篇文章会介绍使用 Python 对网络关系数据进行分析。networkx 和 Gephi 是分析和可视化网络关系数据的有效工具。

## 前言

## networkx

## Gephi

我们可以使用 pandas 来生成 correlation matrix，然后将它存储到CSV格式，就可以被 Gephi 读取了。

当 Gephi 打开 CSV 文件后得到的可视化并不易于观看。可以通过下面的步骤来优化可视化结果：

1. 点击下方的T标志按钮来打开每个节点的文字标注。
2. 在左边的窗口调节节点和边的颜色，大小。
3. 到 Filter Gallery 中找到 Degreen Range 来消除一些噪声数据
4. 对可视化网络的排布进行优化。 可以先进行"Force Atlas"一次, 多次"Expand"，最后再来一次"Label Adjust".
5. 使用画图工具自定义节点和边的颜色。

## 结语

## 参考

* <https://www.pingshiuanchua.com/blog/post/keyword-network-analysis-with-python-and-gephi>
