---
layout: post
title:  "从零开始实现决策树"
date: 2019-09-21 15:53:00 +0800
categories: Algorithm
toc: true
---

## 简介

决策树是一个强大的预测模型，它既适用于分类任务也适用于回归任务。决策树的特点是使用树结构在每个节点对数据进行简单的判断，这使得它的预测结果非常易于解释。决策树还提供了其它集成方法的基础，比如bagging，random forests，gradient boosting。

这里介绍一下如何使用Python从头实现一个CART树。CART树是一个二叉树结构（binary tree），和基础的树结构一样每个节点包含0到2个分支连接到其它节点，包含0个分支的节点即使叶子节点。每个节点包含一个选择条件，这个条件决定了输入变量流入哪个分支，流入的分支即为预测的结果。

创建决策树的过程其实是一个划分输入空间的问题。这个过程可以通过贪心搜索（greedy search）的方法来进行搜索，即在每一个节点的选择时候，每一个变量的每一种可能分割的方法都会被尝试，然后通过一个损失函数来决定什么是当前最优的分割点。对于回归任务，可以使用sum squared error来作为损失函数；对于分类任务，通常使用基尼系数（Gini Index）作为损失函数来衡量这个节点的纯度，流入当前节点的样本的种类越单一，纯度越高。分割决策树的过程可以通过定义最大深度和节点包含的最小样本数来停止递归。

## 熵 和 熵的增益

熵（Entropy）和熵的增益（Information Gain）是用来衡量是否得到一个很好的分割节点的指标。

$$
H(S) = - \sum_i p_i(S)\log_2 p_i(S)
$$

$$
IG(S, A) = H(S) - \sum_{v \in Values(A)} \frac{|S_v|}{S}H(S_v)
$$

## 基尼系数

$$
\begin{aligned}
Gini(P) &= \sum_{k=1}^k P_k (1 - P_k) \\
		&= 1 - \sum_{k=1}^k(P_k)^2
\end{aligned}
$$

基尼系数是用来衡量每个分开的集合的纯度的指标。一个完美的分割可以使得结果的基尼系数为0，一个最差的结果（即对于二分类来说50/50的比例）基尼系数为0.5。

## 伪代码 

```
FUNC TreeGenerate(dataset):
	IF 如果dataset中全部为同一类C：
		返回叶子节点并标记为C
	ELSE IF 满足递归条件(达到最大深度或者dataset数量小于最小要求)：
		返回叶子节点，标记为dataset中数量较多的标签C
	ELSE：
		从dataset中寻找最佳分割点（使用基尼系数，熵等），得到数据集子集left和right
		返回 Tree(TreeGenerate(left), TreeGenerate(right), 当前分割点条件)	
```



## 使用Python实现决策树

