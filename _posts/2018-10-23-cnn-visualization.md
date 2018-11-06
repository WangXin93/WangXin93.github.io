---
layout: post
title:  "为什么要相信你？CNN可解释性总结"
date: 2018-10-23 20:42:05 +0800
categories: Algorithm
---

## 前言

研究CNN的可解释性，可以让我们知道为什么模型会做出这样的决定，因为我们很难用黑盒的模型去说服用户去做一个医疗上的或者军事上的一个重大决定。同时，通过可解释性的研究，我们可以知道为什么CNN做出这样的决定，从而更好地诊断我们地模型。

如何解释一个CNN模型？如果我们可以知道对应不同的物体，CNN模型在关注什么地方，这会是一个很好的解释。

要实现这个目标，目前的方法有：

* Occulsion sentivity
* Guided Back-propagation
* Deconvolution
* CAM
* Grad-CAM
* LIME

## Occulsion sentivity

Occulsion sentivity的思想可以这样理解，假设有一张“一个男人正在吹号的图片”，如果我们想知道模型认为什么地方是圆号，那么可以对图片中的不同未知进行遮挡，如果遮挡后的图片让模型识别不出圆号，那么这就是模型认为这是圆号的地方。

![img](https://blogs.mathworks.com/deep-learning/files/2017/12/occlusion_sensitivity_resnet_04.png)

参考：

* [Visualizing and Understanding Convolutional Networks](https://arxiv.org/pdf/1311.2901.pdf)
* [Network Visualization Based on Occlusion Sensitivity](https://blogs.mathworks.com/deep-learning/2017/12/15/network-visualization-based-on-occlusion-sensitivity/)

## Deconvolution & Guided Back-propagation

反卷积和导向反向传播的基础都是反向传播，主要思想是对输入模型的内容进行求导。不同的是普通反向传播是将输入大于0的梯度传递回去，反卷积是将梯度大于0对应的梯度传递回去，导向反向传播是将输入和梯度均大于0的梯度传递回去。

虽然方法上差别不大，但是最终的结果却有很大差别：

![img](https://upload-images.jianshu.io/upload_images/415974-fb540b47870df312.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/306/format/webp)

参考：

* [Deep Inside Convolutional Networks: Visualising Image Classification Models and Saliency Maps](https://arxiv.org/pdf/1312.6034.pdf)
* [Striving For Simplicity: The All Convolutional Net](https://arxiv.org/pdf/1412.6806.pdf)

## CAM

对输入求导的方法虽然可以告诉我们模型在关注哪里，但是并不能拿来解释分类，因为我们不知道模型对不同类别的反应是什么样的。CAM提供了一个解决方法。它使用Global Average Pooling（GAP）替换掉全连接层将网络之前层学习的带有空间信息feature map降为低维的信号。最后一层全连接层学习到的参数可以作为feature maps对应不同类别的权重参数。通过将某一个类别的feature maps进行权重加和可以得到我们想要的Class Activation Map。

![img](https://upload-images.jianshu.io/upload_images/415974-3f622c0e242d2bf0.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1000/format/webp)

参考：

* [Learning Deep Features for Discriminative Localization](https://www.cv-foundation.org/openaccess/content_cvpr_2016/papers/Zhou_Learning_Deep_Features_CVPR_2016_paper.pdf)

## Grad-CAM

但是CAM有个实现的前提是需要更改模型结构，这在有的时候是致命的。于是Grad-CAM横空出世。Grad-CAM另辟蹊径，用梯度的全局平均来计算权重。事实上，经过严格的数学推导，Grad-CAM与CAM计算出来的权重是等价的。

除了直接生成热力图对分类结果进行解释，Grad-CAM还可以与其他经典的模型解释方法如导向反向传播相结合，得到更细致的解释。

![img](https://upload-images.jianshu.io/upload_images/415974-0147c44dcfb8cc1c.jpg?imageMogr2/auto-orient/strip%7CimageView2/2/w/1000/format/webp)

参考：

* [Grad-CAM: Visual Explanations from Deep Networks via Gradient-Based Localization](http://openaccess.thecvf.com/content_ICCV_2017/papers/Selvaraju_Grad-CAM_Visual_Explanations_ICCV_2017_paper.pdf)


## LIME
LIME是KDD 2016上一篇非常漂亮的论文，思路简洁明了，适用性广，理论上可以解释任何分类器给出的结果。其核心思想是：对一个复杂的分类模型(黑盒)，在局部拟合出一个简单的可解释模型，例如线性模型、决策树等等。

![img](http://lc-cf2bfs1v.cn-n1.lcfile.com/f4682022fc64aa470120.png)

如图所示，红色和蓝色区域表示一个复杂的分类模型（黑盒），图中加粗的红色十字表示需要解释的样本，显然，我们很难从全局用一个可解释的模型（例如线性模型）去逼近拟合它。但是，当我们把关注点从全局放到局部时，可以看到在某些局部是可以用线性模型去拟合的。具体来说，我们从加粗的红色十字样本周围采样，所谓采样就是对原始样本的特征做一些扰动，将采样出的样本用分类模型分类并得到结果（红十字和蓝色点），同时根据采样样本与加粗红十字的距离赋予权重（权重以标志的大小表示）。虚线表示通过这些采样样本学到的局部可解释模型，在这个例子中就是一个简单的线性分类器。在此基础上，我们就可以依据这个局部的可解释模型对这个分类结果进行解释了。

一个看似复杂的模型通过我们巧妙的转换，就能够从局部上得到一个让人类理解的解释模型，光这样说还是显得有些空洞，具体来看看LIME在图像识别上的应用。我们希望LIME最好能生成和Grad-CAM一样的热力图解释。但是由于LIME不介入模型的内部，需要不断的扰动样本特征，这里所谓的样本特征就是指图片中一个一个的像素了。仔细一想就知道存在一个问题，LIME采样的特征空间太大的话，效率会非常低，而一张普通图片的像素少说也有上万个。若直接把每个像素视为一个特征，采样的空间过于庞大，严重影响效率；如果少采样一些，最终效果又会比较差。

所以针对图像任务使用LIME时还需要一些特别的技巧，也就是考虑图像的空间相关和连续的特性。不考虑一些极小特例的情况下，图片中的物体一般都是由一个或几个连续的像素块构成，所谓像素块是指具有相似纹理、颜色、亮度等特征的相邻像素构成的有一定视觉意义的不规则像素块，我们称之为超像素。相应的，将图片分割成一个个超像素的算法称为超像素分割算法，比较典型的有SLIC超像素分割算法还有quickshit等，这些算法在scikit-image库中都已经实现好了，quickshit分割后如图所示：

![img](http://lc-cf2bfs1v.cn-n1.lcfile.com/e343bec75b31b7bbcd33.png)

从特征的角度考虑，实际上就不再以单个像素为特征，而是以超像素为特征，整个图片的特征空间就小了很多，采样的过程也变的简单了许多。更具体的说，图像上的采样过程就是随机保留一部分超像素，隐藏另一部分超像素。

整体流程如图所示：

![img](http://lc-cf2bfs1v.cn-n1.lcfile.com/7f5f62a0ab431169c75d.png)

和Grad-CAM一样，LIME同样可以对其他可能的分类结果进行解释。

![img](http://lc-cf2bfs1v.cn-n1.lcfile.com/6bb64a832e2cce97dc39.png)

参考：

* [“Why Should I Trust You?” Explaining the Predictions of Any Classifier](https://arxiv.org/pdf/1602.04938.pdf)

## Reference

实现：
* [Grad-CAM implementation in Pytorch](https://github.com/jacobgil/pytorch-grad-cam)
* [pytorch-cnn-visualizations](https://github.com/utkuozbulak/pytorch-cnn-visualizations/blob/master/src/guided_backprop.py)

笔记：
* <http://cs231n.github.io/understanding-cnn/>
* [凭什么相信你，我的CNN模型？（篇一：CAM和Grad-CAM)](https://www.jianshu.com/p/1d7b5c4ecb93)
* [凭什么相信你，我的CNN模型？（篇二：万金油LIME)](http://bindog.github.io/blog/2018/02/11/model-explanation-2/)
