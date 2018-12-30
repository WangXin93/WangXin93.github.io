---
layout: post
title:  "各种各样的距离"
date:   2018-03-10 16:39:00 +0800
categories: Python
toc: true
---

## 前言
各种各样的距离
from sklearn.metrics.pairwise import pairwise_distances
user_similarity = pairwise_distances(train_data_matrix, metric='cosine')

metric可以从下面范围取值：
- From scikit-learn: ['cityblock', 'cosine', 'euclidean', 'l1', 'l2',
  'manhattan']. These metrics support sparse matrix inputs.

- From scipy.spatial.distance: ['braycurtis', 'canberra', 'chebyshev',
  'correlation', 'dice', 'hamming', 'jaccard', 'kulsinski', 'mahalanobis',
  'matching', 'minkowski', 'rogerstanimoto', 'russellrao', 'seuclidean',
  'sokalmichener', 'sokalsneath', 'sqeuclidean', 'yule']
  See the documentation for scipy.spatial.distance for details on these
  metrics. These metrics do not support sparse matrix inputs.

## 欧式距离

## 余弦距离

## 汉明距离

## 曼哈顿距离
