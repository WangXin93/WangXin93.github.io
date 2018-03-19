---
layout: post
title:  "IPython 使用技巧"
date:   2018-02-16 11:04:56 +0800
categories: Python
---

## 前言
IPython的使用技巧

## 输出历史
```
hist, %history
Usage:

hist -po # 以>>>作为提示符输出历史并记录输出结果, 方便做笔记
hist -n 3-5 # 打印3-5行
hist -f filename # 打印历史到文件
hist -l 3 # 打印最后三行
```
## 记录运行时间
- %timeit line mode
- %%timeit cell mode

```
import time
def sleeper(t):
    time.sleep(t)
%timeit sleeper(0.002)
```

## 创建一个新文件并写入内容
```
%%writefile example.txt
first line
second line
third line
fourth line
```

## 每次运行代码前自动reload模块(https://ipython.org/ipython-doc/3/config/extensions/autoreload.html)
```python
In [1]: %load_ext autoreload

In [2]: %autoreload 2

In [3]: from foo import some_function

In [4]: some_function()
Out[4]: 42

In [5]: # open foo.py in an editor and change some_function to return 43

In [6]: some_function()
Out[6]: 43
```
