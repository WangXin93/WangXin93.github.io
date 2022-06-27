---
layout: post
title:  "Python访问sqlite数据库"
date:   2022-06-27 19:41:00 +0800
categories: Python
---

<div align="center">
<img src="/assets/2022-06-27-python-sqlite/python_loves_sqlite.png" style="width:100%"/>
</div>

> sqlite使用一个文件存储数据库内容，非常适合快速开发测试软件。python内建有sqlite3模块这使得使用python操作sqlite数据库更加方便。本篇博客的下面内容会介绍如何使用python以及sqlite3模块创建sqlite数据库，建立表格，操作数据。

## 前言

如果你正在开发一个中小型软件应用，需要使用数据库，同时不希望使用完整功能但是过于笨重的数据库比如MySQL，PostgreSQL，你可以尝试使用SQLite。SQLite使用文件作为数据库内容，轻量便携且快速，适合快速开发测试软件原型。同时如果你使用python在开发软件那么会更加方便，因为你可以使用内建的sqlite3模块操作sqlite数据库，不需要额外的安装包。

下面的内容会分别介绍如何使用sqlite3模块创建sqlite数据库，建立表格，操作数据，最终会创建一个关系型数据库存储书籍，作者，出版社相关信息。

## 连接数据库&建立表格

```python
# in memory database
conn = sqlite3.connect(':memory:')

# file database, will create new file if not exists
conn = sqlite3.connect('movie.db')

# create cursor
cur = conn.cursor()

# execute SQL
cur.execute("""CREATE TABLE IF NOT EXISTS actors (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    first TEXT,
    last TEXT,
    age INTEGER
)""")

# commit the change
conn.commit()

# close the connection
conn.close()
```

你可以使用sqlite studio来方便地查看sqlite数据库中的表格格式，数据内容。

## 操作数据

### 插入数据

```python
with sqlite3.connect('movie.db') as conn:
    cur = conn.cursor()
    cur.execute(
        "INSERT INTO actors (first, last, age) VALUES"
        "('Neil', 'Wang', 18)")
    conn.commit()
```

```python
first, last, age = 'Carl', 'Zhao', 20
with sqlite3.connect('movie.db') as conn:
    cur = conn.cursor()
    cur.execute(
        f"INSERT INTO actors (first, last, age) VALUES ('{first}','{last}',{age})")
    conn.commit()
```

使用string formatting容易受到sql injection攻击，因为没有escape特殊字符

使用问号作为占位符，execute函数第二个参数使用一个tuple是解决这个问题的一个办法

```python
first, last, age = 'Carl', 'Zhao', 20
with sqlite3.connect('movie.db') as conn:
    cur = conn.cursor()
    cur.execute(
        "INSERT INTO actors (first, last, age) VALUES (?,?,?)",
        (first, last, age))
    conn.commit()
```

另一个方法是使用字典来填入数据到SQL语句中

```python
first, last, age = 'Carl', 'Wang', 25
with sqlite3.connect('movie.db') as conn:
    cur = conn.cursor()
    cur.execute(
        "INSERT INTO actors (first, last, age) VALUES (:first, :last, :last)",
        dict(first=first, last=last, age=age))
    conn.commit()
```

可以使用with语句来保证离开context的时候进行commit，防止忘记

```python
first, last, age = 'Carl', 'Wang', 25
conn = sqlite3.connect('movie.db')
cur = conn.cursor()
# use context manager to commit after execute one or many SQL
with conn: # this will commit after left the context
    cur.execute(
        "INSERT INTO actors (first, last, age) VALUES (:first, :last, :age)",
        dict(first=first, last=last, age=age))
conn.close()
```

### 查询数据

```python
first, last, age = 'Carl', 'Zhao', 20
# close connection after leaving the context
with sqlite3.connect('movie.db') as conn:
    cur = conn.cursor()
    cur.execute("SELECT * FROM actors WHERE last='Wang'")
    print(cur.fetchone()) # return one matched result, or None if no match
    # print(cur.fetchmany(5)) # return a list of matched results
    # print(cur.fetchall()) # return all matched
    # 查询数据不需要commit
```

### 修改数据

```python
conn = sqlite3.connect('movie.db')
cur = conn.cursor()
with conn:
    cur.execute("""UPDATE actors SET age = :age
    WHERE last = :last""",
    dict(age=30, last='Wang'))
conn.close()
```

### 删除数据

```python
conn = sqlite3.connect('movie.db')
cur = conn.cursor()
with conn:
    cur.execute("""DELETE FROM actors WHERE first=:first AND last=:last""",
    dict(first='Carl', last='Zhao'))
conn.close()
```

sqlite 可以和SQLAlchemy很好地结合实现ORM

sqlite使用用于开发原型软件，或者中小型软件，在有需要的时候可以很快切换到功能更全面的数据比如MySQL，PostgreSQL。

## 参考

- <https://realpython.com/python-sqlite-sqlalchemy/>
- <https://www.youtube.com/watch?v=pd-0G0MigUA>