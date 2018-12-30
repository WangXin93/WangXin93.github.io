---
layout: post
title:  "Reverse Linked List in Python"
date: 2018-09-16 10:56:00 +0800
categories: Python, Algorithm
toc: true
---

## 前言
翻转链表是一道经典问题，让我们在Python中实现它。

## 链表数据结构

可以使用下面的代码实现链表的数据结构：

```python
class Link:
    empty = ()
    def __init__(self, first, rest=empty):
        assert rest is Link.empty or isinstance(rest, Link)
        self.first = first
        self.rest = rest

    def __str__(self):
        if is_empty(self.rest):
            return str(self.first)
        else:
            start = str(self.first)
            start += ' -> '
            return start + str(self.rest)

    def __repr__(self):
        if is_empty(self.rest):
            return 'Link({})'.format(self.first)
        else:
            s = 'Link({}, {})'.format(self.first, repr(self.rest))
            return s
```

## 翻转链表

翻转链表的基本思想是：将原来链表的第一个元素指向一个空指针，然后将第二个元素指向第一个，再将第三个元素指向第二个...依此类推。

```python
def reverse_link(a):
    """
    >>> a = Link(1, Link(2, Link(3)))
    >>> reverse_link(a)
    Link(3, Link(2, Link(1)))
    """
    current = a
    reverse = Link.empty
    while not is_empty(current):
        rest_of_current = current.rest
        current.rest = reverse
        reverse = current
        current = rest_of_current
    return reverse
```

## 局部反转链表

更有难度的，我们可以实现反转部分的链表。

```python
def slice_reverse(s, i, j):
    """
    >>> s = Link(1, Link(2, Link(3)))
    >>> slice_reverse(s, 1, 2)
    >>> s
    Link(1, Link(2, Link(3)))
    >>> s = Link(1, Link(2, Link(3, Link(4, Link(5)))))
    >>> slice_reverse(s, 2, 4)
    >>> s
    Link(1, Link(2, Link(4, Link(3, Link(5)))))
    """
    start = s
    for _ in range(i-1):
        start = start.rest
    reverse = Link.empty
    current = start.rest
    for _ in range(j-i):
        tmp = current.rest
        current.rest = reverse
        reverse = current
        current = tmp
    extend(reverse, current)
    start.rest = reverse
```

## 参考链接

* [CS61A Exam Prepration 06](https://inst.eecs.berkeley.edu/~cs61a/sp18/assets/pdfs/exam_prep06.pdf)
* [用python介绍4种常用的单链表翻转的方法](https://blog.csdn.net/u011452172/article/details/78127836)