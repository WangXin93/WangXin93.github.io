---
categories: Python
date: "2018-02-16T11:04:56Z"
draft: true
title: IPython 使用技巧
toc: true
---

![ipython](https://ipython.readthedocs.io/en/stable/_images/ipython-6-screenshot.png)

## 前言

IPython 是一个增强的 Python shell，它可以在终端使用，也可以作为 kernel 在 [jupyter](https://jupyter.org/) 中作为交互核心，使用jupyter notebooks作为前端使用。

2001 年, Fernando Pérez 为了得到一个更为高效的交互式 Python 解释器而启动了一个业余项目, 于是 IPython 项目诞生了。之后，它逐渐被公认为现代科学计算中最重要的 Python 工具之一。IPython 本身并没有提供任何的计算或数据分析功能, 其设计目的是在交互式计算和软件开发这两个方面最大化地提高生产力。它鼓励一种 “执行-探索”(execute explore) 的工作模式, 而不是许多其他编程语言那种“编辑-编译-运行”(edit-complie-run)的传统工作模式。此外, 它跟操作系统shell和文件系统之间也有着非常紧密的集成。由于大部分的数据分析代码都含有探索式操作(试误法和迭代法), 因此 IPython (在绝大多数情况下)将有助于提高你的工作效率。

IPython提供的特色功能包括：

* 完整的对象内省（object introspection）
* 输入历史查询，可以在不同会话之间保留
* 输出结果缓存
* 使用“魔法”命令，可以操作IPython和操作系统
* 内建 pdb Debugger
* 使用tab键可以自动补全
* 语法高亮
* 多行代码编辑
* 多媒体文件展示，支持从对象创建 HTML，Images，Latex，Sound 和 Video 的结果展示
* 可以自定义的配置
* ...

完整的功能列表可以在[官方文档](https://ipython.readthedocs.io/en/stable/)查阅。这篇教程介绍IPython中最常使用的功能，包括对象内省，“魔法”命令，多媒体文件展示，配置系统。

## 对象内省

对象内省（object introspection）的含义是查看一个对象的数据类型，文档字符串等自身信息。在 IPython 中，可以使用``?``符号来查看对象的基本信息，比如docstring，使用``??``来查看对象的更具体的信息，比如source code。

### 变量内省

在 IPython 命名空间中的变量可以通过``?``来查看数据类型，字符串输出格式，内在属性，Docstring等相关信息。例如：

```
In [1]: l = [1, 2, 3]

In [2]: l?
Type:        list
String form: [1, 2, 3]
Length:      3
Docstring:
Built-in mutable sequence.

If no argument is given, the constructor creates a new empty list.
The argument must be an iterable if specified.
```

### 函数内省

对于函数，可以使用``?``符号来查看对象的docstring，使用``??``来查看对象的source code。

```
In [3]: def print_hello(name):
   ...:     """ This function can print hello to you """
   ...:     print("Hello {}".format(name))
   ...:

In [4]: ?print_hello
Signature: print_hello(name)
Docstring: This function can print hello to you
File:      ~/<ipython-input-3-07b68fbd6f33>
Type:      function

In [5]: ??print_hello
Signature: print_hello(name)
Source:
def print_hello(name):
    """ This function can print hello to you """
    print("Hello {}".format(name))
File:      ~/<ipython-input-3-07b68fbd6f33>
Type:      function
```

或者可以使用通配符加上``?``就可以查找匹配的函数方法，例如：

```
In [7]: import datetime

In [8]: datetime.*time*?
datetime.datetime
datetime.datetime_CAPI
datetime.time
datetime.timedelta
datetime.timezone
```

在 Jupyter notebook 中，你可以在输入函数参数括号内按下 ``shift+tab`` 来在一个浮动窗口中触发内省：

```
print_hello(#press shift+tab here
```

## “魔法”命令

IPython 中的 “魔法” 命令可以实现特殊的 IPython 功能或者操作系统功能。魔法命令都是以``%``开头的，比如``%history``，你可以通过``%lsmagic``来列出所有的魔法命令。使用``?``来查看魔法命令的帮助比如``%run?``。下面的内容介绍几个常用的魔法命令。

### 运行脚本

可以使用``%run``命令在 IPython 中运行其它 python 文件，运行完成后 IPython shell 中的命名空间中的变量会被修改。

```
%run script.py
```

### 输出历史

``%history`` 命令可以将输入的命令历史全部打印出来，你可以通过额外的参数来设置打印的格式和范围：

```
hist, %history
Usage:

hist -po # 以>>>作为提示符输出历史并记录输出结果, 方便做笔记
hist -n 3-5 # 打印3-5行
hist -f filename # 打印历史到文件
hist -l 3 # 打印最后三行
```

### 记录运行时间

``timeit`` 魔法命令可以帮助测试命令运行的时间，它是使用 ``timeit`` 模块编写的。它支持 line mode 和 cell mode：

- ``%timeit`` line mode，测试单行命令
- ``%%timeit`` cell mode，测试多行命令。在这个模式下，第一行是 setup code（会被执行但是不计算时间），第二行至最后的代码会被计时。

line mode的使用方法例如：

```
import time
def sleeper(t):
    time.sleep(t)
%timeit sleeper(0.002)
```

### 载入一个文件到cell

当有一个已经编写好的 Python 文件时，与其手动复制粘贴到 shell，还可以使用``%load``命令：

```
%load file_path
```

这里的`file_path`可以是本地路径也可以是URL，例如这里载入一个网络上的matplotlib的例子：

```
%load http://matplotlib.org/mpl.examples/pylab_examples/contour_demo.py
```

### 创建一个新文件并写入内容

你可以通过``%%writefile``命令将 IPython cell中的内容写入到另一个文件：

```
%%writefile example.txt
first line
second line
third line
fourth line
```

### 每次运行代码前自动reload模块

如果在shell中使用 ``import`` 命令导入完一个module之后，如果对module本身的文件进行修改，这是需要重新导入模块，这样重复修改和执行程序会麻烦。你可以使用下面的魔法命令来[自动重新导入](
https://ipython.org/ipython-doc/3/config/extensions/autoreload.html)模块，避免了每次修改之后的手动导入：

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

### Debug 程序

当一个bug发生后，可以在新的cell里输入`%debug`来进入到pdb中并检查问题。

或者，提前输入`%pdb`来打开debug模式，当错误发生时候自动进入到pdb中。

如果要从一个程序开始的时候就进行debug调试，可以执行`%run -d theprogram.py`。

## 多媒体展示：使用IPython的display系统

使用IPython的display可以方便地浏览服务器上不同类型的文件

### Display 音频文件

```python
import IPython
IPython.display.Audio('./data/someaudoi.mp3')
```

### Display公式

浏览器中的公式会用[MathJax library](http://mathjax.org/)渲染。

```python
from IPython.display import display, Math, Latex
display(Math(r'\hat{y}(\mathbf{x}) = w_0 + \sum_{j=1}^{p}w_jx_j + \frac{1}{2} \sum_{f=1}^{k} ((\sum_{j=1}^{p}v_{j,f}x_j)^2-\sum_{j=1}^{p}v_{j,f}^2 x_j^2)'))
```

```python
from IPython.display import Latex
Latex(r"""\begin{eqnarray}
\nabla \times \vec{\mathbf{B}} -\, \frac1c\, \frac{\partial\vec{\mathbf{E}}}{\partial t} & = \frac{4\pi}{c}\vec{\mathbf{j}} \\
\nabla \cdot \vec{\mathbf{E}} & = 4 \pi \rho \\
\nabla \times \vec{\mathbf{E}}\, +\, \frac1c\, \frac{\partial\vec{\mathbf{B}}}{\partial t} & = \vec{\mathbf{0}} \\
\nabla \cdot \vec{\mathbf{B}} & = 0 
\end{eqnarray}""")
```

或者可以使用sympy进行符号运算的公式展示：

```python
from sympy import init_printing; init_printing()
import sympy as sym
from sympy import *
x, y, z = symbols("x y z")
k, m, n = symbols("k m n", integer=True)
f, g, h = map(Function, 'fgh')
Rational(3,2)*pi + exp(I*x) / (x**2 + y)
```

```python
a = 1/x + (x*sin(x) - 1)/x
a
```

```python
(1/cos(x)).series(x, 0, 6)
```

### Display图片

可以直接 display 本地图片：

```python
IPython.display.Image("images/jazz.jpg")
```

或者从url寻找网络图片，你可以先把Image赋值，再用display函数展示它：

```python
from IPython.display import Image
i = Image(url='https://www.python.org/static/img/python-logo.png', embed=True)
display(i)
```

这里的 embed 意味着将图片嵌入到Notebook file，这样就不用每次重新run这个cell。

### Display 视频

```python
from IPython.display import YouTubeVideo
YouTubeVideo('sjfsUzECqK0')
```

### Display HTML 网页

```python
s = """<table>
<tr>
<th>Header 1</th>
<th>Header 2</th>
</tr>
<tr>
<td>row 1, cell 1</td>
<td>row 1, cell 2</td>
</tr>
<tr>
<td>row 2, cell 1</td>
<td>row 2, cell 2</td>
</tr>
</table>"""
IPython.display.HTML(s)
```

或者这样展示一个外部站点：
```python
IPython.display.HTML('<iframe src=http://wangxin93.github.io width=700 height=350></iframe>')
```

除此之外，IPython notebook还可以display Javascript，SVG，PDF等等。用它写一个技术说明书一定很酷！

## 配置 IPython

IPython支持[自定义配置](https://ipython.readthedocs.io/en/stable/config/intro.html)来满足使用的需要。如果需要进行配置，需要首先使用下面的命令创建配置文件：

```
ipython profile create
```

之后在创建的配置文件中可以进行修改，例如：

```
# 配置命令别名
c.AliasManager.user_aliases = [
    ('ll', 'ls -al')
]

# 列出启动时需要自动执行的代码行
c.InteractiveShellApp.exec_lines = [
    'import os',
    'import sys',
    'from pprint import pprint',
]

# 列出启动时需要自动执行的文件
c.InteractiveShellApp.exec_files = []
```

在 IPython 启动后修改配置可以进行类似于如下的操作：

```
from IPython.core.interactiveshell import InteractiveShell
InteractiveShell.ast_node_interactivity = "all"
```

## 参考资料
* [Introducting IPython](http://ipython.readthedocs.io/en/stable/interactive/tutorial.html)
* [IPython's Rich Display System](http://jeffskinnerbox.me/notebooks/ipython's-rich-display-system.html)
* [IPython 基本使用](https://blog.konghy.cn/2017/11/22/ipython-usage/)