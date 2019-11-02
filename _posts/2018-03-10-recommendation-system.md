---
layout: post
title:  "推荐系统"
date:   2018-03-10 22:04:11 +0800
categories: Algorithm
toc: true
---

## 什么是推荐系统

自上而下地说，推荐系统是根据用户地兴趣推荐符合他们地产品。推荐系统是众多机器学习系统中地重要部分，许多零售商家实现推荐系统是为了驱动市场的销售。

推荐系统用到到数据包括用户对商品到明确评价（比如看过到电影，听过到音乐）；搜索或者购买到历史，亦或者用户自身到信息（性别，职业，爱好等）。类似于网易云音乐，bilibili，youtube这样的网站利用这样的信息来推送给用户他们可能喜欢的内容，比如网易云音乐的每日推荐，youtube的视频推荐。

## 为什么需要推荐系统

拥有完善推荐系统的公司无疑给用户带来了良好的购物体验。首先，推荐的结果加速了用户搜索的速度，帮助他们快速找到自己感兴趣的商品，同时还会列出一些用户从未搜索过但是他们非常喜欢的商品，这样的体验是惊喜的。此外，公司可以发送邮件或者消息的方法第一时间将用户感兴趣的商品信息推送过去，或者定期制作推荐内容来和用户保持联系，这是有助于留住用户群体的。因为如果推荐的内容有效，用户会觉得自己的兴趣是被了解的，因此有可能购买更多商品，这对于同类公司来说是巨大的竞争力，更有可能在销售中给同类公司带来威胁。

## 推荐系统的工作原理

推荐系统通常使用两类数据信息作为输入：

* 特征信息：商品的关键字，类别，用户的偏好，简历等。
* 交互信息: 评分，购买，点赞等。

基于上面的输入信息，我们可以划分三类推荐系统算法：

* 基于内容的推荐系统：使用特征信息。
* 协同滤波推荐系统：基于用户和商品的交互。
* 混合推荐系统：希望结合上面两种方法来避免它们单独使用时候的缺点。

### 基于内容的推荐系统

这样的方法使用到用户和商品到特征。它假设用户过去喜欢到东西，在未来同样会感兴趣。可以使用特征将同类到商品进行归类，用户的简历可以通过历史的交互或者明确的问题来得到。

### 协同滤波系统

协同滤波方法是目前最常用的方法之一，它通常会提供比基于内容的推荐系统更好的体验，Youtube，Netflix, Spotify都用到了这样的技术。

协同滤波系统使用用户的交互来过滤得到感兴趣的商品。简短来说，协同滤波假设如果一个用户对商品A感兴趣，这个商品A也是另一个用户感兴趣对，同时那个用户还对商品B感兴趣，那么第一个用户很有可能也感兴趣商品B。实现这样对目标有两种方法：基于记忆对方法和基于模型的方法。

#### 基于记忆的方法 (memory-based approach)

这里有两种方法，第一种是对用户聚类，然后用某一个具体用户来预测相似用户对交互；第二种是对用户A所有评论过对商品聚类，然后使用它们来判断用户A对于一个不同但是相似对商品B的交互行为。这类方法会遇到矩阵过于稀疏，已有的用户和商品的交互历史难于有效聚类的问题。

#### 基于模型的方法（model-based approach)
这类方法基于机器学习和数据挖掘的技术，通过训练一个模型来作出预测。比如，可以利用已有的用户商品交互历史训练一个模型来得到一个用户喜欢的商品的前5名，这么做的好处是相对于基于记忆的方法，它可以对大量用户作出大量商品的预测，这即使在矩阵稀疏时候依然有效。

协同滤波的问题：

* 冷启动
* 新用户，商品的加入


* **Content-based recommender systems** focus on the attributes of the items and give you recommendations based on the similarity between them.
* **Collaborative filtering** produces recommendations based on the knowledge of users’ attitude to items, that is it uses the "wisdom of the crowd" to recommend items. CF can be divided into **Memory-Based Collaborative Filtering** and **Model-Based Collaborative filtering**. 

