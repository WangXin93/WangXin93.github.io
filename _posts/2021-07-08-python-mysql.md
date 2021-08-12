---
layout: post
title:  "使用Python操作MySQL的方法介绍"
date:   2021-07-08 11:56:09 +0800
categories: SQL Python
toc: true
---

> 许多软件应用都需要连接数据库来进行数据的交互从而实现强大的功能。本篇博客将会介绍如何使用 Python 语言操作 MySQL数据库，包括如何将软件和数据库进行连接，如何进行数据的增删查改，如何处理访问数据库时候的异常情况，以及常用的代码模版。

## 前言

### MySQL 简介

SQL 全名为 [Structured Query Language](https://en.wikipedia.org/wiki/SQL) 是广泛用于管理关系型数据库的编程语言。SQL 语言服从于[SQL 标准](https://docs.oracle.com/cd/B28359_01/server.111/b28286/intro002.htm)，但是不同风格的数据库管理系统在实现这个标准的时候会有自己的风格，与标准有不同程度的偏离，流行的数据库管理系统包括 [MySQL](https://www.mysql.com/)，[PostgreSQL](https://www.postgresql.org/)，[SQLite](https://www.sqlite.org/index.html) 和 [SQL Server](https://www.microsoft.com/en-us/sql-server/sql-server-2019)。

自1995年开源以来， MySQL 在 SQL 方案中迅速称为主要选择。MySQL 是 Oracle 生态中的一部分，它的核心是免费的，但是也有需要付费的插件。目前主要的技术公司包括 Google，LinkedIn，Uber，Netflix，Twitter。MySQL 被选择的原因包括：开源社区的大量支持，易于安装而且有第三方工具支持（比如[phpMyAdmin](https://www.phpmyadmin.net/)），速度优势，用户优先（包含设置密码的脚本而不是使用配置文件）。

MySQL 也有一些问题，比如[并发读写问题](https://dev.mysql.com/doc/refman/5.7/en/concurrent-inserts.html)，如果你的软件有大量用户同时写入数据，你应该考虑其它方案比如 PostgreSQL。

在 2010 年 MySQL 最大的竞争独守 Orcale 收购了 Sun Micosystems 和 MySQL，开发者担心 Oracle 会毁掉 MySQL 的未来，因此 MySQL 的作者 [Michael Widenius](https://en.wikipedia.org/wiki/Michael_Widenius)，开发了一个分支并成立了 [MariaDB](https://mariadb.org/) 基金会，致力于 MySQL 的安全访问和永久免费使用。MySQL 有一些特性只有在付费的情况下才能使用，同时 MariaDB 页提供了一些 MySQL 不包含的功能，比如 [distributed SQL](https://mariadb.com/resources/blog/mariadb-adds-xpand-for-distributed-sql/) 和 [columnar storage](http://www.inf.ufpr.br/eduardo/ensino/ci809/papers/p967-abadi.pdf)。关于 MySQL 和 MariaDB 的异同可以在[MariaDB的网站](https://mariadb.com/products/mariadb-platform/comparison/)看到。

### Python MySQL 驱动

[数据库驱动](https://docs.microsoft.com/en-us/sql/odbc/reference/dbms-based-drivers)让软件应用能够连接和操作数据库系统。对于 Python 语言来说，需要使用不同的驱动来操作不同类型的数据库系统，[sqlite3](https://docs.python.org/3/library/sqlite3.html) 用于 SQLite，[psycopy](https://www.psycopg.org/docs/) 用于 PostgreSQL，[MySQL Connector/Python](https://github.com/mysql/mysql-connector-python) 用于 MySQL。[PEP 249](https://www.python.org/dev/peps/pep-0249/) 定义了Python Database API，所有的 Python 数据库驱动都要遵守。

Python 用于 MySQL 的驱动目前有3种：

* mysqlclient：目前最快的MySQL驱动，需要``mysql-connector-c``库才能工作
* PyMySQL：一个完全使用Python的方案，如果不能安装 ``libmysqlclient`` 那么可以使用该方案
* mysql-connector-python：由 Oracle 团队开发的 MySQL 驱动，完全使用 Python 编写，性能相对较差。

## 连接到 MySQL 数据库

这里使用``pymysql``第三方库作为数据库驱动，它可以通过``pip``来进行安装：

```
pip install pymysql
```

MySQL 是一个基于服务器的数据库管理系统。一个服务器可以包含数据库。为了和这些数据库进行交互，你需要先连接到这个服务器。Python 程序连接到 MySQL 数据库的基本工作流程为：

* 连接到 MySQL 服务器
* 创建数据库
* 连接到新建的或者已有的数据库
* 执行 SQL 语句和得到结果
* 如果有表格变动，通知到服务器
* 关闭到 MySQL 服务器的连接

第一步是连接到 MySQL 服务器，你需要使用``connect()``方法，这个方法会需要你的user，passwrod，然后返回一个connection对象，你可以使用控制台的输入将这些身份信息输入到``connect()``方法中去：

```python
from getpass import getpass
from mysql.connector import connect, Error

try:
    with pymysql.connect(
        host="localhost",
        user=input("Enter username: "),
        password=getpass("Enter password: "),
    ) as connection:
        print(connection)
except pymysql.Error as e:
    print(e)
```

上面的代码有几个要点值得注意：

* 在连接 MySQL 服务器的过程中，你应该一直使用 try excpet 语句来捕捉其中发生的异常。
* 一定要记得在访问完数据后关闭连接，防止这个打开的连接带来不必要的错误。你可以像上面的片段一样使用 with 语句来构建自动关闭连接的过程。
* 不要把你的身份信息暴露在 Python 脚本中，这会带来严重的安全问题。你可以 getpass

在连接到 MySQL 数据库后，下一步介绍如何在数据库中创建表。如果希望创建一个表名称为``movies_db``，SQL 对应的语句为：

```sql
CREATE DATABASE movies_db;
```

如果希望在 Python 中运行 SQL 查询语句，你需要使用 [cursor](https://en.wikipedia.org/wiki/Cursor_(databases))，它是一个访问数据库的抽象对象。PyMySQL 提供了创建 cursor 的方法，代码`` curosr = connection.cursor() ``会返回一个 cursor 对象。需要执行的 SQL 语句以字符串形式传入到 `` cursor.execute()`` 方法中。在数据库中创建一个名为``movies_db``的数据库的代码片段为：

```python
try:
    with pymysql.connect(
        host="localhost",
        user=input("Enter username: "),
        password=getpass("Enter password: "),
    ) as connection:
        with connection.cursor() as cursor:
            cursor.execute('CREATE DATABASES movie_db')
except pymysql.Error as e:
    print(e)
```

PyMySQL会自己在执行语句最后加上``;``，所以这里可以不用写分号。执行完上面的代码后，MySQL 服务器中就会新创建一个名为``movies_db``的数据库。你可以用内容为``SHOW DATABASES;``的SQL语句来查询当前有哪些数据库，在 Python 中，你可以使用下面的代码来得到所有数据库的名字：

```python
with connection.cursor() as cursor:
    cursor.execute('SHOW DATABASES')
    for db in cursor:
        print(db)
# ('information_schema',)
# ('movies_db',)
# ('mysql',)
# ('performance_schema',)
# ('sys',)
```

## 创建，修改，删除表格

你可以使用[DDL](https://en.wikipedia.org/wiki/Data_definition_language)来CREATE，DROP 或者 ALTER 表格。下面的代码会展示如何创建电影评分系统数据库 ``movies_db``中的表格movies，reviewers和ratings，这3个表格的关系如下：

![schema](https://files.realpython.com/media/schema.2e80e67d2ae1.png)

这3个表格相互关联，movies 和 reviewers 是一个 many-to-many 的关系，一个电影可以被多个人评价，一个人也可以评价多个电影。

```python
create_movies_table_query = """
CREATE TABLE movies(
    id INT AUTO_INCREMENT PRIMARY KEY,
    title VARCHAR(100),
    release_year YEAR(4),
    genre VARCHAR(100),
    collection_in_mil INT
)
"""
create_reviewers_table_query = """
CREATE TABLE reviewers (
    id INT AUTO_INCREMENT PRIMARY KEY,
    first_name VARCHAR(100),
    last_name VARCHAR(100)
)
"""
create_ratings_table_query = """
CREATE TABLE ratings (
    movie_id INT,
    reviewer_id INT,
    rating DECIMAL(2,1),
    FOREIGN KEY(movie_id) REFERENCES movies(id),
    FOREIGN KEY(reviewer_id) REFERENCES reviewers(id),
    PRIMARY KEY(movie_id, reviewer_id)
)
"""
try:
    with pymysql.connect(
        host="localhost",
        user=input("Enter username: "),
        password=getpass("Enter password: "),
        database="movies_db",
    ) as connection:
        with connection.cursor() as cursor:
            cursor.execute(create_movies_table_query)
            cursor.execute(create_reviewers_table_query)
            cursor.execute(create_ratings_table_query)
            connection.commit()
except pymysql.Error as e:
    print(e)
```

使用 PyMySQL 创建这三个表格的代码如上。首先需要连接到一个数据库，这个通过定义``connect()``中的参数``database``来实现。然后使用``execute()``方法来执行 SQL 语句。[``connection.commit()``](https://dev.mysql.com/doc/connector-python/en/connector-python-api-mysqlconnection-commit.html)会给MySQL服务器发送一个 COMMIT 指令，来提交当前的 [transaction](https://dev.mysql.com/doc/refman/8.0/en/glossary.html#glos_transaction)，对于 [transactional storage engines](https://dev.mysql.com/doc/refman/8.0/en/storage-engines.html) ，每次修改数据或者表格，调用这个方法非常重要。一个cursor可以执行多次SQL语句，然后commit一次transaction。你可以使用[``rollback()``](https://dev.mysql.com/doc/connector-python/en/connector-python-api-mysqlconnection-rollback.html)方法来向 MySQL Server 发送 ROLLBACK 指令来删除来自一个transaction的数据改变。

如果希望查看刚才创建的3个表格的属性，可以使用``DESCRIBE <table_name>;`` SQL 语句。如果希望从cursor对象总得到返回的结果，需要使用[``cursor.fetchall()``](https://dev.mysql.com/doc/connector-python/en/connector-python-api-mysqlcursor-fetchall.html)：

```python
try:
    with pymysql.connect(
        host="localhost",
        user=input("Enter username: "),
        password=getpass("Enter password: "),
        database="movies_db",
    ) as connection:
        with connection.cursor() as cursor:
            cursor.execute("DESCRIBE movies")
            for row in cursor:
                print(row)
except pymysql.Error as e:
    print(e)
```

代码执行成功后，你会得到描述``movies``表格的信息，比如每一列的数据类型，是否是primary key等。

[``ALTER TABLE``](https://dev.mysql.com/doc/refman/8.0/en/alter-table.html)语句可以用来改变表格的数据类型。如果希望将 movies 表格中的 ``collection_in_mil`` 一栏从 INT 变成 DECIMAL 类型，可以使用下面的代码：

```python
alter_table_query = """
ALTER TABLE movies
MODIFY COLUMN collection_in_mil DECIMAL(4,1)
"""
show_table_query = "DESCRIBE movies"
try:
    with pymysql.connect(
        host="localhost",
        user=input("Enter username: "),
        password=getpass("Enter password: "),
        database="movies_db",
    ) as connection:
        with connection.cursor() as cursor:
            cursor.execute(alter_table_query)
            cursor.execute(show_table_query)
            results = cursor.fetchall()
            for row in results:
                print(row)
            for row in cursor:
                print(row)
except pymysql.Error as e:
    print(e)
```

[``DROP TABLE``](https://dev.mysql.com/doc/refman/8.0/en/drop-table.html)语句可以用来删除表格。删除表格是一个不可逆的过程，如果执行了下面的代码，那么你就需要使用``CREATE TABLE``重新创建表格。

```python
drop_table_query = "DROP TABLE ratings"
with connection.cursor() as cursor:
    cursor.execute(drop_table_query)
```

## 向表格输入数据

向表格插入数据有两种方法：

* ``execute()`` 适合小规模数据，所有数据都可以手动输入完。
* ``executemany()`` 在现实场景用的更多。

使用``execute()``方法执行 INSERT INTO 语句就可以插入一次数据到表格。例如要插入数据到已经建好的 movies 表格中，我们需要为每条数据提供 ``id``, ``title``, ``release_year``, ``genre``, ``collection_in_mil``，自动增加的一列不同记录数据。插入多条数据的代码如下：

```python
insert_movies_query = """
INSERT INTO movies (title, release_year, genre, collection_in_mil)
VALUES
    ("Forrest Gump", 1994, "Drama", 330.2),
    ("3 Idiots", 2009, "Drama", 2.4),
    ("Eternal Sunshine of the Spotless Mind", 2004, "Drama", 34.5),
    ("Good Will Hunting", 1997, "Drama", 138.1),
    ("Skyfall", 2012, "Action", 304.6),
    ("Gladiator", 2000, "Action", 188.7),
    ("Black", 2005, "Drama", 3.0),
    ("Titanic", 1997, "Romance", 659.2),
    ("The Shawshank Redemption", 1994, "Drama",28.4),
    ("Udaan", 2010, "Drama", 1.5),
    ("Home Alone", 1990, "Comedy", 286.9),
    ("Casablanca", 1942, "Romance", 1.0),
    ("Avengers: Endgame", 2019, "Action", 858.8),
    ("Night of the Living Dead", 1968, "Horror", 2.5),
    ("The Godfather", 1972, "Crime", 135.6),
    ("Haider", 2014, "Action", 4.2),
    ("Inception", 2010, "Adventure", 293.7),
    ("Evil", 2003, "Horror", 1.3),
    ("Toy Story 4", 2019, "Animation", 434.9),
    ("Air Force One", 1997, "Drama", 138.1),
    ("The Dark Knight", 2008, "Action",535.4),
    ("Bhaag Milkha Bhaag", 2013, "Sport", 4.1),
    ("The Lion King", 1994, "Animation", 423.6),
    ("Pulp Fiction", 1994, "Crime", 108.8),
    ("Kai Po Che", 2013, "Sport", 6.0),
    ("Beasts of No Nation", 2015, "War", 1.4),
    ("Andadhun", 2018, "Thriller", 2.9),
    ("The Silence of the Lambs", 1991, "Crime", 68.2),
    ("Deadpool", 2016, "Action", 363.6),
    ("Drishyam", 2015, "Mystery", 3.0)
"""
with connection.cursor() as cursor:
    cursor.execute(insert_movies_query)
    connection.commit()
```

一定要记得在修改数据的操作后面加上``connection.commit()``。

当数据量过大的时候，把所有数据都写在SQL语句不太方便，一般都会将数据存放在额外的文件。``executemany()``方法可以帮助你将文件数据中的每一条单独执行语句，你需要把每一次执行的语句和一个列表作为参数传入其中。代码例子如下：

```python
insert_reviewers_query = """
INSERT INTO reviewers
(first_name, last_name)
VALUES ( %s, %s )
"""
reviewers_records = [
    ("Chaitanya", "Baweja"),
    ("Mary", "Cooper"),
    ("John", "Wayne"),
    ("Thomas", "Stoneman"),
    ("Penny", "Hofstadter"),
    ("Mitchell", "Marsh"),
    ("Wyatt", "Skaggs"),
    ("Andre", "Veiga"),
    ("Sheldon", "Cooper"),
    ("Kimbra", "Masters"),
    ("Kat", "Dennings"),
    ("Bruce", "Wayne"),
    ("Domingo", "Cortes"),
    ("Rajesh", "Koothrappali"),
    ("Ben", "Glocker"),
    ("Mahinder", "Dhoni"),
    ("Akbar", "Khan"),
    ("Howard", "Wolowitz"),
    ("Pinkie", "Petit"),
    ("Gurkaran", "Singh"),
    ("Amy", "Farah Fowler"),
    ("Marlon", "Crafford"),
]
with connection.cursor() as cursor:
    cursor.executemany(insert_reviewers_query, reviewers_records)
    connection.commit()
```

代码中的``%s``是占位符，用来为字符串中的变量[保留位置](https://realpython.com/python-string-formatting/)。

SELECT 语句可以从表格中读取数据，对应的python代码片段为：

```python
select_movies_query = "SELECT * FROM movies LIMIT 5"
with connection.cursor() as cursor:
    cursor.execute(select_movies_query)
    result = cursor.fetchall()
    for row in result:
        print(row)
```

除了``fetchall()``，还有其它方法从 cursor 对象中取得结果：

* ``fetchone()``，只取得下一个结果，如果没有结果了返回 None。
* ``fetchmany(size=n)``，返回size个数的结果。默认size为1。

[UPDATE 语句](https://dev.mysql.com/doc/refman/5.7/en/update.html)可以用来更新表格数据。代码片段例子为：

```python
update_query = """
UPDATE
    reviewers
SET
    last_name = "Cooper"
WHERE
    first_name = "Amy"
"""
with connection.cursor() as cursor:
    cursor.execute(update_query)
    connection.commit()
```

[DELETE 语句](https://dev.mysql.com/doc/refman/5.7/en/delete.html)可以删除选中的数据。DELETE 操作非常危险，它是不可逆的操作，如果数据被删除，你得重新用INSERT INTO来插入。好的习惯是先用SELECT语句查询到哪些数据会被选中，然后再用DELETE语句删除：

```python
select_movies_query = """
SELECT reviewer_id, movie_id FROM ratings
WHERE reviewer_id = 2
"""
with connection.cursor() as cursor:
    cursor.execute(select_movies_query)
    for movie in cursor.fetchall():
        print(movie)
```

```python
delete_query = "DELETE FROM ratings WHERE reviewer_id = 2"
with connection.cursor() as cursor:
    cursor.execute(delete_query)
    connection.commit()
```

## 其它使用 Python 操作数据库的方法

[Object-relational mapping](https://en.wikipedia.org/wiki/Object-relational_mapping) 运行你使用面向对象的方法操作数据库。ORM 库将操作数据需要的代码封装起来，所有几乎用不到SQL代码。常用的Python ORM库有：

* [SQLAlchemy](https://docs.sqlalchemy.org/en/13/index.html)可以创建和不同数据库的引擎，包括MySQL，PostgreSQL，SQLite等。SQLAlchemy和[pandas](https://realpython.com/pandas-read-write-files/#sql-files)结合可以构建完整的数据处理流程。
* [peewee](https://docs.peewee-orm.com/en/latest/)是一个轻量快速的ROM库，如果只是想从MySQL中复制一些数据到CSV文件，可以考虑这个解决方案。
* [Django ORM](https://books.agiliq.com/projects/django-orm-cookbook/en/latest/introduction.html)是Django的功能之一，可以和不同数据库连接。

## 结论

使用 PyMySQL 可以访问和操作 MySQL 数据库。包括：

* 连接数据库，创建数据库
* 创建，修改，删除表格
* 插入，读取，修改，删除表格中的数据

使用这些功能可以帮助 Python 程序访问数据，构建不同的应用比如电影评分系统，学生选课系统，超市购物系统等等。

除了 MySQL 之外，Python 还能够访问其它数据库管理系统，比如 [MongoDB](https://realpython.com/introduction-to-mongodb-and-python/)，[PostgreSQL](https://realpython.com/python-sql-libraries/)。

## 参考

* <https://realpython.com/python-mysql/>
