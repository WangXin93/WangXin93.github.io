---
layout: post
title:  "使用 SQLAlchemy 操作数据库"
date:   2021-06-02 18:02:27 +0800
categories: Python SQL
toc: true
---

> python sql

```python
import pymysql

con = pymysql.connect(
    host='localhost',
    user='root',
    passwd='1234',
    database='air_quality'
)

try:
    with con.cursor() as cur:
        cur.execute('SELECT VERSION()')
        version = cur.fetchone()
        print(f'Database version: {version[0]}')
finally:
    con.close()
```

```python
con = pymysql.connect(
    host='localhost',
    user='root',
    passwd='1234',
    database='air_quality'
)

try:
    with con.cursor() as cur:
        cur.execute('SELECT * FROM irr_28')
        rows = cur.fetchall()
        for row in rows:
            print(f'{row[0]} {row[1]} {row[2]}')
finally:
    con.close()
```

## 前言

## 结语

## 参考

