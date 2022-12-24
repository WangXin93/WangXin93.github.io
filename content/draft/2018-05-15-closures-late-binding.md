---
categories: Python
date: "2018-05-15T22:21:00Z"
draft: true
title: Late Binding in Python Closures
toc: true
---

## Closures in Python
在一个函数环境中定义的函数，它们的命名空间除了global环境，还有函数定义时候的local环境，例如这里：
```python
def sqrt(a):
    def sqrt_update(x):
        return average(x, a/x)
    def sqrt_close(x):
        return approx_eq(x * x, a)
    return improve(sqrt_update, sqrt_close)
	
result = sqrt(256)
```
变量a所指的是sqrt这个函数的local环境中的a值。由于变量命名空间相对封闭的属性，函数中定义的函数常被成为closure（闭包）。

## Late binding
Python中的closure的问题是，Python希望尽可能迟地绑定变量的值，这是为了性能考虑的。这在大多数情况下工作良好，但是有时候也会导致一些意想不到的问题。比如：
```python
eggs = [lambda a: i * a for i in range(3)]

for egg in eggs:
    print(egg(5))
```
我们期望它的结果为：
```
0
5
10
```
但是，实际情况却不是这样的。由于late binding，变量i在调用的时候才从周围的命名空间中去找i对它进行赋值，而不是它被定义的时候。所以它的实际输入为：
```
10
10
10
```
可以使用[pythontutor](http://pythontutor.com/composingprograms.html#mode=display)工具分步查看函数执行情况。

那么如果避免这种情况？解决的方法是将变量变得local，一个方法是通过partial函数进行currying，强制函数立刻binding：
```python
import functools

eggs = [functools.partial(lambda i, a: i*a, i) for i in range(3)]
for egg in eggs:
    print(egg(5))
```
更好的方法是通过不要引入外部空间（lambda），或者外部变量来避免binding问题。如果i和a都作为lambda的参数，那么这就不是个问题了。
