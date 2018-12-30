---
layout: post
title:  "IPython 使用技巧"
date:   2018-02-16 11:04:56 +0800
categories: Python
toc: true
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

## 使用IPython的display系统

使用IPython的display可以方便地浏览服务器上不同类型的文件

* Display音频文件
```python
import IPython
IPython.display.Audio('./data/someaudoi.mp3')
```

* Display公式

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

* Display图片

可以直接display本地图片：

```python
IPython.display.Image("images/jazz.jpg")
```

或者从url寻找网络图片，你可以先把Image赋值，再用display函数展示它：

```python
from IPython.display import Image
i = Image(url='https://www.python.org/static/img/python-logo.png', embed=True)
display(i)
```

这里的embed意味着将图片嵌入到Notebook file，这样就不用每次重新run这个cell。

IPython display 还可以做到更多！

* Display video

```python
from IPython.display import YouTubeVideo
YouTubeVideo('sjfsUzECqK0')
```

* Display HTML

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
IPython.display.HTML('<iframe src=http://wangxin93.top width=700 height=350></iframe>')
```

除此之外，IPython notebook还可以display Javascript，SVG，PDF等等。用它写一个技术说明书一定很酷！

## 参考资料
* [Introducting IPython](http://ipython.readthedocs.io/en/stable/interactive/tutorial.html)
* [IPython's Rich Display System](http://jeffskinnerbox.me/notebooks/ipython's-rich-display-system.html)