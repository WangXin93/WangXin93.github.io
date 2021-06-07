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

### 显卡

一台台式机服务机可以安装1-2张显卡，如果主板上的插槽够用，可以安装4张显卡。你可能会看到过有一些开放式的机箱和主板上安装了8张以上的显卡，但是对于个人用户而言，这样的机器并不是一个好的选择，如果你确实需要这样的机器，向OEM（Supermicro，HP，Gigabyte）购买会是更好的选择，一个是因为这样的机器不光显卡贵，主板和其他配件也会需要更好更贵的选择，OEM提供的价格这种情况下不会相差太多；二是因为这样的机器通常热量大，噪音大，最好是放在专用的机房；最后是OEM会提供一些额外的售后服务。因此，对于个人组装机器而言，最好选择1-4张显卡的机器去组装。

到目前的2021年，现在NVIDIA 3080Ti显卡以及发布。应该尽量购买30系列的显卡。

这里有一份显卡在深度学习上的Benchmark

<https://ai-benchmark.com/ranking_deeplearning.html>

### CPU

Intel I9

Xeon Parts

AMD

### 内存

内存的一个参考标准是GPU内存的两边，比如两张2080ti最好适配2x11x2=44GB的内存。一些比较常见的内存品牌有Corsair, HyperX, Patriot, G.Skill, A-Data。

### 主板

主板需要考虑的因素包括CPU针脚的适配，内存的适配，PCI-E插槽的数量，足够的空间，足够数量的lanes。一些主板有足够的GPU插槽，但是不是完整的8/16 PCI-E lanes。大多数主板实际上最多支持3个GPU。常见的主板品牌有MSI，ASUS，GIGABYTE。ASUS X299 芯片组的主板经常被用在Intel CPU的机器上，AMD CPU的机器经常用 X399 芯片组的主板。

### 电源

机器的电源一定要能够满足所有配件运行的功率。双卡的机器最好配置1000W及以上的电源，如果需要安装更多的卡，你可以考虑考虑使用双电源供电，一些比较好的电源品牌有Antec, CoolerMaster, Corsair, SeaSonic, EVGA。

### 硬盘

你可以把经常使用的数据集放在快速的SSD上，500G的SSD可以基本够用，把用于存档，备份的数据集放在一个4TB的机械硬盘上。如果预算足够，可以选择尽可能大的固态硬盘。

### 机箱与散热

机器最好放置在一个通风凉爽的环境，如果它的噪音太大，你最好把它放在单独的一个房间。

深度学习服务器的机箱需要能够放下所有的配件，如果显卡过多可能需要两个电源的位置，同时还要能够满足偶尔打开进行维修和配件替换的需要。

## 软件

### Ubuntu Configuration

```
sudo apt-get update
sudo apt-get upgrade -y
sudo apt-get install -y build-essential cmake unzip pkg-config
sudo apt-get install -y libxmu-dev libxi-dev libglu1-mesa libglu1-mesa-dev
sudo apt-get install -y libjpeg-dev libpng-dev libtiff-dev
sudo apt-get install -y libavcodec-dev libavformat-dev libswscale-dev libv4l-dev
sudo apt-get install -y libxvidcore-dev libx264-dev
sudo apt-get install -y libgtk-3-dev
sudo apt-get install -y libopenblas-dev libatlas-base-dev liblapack-dev gfortran
sudo apt-get install -y libhdf5-serial-dev graphviz
sudo apt-get install -y python3-dev python3-tk python-imaging-tk
sudo apt-get install -y linux-image-generic linux-image-extra-virtual
sudo apt-get install -y linux-source linux-headers-generic
```

### Install Nvidia (Driver, CUDA, cuDnn)

```
sudo apt-get purge nvidia*
sudo add-apt-repository ppa:graphics-drivers/ppa
sudo apt-get update
ubuntu-drivers devices # Search available drivers
sudo apt-get install nvidia-driver-460 #  Install the driver with the best version
nvidia-smi
```

```
wget https://developer.download.nvidia.com/compute/cuda/11.2.2/local_installers/cuda_11.2.2_460.32.03_linux.run
sudo sh cuda_11.2.2_460.32.03_linux.run

export PATH=/usr/local/cuda-11.2/bin${PATH:+:${PATH}}
export LD_LIBRARY_PATH=/usr/local/cuda-11.2/lib64${LD_LIBRARY_PATH:+:${LD_LIBRARY_PATH}}
export CUDA_HOME=/usr/local/cuda
```

```
tar -zvxf cudnn-11.2-linux-x64-v8.1.0.77.tgz
export LD_LIBRARY_PATH=xxx/cuda/lib64:$LD_LIBRARY_PATH

cd xxx/cuda/include
sudo cp *.h /usr/local/cuda/include/
# replace xxx with your own path

sudo chmod a+r /usr/local/cuda/include/cudnn.h

nvidia-smi
nvcc -V
```

### Install PyTorch

```
conda install pytorch torchvision torchaudio cudatoolkit=11.1 -c pytorch -c conda-forg
```

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

## 参考

* <https://medium.com/analytics-vidhya/install-cuda-11-2-cudnn-8-1-0-and-python-3-9-on-rtx3090-for-deep-learning-fcf96c95f7a1>
* <https://towardsdatascience.com/another-deep-learning-hardware-guide-73a4c35d3e86>
