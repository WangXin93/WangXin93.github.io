---
layout: post
title:  "Python 位运算"
date:   2018-03-20 09:24:12 +0800
categories: Python
---

## 前言

位运算对于人来说难于理解，但是对于机器来说却更容易。合理使用位运算可以像让计算机变魔术一样实现自己想要的功能。这里一起来探讨一下Python中位运算的方法。

## 位运算符号
---

假定a=60, b=13，这两个数用二进制表示为：
```
a = 0011 1100

b = 0000 1101
```
那么根据二进制计算法则应该得到如下结果：
```
a&b = 0000 1100

a|b = 0011 1101

a^b = 0011 0001

~a  = 1100 0011

a<<2 = 1111 0000

a>>2 = 0000 1111
```

下面用Python实现位运算：
```python
a = 0b00111100
b = 0b00001101

>>> print('a & b = {} ==> {:08b}'.format(a&b, a&b))
a & b = 12 ==> 00001100

>>> print('a | b = {} ==> {:08b}'.format(a|b, a|b))
a | b = 61 ==> 00111101

>>> print('a ^ b = {} ==> {:08b}'.format(a^b, a^b))
a ^ b = 49 ==> 00110001

>>> print('~a = {} ==> {:08b}'.format(~a, ~a))
~a = -61 ==> -0111101

>>> print('a << 2 = {} ==> {:08b}'.format(a<<2, a<<2))
a << 2 = 240 ==> 11110000

>>> print('a >> 2 = {} ==> {:08b}'.format(a>>2, a>>2))
a >> 2 = 15 ==> 00001111
```

等一下，为什么`~a`等于-61？这是因为a是一个有正负的整数，当使用2's complement from的格式表示的时候，`11000011`等于-61。再来详细解释一下，例如当5+11的时候：
```
   0101
+  1011
-------
  10000
```
通过二进制运算，得到的结果是0！这就意味着5+11=0，或者说5 = - 11

再来看~a = 11000011:
```
   11000011
+  00111101
-----------
  100000000
```
`11000011`等于195也就是195-256=-61。-61这样得到的。

## 为什么要学习位运算？

为了阐明位运算的神奇的地方，这里举一个例子。当需要交换两个数字的时候，典型的做法是：
```python
a, b = 10, 13
temp = a
a = b
b = temp
```
交换数字需要3个变量不是吗？但是使用位运算就可以表演一个小戏法：
```python
a, b = 10, 13
a = a ^ b
b = a ^ b
a = a ^ b
print(b, a)
```
现在不需要3个变量也能交换了，很神奇不是么？

还有更多使用位运算的巧妙例子，比如判断一个数是否为2的n次方，可以使用：
```python
if i & (i-1) == 0:
```

## 参考链接
* [Python运算符号](https://www.tutorialspoint.com/python/python_basic_operators.htm)
* [2's complement binary for negative](http://grokbase.com/t/python/tutor/1451z5jy6t/2s-complement-binary-for-negative)
* [Python中二进制表示的格式](https://stackoverflow.com/questions/16926130/convert-to-binary-and-keep-leading-zeros-in-python)
