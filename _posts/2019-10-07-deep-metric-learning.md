---
layout: post
title:  "深度度量学习（Deep Metric Learning）"
date:   2019-10-07 15:05:35 +0800
categories: Algorithm
---

> 度量学习的任务是使用算法来学习输入对象之间的距离。它可以用于人脸识别认证，商品检索，通过训练的模型可以让相似对象之间的特征距离相近，不相似的对象之间的特征距离较远。深度学习模型能够有效学习这样的特征。本篇文章会介绍深度度量学习的基本原理和一些最近的进展。

## 什么是度量学习？

## 深度度量学习

* Contrastive Loss

[R. Hadsell, S. Chopra, and Y. LeCun. Dimensionality reduction by learning an invariant mapping]()

* Semi-Hard Mining Strategy

[F. Schroff, D. Kalenichenko, and J. Philbin. Facenet: A unified embedding for face recognition and clustering. In CVPR, 2015]()

* Lifted Structure Loss

[Deep Metric Learning via Lifted Structured Feature Embedding](https://arxiv.org/abs/1511.06452v1)

* Binomial BinDeviance lLoss

[D. Yi, Z. Lei, and S. Z. Li. Deep metric learning for practical person re-identification]()

* NCA Loss

[C. Wu, R. Manmatha, A. J. Smola, and P. Kr¨ahenb¨uhl. Sampling matters in deep embedding learning. ICCV, 2017]()

* Proxy-NCA

[No Fuss Distance Metric Learning using Proxies](http://openaccess.thecvf.com/content_ICCV_2017/papers/Movshovitz-Attias_No_Fuss_Distance_ICCV_2017_paper.pdf)

* N-pair loss

[Improved Deep Metric Learning with Multi-class N-pair Loss Objective](https://papers.nips.cc/paper/6200-improved-deep-metric-learning-with-multi-class-n-pair-loss-objective)

* Clustering loss

[Deep Metric Learning via Facility Location](http://openaccess.thecvf.com/content_cvpr_2017/papers/Song_Deep_Metric_Learning_CVPR_2017_paper.pdf)

* Angular loss

[Deep Metric Learning with Angular Loss](https://arxiv.org/abs/1708.01682v1)

* Multi-Similarity Loss

<https://github.com/MalongTech/research-ms-loss>

* Proxy Anchor Loss

## 参考

* [Deep Metric Learning in PyTorch](Deep Metric Learning in PyTorch)
* [Deep Metric Learning](https://github.com/ronekko/deep_metric_learning)
* [pytorch metric learning library](https://github.com/KevinMusgrave/pytorch-metric-learning)
* [deep person reid library](https://github.com/KaiyangZhou/deep-person-reid)
* [Stanford Online Products Retrieval Leaderboard](https://kobiso.github.io/Computer-Vision-Leaderboard/sop.html)
* [The Why and the How of Deep Metric Learning](https://towardsdatascience.com/the-why-and-the-how-of-deep-metric-learning-e70e16e199c0)
