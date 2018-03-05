---
layout: post
title:  "Mysql使用笔记"
date:   2018-03-05 16:27:14 +0800
categories: Python
---

## 前言
Mysql使用笔记。

---

## 安装mysql
```bash
$ sudo apt-get install mysql-server
```

## 连接数据库
```bash
$ mysql -u user -p
mysql> QUIT # 退出连接
-u 表示用户名
-p 表示登录密码
```

---

## 查看数据库
```sql
mysql> SHOW DATABASE;
```

## 创建数据库
```sql
mysql> CREATE DATABASE db1;
```
## 使用数据库
```sql
mysql> USE db1;
```
## 显示当前数据库中所有表
```sql
mysql> TABLES;
```

---

## 表操作
```sql
mysql> SElECT * FROM tb1; 
```
