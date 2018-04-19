---
layout: post
title:  "Mac 挂载NTFS移动硬盘进行读写操作"
date: 2018-04-19 20:02:13 +0800
categories: Machine_Learning
---

## 前言

```python
from sklearn.model_selection import KFold
import numpy as np

ntrain = train.shape[0] #891
ntest = test.shape[0] # 418
kf = KFold(n_splits=5, random_state=666)

def get_oof(clf, X_train, y_train, X_test):
    oof_train = np.zeros((ntrain,))
    oof_test = np.zeros((ntest,))
    oof_test_skf = np.empty((5, ntest))

    for i, (train_index, test_index) in enumerate(kf.split(X_train)): # X_train: 891 * 7
        kf_X_train = X_train[train_index] # 712 * 7 ex: 712 instances for each fold
        kf_y_train = y_train[train_index] # 712 * 1 ex: 712 instances for each fold
        kf_X_test = X_train[test_index] # 179 * 7 ex: 178 instances for each fold

        clf.train(kf_X_train, kf_y_train)

        oof_train[test_index] = clf.predict(kf_X_test) # 1 * 179 =====> will be 1 * 891 after 5 folds
        oof_test_skf[i, :] = clf.predict(X_test) # oof_test_skf[i, :]: 1 * 418

    oof_test[:] = oof_test_skf.mean(axis=0) # oof_test[:] 1 * 418
    return oof_train.reshape(01, 1), oof_test.reshape(-1, 1)
    # oof_train.reshape(-1, 1): 891 * 1        oof_test.reshape(-1, 1): 418 * 1
```


## 参考链接
* [Kaggle机器学习之模型融合（stacking）心得](https://www.leiphone.com/news/201709/zYIOJqMzR0mJARzj.html)
