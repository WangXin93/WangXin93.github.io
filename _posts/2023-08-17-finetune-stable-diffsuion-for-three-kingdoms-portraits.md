---
layout: post
title: "如何微调stable diffusion来生成三国志人物肖像"
date: 2023-08-17 11:13
categories: MachineLearning ComputerVision
toc: true
---

> 通过在指定数据集上微调 stable diffusion 模型可以用diffusion模型生成和数据集相关的图像。这篇博客介绍如何微调 stable diffusion 模型来生成三国志人物肖像。

![result](/assets/2023-08-17-finetune-stable-diffsuion-for-three-kingdoms-portraits/samples_gs-000000_e-000000_b-000001.png)

这篇博客介绍如何微调 stable diffusion 模型来生成三国志人物肖像。微调的代码使用 [Justin Pinkney](https://lambdalabs.com/blog/how-to-fine-tune-stable-diffusion-how-we-made-the-text-to-pokemon-model-at-lambda) 微调 stable diffusion 模型生成 pokemon 的代码，但是这篇博客会介绍如何创建并上传三国志人物肖像数据集，同时使用的训练平台是 [featurize](https://featurize.cn?s=a0551539ffa14f948b962309548818d2)，而不是 Lambda GPU Cloud。

## 硬件

Justin Pinkney 的代码在微调 stable diffusion 模型时候需要大于 24GB 的显存。featurize 提供了 a6000 的显卡，价格是5.8元一小时，首次充值50元会送10+2元代金券. 我在训练的时候使用了1张 a6000，三国志的数据集每200步需要5分钟，我一共训练了 12000 步，再加上调试环境的时间，大约花了40元。

如果你想使用featurize复现这个实验，或者微调到其它数据集，可以通过这个[链接](https://featurize.cn?s=a0551539ffa14f948b962309548818d2)注册，如果充值50元博主会获得10元训练时间的奖励。

![a6000](/assets/2023-08-17-finetune-stable-diffsuion-for-three-kingdoms-portraits/a6000.png)

后记：根据[这里](https://github.com/justinpinkney/stable-diffusion/issues/15#issuecomment-1257317868)和[这里](https://github.com/LambdaLabsML/examples/issues/12)所述，可以使用24GB显存的显卡finetune模型，所以可以使用3090和4090进行训练，不过结果如何我还没实验过。

## 数据集

如果你想使用三国志的数据集，可以直接使用我上传到 huggingface datasets 的数据集，使用下面的代码可以查看数据集的样例：

```python
from datasets import load_dataset
ds = load_dataset("wx44wx/three-kingdoms-blip-captions", split="train")
sample = ds[0]
display(sample["image"].resize((256, 256)))
print(sample["text"])
```

如果希望自己创建数据集，下面是我的过程作为参考。

1. 我从 https://kongming.net/11/portraits/ 这个网站下载了三国志人物的肖像，每张图片的大小是 256x256，一共883张图片。
2. 使用了预训练的 [BLIP](https://github.com/salesforce/BLIP) 模型生成了每张图片的描述，将这些文字描述制作为一个`metadata.csv`和图片文件放在同一个目录。

    图片和`metadata.csv`的文件目录按照下面的位置存放：

    ```
    ./data_lg
    ├── Created-Male-001.jpg
    ├── Created-Male-002.jpg
    ...
    ├── Created-Male-096.jpg
    ├── Created-Male-097.jpg
    ├── Created-Male-098.jpg
    ├── Created-Male-099.jpg
    ├── Created-Male-100.jpg
    └── metadata.csv
    ```

3. 然后将图片和描述一起上传到了 huggingface datasets。

    上传数据集可以通过下面的代码完成：

    ```python
    from huggingface_hub import login
    login()

    from datasets import load_dataset

    dataset = load_dataset("imagefolder", data_dir="./data_lg")

    dataset.push_to_hub("you-account-name/three-kingdoms-blip-captions")
    ```

## 训练过程

0. 申请实例
    
    在featurize平台搜索a6000，选择一个实例，选择一个镜像，之后按照说明从jupyterlab或者vscode连接到实例。

1. 安装环境

    ```bash
    git clone https://github.com/justinpinkney/stable-diffusion.git
    cd stable-diffusion
    pip install --upgrade pip
    pip install -r requirements.txt
    ```

2. 修改配置文件

    复制项目中的`configs/stable-diffusion/pokemon.yaml`到`configs/stable-diffusion/three-kingdoms.yaml`，在其中中修改数据集部分的配置：

    ```yaml
    data:
      target: main.DataModuleFromConfig
      params:
        batch_size: 4
        num_workers: 4
        num_val_workers: 0 # Avoid a weird val dataloader issue
        train:
          target: ldm.data.simple.hf_dataset
          params:
            name: wx44wx/three-kingdoms-blip-captions
            image_transforms:
            - target: torchvision.transforms.Resize
              params:
                size: 512
                interpolation: 3
            - target: torchvision.transforms.RandomCrop
              params:
                size: 512
            - target: torchvision.transforms.RandomHorizontalFlip
        validation:
          target: ldm.data.simple.TextOnly
          params:
            captions:
            - "a man with a beard and mustache"
            - "a man in armor"
            - "a woman in a red dress"
            - "a man with a crown on his head"
            output_size: 512
            n_gpus: 2 # small hack to sure we see all our samples
    ```
3. 下载模型

    运行下面的代码下载，之后放到stable-diffusion的目录下

    ```python
    from huggingface_hub import hf_hub_download
    ckpt_path = hf_hub_download(repo_id="CompVis/stable-diffusion-v-1-4-original", filename="sd-v1-4-full-ema.ckpt")
    ```

4. 开始训练

    ```bash
    # 1xA6000
    python main.py \
        -t \
        --base configs/stable-diffusion/three-kingdoms.yaml \
        --gpus 0, \
        --scale_lr False \
        --num_nodes 1 \
        --check_val_every_n_epoch 10 \
        --finetune_from sd-v1-4-full-ema.ckpt \
        data.params.batch_size=4 \
        lightning.trainer.accumulate_grad_batches=2 \
        data.params.validation.params.n_gpus=1 \
    ```

## 生成的结果

运行下面的代码来使用训练后的模型生成图片：

```bash
python scripts/txt2img.py \
  --prompt 'a man in armor' \
  --outdir 'outputs/generated_sanguozhi_portraits' \
  --H 512 --W 512 \
  --n_samples 4 \
  --config 'configs/stable-diffusion/three-kingdoms.yaml' \
  --ckpt 'logs/path/to/your/checkpoint'
```

运行后会在 `outputs/generated_sanguozhi_portraits` 目录下得到同一个提示词的4个不同的图像，如下图所示：

> a man in armor
![a-man-in-armor](/assets/2023-08-17-finetune-stable-diffsuion-for-three-kingdoms-portraits/a-man-in-armor.png)

> a man with a beard and mustache
![a-man-with-a-beard-and-mustache](/assets/2023-08-17-finetune-stable-diffsuion-for-three-kingdoms-portraits/a-man-with-a-beard-and-mustache.png)

> a women in red dress
![a-women-in-red-dress](/assets/2023-08-17-finetune-stable-diffsuion-for-three-kingdoms-portraits/a-women-in-red-dress.png)

> a women in armor
![a-women-in-armor](/assets/2023-08-17-finetune-stable-diffsuion-for-three-kingdoms-portraits/a-women-in-armor.png)

> a man with red dress
![a-man-with-red-dress](/assets/2023-08-17-finetune-stable-diffsuion-for-three-kingdoms-portraits/a-man-in-red-dress.png)

## 上传模型

如果希望将模型上传到huggingface网站，首先需要将stable diffusion模型转换成diffusers可以读取的格式，可以使用项目中的脚本转换：

```bash
python scripts/convert_sd_to_diffusers.py \
  --checkpoint_path logs/checkpoint-path.ckpt \
  --original_config configs/stable-diffusion/three-kingdoms.yaml \
  --dump_path ./dump \
  --use_ema
```

可以通过浏览器将文件拖拽到huggingface网站上。

## 结语

本文介绍了如何微调 stable diffusion 模型来生成三国志人物肖像，包括了从数据集创建上传到如何在featurize平台训练。您可以直接使用我训练好的数据集和模型，当然也可以构建其它数据集来微调模型满足您的需求。

- [原模型权重](https://huggingface.co/wx44wx/three-kingdoms-stable-diffusion)
- [diffusers模型权重](https://huggingface.co/wx44wx/sd-three-kingdoms-diffusers)
- colab的[链接](https://colab.research.google.com/drive/1Wu_V-beDvLltrP4t6QURbb_8UDYYcUSC)

如果这篇博客对你有帮助，欢迎点赞和转发，也可以通过在使用featurize平台的时候通过[这里](https://featurize.cn?s=a0551539ffa14f948b962309548818d2)注册充值，博主会获得一点点训练时间的奖励。
