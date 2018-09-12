---
layout: post
title:  "Python Parse Args"
date: 2018-09-12 18:00:00 +0800
categories: Python
---

## 前言

合理地给Python脚本程序设计一个运行参数可以很大地提高工作效率。

## 使用sys

最简单地方法是使用sys模块来读取命令行参数。

```python
# foo.py
import sys
args = sys.argv[1:]
print(args)
```

## 使用argparse

如果需要更多地功能比如可选参数，一个参数多个值，参数帮助，那么argparse模块可以帮助你。

这里有一个简单地版本：

```python
# foo.py
parser = argparse.ArgumentParser(description="Polyvore MSE")
parser.add_argument('--model', type=str, default='gru')  
parser.add_argument('--epochs', type=int, default=20)    
parser.add_argument('--comment', type=str, default='')   
args = parser.parse_args()  
```

将上面内容保存为``foo.py``然后执行``python foo.py -h``就可以看见参数说明啦！

## 参考

* [argparse文档](https://docs.python.org/3/library/argparse.html)