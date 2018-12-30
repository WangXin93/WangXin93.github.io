---
layout: post
title:  "Python Parse Args"
date: 2018-09-12 18:00:00 +0800
categories: Python
toc: true
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

## 使用docopt

每次写代码解析命令行参数, 之后还要为它写文档，太繁琐了！还有简洁的方法吗？

`docopt`模块，通过解析代码的`docstring`的内容，来得到命令行的参数要求。所以，当你书写完一个doc的时候，`docopt`也就帮你的程序设置好了参数要求。没有了重复工作，天才一般的主意！

让我们从一个简单的例子开始, 创建一个文件`ex.py`，其中内容如下：

```python
#!/usr/bin/env python                                                           
    
"""A example for docopt    
    
Usage:    
    foo tcp <host> <port> [--timeout=<seconds>]    
    foo serial <port> [--baud=9600] [--timeout=<seconds>]    
    foo (-h | --help | --version)    
"""    
from docopt import docopt    
print(docopt(__doc__, version='1.0.0rc2'))    
```

在命令行中哦你输入`python ex.py tcp localhost 80`，你可以看到`docopt`函数返回一个字典，其中包含着解析好的命令行参数。


如果希望给参数加上解释或者默认值，可以额外添加一段`options`：

```python
Naval Fate.

Usage:
  naval_fate ship new <name>...
  naval_fate ship <name> move <x> <y> [--speed=<kn>]
  naval_fate ship shoot <x> <y>
  naval_fate mine (set|remove) <x> <y> [--moored|--drifting]
  naval_fate -h | --help
  naval_fate --version

Options:
  -h --help     Show this screen.
  --version     Show version.
  --speed=<kn>  Speed in knots [default: 10].
  --moored      Moored (anchored) mine.
  --drifting    Drifting mine.
```

## 参考

* [argparse文档](https://docs.python.org/3/library/argparse.html)
* [Docopt Homepage](http://docopt.org/): 可以同时学习docopt的语法和posix命令行参数规范
* [PyCon UK 2012: Create *beautiful* command-line interfaces with Python](https://www.youtube.com/watch?v=pXhcPJK5cMc&feature=youtu.be)
