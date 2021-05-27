---
layout: post
title:  "MySQL使用笔记"
date:   2018-03-05 16:27:14 +0800
categories: SQL
toc: true
---

## MySQL

Mysql使用笔记。

---

### 安装mysql

#### Ubuntu

```bash
sudo apt-get update # 更新 apt package index
sudo apt-get install mysql-server # 安装 MySQL 包
```

安装过程结束后，MySQL服务会自动启动。你可以使用``systemctl status mysql``来查看到当前的运行状态。

### 连接数据库

```bash
$ mysql -u user -p
mysql> QUIT # 退出连接
-u 表示用户名
-p 表示登录密码
```

---

### 查看数据库

```sql
mysql> SHOW DATABASE;
```

### 创建数据库

```sql
mysql> CREATE DATABASE db1;
```

### 使用数据库

```sql
mysql> USE db1;
```

### 显示当前数据库中所有表

```sql
mysql> TABLES;
```

### 删除数据库

```sql
mysql> DROP DATABASE db1;
```

### 删除表

```sql
mysql> DROP TABLE tablename;
```

---

### 表操作

```sql
mysql> SElECT * FROM tb1; 
```

## SQLite

```sql
.open db.sqlite3
.tables

SELECT * FROM auth_user;
```

获取帮助：``.help``

### 创建table

Method 1:

```sql
create table animals as
    select "dog" as kind, 4 as legs, 20 as weight union
    select "cat"        , 4        , 10           union
    select "ferret"     , 4        , 10           union
    select "parrot"     , 2        , 6            union
    select "penguin"   , 2        , 10           union
    select "t-rex"      , 2        , 12000;
```

Method 2:

```sql
CREATE TABLE animals (
    kind text not null, 
    legs int not null, 
    weight int not null
);

INSERT INTO animals(kind, legs, weight)
VALUES
    ("dog", 4, 20),
    ("cat", 4, 10),
    ("ferret", 4, 10),
    ("parrot", 2, 6),
    ("penguin", 2, 10),
    ("t-rex", 2, 12000);
```

Method 3

创建一个文本文件，写入SQL语句，然后在通过下面指令读入该文件：

```sql
.read animals.sql
```

### 删除table

```sql
DROP TABLE animals;
```

### JOIN

```sql
create table people as
    select "Peter" as name, 1 as gender, 32 as age, "dog" as animal union
    select "John"         , 1          , 19       ,"parrot"         union
    select "Liu"          , 0          , 23       , "tiger"         union
    select "Lily"         , 0          , 31       , "cat";

SELECT *
FROM animals
CROSS JOIN people;

-- The INNER JOIN clause matches each row from the (people) table with every row from the (animals) table based on the join condition.

SELECT *
FROM people
INNER JOIN animals ON
    kind = animal;

-- The LEFT JOIN clause selects data starting from the left table (animals) and matching rows in the right table (people) based on the join condition.

SELECT p.name, a.kind
FROM people p
LEFT JOIN animals a ON
    a.kind = p.animal;    
```

* Difference between INNTER JOIN and LEFT JOIN: <https://www.codeproject.com/Articles/33052/Visual-Representation-of-SQL-Joins>
* JOIN in SQLite: <https://www.sqlitetutorial.net/sqlite-join/>

### Python Pandas 数据导出到 MySQL

```python
from sqlalchemy import create_engine
engine = create_engine("mysql://username:password@host/database_name")
con = engine.connect()
df.to_sql('df', con=con, if_exists='replace',index=False)
```

## 参考

* [CS61A disc10: Introduct SQL](https://inst.eecs.berkeley.edu/~cs61a/sp18/disc/disc10.pdf)
