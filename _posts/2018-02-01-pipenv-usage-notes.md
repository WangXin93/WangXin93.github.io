---
layout: post
title:  "Pipenv 速成指南"
date:   2018-02-01 17:25:46 +0800
categories: Python
---

## 前言
`pipenv`是`python`项目的依赖管理器，近来社区不断推广使用之，比如董伟明的[这篇](http://www.dongwm.com/archives/%E4%BD%BF%E7%94%A8pipenv%E7%AE%A1%E7%90%86%E4%BD%A0%E7%9A%84%E9%A1%B9%E7%9B%AE/), 不光介绍了`pipenv`的特性，还介绍了一个利用`pipenv`的特性来卸载已安装的包及其所有依赖项的方法，点赞。本文为`pipenv`的速成介绍，适合熟悉`virtualenv`的用户，可以帮助`python`用户从`virtualenv`平滑过渡到`pipenv`。

---

## 安装pipenv
`pipenv`可以用`pip`安装，过程非常简单直接。这里以Mac为例：
```bash
$ brew install python3
$ pip3 install pipenv --user #  安装在个人目录下
$ export PATH="/Users/username/Library/`python`/3.6/bin:$PATH" # 将pipenv路径加入环境变量
```

---

## 基本使用

# 1. 创建虚拟环境
通过下面语句可以分别创建`python3`, `python2`, `python3.6`虚拟环境。
```bash
$ pipenv --three
$ pipenv --two
$ pipenv --python 3.5
```
如果成功执行，可以看到类似下面的消息：
```bash
Virtualenv location: /home/wangx/.local/share/virtualenvs/testpipenv-kyMeQK-Y
Creating a Pipfile for this project…
```
同时目录中会多出一个`Pipfile`文件，该命令的作用类似于`$ virutalenv .env`。

# 2. 安装依赖项
在有`Pipfile`的目录执行下面命令会安装存储于`Pipfile`文件中的依赖项，作用类似于`$ pip install -r requirements.txt`。
```bash
$ pipenv install
```
成功执行该命令可以发现目录中多了一个`Pipfile.lock`文件。

如果目录没有`Pipfile`，该命令会自动先创建一个虚拟环境和`Pipfile`，然后安装依赖项。

如果除了`Pipfile`中的包还有其他的包需要安装，使用下面的命令。

```bash
$ pipenv install flask
```

# 3. 进入虚拟环境
使用下面命令可以进入新建的虚拟环境。作用类似于`$ source .env/bin/active`。
```bash
$ pipenv shell
```
执行完成后发现命令行提示符号变为类似如下形式：
```bash
(testpipenv-kyMeQK-Y) wangx test_pipenv $ 
```

# 4. 查看已安装依赖项
```bash
$ pipenv graph
```

# 5. 退出虚拟环境
使用`exit`可以退出虚拟环境。可以发现命令行提示符号变为正常形式。
```bash
(testpipenv-kyMeQK-Y) wangx test_pipenv $ exit
exit
wangx test_pipenv $
```
至此利用`pipenv`实现`python`虚拟环境的工作流程介绍完毕。相信越来越多的`python`用户在熟悉`pipenv`之后会选择使用它作为自己的好搭档。

# 6. 其他功能
查看`pipenv`文档帮助。网页文档的链接在[这里](https://docs.pipenv.org/)。
```bash
pipenv --man
```
用`Flake8`检查`python`代码规范。
```bash
pipenv check --style project.py
```

