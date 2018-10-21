---
layout: post
title:  "朴素贝叶斯分类"
date: 2018-10-21 16:00:27 +0800
categories: Algorithm
---

## 前言

朴素贝叶斯分类器是一个用来分类的Machine Learning算法。它主要用来进行文本分类，尤其是对于高维度的训练数据。应用的场景比如spam filtering， sentimental analysis，或者classifying news articles。

## 介绍

Naive bayes被称为naive的原因就是因为它假设每一个特征都于其它特征独立。
贝叶斯分类起基于贝叶斯理论。Bayes theorem的基本公式是：

$$
P(A|B) = \frac{P(B|A)P(A)}{P(B)}
$$

## 实践

```python
import numpy as np
import pandas as pd
from sklearn.datasets import load_iris
import seaborn as sns; sns.set(color_codes=True)
from mpl_toolkits.mplot3d import Axes3D
import matplotlib.pyplot as plt

iris = load_iris()
df = pd.DataFrame(iris.data, columns=iris.feature_names)
from sklearn.naive_bayes import GaussianNB
gnb = GaussianNB()
gnb.fit(df, iris.target)
gnb.score(df, iris.target)
```


## Reference

# Document
* [CMU MLE, MAP, Bayes classification](http://www.cs.cmu.edu/~aarti/Class/10701_Spring14/slides/MLE_MAP_Part1.pdf)
* [MLE, MAP, AND NAIVE BAYES](https://www.cs.cmu.edu/~tom/10601_sp08/slides/recitation-mle-nb.pdf)
* [CMU assignment](http://www.cs.cmu.edu/~aarti/Class/10701_Spring14/assignments/assignment_1.pdf)
* [How To Implement Naive Bayes From Scratch in Python](https://machinelearningmastery.com/naive-bayes-classifier-scratch-python/)
* [zekelabs, Naive Bayes](https://github.com/zekelabs/data-science-complete-tutorial/blob/master/7.%20Naive%20Bayes.ipynb)

# Video
* [Naive Bayes - Georgia Tech - Machine Learning](https://www.youtube.com/watch?v=M59h7CFUwPU)
* [Naive Bayes Theorem: Introduction to Naive Bayes Theorem - Machine Learning Classification](https://www.youtube.com/watch?v=sjUDlJfdnKM)
* 如果在分类时候遇到训练时候没碰到过的word，这可以是一个单独的class或者over all，参考[Laplace Smoothing](https://www.youtube.com/watch?v=gCI-ZC7irbY)。
