---
layout: post
title: "使用Docker Compose"
date: 2019-01-08 19:39:00 +0800
categories: Linux
toc: true
---

## 前言

Docker compose是用来定义和运行多个Docker容器的应用。当你使用compose的时候，只需要创建一个YAML文件来配置你的应用服务，然后只要使用一行命令你就可以启动配置中的所有应用。

## 方法

使用Compose基本按下面3步进行：

1. 为你的应用创建一个`Dockerfile`来定义它的环境。
2. 将组成你的应用的services写到`docker-compose.yml`中，所以它们可以在一个独立的环境中一起运行。
3. 执行`docker-compose`然后Compose会帮你运行起整个应用。

一个`docker-compose.yml`的例子如下：

```yaml
version: '3'
services:
  web:
    build: .
    ports:
    - "5000:5000"
    volumes:
    - .:/code
    - logvolume01:/var/log
    links:
    - redis
  redis:
    image: redis
volumes:
  logvolume01: {}
```

## 参考

* [Docker docs](https://docs.docker.com/compose/overview/)