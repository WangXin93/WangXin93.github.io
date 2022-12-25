---
CNcategories: python
CNtags: ["python", "bitwise-operation"]
CNseries: python
date: "2018-03-20T09:24:12Z"
title: Python 位运算
cover:
    image: "python_bit_byte.svg"
    alt: "python_bit_byte"
    caption: "python_bit_byte"
    relative: true
---

## 前言

位运算对于人来说难于理解，但是对于机器来说却更容易。合理使用位运算可以像让计算机变魔术一样实现自己想要的功能。这里一起来探讨一下Python中位运算的方法。

## 预备知识：Twos-Complement Numbers

数字在Python或者在计算机中是以一串bit（0或者1）来存储的，比如``0000 0001``表示数字1，``0000 0110``表示数字6。但是这样的记录方法无法表示负数。Twos-complement numbers就是用bit来表示负数的一个方法。

### Twos-Complement Binary for Positive Integer
Twos-complement numbers使用最前一位bit来记录正负号，如果最前一位为0，那么这个数为正数，如果为1，那么这个数为负数。比如：

* ``0000 0000``表示0
* ``0000 0001``表示1
* ``0000 0010``表示2

那么这样下来，8 bits一共可以表达的正整数的范围是``0000 0000``到``0111 1111``即0到127。

### Twos-Complement Binary for Negative Integer
所有剩下的``1xxx xxxx``的格式都被用来记录负数。对于一个负数-x，要得到它的bit表达可以先算出(x-1)的结果，然后将(x-1)的所有bit进行取反（将所有的1变成0，0变成1）。例如：

* x=-1, (x-1)=0, 0的8 bits形式为``0000 0000``, 取反得到``1111 1111``
* x=-8, (x-1)=7, 7的8 bits形式为``0000 0111``，取反得到``1111 1000``

这样的表达方法的负数范围为``1111 1111``到``1000 0000``，即-1到-128。

Python记录正数不是用的8 bits，用多少bits一般根据机器来决定。Python最近的版本切换到了无限个bits，即Python中的-5在进行位运算的时候实际像是写成``...111111111111011``。

## 位运算符号
---

假定a=60, b=13，这两个数用二进制表示为：
```
a = 0011 1100

b = 0000 1101
```

那么根据二进制计算法则应该得到如下结果：

```python
a = 0b00111100
b = 0b00001101

# Does a "bitwise and". Each bit of the output is 1 if the corresponding bit of x AND of y is 1, otherwise it's 0.
>>> print('a & b = {} ==> {:08b}'.format(a&b, a&b))
a & b = 12 ==> 00001100

# Does a "bitwise or". Each bit of the output is 0 if the corresponding bit of x AND of y is 0, otherwise it's 1.
>>> print('a | b = {} ==> {:08b}'.format(a|b, a|b))
a | b = 61 ==> 00111101

# Does a "bitwise exclusive or". Each bit of the output is the same as the corresponding bit in x if that bit in y is 0, and it's the complement of the bit in x if that bit in y is 1.
>>> print('a ^ b = {} ==> {:08b}'.format(a^b, a^b))
a ^ b = 49 ==> 00110001

# Returns the complement of x - the number you get by switching each 1 for a 0 and each 0 for a 1. This is the same as -x - 1.
>>> print('~a = {} ==> {:08b}'.format(~a, ~a))
~a = -61 ==> -0111101

# Returns x with the bits shifted to the left by y places (and new bits on the right-hand-side are zeros). This is the same as multiplying x by 2**y.
>>> print('a << 2 = {} ==> {:08b}'.format(a<<2, a<<2))
a << 2 = 240 ==> 11110000

# Returns x with the bits shifted to the right by y places. This is the same as //'ing x by 2**y.
>>> print('a >> 2 = {} ==> {:08b}'.format(a>>2, a>>2))
a >> 2 = 15 ==> 00001111
```

值得注意的是``~a``部分，可以看到Python并没有给我们一个以1为开头的bits，这是因为Python使用任意长度的bit来记录整数，two-complement interger需要知道bit string的长度。所以Python的整数内部使用的不是two complement interger，而是使用了一个负号来取代开头的1来表示正负数。尽管形式不同，Python依然模仿了two-complement interger的行为，即x的取反后得到-x-1。

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

## Python中string，bytes，bits的变换

![img](python_bit_byte.svg)

自己实现bin函数:

```python
def bin(s):
    return str(s) if s<=1 else bin(s>>1) + str(s&1)
```

相关库：
* [struct](https://docs.python.org/3/library/struct.html)
* [binascii](https://docs.python.org/3/library/binascii.html)
* [bytearray](https://docs.python.org/3/library/stdtypes.html#bytearray)
* [bitstring](https://github.com/scott-griffiths/bitstring0)

## 参考链接
* [Python运算符号](https://www.tutorialspoint.com/python/python_basic_operators.htm)
* [Python中二进制表示的格式](https://stackoverflow.com/questions/16926130/convert-to-binary-and-keep-leading-zeros-in-python)
* [FAQ: What do the operators <<, >>, &, \|, ~, and ^ do?](https://wiki.python.org/moin/BitwiseOperators)
* [Two's Complement Binary in Python](https://stackoverflow.com/questions/12946116/twos-complement-binary-in-python)
* [Python bits and bytes](https://www.theunterminatedstring.com/python-bits-and-bytes/)
* [Python BitManipulation](https://wiki.python.org/moin/BitManipulation)
* [Python strings and bytes](https://medium.com/better-programming/strings-unicode-and-bytes-in-python-3-everything-you-always-wanted-to-know-27dc02ff2686)
