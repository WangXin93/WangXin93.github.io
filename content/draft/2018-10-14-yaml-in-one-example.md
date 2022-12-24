---
categories: Linux
date: "2018-10-14T09:02:48Z"
draft: true
title: Learn YAML in one example
toc: true
---

## 前言

今天我们来通过一个例子掌握YAML的常用的基本语法。YAML是一个用来存储数据的语言，和它功能相同的语言有JSON。相比而言，YAML更加注重它编写时候的美观简洁, s所以它可读性非常的好。YAML文件通常用`.yml`或者`.yaml`作为后缀。

我们可以使用YAML来编写key-value对，比如variable，list，objects。

## 例子

```yaml
# YAML Ain't Markup Language

# This is a comment
person:
    name: &name "wangx"
    occupation: 'programmer'
    age: !!float 25 # 25.0
    gpa: !!str 3.5 # "3.5"
    fav_num: 7
    salary: 1e+10
    male: true
    birthday: 1993-04-11 11:11:01 # ISO 8601
    flaws: null
    hobbies:
        - coding
        - guitar
        - movies
        - poping
    # Equivalent to the above
    movies: ["Dark Knight", "Good Will Hunting"]
    # Complex objects, all three are of the same meaning
    friends:
        - name: "Li"
          age: 28
        - {name: "Adam", age: 22}
        -
          name: "joe"
          age: 233
    description: > # render the below as single line
        Giraffe Academy is rebranding!  I've decided to
        re-focus the brand of this channel to highlight
        myself as a developer and teacher! The newly
        minted Mike Dane channel will have all the same
        content, with more to come in the future!
    signature: | # preserve formatting
        WangX
        Google Research
        email - somewhere@gmail.com
    id: *name # id have the value of the name, anchor of name needed

    base: &base
        var1: value1

    foo:
        <<: *base # var1: value1
```

我们可以试着用python读取它，我们需要安装`pyyaml`包，你可以使用`pip`非常方便的安装：

```
$ pip install pyyaml
```

然后我们来读取它，你可以发现YAML文件成功读取为python的数据格式（list和dict）。

```python
import yaml
data = yaml.load(open('example.yml'))
data
"""
{'person': {'name': 'wangx',
             'occupation': 'programmer',
             'age': 25.0,
             'gpa': '3.5',
             'fav_num': 7,
             'salary': '1e+10',
             'male': True,
             'birthday': datetime.datetime(1993, 4, 11, 11, 11, 1),
             'flaws': None,
             'hobbies': ['coding', 'guitar', 'movies', 'poping'],
             'movies': ['Dark Knight', 'Good Will Hunting'],
             'friends': [{'name': 'Li', 'age': 28},
                {'name': 'Adam', 'age': 22},
                {'name': 'joe', 'age': 233}],
             'description': "Giraffe Academy is rebranding!  I've decided to re-focus the brand of this channel to highlight myself as a developer and teacher! The newly minted Mike Dane channel will have all the same content, with more to come in the future!\n",
             'signature': 'WangX\nGoogle Research\nemail - somewhere@gmail.com\n',
             'id': 'wangx',
             'base': {'var1': 'value1'},
             'foo': {'var1': 'value1'}}}
"""
```

我们也可以在pypi中搜索更多关于YAML的包，使用命令：

```
$ pip search yaml
```

## Reference

* [YAML In One Video](https://www.youtube.com/watch?v=cdLNKUoMc6c)

