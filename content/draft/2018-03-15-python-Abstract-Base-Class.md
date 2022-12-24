---
categories: Python
date: "2018-03-15T10:42:00Z"
draft: true
title: Python Abstract Base Class，Python中的抽象基类
toc: true
---

## 前言
抽象基类（Abstract Base Class or ABC）是python的metaclass应用中最使用和广泛使用的例子，它的作用是保证了class遵循一个固定的接口规则而不需要人工反复检查。下面来看看如何使用python中的抽象基类ABC。

---

```python
>>> import abc
>>> class Spam(metaclass=abc.ABCMeta):
...     @abc.abstractmethod
...     def some_method(self):
...         raise NotImplemented()
...
>>> class Eggs(Spam):
...     def some_new_method(self):
...         pass
...
>>> eggs = Eggs()
---------------------------------------------------------------------------
TypeError                                 Traceback (most recent call last)
<ipython-input-4-2f49c09d2b81> in <module>()
----> 1 eggs = Eggs()

TypeError: Can't instantiate abstract class Eggs with abstract methods some_method

>>> class Bacon(Spam):
...     def some_method():
...         pass
...
>>> bacon = Bacon()
```
观察上面代码，如果class不能满足所有的抽象方法都被继承或者说重写，抽象基类就会阻止class的实例化。除了一般的方法，python中的`property`，`staticmethod`，`classmethod`都支持作为抽象方法，即被装饰器`@abc.abstractmethod`所修饰。

要注意的是从python3.3过后，`abstractproperty`，`abstractclassmethod`，`abstractstaticmethod`都被遗弃了，因为`propery`，`classmethod`，`staticmethod`都可以被`abstractmethod`认识，所以只要先用`property`装饰器，再使用`abstractmethod`就能被认为是一个`abstractproperty`装饰器了。要小心`abstractmethod`放在最里面装饰。
```python
>>> class Spam(object, metaclass=abc.ABCMeta):
...     @property
...     @abc.abstractmethod
...     def some_property(self):
...         raise NotImplemented()
...
...     @classmethod
...     @abc.abstractmethod
...     def some_classmethod(cls):
...         raise NotImplemented()
...
...     @staticmethod
...     @abc.abstractmethod
...     def some_staticmethod():
...         raise NotImplemented()
...
...     @abc.abstractmethod
...     def some_method():
...         raise NotImplemented()
```
python内部如何实现这样的功能的？可以通过阅读源码`abc.py`，这里也有一个简单的解释：

首先，abc.abstractmethod给function设置了属性`__isabstractmethod__`为True，所以如果你不想要这个装饰器，只要对应这行作修改就好了：
```python
some_method.__isabstractmethod__ = True
```
然后，元类abc.ABCMeta浏览所有`__isabstractmethod__`为True的条目。此外，它还检查每个基类的`__isabstractmethod__`集合以防这个类是从abstract类继承而来的。所有条目中`__isabstractmethod__`仍然为True的将会被添加到储存在class的frozenset中形成一个`__abstractmethods__`集合。

如何检查`class`是否完全实现不包含abstractmethod，这个其实是python内部的功能。我们可以简单地模拟`metaclass`的表现行为，但是要注意的是`abc.ABCMeta`实际上包含的功能更多。
```python
>>> class AbstractMeta(type):
...     def __new__(metaclass, name, bases, namespace):
...         cls = super().__new__(metaclass, name, bases, namespace)
...         cls.__abstractmethods__ = frozenset(('something',))
...         return cls

>>> class Spam(metaclass=AbstractMeta):
... 	pass

>>> eggs = Spam()
---------------------------------------------------------------------------
TypeError                                 Traceback (most recent call last)
<ipython-input-24-c7d64fafb2e2> in <module>()
----> 1 eggs = Spam()

TypeError: Can't instantiate abstract class Spam with abstract methods somethingclas
```
---

## 参考链接
- Mastering Python - Rick can Hattem
