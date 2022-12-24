---
categories: Python
date: "2021-09-15T19:54:00Z"
draft: true
title: Python Multiple Inheritance
toc: true
---

> Python支持multiple inheritance来让子类继承多个父类的功能。这篇博客介绍了python multiple inheritance的语法，python继承关系中寻找同名方法的顺序即MRO，以及如何在子类中调用父类方法，如何使用super函数，通过super函数传递函数参数给父类，和避免复杂继承关系mixin技巧。

## 语法

在Python中，当一个类从一个以上类的继承的时候，这种继承关系就被成为multiple inheritance。继承多个类的子类可以拥有所有父类的属性和方法。

例如，如果需要设计要给既能显示日历又能显示时钟的“日历钟”，同时我们已经有了“日历”类和“时钟”类，那么就可以让“日历钟”同时继承“日历”类和“时钟”类来快速实现功能，并且避免代码重复。

```python
from datetime import datetime

class Clock(object):
    def showtime(self):
        time = datetime.now().strftime('%H:%M:%S')
        print(time)

class Calendar(object):
    def showdate(self):
        date = datetime.now().strftime('%Y-%m-%d')
        print(date)

class CalendarClock(Calendar, Clock):
    def showdatetime(self):
        self.showdate()
        self.showtime()
```

![inherit_graph](/assets/2021-09-15-python-multiple-inheritance/inherit_graph.svg)

## Diamond Problem and MRO

在下图的情形中，Calendar和Clock都继承与Tool类，CalendarClock同时继承了Calendar类和Clock类，如果Tool，Calendar，Clock同时具有一个名为``showname``的方法，那么CalendarClock类会继承哪个类中的方法？这种由于multiple inheritance带来的歧义性问题被称为“Dismond Problem"。

![diamond](/assets/2021-09-15-python-multiple-inheritance/diamond.svg)

这里可以用下面的代码来实验，

```python
from datetime import datetime

class Tool(object):
    def showname(self):
        print("Tool")

class Clock(Tool):
    def showname(self):
        print("Clock")

class Calendar(Tool):
    def showname(self):
        print("Calendar")

class CalendarClock(Calendar, Clock):
    pass

calclock = CalendarClock()
calclock.showname()
```

得到的结果为：

Calendar

这是因为Python在继承关系中寻找overridden的方法时候遵循一定的顺序，这个顺序被称为MRO（ **Method Resolution Order**）。你可以使用``mro()``方法来查看这个顺序：

```python
>>> CalendarClock.mro()
[<class '__main__.CalendarClock'>, <class '__main__.Calendar'>, <class '__main__.Clock'>, <class '__main__.Tool'>, <class 'object'>]
```

Python3中MRO遵循广度优先搜索的顺序来寻找overridden的方法。（在Python2中，如果使用``class Tool: ``来定义类，MRO的顺序为深度优先，从左到右的搜索顺序，可以使用``class Tool(object):``来让MRO顺序和python3一致）

## The super() function

### 子类如何调用父类方法？

上节说到了multiple inheritance中的子类可以按MRO的顺序搜索方法，但是如何使用其它父类中同名的方法？一种方法是直接指定一个父类的名称中的方法：

```python
>>> Clock.showname(calclock)
Clock
>>> Tool.showname(calclock)
Tool
```

但是这种指定父类的方法会随着继承关系的复杂让代码变得复杂，同时寻找继承关系中的父类名称增加额外的负担，比如下面的情形：

```python
class CalendarClock(Calendar, Clock):
    def showname(self):
        print("CalendarClock")
        Calendar.showname(self)
        Clock.showname(self)
        Tool.showname(self)
```

除此以外，如果希望Calendar和Clock都能调用父类的方法，编写下面的代码还会导致bug，这是因为ClaendarClock调用了多次Tool的showname：