* **Memory-based models** are based on similarity between items or users, where we use cosine-similarity.
* **Model-based CF** is based on matrix factorization where we use SVD to factorize the matrix.
* Models that use both ratings and content features are called **Hybrid Recommender Systems** where both Collaborative Filtering and Content-based Models are combined. Hybrid recommender systems usually show higher accuracy than Collaborative Filtering or Content-based Models on their own: they are capable to address the cold-start problem better since if you don't have any ratings for a user or an item you could use the metadata from the user or item to make a prediction. 

## 用于推荐系统的技术

### 全连接网络

可以将用户的嵌入和商品的嵌入拼接成一个向量来喂入到全连接网络中，预测最终用户和商品是否发生交互行为，这可以视为一个二分类问题。

非常有意思到是，学习到的用户和商品到嵌入通常会包含明确到语义信息。所以嵌入相似对用户会在实际上也非常相似，这对于分析用的行为是有用的。

### Item2Vec

类似于Word2Vec，Item2Vec将商品购买历史到顺序作为上下文信息，暗示了类似情况下购买到商品是可以相互比较的，它们到嵌入也会类似。这个方法没有用到用户信息，在作出推荐时候也没有考虑用户信息。但是，如果我们到目标是给用户推荐一些已选定商品的替代品，这个方法是有用的。

## 什么时候需要推荐系统？

实现一个推荐系统到底值不值得？如果你正在运营一个成功的企业，那么没有推荐系统企业也可以生存，但是如果你需要使用数据的力量来提升用户体验，那么推荐系统是有帮助的。从众多使用了推荐系统的公司的经历来看，实现推荐系统是值得的：

* 35%的Amazon的购买是它们的推荐系统的结果
* 截止到2016年11月，阿里巴巴的个性化页面的转化率增长到20%
* 推荐结果承包了Youtube 70%的视频访问
* 75%的Netflix用户从推荐结果中观看电影。
* 采用一个推荐系统帮助了Netflix每年节省10个亿。

## 构建一个推荐系统的前提

数据是一个重要前提。这些数据包含用户数据和商品数据。如果你只有特征数据，那么可以考虑从基于内容的推荐开始，如果你有大量的交互数据，那么你可以体验更强大的协同滤波方法。数据规模越大，通常推荐系统的效果会越好。同时，开发推荐系统的团队要能够理解数据，正确处理数据，使得推荐技术能够有效转化吸收这些数据。

在考虑用户商品的交互时，这里有一些需要记住的东西：

1. 你需要定义什么是一个交互？购买，点击，浏览，点赞，放入购物车等
2. 交互可以是显式的也可以是隐式的，显式的交互比如明确的点赞或者讨厌，打分等，隐式的交互比如搜索或者购买某件商品。
3. 交互数据数量越多，通常最后结果越好
4. 通常有少数商品的交互数量特别多，而其它大部分则很少存在交互，这呈现出一个长尾分布。推荐系统通常对于那些交互多的部分表现的非常好，但是这部分商品因为太过流行用户不再希望了解它们，而在尾巴部分的实际上是用户真正感兴趣的部分，因为这部分商品还没有被充分了解。

![img](https://tryolabs.com/images/blog/post-images/2018-05-09-introduction-to-recommender-systems/long-tail.f55e22ee.png)


## 如何评估推荐系统？

### 在线评估

也被称为A/B测试，可以通过计算用户点击数量，或者说转化率来衡量。这样的评估是最理想的，但是它很耗时，较差的方案还会用户不一样的用户体验带来一些损失。

### 离线评估

离线方法适合于实验阶段。，它不会让用户实际参与而是划分出训练集和验证集。但是这样也会导致有些因素在实验时候无法考虑到，比如季节，天气，用户在某个时间段的情绪等。

## 参考

* [Introduction to Recommender Systems in 2019](https://tryolabs.com/blog/introduction-to-recommender-systems/)
* [wikipedia: Recommender system](https://en.wikipedia.org/wiki/Recommender_system)
