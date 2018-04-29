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

## 载入一个文件到cell
```
%load file_path
```
这里的`file_path`可以是本地路径也可以是URL，例如这里载入一个网络上的matplotlib的例子：
```
%load http://matplotlib.org/mpl.examples/pylab_examples/contour_demo.py
```


## 创建一个新文件并写入内容
```
%%writefile example.txt
first line
second line
third line
fourth line
```

## [每次运行代码前自动reload模块](https://ipython.org/ipython-doc/3/config/extensions/autoreload.html)
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

## 查看函数docstring和source
```
object? 显示对象的细节，如docstring
object?? 显示更多细节，比如source
```

## Debug
当一个bug发生后，可以在新的cell里输入`%debgu`来进入到pdb中并检查问题。或者，提前输入`%pdb`来打开debug模式，当错误发生时候自动进入到pdb中。

如果要从一个程序开始的时候就进行debug调试，可以执行`%run -d theprogram.py`。

## 参考资料
* [Introducting IPython](http://ipython.readthedocs.io/en/stable/interactive/tutorial.html)I
