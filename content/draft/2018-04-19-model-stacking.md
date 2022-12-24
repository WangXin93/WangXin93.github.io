---
categories: Machine_Learning
date: "2018-04-19T20:02:13Z"
draft: true
title: 从Data Cleaning到Model Stacking
toc: true
---

## 前言
堆叠（也称为元组合）是用于组合来自多个预测模型的信息以生成新模型的模型组合技术。通常，堆叠模型（也称为二级模型）因为它的平滑性和突出每个基本模型在其中执行得最好的能力，并且抹黑其执行不佳的每个基本模型，所以将优于每个单个模型。因此，当基本模型显著不同时，堆叠是最有效的。关于在实践中怎样的堆叠是最常用的，这里我使用[titanic](https://www.kaggle.com/c/titanic)数据集为例, 从实战出发来帮助理解。

首先读入数据：
```python
train = pd.read_csv('titanic_train.csv')
train.head()
```
通过观察heatmap可以发现这里存在大量缺失的数据。
```python
sns.heatmap(train.isnull(),yticklabels=False,cbar=False,cmap='viridis')
```
<div align="center">
    <img src="/assets/model_stacking/output_6_1.png"/>
</div>

可以发现大约20%的Age数据已经缺失, 在这个缺失比例下使用imputation技术对数据进行填充是非常合理的。而对于Cabin一列，可以看见大量的数据缺失导致不能利用这一列进行判断，这时可以选择丢弃这一列，或者将这一列变化为其它特征，比如“Cabin Known: 1 or 0”。

这里使用一种巧妙的方法填充缺失的数据，可以根据不同乘客类别的平均年龄来填充：
```
plt.figure(figsize=(12, 7))
sns.boxplot(x='Pclass',y='Age',data=train,palette='winter')
```
<div  align="center">
    <img src="/assets/model_stacking/output_19_1.png"/>
</div>

从图中可以发现更加富有的类型的乘客年龄会更大一些，这是非常合理的。然后我们可以使用这几个平均年龄来填充到Age一列。
```python
def impute_age(cols):
    Age = cols[0]
    Pclass = cols[1]

    if pd.isnull(Age):

        if Pclass == 1:
            return 37

        elif Pclass == 2:
            return 29

        else:
            return 24

    else:
        return Age
```
将该函数apply到DataFrame数据结构上：
```python
train['Age'] = train[['Age','Pclass']].apply(impute_age,axis=1)
```
对于Cabin一列，选择丢弃它。同时还要丢弃Embarked一列为NaN的那几行数据：
```python
train.drop('Cabin',axis=1,inplace=True)
train.dropna(inplcae=True)
```
然后来检查确认一下数据中不存在缺失的数据了：
```python
train.isnull().sum()
```

    PassengerId    0
    Survived       0
    Pclass         0
    Name           0
    Sex            0
    Age            0
    SibSp          0
    Parch          0
    Ticket         0
    Fare           0
    Embarked       0
    dtype: int64

## 转化Categorical Features
然后我们需要将类别特征（categorical features）转化为伪变量（dummy variables），否则机器学习的算法不能将它们作为输入的特征：
```python
sex = pd.get_dummies(train['Sex'],drop_first=True)
embark = pd.get_dummies(train['Embarked'],drop_first=True)
```

```python
train.drop(['Sex','Embarked','Name','Ticket'],axis=1,inplace=True)
```

```python
train = pd.concat([train,sex,embark],axis=1)
```

```python
train.head()
```

<div>
<style>
    .dataframe thead tr:only-child th {
        text-align: right;
    }

    .dataframe thead th {
        text-align: left;
    }

    .dataframe tbody tr th {
        vertical-align: top;
    }
</style>
<table border="1" class="dataframe">
  <thead>
    <tr style="text-align: right;">
      <th></th>
      <th>PassengerId</th>
      <th>Survived</th>
      <th>Pclass</th>
      <th>Age</th>
      <th>SibSp</th>
      <th>Parch</th>
      <th>Fare</th>
      <th>male</th>
      <th>Q</th>
      <th>S</th>
    </tr>
  </thead>
  <tbody>
    <tr>
      <th>0</th>
      <td>1</td>
      <td>0</td>
      <td>3</td>
      <td>22.0</td>
      <td>1</td>
      <td>0</td>
      <td>7.2500</td>
      <td>1</td>
      <td>0</td>
      <td>1</td>
    </tr>
    <tr>
      <th>1</th>
      <td>2</td>
      <td>1</td>
      <td>1</td>
      <td>38.0</td>
      <td>1</td>
      <td>0</td>
      <td>71.2833</td>
      <td>0</td>
      <td>0</td>
      <td>0</td>
    </tr>
    <tr>
      <th>2</th>
      <td>3</td>
      <td>1</td>
      <td>3</td>
      <td>26.0</td>
      <td>0</td>
      <td>0</td>
      <td>7.9250</td>
      <td>0</td>
      <td>0</td>
      <td>1</td>
    </tr>
    <tr>
      <th>3</th>
      <td>4</td>
      <td>1</td>
      <td>1</td>
      <td>35.0</td>
      <td>1</td>
      <td>0</td>
      <td>53.1000</td>
      <td>0</td>
      <td>0</td>
      <td>1</td>
    </tr>
    <tr>
      <th>4</th>
      <td>5</td>
      <td>0</td>
      <td>3</td>
      <td>35.0</td>
      <td>0</td>
      <td>0</td>
      <td>8.0500</td>
      <td>1</td>
      <td>0</td>
      <td>1</td>
    </tr>
  </tbody>
</table>
</div>

然后需要对test数据集做同样的处理。
```python
# Impute or drop missing data
test = pd.read_csv('./titanic_test.csv')
test['Age'] = test[['Age','Pclass']].apply(impute_age,axis=1)
test.drop('Cabin',axis=1,inplace=True)
test.dropna(inplace=True)

# Convert dummpy variable
sex = pd.get_dummies(test['Sex'],drop_first=True)
embark = pd.get_dummies(test['Embarked'],drop_first=True)
test.drop(['Sex','Embarked','Name','Ticket'],axis=1,inplace=True)
test = pd.concat([test,sex,embark],axis=1)
test.head()
```
<div>
<style>
    .dataframe thead tr:only-child th {
        text-align: right;
    }

    .dataframe thead th {
        text-align: left;
    }

    .dataframe tbody tr th {
        vertical-align: top;
    }
</style>
<table border="1" class="dataframe">
  <thead>
    <tr style="text-align: right;">
      <th></th>
      <th>PassengerId</th>
      <th>Pclass</th>
      <th>Age</th>
      <th>SibSp</th>
      <th>Parch</th>
      <th>Fare</th>
      <th>male</th>
      <th>Q</th>
      <th>S</th>
    </tr>
  </thead>
  <tbody>
    <tr>
      <th>0</th>
      <td>892</td>
      <td>3</td>
      <td>22.0</td>
      <td>0</td>
      <td>0</td>
      <td>7.8292</td>
      <td>1</td>
      <td>1</td>
      <td>0</td>
    </tr>
    <tr>
      <th>1</th>
      <td>893</td>
      <td>3</td>
      <td>38.0</td>
      <td>1</td>
      <td>0</td>
      <td>7.0000</td>
      <td>0</td>
      <td>0</td>
      <td>1</td>
    </tr>
    <tr>
      <th>2</th>
      <td>894</td>
      <td>2</td>
      <td>26.0</td>
      <td>0</td>
      <td>0</td>
      <td>9.6875</td>
      <td>1</td>
      <td>1</td>
      <td>0</td>
    </tr>
    <tr>
      <th>3</th>
      <td>895</td>
      <td>3</td>
      <td>35.0</td>
      <td>0</td>
      <td>0</td>
      <td>8.6625</td>
      <td>1</td>
      <td>0</td>
      <td>1</td>
    </tr>
    <tr>
      <th>4</th>
      <td>896</td>
      <td>3</td>
      <td>35.0</td>
      <td>1</td>
      <td>1</td>
      <td>12.2875</td>
      <td>0</td>
      <td>0</td>
      <td>1</td>
    </tr>
  </tbody>
</table>
</div>

## Model Stacking
所有的数据都已经准备就绪，下面进行正式开始模型融合。

![jpg](/assets/model_stacking/stacking.jpg)

```python
X_train = train.drop('Survived', axis=1)
y_train = train['Survived']
X_test = test
```

```python
from sklearn.model_selection import KFold
import numpy as np

ntrain = train.shape[0] #891
ntest = test.shape[0] # 418
kf = KFold(n_splits=5, random_state=666)
```

```python
from sklearn.linear_model import LogisticRegression
logmodel = LogisticRegression()
```

```python
# Get out-of-folder 
def get_oof(clf, X_train, y_train, X_test):
    oof_train = np.zeros((ntrain,))
    oof_test = np.zeros((ntest,))
    oof_test_skf = np.empty((5, ntest))

    for i, (train_index, test_index) in enumerate(kf.split(X_train)): # X_train: 891 * 7
        kf_X_train = X_train.iloc[train_index] # 712 * 7 ex: 712 instances for each fold
        kf_y_train = y_train.iloc[train_index] # 712 * 1 ex: 712 instances for each fold
        kf_X_test = X_train.iloc[test_index] # 179 * 7 ex: 178 instances for each fold

        clf.fit(kf_X_train, kf_y_train)

        oof_train[test_index] = clf.predict(kf_X_test) # 1 * 179 =====> will be 1 * 891 after 5 folds
        oof_test_skf[i, :] = clf.predict(X_test) # oof_test_skf[i, :]: 1 * 418

    oof_test[:] = oof_test_skf.mean(axis=0) # oof_test[:] 1 * 418
    return oof_train.reshape(-1, 1), oof_test.reshape(-1, 1)
```

```python
oof_train, oof_test = get_oof(logmodel, X_train, y_train, X_test)
```

```python
oof_train.shape
```
    (889, 1)

```python
oof_test.shape
```
    (418, 1)

## 参考链接
* [Kaggle机器学习之模型融合（stacking）心得](https://www.leiphone.com/news/201709/zYIOJqMzR0mJARzj.html)
* [https://www.kaggle.com/arthurtok/introduction-to-ensembling-stacking-in-python](https://www.kaggle.com/arthurtok/introduction-to-ensembling-stacking-in-python)
* [模型融合方法综述](https://zhuanlan.zhihu.com/p/25836678)
