---
layout: post
title: "因子分解机即其变体"
date: 2019-02-02 14:00:00 +0800
categories: Algorithm
toc: true
---

## 前言

## FM (Factorization Machine)


假设一个点击预测的问题可以建模为：

| Clicked? | Country=USA | Country=China | Month=May | Month=June | Month=July | Type=Movie | Type=Game |
|----------|-------------|---------------|-----------|------------|------------|------------|-----------|
| 1        | 1           | 0             | 1         | 0          | 0          | 1          | 0         |
| 0        | 0           | 1             | 0         | 1          | 0          | 0          | 1         |
| 1        | 0           | 1             | 0         | 0          | 1          | 0          | 1         |

那么可以将是否点击作为预测目标，该问题可以认为是一个回归问题，或者是二元分类问题。那么预测的目标可以建模为：

$$
\hat{y}(x) := w_0 + \sum_{i=1}^{n}w_ix_i + \sum_{i=1}^{n}\sum_{j=i+1}^{n} <v_i, v_j> x_i x_j
$$

其中模型的参数有\\(w_0 \in \mathbb{R}, w \in \mathbb{R}^n, V \in \mathbb{R}^{n \times k}\\)。

\\(<\cdot, \cdot>\\)代表的是两个维度为\\(k\\)的向量的点积运算，即：

$$
<v_i, v_j> := \sum_{f=1}^k v_{i, f} \cdot v_{j, f}
$$


[[paper](https://www.csie.ntu.edu.tw/~b97053/paper/Rendle2010FM.pdf)] [[slides](http://www.cs.cmu.edu/~wcohen/10-605/2015-guest-lecture/FM.pdf)]

## FFM (Field-aware Factorization Machine)

$$
\hat{y}(x) := w_0 + \sum_{i=1}^{n}w_i x_i + \sum_{i=1}^{n} \sum_{j=i+1}^{n} <v_{i,f_j}, v_{j,f_i}>x_i x_j
$$

[[slides](https://www.csie.ntu.edu.tw/~r01922136/slides/ffm.pdf)]

## PNN

## DeepFM


## DCN(Deep Cross Network)

## xDeepFM

## 参考资料

* [机器学习算法讲堂(3)：FM算法 Factorization Machine](https://www.bilibili.com/video/av31750829/)
* [深入FFM原理与实践](https://tech.meituan.com/2016/03/03/deep-understanding-of-ffm-principles-and-practices.html)
* [Factorization Machine笔记及Pytorch 实现](http://shomy.top/2018/12/31/factorization-machine/)
