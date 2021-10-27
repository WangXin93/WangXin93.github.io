---
layout: post
title:  "Python 新版本功能介绍（持续更新）"
date:   2021-10-26 17:19:00 +0800
categories: Python
toc: true
---

> 本博客持续收集 Python 新版本中值得注意的功能。包括 Python3.8 开始的海豹运算符，Python3.10 的match语句等。

<div align="center">
<img src="/assets/2021-10-27-python-new-features-update/python-update.svg" style="width:80%"/>
</div>

## Python3.8

### 海豹运算符（Python Assignment Expression）

海豹运算符``:=``是 python3.8 引入的最大的改变。海豹运算符的功能是在evalute experssion的时候能够完成assignment。因为这个符号长得很像[海豹](https://en.wikipedia.org/wiki/Walrus)的眼睛和牙齿，因此被称为海豹运算符，官方称这个运算符为 assignment expression operator。

> 在Python中，一串代码被称为 statement，而 expression 是特殊的 statement，它可以被 evaluate 为一个值。例如 ``a = 1+2``是一句 statement，它将数值3赋值给变量``a``，其它的 statment 比如 return statement 和 import statement；而``1+2``是一句 expression，它可以被评估为数值3，在 REPL 中运行的时候会打印出3。

为了快速理解海豹运算符的语法，可以打开REPL输入下面的代码：

```python
>>> walrus = 3
>>> walrus
3

>>> (walrus := 3)
3
>>> walrus
3

>>> walrus := 3
  File "<stdin>", line 1
    walrus := 3
           ^^
SyntaxError: invalid syntax
```

在第一个语句中，代码使用了传统的赋值语句将数值3赋值给了变量walrus；在第二段的代码中，数值3不仅赋值给了变量而且语句会返回3；第二段的代码中报出了语法错误，因为使用海豹运算符的语句需要使用括号包裹起来才能运行。（在if语句中括号可以省略）

海豹运算符没有为python提供额外的功能，所有原来代码能够实现的功能现在也能够实现，但是海豹运算符提供了一些情况下代码结构上的便利，并且方便了和代码的交互。下面介绍一些海豹运算符的使用案例。

首先是用于Debugging。假设你正在计算一个公式，比如计算一个圆的面积，其中圆的半径是从另外一个公式计算而来。如果希望检查公式中计算半径的过程是否出错，你可以重组代码，将半径计算部分复制粘贴出来，或者你可以使用海豹计算符给中间的表达式一个命名。这样就能在保持原有的计算过程，不破坏代码的同时得到中间公式的值，避免了重组代码可能产生的bug。

```python
>>> import math
>>> total = 100
>>> area = math.pi * (width := total / 10) ** 2
>>> width
10.0
>>> area
314.1592653589793
```

另一个使用情况是在list或者dict的构建中，一些重复执行的代码会被重复执行，可以使用海豹运算符对其进行修改优化。比如下面的例子实现了一个简单的[wc](https://en.wikipedia.org/wiki/Wc_%28Unix%29)程序功能，但是可以发现其中``path.read_text()``被执行了多次，因此文件内容被读取了多次。

```python
# wc.py

import pathlib
import sys

for filename in sys.argv[1:]:
    path = pathlib.Path(filename)
    text = path.read_text()
    counts = [
        text.count("\n"),  # Number of lines
        len(text.split()),  # Number of words
        len(text),  # Number of characters
    ]
    print(*counts, path)
```

进行如下的修改，可以在读取完文件内容后将其保存在``text``变量，在列表的后面的元素中也可以重复使用：

```python
# wc.py

import pathlib
import sys

for filename in sys.argv[1:]:
    path = pathlib.Path(filename)
    counts = [
        (text := path.read_text()).count("\n"),  # Number of lines
        len(text.split()),  # Number of words
        len(text),  # Number of characters
    ]
    print(*counts, path)
```

List comprehension是python代码的一个特色，你可以简洁清晰地写出想要的功能，而且使用list comprehension会运算更快。但是在有些情况下使用list comprehension会引入不必要的计算。例如下面的例子中，代码希望实现寻找找到大于5的数字然后加倍，但是这样的语法让``double``函数对每个满足条件的数字执行了2次，这时不必要的开销。

```python
numbers = [6, 3, 2, 4, 1, 7, 0, 6]

results = [double(num) for num in numbers if double(num) > 5]
```

这时你可以使用海豹运算符，将``double``计算得到的结果保存到变量，只有满足大于5的条件的值会被保留。这当然可以用多行代码来实现同样的效果，但是海豹运算符在这里保留了list comprehension的简洁性。

```python
results = [value for num in numbers if (value := double(num)) > 5]
```

在 while 循环中，你需要在 while 关键词后面检查循环的中止条件，如果要检查的变量需要提前进行设置，就会导致语法上非常奇怪，例如下面询问用户输入的代码例子。这里两句包含``input``函数的代码是同样的作用，第一个``input``的作用是在循环初始的时候询问用户的输入，在循环体中的``input``也是必要的，因为需要在用户输入不合理的时候持续询问用户输入。但是这样就让循环体变复杂的时候代码难于维护。

```python
question = "Will you use the walrus operator?"
valid_answers = {"yes", "Yes", "y", "Y", "no", "No", "n", "N"}

user_answer = input(f"\n{question} ")
while user_answer not in valid_answers:
    print(f"Please answer one of {', '.join(valid_answers)}")
    user_answer = input(f"\n{question} ")
```

如果希望代码更易于阅读管理，这样的循环结构通常为改为下面的方式，使用``break``来设置退出循环的条件。

```python
while True:
    user_answer = input(f"\n{question} ")
    if user_answer in valid_answers:
        break
    print(f"Please answer one of {', '.join(valid_answers)}")
```

不过使用海豹计算符可以在这里做地更好，下面的代码更加紧凑，而且没有重复的语句。

```python
while (user_answer := input(f"\n{question} ")) not in valid_answers:
    print(f"Please answer one of {', '.join(valid_answers)}")
```

这里再介绍一个使用案例witnesses和counterexamples。当使用python中的``any()``函数检查一系列元素的时候，如果有元素检查结果为True，这个元素被称为witness；当使用``all()``函数检查一系列元素的时候，如果有元素检查结果为False，这个元素被称为counterexample。但是``any()``和``all()``函数只会返回是否有元素为witness和counterexample。例如找寻列表中是否有偶数：

```python
>>> lst = [1, 3, 4, 7, 8]
>>> any(num % 2 == 0 for num in lst)
True
```

如果希望检车这个偶数值具体为多少，就需要添加更多行的代码。但是海豹计算符可以用很小的改动满足这个需求：

```python
>>> lst = [1, 3, 4, 7, 8]
>>> any((witness := num) % 2 == 0 for num in lst)
True
>>> witness
4
```

这里witness变量就捕捉到了第一个偶数，需要注意的是``any()``函数在捕捉到第一个偶数的时候就会退出函数过程。

海豹计算符可以在python代码中带来一些语法上的方便，这些功能使用原来版本的代码也能够实现同样的功能。在保证代码可读性和可维护性的前提下，可以尝试海豹计算符对代码的改善。

## Python3.9

## Python3.10

## 参考

1. <https://realpython.com/python-walrus-operator>
2. <https://realpython.com/python39-new-features>
3. <https://realpython.com/python310-new-features>