[banknote](http://archive.ics.uci.edu/ml/datasets/banknote+authentication) 数据集包含1372条记录，每条记录包含5个变量，其中最后一个变量代表这个banknote是否是真的。这是一个典型的二分类问题。

```python
import pandas as pd
import numpy as np
from sklearn.model_selection import train_test_split

def gini_index(groups, classes):
    """ Calculate the Gini index for a split. Perfect split leads
    gini index to 0.0, the worst split leads to 0.5
    >>> gini_index([[[1, 1], [1, 0]], [[1, 1], [1, 0]]], [0, 1])
    0.5
    >>> gini_index([[[1, 0], [1, 0]], [[1, 1], [1, 1]]], [0, 1])
    0.0
    """
    # count all samples at split point
    n_instances = sum(len(group) for group in groups)
    gini = 0
    for group in groups:
        size = len(group)
        if size == 0:
            continue
        score = 0
        labels =[row[-1] for row in group]
        for c in classes:
            prop = labels.count(c) / size
            score += prop * prop
        gini += (1 - score) * (size / n_instances)
    return gini

def tree(left=None, right=None, is_leaf=False, **kwargs):
    """ Use dict to represent a node on tree """
    if is_leaf:
        return {'left':None, 'right': None, 'label': kwargs['label']}
    elif left is None and right is None:
        return {'left':[], 'right':[], **kwargs}
    else:
        return {'left':left, 'right':right, **kwargs}

def exec_split(index, value, rows):
    """Split dataset based on a feature and a feature value"""
    left, right = [], []
    for row in rows:
        if row[index] >= value:
            right.append(row)
        else:
            left.append(row)
    return [left, right]

def best_split(dataset):
    """ select a best split point for a datast."""
    class_values = list(set(row[-1] for row in dataset))
    best_index, best_value, best_score, best_groups = 999, 999, 999, None
    for index in range(len(dataset[0]) -1):
        for row in dataset:
            groups = exec_split(index, row[index], dataset)
            gini = gini_index(groups, class_values)
            if gini < best_score:
                best_index, best_value, best_score, best_groups = index, row[index], gini, groups
    return best_index, best_value, best_groups


def build_tree(dataset, current_depth=0, max_depth=10, min_size=1):
    """ Build a tree
    """
    if current_depth > max_depth or \
        len(dataset) <= min_size or \
        len(set([row[-1] for row in dataset])) == 1:
            labels = [row[-1] for row in dataset]
            label = max(set(labels), key=labels.count)
            return tree(is_leaf=True, label=label, dataset=dataset)
    else:
        best_index, best_value, best_groups = best_split(dataset)
        left, right = best_groups
        if len(left) == 0:
            labels = [row[-1] for row in right]
            label = max(set(labels), key=labels.count)
            return tree(is_leaf=True, label=label)
        if len(right) == 0:
            labels = [row[-1] for row in left]
            label = max(set(labels), key=labels.count)
            return tree(is_leaf=True, label=label)
        else:
            return tree(
                build_tree(left, current_depth=current_depth+1, max_depth=max_depth, min_size=min_size), 
                build_tree(right, current_depth=current_depth+1, max_depth=max_depth, min_size=min_size), 
                index=best_index, 
                value=best_value
                )

def is_leaf(dtree):
    if dtree['left'] is None and dtree['right'] is None and dtree.get('label', None) is not None:
        return True
    else:
        return False

def predict(dtree, row):
    if is_leaf(dtree):
        return dtree['label']
    elif row[dtree['index']] >= dtree['value']:
        return predict(dtree['right'], row)
    else:
        return predict(dtree['left'], row)

if __name__ == "__main__":
    data = pd.read_csv("./data_banknote_authentication.txt", header=None).values
    trainset, testset = train_test_split(data, random_state=2033)
    dt = build_tree(trainset)
    print("Training done")
    preds = [predict(dt, row) for row in testset]
    acc = sum(pred==row[-1] for pred, row in zip(preds, testset)) / len(testset)
    print("Accuracy: {:.2f}".format(acc))
```



## 使用sklearn实现决策树

```python
import numpy as np
import sklearn.datasets as ds
from sklearn.model_selection import train_test_split
from sklearn.tree import DecisionTreeClassifier

X, y = ds.load_iris(return_X_y=True)
X_train, X_test, y_train, y_test = train_test_split(X, y, random_state=2033, test_size=0.33)

clf = DecisionTreeClassifier(criterion="entropy", min_samples_leaf=3)
dt_clf = clf.fit(X_train, y_train)

y_hat = dt_clf.predict(X_test)
c = np.count_nonzero(y_hat == y_test)
print("Accuracy: {}/{}={:.2%}".format(c, len(y_test), c / len(y_test)))
```

## Random Forest

为了提高性能表现，我们可以使用使用许多的树，每个树使用随机一部分的特征进行训练。

* 每个树都使用所有特征中随机的一部分特征进行训练
* 对于分类任务，m 通常取值为 p 的平方根, m 是选择的特征数量，p 是全部特征的数量

为什么随机森林能够提高性能表现？通过每个数随机去掉了一些特征，每个训练后的决策树相互独立，因此平均后的结果减少了模型的variance。

## 参考资料

### 文档

* [Chapter 8 of Introduction to Statistical Learning by Gareth James et al.](https://www.statlearning.com/)

* [How To Implement The Decision Tree Algorithm From Scratch In Python](https://machinelearningmastery.com/implement-decision-tree-algorithm-scratch-python/)
* [Classification And Regression Trees for Machine Learning](https://machinelearningmastery.com/classification-and-regression-trees-for-machine-learning/)
* [A Complete Tutorial on Tree Based Modeling from Scratch (in R & Python)](https://www.analyticsvidhya.com/blog/2016/04/complete-tutorial-tree-based-modeling-scratch-in-python/)

### 代码

* [scikit-learn的决策树实现](https://github.com/scikit-learn/scikit-learn/blob/1495f6924/sklearn/tree/tree.py)
* [Decision Tree from scratch (not sklearn)](https://www.kaggle.com/jarvvis/decision-tree-from-scratch-not-sklearn)
