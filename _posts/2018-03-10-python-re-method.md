---
layout: post
title:  "Python re 模块使用笔记"
date:   2018-03-10 15:16:29 +0800
categories: Python
---

## 前言
Python中处理字符串一般从两个方向思考，一个是利用`str`对象自身的方法，另一个更加强大的方法就是`re`模块中的正则表达式方法。在面对稍复杂的字符串处理要求的时候，正则表达式更加简洁优雅。

---

## 从一个简单例子出发

导入`re`模块：
```python
import re
```
找到字符串中的数字：
```python
_str = 'adfaq1334a'
re.findall('[0-9]', _str)
# ['1', '3', '3', '4']
```

下面列出一些常用的表达式，掌握这几个已经可以使生活简单很多～

```
^        Matches the beginning of a line
$        Matches the end of the line
.        Matches any character
\s       Matches whitespace
\S       Matches any non-whitespace character
*        Repeats a character zero or more times
*?       Repeats a character zero or more times 
         (non-greedy)
+        Repeats a character one or more times
+?       Repeats a character one or more times 
         (non-greedy)
[aeiou]  Matches a single character in the listed set
[^XYZ]   Matches a single character not in the listed set
[a-z0-9] The set of characters can include a range
(        Indicates where string extraction is to start
)        Indicates where string extraction is to end

https://www.py4e.com/lectures3/Pythonlearn-11-Regex-Handout.txt
```


# 贪婪模式
**注意**：当正则表达式中包含能接受重复的限定符时，默认的行为是匹配尽可能多的字符，称为贪婪模式。
如果在表示重复的限定符后面加上?，表示非贪婪匹配，意味着在匹配成功条件下使用最少的重复。

```
+?       重复1次或者多次，但是尽可能少重复
*?       重复0次或者多次，但是尽可能少重复
??       重复1次或者0次，但是尽可能少重复
{n,m}?   重复n到m次，但是尽可能少重复
{n,}?    重复n次以上，但是尽可能少重复
```
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
---

## re 模块方法
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
    
