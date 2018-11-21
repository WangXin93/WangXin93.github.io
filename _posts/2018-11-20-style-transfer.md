---
layout: post
title:  "Style Transfer"
date: 2018-11-20 19:50:16 +0800
categories: algorithm
---

## 前言

# Neural Style

# Pix2Pix

# Cycle GAN

不像Pix2Pix，CycleGAN可以训练这个风格转变，而且不需要两个domain的一对一匹配的数据来训练。取而代之的是使用一个两步的方法将source domain的映射到target domain，然后再将它映射会source domain。Generator用来将source domain的图像映射到target domain，而discriminitor与generator对抗训练来提高生成的图片的质量。

> Cycle-Consistent:
> 
> 为了regularize 模型，作者提出了cycle-consistent约束：如果我们从源分布变换到目标分布然后再变换回来，我们应该得到我们源分布的采样。

CycleGAN的整体框架如下：

<div style="text-align:center">
<img src="https://hardikbansal.github.io/CycleGANBlog/images/model.jpg" style="width:60%; padding: 10px;"/>
<hr style="border-top:">
<img src="https://hardikbansal.github.io/CycleGANBlog/images/model1.jpg" style="width:60%; padding:10px;"/>
</div>

在CycleGAN中，我们所训练的数据不是pair而是一个domain $$D_A$$ 到另一个domain $$D_B$$, 当我们把一张图像$$Img_A$$从source domain转换到target domain的时候，在target domain没有一个真值$$Gen_B$$。但是，由于转换后的图像和原来的图像必然后sharing features，所以必然有一个映射将转换后的图像变为原来的图像$$Img_A$$，这样才能训练一个有意义的mapping。
    
<div style="text-align:center">
<img src="https://hardikbansal.github.io/CycleGANBlog/images/img_translation.JPG" style="width:60%; padding:10px;"/>
</div>

简单来说，CycleGAN模型包含两个生成器 $$Generator_{A \to B}$$, $$Generator_{B \to A}$$。在训练阶段，当给模型输入一个$$D_A$$的图像$$Img_A$$，$$Generator_{A \to B}$$ 将其转化为$$D_B$$的图像$$Gen_B$$。然后$$Generator_{B \to A}$$再将$$Gen_B$$转化到$$D_A$$，即$$Cyclic_A$$。我们希望训练模型使得$$Cyclic_A$$和$$Img_A$$的差异很小（类似与autoencoder），同时完成生成器和判别器达到 Nash equilibrium，即生成器能够生成target domain同样的分布。

具体来说，生成器可以采用如下结构：
<div style="text-align:center">
<img src="https://hardikbansal.github.io/CycleGANBlog/images/Generator.jpg" style="width:60%; padding:10px;"/>
</div>

判别器可以使用如下结构：
<div style="text-align:center">
<img src="https://hardikbansal.github.io/CycleGANBlog/images/discriminator.jpg" style="width:60%; padding:10px;"/>
</div>

损失函数的设计依照下面四个步骤：
1. 判别器成功判断所有original images为0。
2. 判别器成功判断所有generated images为1。
3. 生成器成功生成被判别为0的generated images。
4. 生成器生成的图像满足cyclic consistency。

## 参考
* [Understanding and Implementing CycleGAN in TensorFlow](https://hardikbansal.github.io/CycleGANBlog/)