```python
from datetime import datetime

class Tool(object):
    def showname(self):
        print("Tool")

class Clock(Tool):
    def showname(self):
        print("Clock")
        Tool.showname(self)

class Calendar(Tool):
    def showname(self):
        print("Calendar")
        Tool.showname(self)

class CalendarClock(Calendar, Clock):
    def showname(self):
        print("CalendarClock")
        Calendar.showname(self)
        Clock.showname(self)
        Tool.showname(self)

calclock = CalendarClock()
calclock.showname()

# 程序输出结果为：
# CalendarClock
# Calendar
# Tool
# Clock
# Tool
# Tool
```

### 使用super函数调用父类方法

Python提供了``super()``函数来解决multiple inheritance中父类同名函数的调用问题：

```python
class A(object):
    def m(self):
        print("m of A called")

class B(A):
    def m(self):
        print("m of B called")
        super().m()
    
class C(A):
    def m(self):
        print("m of C called")
        super().m()

class D(B,C):
    def m(self):
        print("m of D called")
        super().m()
        
x = D()
x.m()

# 上面程序输出的结果为：
# m of D called 
# m of B called
# m of C called 
# m of A called
```

``super()``函数经常用于class的实例化方法``__init__()``。例如：

```python
class A(object):
    def __init__(self):
        print("A.__init__")

class B(A):
    def __init__(self):
        print("B.__init__")
        super().__init__()
    
class C(A):
    def __init__(self):
        print("C.__init__")
        super().__init__()


class D(B,C):
    def __init__(self):
        print("D.__init__")
        super().__init__()
```

### 给父类方法传递函数参数

如果希望在multiple inheritance的情况下，如果希望传递参数到父类的方法，你需要让继承关系中间的类能够使用额外的关键字参数。额外的关键字参数让一个类能够得到参数，然后通过``super()``方法传递到父类的方法。例如：

```python
class A(object):
    def __init__(self,a):
        self.a=a

class B(A):
    def __init__(self,b,**kw):
        self.b=b
        super(B,self).__init__(**kw)

 class C(A):
    def __init__(self,c,**kw):
        self.c=c
        super(C,self).__init__(**kw)

class D(B,C):
    def __init__(self,a,b,c,d):
        super(D,self).__init__(a=a,b=b,c=c)
        self.d=d
```

## Mixin

Multiple inheritance会随着类变多变得非常复杂，一种常用的技巧是写一个mixin。一个mixin是一个类，它在继承关系中的位置不重要，它只是包含一个或者多个方法。例如：

```python
class SurfaceAreaMixin:
    def surface_area(self):
        surface_area = 0
        for surface in self.surfaces:
            surface_area += surface.area(self)

        return surface_area

class Cube(Square, SurfaceAreaMixin):
    def __init__(self, length):
        super().__init__(length)
        self.surfaces = [Square, Square, Square, Square, Square, Square]

class RightPyramid(Square, Triangle, SurfaceAreaMixin):
    def __init__(self, base, slant_height):
        self.base = base
        self.slant_height = slant_height
        self.height = slant_height
        self.length = base
        self.width = base

        self.surfaces = [Square, Triangle, Triangle, Triangle, Triangle]
```

## Reference

* [The History of Python: Method Resolution Order (python-history.blogspot.com)](http://python-history.blogspot.com/2010/06/method-resolution-order.html)
* [Multiple Inheritance in Python – Real Python](https://realpython.com/lessons/multiple-inheritance-python/)
* [python multiple inheritance passing arguments to constructors using super - Stack Overflow](https://stackoverflow.com/questions/34884567/python-multiple-inheritance-passing-arguments-to-constructors-using-super)
* [Multiple Inheritance in Python - GeeksforGeeks](https://www.geeksforgeeks.org/multiple-inheritance-in-python/)
* [How does Python's super() work with multiple inheritance? - Stack Overflow](https://stackoverflow.com/questions/3277367/how-does-pythons-super-work-with-multiple-inheritance)