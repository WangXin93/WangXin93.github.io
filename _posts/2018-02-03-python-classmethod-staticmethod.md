---
layout: post
title:  Python classmethod and staticmethod
date:   2018-02-03 21:14:23 +0800
categories: Python
toc: true
---

## 前言
Python中每次调用类的方法都会把实例化后的对象作为第一个参数传入进去，即常见的`self`参数。那有没有办法在不实例化的情况下调用类的方法呢？有的。

`classmethod`和`staticmethod`这两个装饰器都可以使得类中的方法在不经过类实例化的情况下可以执行。不同的是`classmethod`输入的第一个参数是`class`对象本身，而不是一般的方法情况下的类型实例。即第一个参数为`class`而不是`instance`。而`staticmethod`使得一个方法无论是利用类来调用它，还是实例化后调用它。都没有这个第一个默认的输入参数。这使得`staticmethod`的使用起来非常像一个不在类定义中的普通函数。

## 下面来看一个不是非常恰当的例子：
```python
class Foo(object):
    def print_instance(self):
        print("Instance: %s" % self)
    
    @classmethod
    def print_class(cls):
        print("Class: %s" % cls)

    @staticmethod
    def print_args(*args):
        print("Args: %s" % args)

    def print_no_self():
        print("I don't have self input.")
```
这里的四个方法中`print_instance()`是一般方法，`print_class`是`classmethod`装饰的方法，`print_args`是`staticmethod`装饰的方法。

通过`classmethod`装饰后的方法就可以不经过实例化直接调用，就像这样：
```python
In [40]: Foo.print_class()
Class: <class '__main__.Foo'>  
```
