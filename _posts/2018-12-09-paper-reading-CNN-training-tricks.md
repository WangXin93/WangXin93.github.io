---
layout: post
title:  "论文阅读12.09: CNN Training Tricks"
date: 2018-12-09 14:26:00 +0800
categories: bash
toc: true
---

## Recent Tricks for training CNN classification model

Tricks或者说调参技巧对于模型性能的表现是有很大影响的。最近[Bag of Tricks for Image Classification with Convolutional Neural Networks](https://arxiv.org/pdf/1812.01187v2.pdf)整理了目前多个有效的调参方法（包括mixup数据增广，label smoothing，循环学习率，知识蒸馏），可以发现ResNet-50模型经过调参后可以达到高于DenseNet-201的表现。

| Model         | FLOPS | top-1 | top-5 |
|---------------|-------|-------|-------|
| ResNet-50     |  3.9G | 75.3  | 92.2  |
| SE-ResNeXt-50 |  4.3G | 78.90 | 94.51 |
| DenseNet-201  |  4.3G | 77.42 | 93.66 |
| ResNet        |  4.3G | 79.29 | 94.63 |

这充分体现了模型训练技巧或者说tricks的作用。除了已经众所周知的Data Augmentation，L2 regularization，Batch Normalization， Dropout等，这里介绍最近的论文中的一些通用的trick。

### [1. mixup: BEYOND EMPIRICAL RISK MINIMIZATION](https://arxiv.org/abs/1710.09412)

这是一个简单有效的方法，它可以用两行公式就能说明白：

$$
\begin{aligned}
\tilde{x} = \lambda x_i + (1 - \lambda) x_j, \quad \text{where } x_i, x_j \text{ are raw input vectors} \\
\tilde{y} = \lambda y_i + (1 - \lambda) y_j, \quad \text{where } y_i, y_j \text{ are raw input vectors}
\end{aligned}
$$

这里$$(x_i, y_i)$$和$$(x_j, y_j)$$是从训练数据中随机选择的样本，$$\lambda \in [0, 1]$$的是两者线性相加的权重。通过这样的mixup训练数据，然后喂入模型训练，在CIFAR-10上的表现达到4.24%，在CIFAR-100，ImageNet-2012上均取得SOTA，并且可以稳定GAN的训练。

作者公开的代码实现在：https://github.com/facebookresearch/mixup-cifar10

### [2. Cutout](https://arxiv.org/pdf/1708.04552.pdf)

Cutout的工作展示了在训练时候随机mask掉图片中的一个方块可以起到正则化的作用，从而提高CNN的鲁棒性和性能。

![Selection_014](https://i.imgur.com/NpmsrFY.png)

根据作者的实验，cutout和shake-shake regularization可以起到互补作用。


| Model                      | Error rates(%) |
|----------------------------|----------------|
| Shake-shake regularization | 2.86           |
| Shake-shake reg + cutout   | 2.56           |


### [3. shake-shake regularization](https://arxiv.org/pdf/1705.07485.pdf)

![Selection_015](https://i.imgur.com/fTiduGT.png)

下面说一下刚刚提到的shake-shake regularization。Shake-shake的方法动机是：数据增广通常是对输入的image进行，但是对计算机来说，image和CNN的中间层表达并没有实质区别。Shake-shake尝试在中间层上随机混合2个表达来增加扰动。形式上可以表达为：

$$
x_{i+1} = x_i + \alpha_i \mathcal{F}(x_i, \mathcal{W_i^{(1)}}) + \mathcal{F}(x_i, \mathcal{W_i^{(2)}})
$$

其中$$x_i$$代表residual block $$i$$ 的输入，$$\mathcal{W_i^{(1)}}, \mathcal{W_i^{(1)}}$$ 是两个preactivation residual block $$\mathcal{F}$$ 的输入。随机变量$$\alpha_i$$用来随机融合两个输入，而在测试阶段，$$\alpha_i$$被设置为0.5。

在CIFAR-10，它可以取得2.86%的Error rate，不过实验中训练了1800个epochs，过于耗时。

### 4. Label smoothing

Label smoothing 的想法最先被在训练[Inception-v2](https://arxiv.org/pdf/1812.01187v2.pdf#page=9&zoom=100,0,640)的时候提出，它能够改变true probability的构成：

$$
q_i =
\begin{cases}
1 - \epsilon & \text{if } i = y, \\
\epsilon/(K - 1) & \text{otherwise}
\end{cases}
$$

### 5. 循环学习率和Stochastic Weight Averaging

https://towardsdatascience.com/stochastic-weight-averaging-a-new-way-to-get-state-of-the-art-results-in-deep-learning-c639ccf36a

### [6. Born-Again Neural Networks](https://arxiv.org/pdf/1805.04770.pdf)

[知识蒸馏（Knowledge Distillation）](https://medium.com/neural-machines/knowledge-distillation-dc241d7c2322)的方法通常是用emsembled model作为teacher model然后让student model去学习teacher的软化后的output。

知识蒸馏可以用于模型压缩。为什么知识蒸馏会有效？一个解释是teacher的output可以分解为两个部分：一个dark knowledge，包含错误输出的信息，另一个是ground-truth component，这部分实际上对应真实标签rescaled后的结果。

在知识蒸馏的teacher-student的框架下，我们可以让student去学习teacher的output，[也可以去学习teacher的中间层的分布](http://openaccess.thecvf.com/content_cvpr_2017/papers/Yim_A_Gift_From_CVPR_2017_paper.pdf)。


![Selection_016](https://i.imgur.com/TAd6D2X.png)

Born Again Network（BAN）的思想是在训练好teacher model后，之后每次让初始化出一个新的student 模型来同时逼近上一个模型和真实标签。最后，多个student ensemble的结果甚至会由于teacher结果。

实验中在CIFAR-100上的结果，teacher的error rate结果在18.25%, 当有3个student时候，依次可以达到17.61%, 17.22%, 16.59%, emsemble可以达到15.68%。

## [Neural Aesthetic Assessment](https://arxiv.org/pdf/1709.05424.pdf)

我们希望能让计算机学会给摄影照片的审美打分。[AVA](http://refbase.cvc.uab.es/files/MMP2012a.pdf)就是这样一个对这个问题有帮助的审美数据集。

但是AVA中，一张照片通常会得到多个评审的打分。那么要设计模型的学习目标，一个方法是取这些多个打分的平均分作为监督信号。

实际上我们可以做的更好，这是因为多个评审打分的方差也可以作为监督信号。那么怎么将这个想法设计到模型中呢？本工作提出使用normalized Earth Mover's Distance作为损失函数。给出groud-truth和模型预估的结果$$p,\hat{p}$$和$$N$$个有序的类别，它们类之间的距离为 $$\|s_i - s_j\|_r$$，那么损失函数为：

$$
EMD(p,\hat{p}) = (\frac{1}{N} \sum_{k=1}^{N} |CDF_p(k) - CDF_{\hat{p}}(k)|^r ) ^ {1/r}
$$

这里$$CDF_p(k)$$是cumulative distribution function即$$\sum_{i=1}^{k}p_{s_i}$$。这个损失函数对于偏离真实值更多的错误预测有更多的惩罚。实验中$$r$$取2。

