---
layout: post
title:  "皮肤检测模型"
date:   2021-10-21 19:27:00 +0800
categories: Python ComputerVision
toc: true
---

> 皮肤检测（Skin Detection）是从图像或者视频中寻找皮肤颜色像素区域的算法过程。这个过程可以作为后续发现人脸或者躯干区域的预处理步骤。这篇博客介绍了使用椭圆模型检测检测图像中的皮肤区域的算法。该算法首先将输入的图像从RGB颜色空间转化到YCrCb颜色空间，然后使用Cr和Cb的值作为特征来分类每个像素是否属于人类皮肤，Cr和Cb的值构成的颜色空间的分类边界是由收集的数据统计得到的，皮肤的分类边界类似一个椭圆形，因此被称为椭圆模型皮肤检测。

## 简介

皮肤的颜色的纹理是分析人类的一个重要因素，它和人的种族，健康状态，年龄，财富，颜值息息相关，因此皮肤检测是图像分析的一个重要工具。皮肤检测算法可以应用与裸体检测进行内容过滤，或者用来监控摄像头下是否出现可疑任务，或者在固定的拍摄环境下，提取照片上的人的脸部和手部信息，因此已经有许多算法被开发来皮肤检测。

皮肤检测算法在实现时候会面临下面的问题：不同种族的人类肤色存在差别；在不同光照条件下人体肤色要都能够被识别；现实中有很多和人体肤色颜色类似的物体，比如木头，皮革，沙子等。

## 算法框架介绍

本博客使用的皮肤检测算法包含两个阶段：训练阶段和预测阶段。训练阶段的步骤：

1. 收集包含不同种族，不同光照条件下包含人体皮肤的图像构建数据集
2. 选择一个合适的颜色空间
3. 训练一个皮肤分类器

检测阶段对一个输入的皮肤图像进行下面操作：

1. 将图像转化到训练阶段一样的颜色空间
2. 使用分类器分类每个像素是否为皮肤
3. 进行一些后处理来加强空间一致性，比如进行一些图像形态学操作。

## 颜色空间选择

由于人体皮肤一般是血色和黑色素的混合颜色，肤色区域的像素会在颜色空间上落入到相似的位置，但是并不是所有颜色空间都是这样。因此，可以通过实验来探索应该选择什么样的颜色空间。理想中的颜色空间应该满足：不同种族的肤色，不同光照的肤色的像素都落入相似区域，而且这个区域有一个清晰的分类边界。

首先查看亚洲人皮肤像素在不同颜色空间的分布。可以发现在RGB空间和CIE空间，皮肤像素在颜色空间的位置会存在分类边界不够清晰的问题，YCrCb颜色空间上的颜色分布类似均为椭圆：

![img1](/assets/2021-10-21-skin-detection/asian-density.png)

然后查看不同种族的人类皮肤（亚洲，非洲，白人）在不同颜色空间的分布。可以发现YCrCb是最适合用于分类皮肤的颜色空间。YCrCb一般常用于JPEG图像压缩和MPEG视频压缩，其中Y通道将亮度和颜色分开，而所有皮肤像素的Cr和Cb通道的值会聚集在一个集中的位置，而且从图中可以发现不同种族的皮肤的在颜色空间的位置具有不变性。

![img2](/assets/2021-10-21-skin-detection/different-race-density.png)

可以使用Cr和Cb的值来判断一个像素是否是皮肤，可以直接判断它是否位于椭圆形的分类边界内，或者使用Baysian方法。

## 实践代码

下面的代码实现了首先将摄像头中的图像转化到YCrCb颜色空间，然后对每一个位置的像素使用它的Cr和Cb值判断是否为人体皮肤，在椭圆区域内的会被判断为人体皮肤，反之则判断不是人体皮肤。

![img3](/assets/2021-10-21-skin-detection/demo.png))

```python
import cv2
import numpy as np

def getSkinCrCbHist():
    canvas = np.zeros((256, 256))
    center_coordinates = (113, 155)
    axesLength = (23, 15)
    angle = 43
    startAngle = 0
    endAngle = 360
    color = (255, 255, 255)
    thickness = -1
    canvas = cv2.ellipse(canvas, center_coordinates, axesLength, angle, startAngle, endAngle, color, thickness)
    return canvas

SkinCrCbHist = getSkinCrCbHist()

def isSkin(img, SkinCrCbHist=SkinCrCbHist):
    converted = cv2.cvtColor(img, cv2.COLOR_BGR2YCrCb)
    out = np.zeros_like(converted)
    nrow, ncol, _ = out.shape
    for r in range(nrow):
        for c in range(ncol):
            YCrCb = converted[r, c]
            _, Cr, Cb = YCrCb
            if SkinCrCbHist[Cr, Cb] > 0:
                out[r, c, :] = 255
            else:
                out[r, c, :] = 0
    return out

# capture frames from a camera with device index=0
cap = cv2.VideoCapture(0)

# loop runs if capturing has been initialized 
while(1): 

	# reads frame from a camera 
	ret, frame = cap.read() 

	# Display the frame
	cv2.imshow('Skin Detector', np.concatenate([frame, isSkin(frame)], axis=1))

	# Wait for 25ms
	if cv2.waitKey(1) & 0xFF == ord('q'):
		break
		
# release the camera from video capture
cap.release() 

# De-allocate any associated memory usage 
cv2.destroyAllWindows() 
```

## 参考

1. Fleck, M.M., Forsyth, D.A., Bregler, C.: Finding naked people. In: Proceedings of the European Conference on Computer Vision (ECCV). (1996) 593–602
2. <https://www.cnblogs.com/tornadomeet/archive/2012/12/05/2802428.html>
3. <http://spottrlabs.blogspot.com/2012/01/super-simple-skin-detector-in-opencv.html>
4. <https://people.cs.rutgers.edu/~elgammal/pub/skin.pdf>