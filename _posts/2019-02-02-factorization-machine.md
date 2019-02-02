---
layout: post
title: "因子分解机即其变体"
date: 2019-02-02 14:00:00 +0800
categories: Algorithm
toc: true
---

## 前言

## FM (Factorization Machine)

$$
\hat{y}(x) := w_0 + \sum_{i=1}^{n}w_ix_i + \sum_{i=1}^{n}\sum_{j=i+1}^{n} <v_i, v_j> x_i x_j
$$

[[paper](https://www.csie.ntu.edu.tw/~b97053/paper/Rendle2010FM.pdf)] [[slides](http://www.cs.cmu.edu/~wcohen/10-605/2015-guest-lecture/FM.pdf)]

## FFM (Field-aware Factorization Machine)

$$
\hat{y}(x) := w_0 + \sum_{i=1}^{n}w_i x_i + \sum_{i=1}^{n} \sum_{j=i+1}^{n} <v_{i,f_j}, v_{j,f_i}>x_i x_j
$$

[[slides](https://www.csie.ntu.edu.tw/~r01922136/slides/ffm.pdf)]


## DeepFM


## DCN

## xDeepFM

## 参考资料

* [机器学习算法讲堂(3)：FM算法 Factorization Machine](https://www.bilibili.com/video/av31750829/)
* [深入FFM原理与实践](https://tech.meituan.com/2016/03/03/deep-understanding-of-ffm-principles-and-practices.html)