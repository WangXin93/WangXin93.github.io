---
layout: post
title:  "K-Fold Cross Validation in Python"
date: 2018-04-24 23:09:23 +0800
categories: Machine_Learning
---

## 前言
[数据集链接](http://www.superdatascience.com/wp-content/uploads/2017/02/SVM.zip)
[更多数据集链接](https://www.superdatascience.com/machine-learning/)

## K-Fold
```python
# k-Fold Cross Validation
from sklearn.model_selection import KFold

# Grid-search can be used to find best hyper-parameters
# Accuray on one test set could differ a lot on another test set, that is
# variance.
# Test on different fold can improve variance problem

# Importing the libraries
import numpy as np
import matplotlib.pyplot as plt
import pandas as pd

# Importing the dataset
dataset = pd.read_csv('Social_Network_Ads.csv')
X = dataset.iloc[:, [2, 3]].values
y = dataset.iloc[:, 4].values

# Splitting the dataset into the Training set and Test set
from sklearn.cross_validation import train_test_split
X_train, X_test, y_train, y_test = train_test_split(X, y, test_size = 0.25, random_state = 0)

# Feature Scaling
from sklearn.preprocessing import StandardScaler
sc = StandardScaler()
X_train = sc.fit_transform(X_train)
X_test = sc.transform(X_test)

# Fitting Kernel SVM to the Training set
from sklearn.svm import SVC
classifier = SVC(kernel = 'rbf', random_state = 0)
classifier.fit(X_train, y_train)

# Predicting the Test set results
y_pred = classifier.predict(X_test)

# Making the Confusion Matrix
from sklearn.metrics import confusion_matrix
cm = confusion_matrix(y_test, y_pred)

# Applying k-Fold Cross Validation
from sklearn.model_selection import cross_val_score
accuracies = cross_val_score(estimator=classifier,
                             X=X_train,
                             y=y_train,
                             cv=10,
                             n_jobs=-1)
accuracies.mean()
accuracies.std()
```

## 参考链接
* [K-Fold Cross Validation in Python](https://www.udemy.com/machinelearning/learn/v4/t/lecture/6289086?start=0)
