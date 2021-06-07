---
layout: post
title:  "深度学习环境配置"
date: 2018-04-02 22:16:55 +0800
categories: Python Linux
toc: true
---

> 这篇文章将会介绍如何从头开始打造一台用于深度学习的服务器。首先我们需要从硬件挑选开始，选择合适的显卡，CPU，主板，内存，机箱，电源；然后开始进行软件的安装，包括CUDA，CuDNN，PyTorch，TensorFlow。

## 前言

Pytorch 安装踩坑笔记。

## 硬件

## 软件

### Ubuntu Configuration

### Install CUDA Toolkit

### Install CuDNN

### Install PyTorch

### Install mmcv mmdetection

### 使用anaconda安装pytorch

#### 1. 修改conda源

直接使用官网链接下载安装时常网速太慢甚至下载失败，所以使用国内conda源加速安装包下载。这里使用清华和中科大的源,修改源的方法是修改`~/.condarc`文件为：（如果文件不存在，创建一个即可）

```
channels:
- https://mirrors.tuna.tsinghua.edu.cn/anaconda/pkgs/free/
- http://mirrors.ustc.edu.cn/anaconda/pkgs/free/
- defaults

show_channel_urls: yes
```

可以使用`conda upgrade --all`确认conda源已经更改成功。

#### 2. 下载安装pytorch

这里只安装cpu版torch，执行以下命令即可安装：

```
conda install pytorch-cpu torchvision -c pytorch
```

等待安装完成后执行：

```python
import torch
import torchvision
```

如果没有错误，表示pytorch已经成功安装。
