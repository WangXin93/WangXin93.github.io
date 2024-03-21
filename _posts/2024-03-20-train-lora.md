---
layout: post
title: "如何训练Lora"
date: 2024-03-20 08:30
categories: MachineLearning ComputerVision
toc: true
---

> 这里记录了如何训练一个lora来生成指定的人物角色

## 引言

虽然stable diffusion模型在使用大量数据训练过后已经可以通过提示词绘制很多对应的内容，但是仍然有一些内容是通用数据集所不包含的，比如一个新画家的绘画风格，一个新的人物角色，这时候可以通过微调stable diffusion模型来将新的概念注入到原来的模型中。但是完整地训练stable diffusion需要大量的计算资源，同时可能导致原来模型中的参数被遗忘，为了解决这个问题，Lora通过训练包含少量参数的额外的低秩矩阵来在推理时候将额外特征加到原来的模型参数中，被证明可以使用较少的参数达到完整训练模型相当的结果。

这篇笔记会记录如何使用目前已有的开源工具来训练一个Lora模型将注入到stable diffusion模型当中。整体来说训练一个Lora模型包含下面的步骤：

1. 准备数据
2. 配置环境
3. 设置训练参数并启动训练
4. 评估训练结果

## 准备数据

准备Lora的训练数据包括准备准备图片，准备描述文本，如果希望同时训练dreambooth可以准备regularization images。

准备图片，准备至少20张左右相同风格或者角色在不同姿态背景下拍摄的照片。如果希望模型能够更好的生成脸部细节，应该使用更好的相机并合理使用拍摄灯光来保证素材的细节展现在图片上。

标注图片，可以使用自动文本标注生成工具，手动检查和补充标注很可能提高生成的结果的准确性。关于文本标注有几个注意点：

1. 详细的文本标注可能帮助你在生成角色的时候只保留角色的身份而不保留角色的装饰。比如训练图片中的角色带着眼镜，如果文本标注只包含角色名称，不包含眼镜，那么训练的模型生成角色会包含眼镜；而如果文本标注包含眼镜，那么训练的模型生成的觉得可能不包含眼镜。
2. 使用接近角色的文本标注可以让模型的训练起点更接近素材，因此可能取得更好的结果。
3. 不同的base model推荐尝试不同的自动标注生成工具，比如sd15使用blip和sdxl可以尝试
CLIP-ViT-g-14-laion2B-s34B-b88K。

## 配置环境

sd-scripts/kohya-ss用来训练模型。如果偏好使用命令行进行训练可以使用sd-scripts，如果偏好使用GUI进行训练可以使用kohya-ss。

sd-webui用来测试结果。将训练好的safetensors文件放入models/Lora之后刷新可以看到出现新的Lora选项，点击可以在prompt中加入新的提示词。

## 设置参数与训练模型

* Clip Skip:
* Learning Rate:
* Network Dim / Alpha
* Keep N tokens:

```bash
    
```

## 评估模型

使用X/Y/Z Plots功能可以帮助你快速对比不同epoch或者不同强度的提示词设置。

## 参考资料

* <https://civitai.com/articles/3105/essential-to-advanced-guide-to-training-a-lora>
* <https://aituts.com/stable-diffusion-lora/>
* <https://techtactician.com/how-to-train-stable-diffusion-lora-models/>
* 照片写实人物lora训练技巧: <https://civitai.com/articles/3701/sdxl-photorealistic-lora-tips-reflections-on-training-and-releasing-10-different-models>
