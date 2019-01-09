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

## Get Started

首先需要新建一个文件夹，将它起名为你的项目名字，比如`composetest`。

创建一个`app.py`文件，执行这个文件将会启动application。作为例子，可以先写上下面的内容。

```python
import time

import redis
from flask import Flask


app = Flask(__name__)
cache = redis.Redis(host='redis', port=6379)


def get_hit_count():
    retries = 5
    while True:
        try:
            return cache.incr('hits')
        except redis.exceptions.ConnectionError as exc:
            if retries == 0:
                raise exc
            retries -= 1
            time.sleep(0.5)


@app.route('/')
def hello():
    count = get_hit_count()
    return 'Hello World! I have been seen {} times.\n'.format(count)

if __name__ == "__main__":
    app.run(host="0.0.0.0", debug=True)
```

然后你需要写一个`Dockerfile`来创建Docker Image。这个Image包含着appliation需要的环境和依赖项。在这里，可以这样写：

```dockerfile
FROM python:3.4-alpine
ADD . /code
WORKDIR /code
RUN pip install -r requirements.txt
CMD ["python", "app.py"]
```

还差一步了！新建一个文件叫`docker-compose.yml`，粘贴上以下内容：

```yml
version: '3'
services:
  web:
    build: .
    ports:
     - "4000:5000"
  redis:
    image: "redis:alpine"
```

Compose可以帮助我们开启多个container，这里的`docker-compose.yml`的含义就是定义了两个services：`web`和`redis`。

其中，`web` service 使用的是`Dockerfile`创建的Image，`redis` servie 使用的是从Docker Hub上拉取的公共的Image。

注意这里`web` service将container中的5000端口映射到了host machine的4000端口。

最后，使用`docker-compose up`来运行这个application。你可以从浏览器中访问`http://0.0.0.0:5000/`来查看这个简单的application的运行效果。


## 参考

* [Docker docs](https://docs.docker.com/compose/overview/)
* [Get Started with Docker Compose](https://docs.docker.com/compose/gettingstarted/)