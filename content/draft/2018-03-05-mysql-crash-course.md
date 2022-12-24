---
categories: SQL
date: "2018-03-05T16:27:14Z"
draft: true
title: MySQL使用笔记
toc: true
---

> MySQL 是常用的关系型数据管理系统之一（relational database management system，RDBMS），RDBMS 可以用来帮助用户存储，管理和检索数据。MySQL 是一个开源软件，同时非常强大灵活。这篇文章会介绍如何安装 MySQL，MySQL 的基本操作，以及如何使用 Python 来操作 MySQL。

## 安装 MySQL

### Ubuntu

```bash
sudo apt-get update # 更新 apt package index
sudo apt-get install mysql-server # 安装 MySQL 包
```

### CentOS

```bashrc
sudo yum install mysql-server
/etc/init.d/mysqld start
```

安装过程结束后，MySQL服务会自动启动。你可以使用``systemctl status mysql``来查看到当前的运行状态。你可以使用``mysql -V``来查看安装的版本。

## MySQL 操作

### 连接到 MySQL 的命令行

在安装完成后，你可以在终端中输入命令来登陆到 MySQL。如果你是 Ubuntu 18.04 的系统，同时 mysql 版本在5.7以上，你可以使用：

```bash
sudo mysql -u root
```

来登陆到 MySQL 数据库。对于一些较早版本的 MySQL，你可以使用下面的命令登陆：

```bash
mysql -u user -p
```

其中``-u``表示用户名, ``-p``表示登录密码。当登陆成功后，你就可以到 MySQL 的命令行中输入命令来执行操作了。如果忘记密码可以[重新设置](https://stackoverflow.com/questions/50691977/how-to-reset-the-root-password-in-mysql-8-0-11)。

MySQL 的命令有下面两个特点：

1. 所有的 MySQL 命令都以一个``;``结束一行，如果没有发现分号，命令不会被执行；
2. 为了便于阅读，MySQL 的指令通常会使用大写字母，数据库名称，表的名称，字符串会使用小写字母，不过 MySQL 本身不会因为大小写报出错误。

### 创建和删除数据库

MySQL 把数据以多个 databases 的形式存储，每个databases 包含多个 tables。你可以通过下面的命令来查看目前的 databases：

```sql
mysql> SHOW DATABASES;
```

创建一个新的数据库使用命令``CREATE DATABASE``，例如下面的命令创建了一个名称为``db1``的 database：

```sql
mysql> CREATE DATABASE db1;
```

你可以再次通过``SHOW DATABASES``命令来查看当前有哪些数据库，从而确认``db1``被成功地创建了。在这个例子中，``SHOW DATABASES``的返回结果如下：

```
mysql> SHOW DATABASES;
+--------------------+
| Database           |
+--------------------+
| db1                |
| information_schema |
| mysql              |
| performance_schema |
| sys                |
+--------------------+
5 rows in set (0.01 sec)
```

如果不再需要一个数据库，可以使用``DROP``命令。例如下面的命令会删除删除数据库``db1``：

```sql
mysql> DROP DATABASE db1;
```

### 使用数据库

一个database可以包含多个tables。当有了一个 database 之后，我们可以向其中创建不同的 table 来填充数据。首先使用``USE``命令来打开一个数据库：

```sql
mysql> USE db1;
```

然后用``SHOW``命令来显示当前数据库中所有表：

```sql
mysql> SHOW TABLES;
```

由于目前``db1``数据库中还没有任何数据，所以你会看到程序返回一个``Empty set``结果。

### Table 操作

创建和删除表

现在要在空的数据库中添加表格，这需要使用``CREATE TABLE``命令。下面的例子创建了一个关于国家土地面积和人口的表格：

```sql
CREATE TABLE countries (id INT NOT NULL PRIMARY KEY AUTO_INCREMENT,
name VARCHAR(20),
continent VARCHAR(20),
population INT,
area FLOAT,
last_update DATE);
```

这个表格的名称为``countries``，它包含6个列，其中``id``一列是一个自动增加的整型数字；``name``是国家的名称，数据类型为字符串，长度不超过20个字符；``continent``是国家的地理位置，数据类型也为长度不超过20个字符的字符串；``population``是国家的人口，数据类型为整型；``area``是国土面积，数据类型为一个浮点数；``last_update``是一行数据最后被修改的时间。

创建表格完成后，可以使用``SHOW TABLES;``命令来确认表格的存在，使用``DESCRIBE countries;``命令来查看表格每一列的数据类型。

如果不需要这个表格了，可以使用``DROP``命令来删除表格：

```sql
mysql> DROP TABLE db1;
```

创建好表格后可以使用``INSERT INTO``命令向表格中插入数据：

```sql
INSERT INTO countries (name, continent, population, area, last_update) VALUES ("China", "Asia", 1433783686, 9706961, "2019-07-01");
INSERT INTO countries (name, continent, population, area, last_update) VALUES ("India", "Asia", 1352642280, 3287590, "2019-07-01");
INSERT INTO countries (name, continent, population, area, last_update) VALUES ("United States", "Americas", 327096265, 9372610, "2019-07-01");
```

插入数据完成后，使用下面的语句来到``countries``中查询数据：

```sql
mysql> SElECT * FROM countries; 
```

删除一行数据

```sql
DELETE FROM countries where name="India";
```

修改数据

```sql
UPDATE countries SET population=9999999 WHERE name="India";
```

添加一列或者删除一列到表格

```sql
ALTER TABLE potluck ADD gdp float;
```

```sql
ALTER TABLE potluck ADD gdp float AFTER name;
```

```sql
ALTER TABLE potluck DROP gdp;
```

## 使用 Python 来操作 MySQL

* <https://realpython.com/python-mysql/>

```
pip install mysql-connector-python
```

## Python Pandas 数据导出到 MySQL

```
pip install sqlalchemy pymysql
```

```python
from sqlalchemy import create_engine
engine = create_engine("mysql+pymysql://root:password@localhost/db1")
con = engine.connect()
df.to_sql('df', con=con, if_exists='replace',index=False)
```

```python
from sqlalchemy import create_engine, text
engine = create_engine("mysql+pymysql://root:password@localhost/db1")
result = engine.execute(text("SELECT * FROM countries;"))
for row in result.fetchall():
    print(row)
```

---

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

## 参考

* [CS61A disc10: Introduct SQL](https://inst.eecs.berkeley.edu/~cs61a/sp18/disc/disc10.pdf)
* <https://www.digitalocean.com/community/tutorials/a-basic-mysql-tutorial>
* <https://realpython.com/pandas-read-write-files/#sql-files>
* <https://hackersandslackers.com/python-database-management-sqlalchemy/>
* <https://hackersandslackers.com/python-mysql-pymysql/>
