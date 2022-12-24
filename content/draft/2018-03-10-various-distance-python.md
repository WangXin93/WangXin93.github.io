---
categories: Python
date: "2018-03-10T16:39:00Z"
draft: true
title: 各种各样的距离
toc: true
---

## 前言

各种各样的距离

![img](https://miro.medium.com/max/1150/1*xJj3srkP0KqdTvX8HeBmqQ.png)

```python
from sklearn.metrics.pairwise import pairwise_distances
user_similarity = pairwise_distances(train_data_matrix, metric='cosine')
```

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

$$
dist(A, B) = \sqrt((x_A - x_B)^2, (y_A - y_B)^2)
$$

## 余弦距离

$$
dist(A, B) = \frac{x_A y_A + x_B y_B}{\sqrt{x_A^2 + x_B^2} \sqrt{y_A^2 + y_B^2}}
$$

## 曼哈顿距离

$$
dist(A, B) = |x_A - x_B|, |y_A - y_B|
$$

## 切比雪夫距离

$$
dist(A, B) = max(|x_A - x_B|, |y_A - y_B|)
$$
