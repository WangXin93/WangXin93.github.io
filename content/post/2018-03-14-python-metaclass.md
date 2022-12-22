---
categories: Python
date: "2018-03-14T12:40:00Z"
title: 理解Python metaclass
toc: true
---

## 前言
定义`class`是为`instance`编程，而定义`metaclass`是为`class`编程。

---

## type(object)的结果是什么？
值得注意的是，在Python中，[所有东西都是`object`](https://stackoverflow.com/questions/576169/understanding-python-super-with-init-methods)， 使用`type(something)`可以查看该对象的类。比如：
```python
>>> print(type(1))
<class 'int'>
>>> print(type('abc'))
<class 'str'>
```
一个整数就是一个`int`类，一个字符串就是一个`str`类。既然一切东西都是类，那它们都包含属性，方法，是从其它对象继承而来的，也可以被继承。举一个简单的例子：
```python
>>> class MyStr(str):
...     def __add__(self, other):
...         print("MyStr is adding...")
...         return super().__add__(other)
...
>>> MyStr('abc') = 'd'
>>> MyStr('abc') + 'd'
'abcd'
```
这里通过继承`str`实现了新的类MyStr，并且重写了`MyStr`加法计算的方法。可以使用`type`来观察这些变量的类型：
```python
>>> mystr = MyStr('abc')
>>> print(type(mystr))
<class '__main__.MyStr'>
>>> print(type(MyStr))
<class 'type'>
>>> print(type(str))
<class 'type'>
>>> print(type(type))
<class 'type'>
```
通过上面的代码可以发现，实例化的对象`mystr`的type是`MyStr`，而类本身呢？未经过实例化的`class`本身呢？它的`type`是`type`!总结来说，**实例化的对象的type是`class`，而`class`本身的type是`type`。`type`本身的type还是`type`。**一切都是从`type`开始衍生而来。python的这种表现是在python语言底层实现的时候构建的。

---

## 使用type动态创建类
`type`的另一个作用是动态创建类。下面的两段代码的作用是一样的：
```python
class Foo(object):
	spam = 1
	
class Bar(Foo):
	def get_spam(self):
		return self.spam
		
bar = Bar()
print(bar.get_spam())
```
```python
Foo = type('Foo', (), dict(spam=1))
bar = type('Bar', (Foo,), dict(get_spam=lambda self: self.spam))
bar = Bar()
print(bar.get_spam())
```
type这里作为一个生产`class`的工厂，它的作用就像下面的`class_factory`，能够产出或者说返回`class`:
```python
def class_factory():
	class Foo(object):
		pass
	return Foo
Foo = class_factory()
foo = Foo()
print(type(foo))
```
**这里的`class_facotry`可以称为`metafunction`。它能够产出的是`class`，而不是实例！与它作用相同的`type`，同样产出`class`，所以可以叫做`metaclass`。**所以，所谓的元编程，可以理解为对产出`class`的类或者函数编程。这些类也就叫做元类，元函数啦。
需要注意的是：type只有再输入三个参数的时候产出`class`,当输入一个参数的时候`type`的作用是返回参数的type。三个参数定义为：
- `name`: `string`类型，表示将要构建的类的名字
- `bases`: `tuple`类型，表示构建的类要从哪些类继承
- `dct`: `dict`类型，表示构建的类包含那些特征和方法

---

## 创建自己的metaclass，从改造type开始
通过从`type`继承并扩展，就可以自定义`metaclass`的行为。 先看一个简单的例子：
```python
class MyInt(type):
    def __call__(cls, *args, **kwargs):
        print("***** Here's My int *****", args)
        print("Now do whatever you want with these objects...")
        return type.__call__(cls, *args, **kwargs)
		
class int(metaclass=MyInt):
	def __init__(self, x, y):
		self.x = x
		self.y = y
		
i = int(4, 5)
# ***** Here's My int ***** (4, 5)
# Now do whatever you want with these objects...
```
对于已经存在的类来说，当需要创建对象时，将调用python的特殊方法`__call__`，这段代码中，当我们使用`int(4, 5)`来实例化`int`类的时候，`MyInt`元类的`__call__`方法将被调用，这意味着现在元类控制着对象的实例化。

再来看一个例子，该例子可以创建一个API，用户可以在它之中创建一个文件对象的接口，并且创建一个string ID。首先需要创建`metaclass`接口，从`type`中继承：
```python
class InterfaceMeta(type):
    def __new__(cls, name, parents, dct):
        # create a class_id if it's not specified
        if 'class_id' not in dct:
            dct['class_id'] = name.lower()
        
        # open the specified file for writing
        if 'file' in dct:
            filename = dct['file']
            dct['file'] = open(filename, 'w')
        
        # we need to call type.__new__ to complete the initialization
        return super(InterfaceMeta, cls).__new__(cls, name, parents, dct)
```
它会为`class`添加一个`class_id`，并将输入参数中的字符串替换为文件对象。然后，要使用这个`InterfaceMete`元类来创建`Interface`类：
```python
Interface = InterfaceMeta('Interface', (), dict(file='tmp.txt'))

print(Interface.class_id)
print(Interface.file)
# interface
# <open file 'tmp.txt', mode 'w' at 0x21b8810>
```
上面的代码和下面的代码等效，只不过又换回了原来的缩进风格：
```python
class Interface(object, metaclass=InterfaceMeta):
    file = 'tmp.txt'
    
print(Interface.class_id)
print(Interface.file)
```
通过定义`metaclass`，构建`Interface`类的时候python就知道去使用`InterfaceMeta`而不是`type`。输入：
```python
type(Interface)
# __main__.InterfaceMeta
```
可以发现python按我们期望的那样工作着。此外，所有从`Interface`继承的类也会使用同样的`metaclass`来构建：
```python
class UserInterface(Interface):
	file = 'foo.txt'
	
print(UserInterface.file)
print(UserInterface.class_id)
```
这个例子展示了如何使用metaclass来为项目创建强大灵活的API。[Django项目](https://www.djangoproject.com/)使用这些构造来允许对其基本类的强大扩展的简明声明。

---

## 另一个例子，注册所有子类
metaclass的另一种可能用途是自动注册从给定基类派生的所有子类。例如，您可能拥有数据库的基本接口，并希望用户能够定义自己的接口，接口将自动存储在主注册表中。
```python
class DBInterfaceMeta(type):
    # we use __init__ rather than __new__ here because we want
    # to modify attributes of the class *after* they have been
    # created
    def __init__(cls, name, bases, dct):
        if not hasattr(cls, 'registry'):
            # this is the base class.  Create an empty registry
            cls.registry = {}
        else:
            # this is a derived class.  Add cls to the registry
            interface_id = name.lower()
            cls.registry[interface_id] = cls
            
        super(DBInterfaceMeta, cls).__init__(name, bases, dct)
```
在metaclass中添加了一个registry，在添加完registry后，新的类会被添加到其中。
```python
class DBInterface(object, metaclass=DBInterfaceMeta):
    pass
    
print(DBInterface.registry)
# {}
class FirstInterface(DBInterface):
    pass

class SecondInterface(DBInterface):
    pass

class SecondInterfaceModified(SecondInterface):
    pass

print(DBInterface.registry)
# {'firstinterface': <class '__main__.FirstInterface'>, 'secondinterface': <class '__main__.SecondInterface'>, 'secondinterfacemodified': <class '__main__.SecondInterfaceModified'>}
```

---

## 什么时候需要metaclass？
```
Metaclasses are deeper magic than 99% of users should ever worry about. If you wonder whether you need them, you don’t (the people who actually need them know with certainty that they need them, and don’t need an explanation about why).

– Tim Peters
```
这段大意是：在确实需要metaclass的时候，需要它的用户自然就会想到它。暂时我还不需要。

---

## 参考链接
- [A Primer on Python Metaclasses](https://jakevdp.github.io/blog/2012/12/01/a-primer-on-python-metaclasses/)