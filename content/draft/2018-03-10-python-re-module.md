---
categories: Python
date: "2018-03-10T15:16:29Z"
draft: true
title: Python中的正则表达式模块简介
toc: true
---

> 正则表达式是强大的文字处理工具，它可以灵活高效地完成字符串的匹配和替代。Python 中的 re 模块实现了正则表达式的功能。本篇博客会介绍如何使用 Python 中的 re 模块进行字符串的匹配和替换。

## 前言

Python中处理字符串一般从两个方向思考，一个是利用`str`对象自身的方法，比如：``find``，``startswith``，``strip``，``replace``等。

但是在面对稍复杂的字符串处理要求的时候，使用这些方法会让代码变得冗长且难以理解。例如下面的例子，如果希望找到所有的连续数字组成的字符串，使用字符串自身的方法需要复杂的代码，但是正则表达式就可以非常简洁高效：

```python
import re

s = 'adfaq1334a799'
re.findall('[0-9]+', s)
# ['1234', '799']
```

这段代码中使用了``re``模块，它实现了正则表达式的功能。字符串``s``是匹配的字符串，``'[0-9]+'``是用来匹配的pattern，``findall``函数会找出字符串``s``中所有满足匹配条件的字符串。

1951年，数学家 Stephen Cole Kleene 提出了 [regular language](https://en.wikipedia.org/wiki/Regular_language) 的概念，它是一种可以被 regular expression 表达的语言。1960年代中期，计算机科学家，Unix的设计者之一 Ken Thompson 在 [QEU text editor](https://en.wikipedia.org/wiki/QED_(text_editor)) 中使用 Kleene的思想实现了 pattern matching。之后， regex 出现在了不同的编程语言和工具中用来匹配字符串和模式，比如 Python，Java，Perl以及很多Unix工具和编辑器。

Python中``re``模块是内建的正则表达式模块，它包含很多的函数方法，比如``findall``，其它常用的函数还有``search``，``match``，``replace``等。

## re模块中的search方法

``re``模块中的``search()``函数的语法为：

```python
re.search(pattern, string)
```

``re.search()``会在string中寻找第一个能够匹配pattern的地方，如果找到了能够匹配的内容，就会返回一个match对象，否则会返回None。例如：

```python
>>> import re
>>> s = 'abc1234efg'
>>> re.search('123', s)
# <re.Match object; span=(3, 7), match='1234'>
```

可以看到REPL中打印出了返回的match对象。存在match对象可以说明找到了匹配的字符串，否则说明没找到匹配的字符串，因此可以用选择结构编写代码：

```python
>>> if re.search('123', s):
...     print("There is a match")
... else:
...     print("No match")
```

match对象中有一些常用的属性，例如找到的匹配字符串的索引，找到的匹配字符串的内容：

```python
>>> s[m.start():m.end()]
'123'
>>> m.group()
'123'
```

到目前为止，我们能够从原来的字符串中匹配到目标的pattern，即``123``字符串，但是这也能通过str对象的``find``方法或者``in``关键字来实现。

## 正则表达式元字符（metacharacter）

正则表达式强大的地方是能够更加灵活的匹配，比如之前用的``[0-9]+``作为pattern可以匹配数字组成的字符串，其中的``[``, ``]``, ``+``, ``-``是**元字符**，它们在正则表达式中有特殊的作用。``[0-9]``意味着匹配单个数字字符0到9，例如单个字符1，2，3，一直到0。``+``意味着一个或者一个以上的字符组成的字符串，例如0，12，234都可以被``[0-9]+``匹配，因此这个正则表达式能够匹配数字组成的字符串。

再例如，``.``元字符在正则表达式中意味着匹配任意的单个字符。``re.search('1.3', 'abc1a3def')``可以匹配到字符串``1a3``，因为能够满足``'1.3'``匹配规则的字符串的特征是两边为1和3，中间为任意一个单个字符。

常用的正则表达式元字符及其含义为：

```
# 单个字符匹配
.        匹配任意一个单个字符
^        如果出现在一行的开始，用作匹配一行的开始
$        如果出现在一行的结尾，用作匹配一行的结尾
\s       匹配空白字符
\S       匹配非空白字符
\w       匹配一个单词字符，等效于'[a-zA-Z0-9_]'
\W       匹配一个非单词字符，等效于'[^a-zA-Z0-9_]'
\d       匹配一个数字字符，等效于'[0-9]'
\D       匹配一个非数字字符，等效于'[^0-9]'
[aeiou]  匹配单个字符，满足字符为集合aeiou中的一个
[^XYZ]   匹配单个字符，满足字符不为集合XYZ中的任意一个
[a-z0-9] 匹配单个字符，字符为范围a到z，0-9中的一个

# 数量匹配
?        一个字符出现0次或者1次
*        一个字符重复0次或者0次以上
*?       一个字符重复1次或者1次以上，但是尽可能少重复(非贪婪模式)
+        一个字符出现1次或者1次以上
+?       一个字符出现1次或者1次以上，但是尽可能少重复(非贪婪模式)
??       一个字符出现0次或者1次，但是尽可能少重复(非贪婪模式)
{}       一个字符出现指定的次数
{n,m}?   重复n到m次，但是尽可能少重复
{n,}?    重复n次以上，但是尽可能少重复

# 位置匹配
^        如果出现在一行的开始，用作匹配一行的开始
$        如果出现在一行的结尾，用作匹配一行的结尾
\A       匹配一行的开始，等效于'^'
\Z       匹配一行的结束，等效于'$'
\b       匹配一个单词的边界的字符
\B       匹配一个不是单词的边界的字符

# 群组
()       创建一个群组，(表示群组提取的地方，)表示群组结束的地方。 
<>       创建一个命名群组

# 其它
|        描述替代关系
\        脱字符，让特殊字符当普通字符使用，或者用在群组引用
```

## 单个字符匹配

单个字符的匹配可以用到下面一系列的元字符：

```
.        匹配任意一个单个字符
\s       匹配空白字符
\S       匹配非空白字符
\w       匹配一个单词字符，等效于'[a-zA-Z0-9_]'
\W       匹配一个非单词字符，等效于'[^a-zA-Z0-9_]'
\d       匹配一个数字字符，等效于'[0-9]'
\D       匹配一个非数字字符，等效于'[^0-9]'
[aeiou]  匹配单个字符，满足字符为集合aeiou中的一个
[^XYZ]   匹配单个字符，满足字符不为集合XYZ中的任意一个
[a-z0-9] 匹配单个字符，字符为范围a到z，0-9中的一个
```

可以通过代码实验来理解这些元字符的功能。

```python
>>> import re
>>> s = 'Email: Press@tesla.com Tel: +86 123-2233-2908'
>>> re.search('.', s)
>>> re.search('\s', s)
<re.Match object; span=(6, 7), match=' '>
>>> re.search('\S', s)
<re.Match object; span=(0, 1), match='E'>
>>> re.search('\w', s)
<re.Match object; span=(0, 1), match='E'>
>>> re.search('\W', s)
<re.Match object; span=(5, 6), match=':'>
>>> re.search('\d', s)
<re.Match object; span=(29, 30), match='8'>
>>> re.search('\D', s)
<re.Match object; span=(0, 1), match='E'>
>>> re.search('[0-9]', s)
<re.Match object; span=(29, 30), match='8'>
>>> re.search('[^0-9]', s)
<re.Match object; span=(0, 1), match='E'>
```

## 数量匹配

数量匹配常用到的元字符包括:

```
?        一个字符出现0次或者1次
*        一个字符重复0次或者0次以上
+        一个字符出现1次或者1次以上
*?       一个字符重复1次或者1次以上，但是尽可能少重复(非贪婪模式)
+?       一个字符出现1次或者1次以上，但是尽可能少重复(非贪婪模式)
??       一个字符出现0次或者1次，但是尽可能少重复(非贪婪模式)
{}       一个字符出现指定的次数
{m}      一个字符出现m次
{n,}     一个字符出现至少n次
{,m}     一个字符出现最多m次
{n,m}?   重复n到m次，但是尽可能少重复
{n,}?    重复n次以上，但是尽可能少重复
```

下面用代码进行实验:

```python
>>> import re
>>> s = 'Email: Press@tesla.com Tel: +86 123-2233-2908'
>>> re.search('tesla.?com', s)
<re.Match object; span=(13, 22), match='tesla.com'>
>>> re.search('\d+', s)
<re.Match object; span=(29, 31), match='86'>
>>> re.search('\S*', s)
<re.Match object; span=(0, 6), match='Email:'>
>>> re.search('\d{3}', s)
<re.Match object; span=(32, 35), match='123'>
>>> re.search('[0-9-]{3,}', s)
<re.Match object; span=(32, 45), match='123-2233-2908'>
```

**注意**，当正则表达式中包含能接受重复的限定符时，默认的行为是匹配尽可能多的字符，称为**贪婪模式**。如果在表示重复的限定符后面加上?，表示**非贪婪匹配**，意味着在匹配成功条件下使用最少的重复。

观察下面的例子：

```python
_str = 'From stephen.marquard@uct.ac.za Sat Jan  5 09:14:16 2008'
print(re.findall('\S+@\S+?', _str)) # non-greedy
print(re.findall('\S+@\S+', _str)) # greedy
print(re.findall('\S+@(\S+)', _str))
# ['stephen.marquard@u']
# ['stephen.marquard@uct.ac.za']
# ['uct.ac.za']
```

## 位置匹配

元字符中用于位置匹配的包括：

```
^        如果出现在一行的开始，用作匹配一行的开始
$        如果出现在一行的结尾，用作匹配一行的结尾
\A       匹配一行的开始，等效于'^'
\Z       匹配一行的结束，等效于'$'
\b       匹配一个单词的边界的字符
\B       匹配一个不是单词的边界的字符
```

```python
>>> import re
>>> s = 'Email: Press@tesla.com Tel: +86 123-2233-2908'
>>> re.search('^Email', s)
<re.Match object; span=(0, 5), match='Email'>
>>> re.search('\d*$', s)
<re.Match object; span=(41, 45), match='2908'>
>>> re.search(r'\btesla\b', s)
<re.Match object; span=(13, 18), match='tesla'>
>>> re.search(r'\Bfoo\B', 'barfoobaz')
<_sre.SRE_Match object; span=(3, 6), match='foo'>
```

需要注意的是由于'\b'在python字符串中属于特殊字符，你需要使用``r'somestr'``来使用raw string作为patter，或者使用``\\b``来标识不使用python字符串的特殊字符含义。

## 群组和引用

群组功能可以将Python字符串分解到多个子字符串。群组的作用包括：（1）作为单独的一个单位添加额外的元字符；（2）同时可以从字符串中提取出来用于后续使用。

```python
>>> import re
>>> s = 'Email: Press@tesla.com Tel: +86 123-2233-2908'
>>> re.search('(\d)+', s)
<re.Match object; span=(29, 31), match='86'>
>>> re.search('(\d){3,}', s)
<re.Match object; span=(32, 35), match='123'>
>>> re.search('(\d{3,4}-?)+', s)
<re.Match object; span=(32, 45), match='123-2233-2908'>
```

这里的``(\d)``，``(\d{3,4}-?)``都是创建的群组，他们可以加上数量元字符``+``，``?``等创建更加复杂的正则表达式。群组还可以进行嵌套比如``(foo(bar)?)+``。

群组的另一个作用是将字符串中满足群组匹配条件的子字符串提取出来用作后续使用。``re.search()``会返回一个match对象，它包含两个方法``groups()``和``group()``。``groups()``方法会返回一个tuple，它包含匹配的多个子字符串；``group(n)``需要一个参数输入到函数，其中1代表第一个匹配的子字符串，2代表第二个匹配的子字符串以此类推。

```python
>>> m = re.search('(\d{3,})-(\d{3,})-(\d{3,})', s)
>>> m = re.search('(\d{3,})-(\d{3,})-(\d{3,})', s)
>>> m
<re.Match object; span=(32, 45), match='123-2233-2908'>
>>> m.groups()
('123', '2233', '2908')
>>> m.group(0)
'123-2233-2908'
>>> m.group(1)
'123'
>>> m.group(2)
'2233'
>>> m.group(3)
'2908'
```

你可以使用``\<n>``的语法来引用之前匹配的群组，n的数字从1开始到99。

```python
>>> re.search(r'(\S+),\1', 'foo,foo')
<re.Match object; span=(0, 7), match='foo,foo'>
>>> re.search(r'(\S+),\1', 'foo,bar')
# None
# 因为bar和foo不一样，所有不能匹配到结果
```

群组的进阶技巧包括：创建命名群组；创建后续不可引用的群组；创建根据条件匹配的群组。

```python
>>> m = re.search('(?P<w1>\w+),(?P<w2>\w+),(?P<w3>\w+)', 'foo,quux,baz')

>>> m.group('w1')
'foo'
>>> m.group(1)
'foo'

>>> m.group('w1', 'w2', 'w3')
('foo', 'quux', 'baz')
>>> m.group(1, 2, 3)
('foo', 'quux', 'baz')
```

## Lookahead 和 Lookbehind 断言

Lookahead代码示例：

```python
# Positive lookahead
>>> re.search('foo(?=[a-z])', 'foobar')
<_sre.SRE_Match object; span=(0, 3), match='foo'>
>>> print(re.search('foo(?=[a-z])', 'foo123'))
None

# Negative lookahead
>>> print(re.search('foo(?![a-z])', 'foobar'))
None
>>> re.search('foo(?![a-z])', 'foo123')
<_sre.SRE_Match object; span=(0, 3), match='foo'>
```

Lookbehind代码示例：

```python
# Positive lookbehind
>>> re.search('(?<=foo)bar', 'foobar')
<_sre.SRE_Match object; span=(3, 6), match='bar'>
>>> print(re.search('(?<=qux)bar', 'foobar'))
None

# Negative lookbehind
>>> print(re.search('(?<!foo)bar', 'foobar'))
None
>>> re.search('(?<!qux)bar', 'foobar')
<_sre.SRE_Match object; span=(3, 6), match='bar'>
```

## 其它常用元字符

添加注释的代码示例：

```python
>>> re.search('bar(?#This is a comment) *baz', 'foo bar baz qux')
<_sre.SRE_Match object; span=(4, 11), match='bar baz'>
```

替代关系：

```python
>>> re.search('foo|bar|baz', 'bar')
<_sre.SRE_Match object; span=(0, 3), match='bar'>

>>> re.search('foo|bar|baz', 'baz')
<_sre.SRE_Match object; span=(0, 3), match='baz'>

>>> print(re.search('foo|bar|baz', 'quux'))
None
```

## flags 选项

大多数re模块中的方法包含一个可选参数``<flags>``，它允许你进一步调整匹配的结果。例如``re.IGNORECASE``允许匹配的结果不考虑大小写的变化：

```python
>>> re.search('a+', 'aaaAAA', re.I)
<_sre.SRE_Match object; span=(0, 6), match='aaaAAA'>
>>> re.search('A+', 'aaaAAA', re.IGNORECASE)
<_sre.SRE_Match object; span=(0, 6), match='aaaAAA'>
```

## re 模块方法

re模块中除了search方法，还有其它常用的函数如下。

- re.match = match(pattern, string, flags=0)

    从字符串开始匹配pattern，如果匹配成功返回一个match对象，否则返回None   
    使用`$pydoc re.match`可以查看python自带文档。

```python
m = re.match(r'hello', 'hello,world')
m.group()
```
    'hello'

- re.search = search(pattern, string, flags=0)

    从一个字符串中匹配pattern，如果匹配成功返回一个match对象，否则返回None。与`match`的不同在于不需要从字符串开始匹配

```python
pattern = re.compile(r'world')
match = pattern.search('hello world!')
print(match)
```
    <_sre.SRE_Match object; span=(6, 11), match='world'>

- re.split = split(pattern, string, maxsplit=0, flags=0)

    按照pattern匹配的子串将string分割后返回列表。maxsplit用于指定最大分割次数，不指定将全部分割

```python
p = re.compile(r'\d+')
p.split('one1two2three3four4')
```
    ['one', 'two', 'three', 'four', '']

```python
re.split(r'\d+', 'one1two2three3four4')
```
    ['one', 'two', 'three', 'four', '']

- re.findall = findall(pattern, string, flags=0)

    搜索string，以列表形式返回全部能匹配的子串

```python
p = re.compile(r'\d+')
p.findall('one1two2three3four4')
```
    ['1', '2', '3', '4']
```python
re.findall(r'\d+', 'one1two2three3four4')
```
    ['1', '2', '3', '4']

- re.finditer = finditer(pattern, string, flags=0)
    
    搜索string，返回一个迭代器，迭代器返回所有匹配的match对象

```python
p = re.compile(r'\d+')
for m in p.finditer('one1two2three3four4'):
    print(m.group())
```
    1
    2
    3
    4

- re.sub = sub(pattern, repl, string, count=0, flags=0)

    使用repl替换string中每一个匹配的子串，返回替换后的字符串。repl可以是一个string或者callable。
    当repl是一个字符串时候，可以使用\id或\g, \g引用分组，但不能使用编号0
    当repl是callable时候，这个方法接受一个match对象，返回一个用于替换的字符串。
    count用于指定最多替换次数。

```python
p = re.compile(r'(\w+) (\w+)')
s = 'I just say, hello world!'
print(p.sub(r'\2 \1', s))

def func(m):
    return m.group(1).title() + ' ' + m.group(2).title()

print(p.sub(func, s))

print(p.subn(func, s))
```

    just I say, world hello!
    I Just say, Hello World!
    ('I Just say, Hello World!', 2)
    
- re.compile

    将字符串形式的正则表达式编译为pattern对象，使用`|`可以表示同时生效，比如`re.I|re.m`
- match 对象

    match对象是一次匹配的结果，使用match提供的属性和方法可以获取关于此次匹配的信息
- pattern 对象

    pattern对象是编译好的正则表达式，通过pattern提供的方法可以对文本进行匹配查找，pattern对象必须由`re.compile`构造。

```python
p = re.compile(r'(\w+) (\w+)')
m = p.match('hello world')
print(m.groups())
print(m.group())
print(m.group(1), m.group(2))
```
    ('hello', 'world')
    hello world
    hello world
    
## 参考

* <https://realpython.com/regex-python>
* <https://www.py4e.com/lectures3/Pythonlearn-11-Regex-Handout.txt>