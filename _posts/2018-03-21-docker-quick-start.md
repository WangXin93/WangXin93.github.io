---
layout: post
title:  "Docker 实用指南"
date:  2018-03-21 14:12:36 +0800
categories: Linux
---

## 前言
实用Docker可以有效保证软件运行环境和开发环境的一致，有效避免了开发者努力开发出的功能在上线时却状况百出，下面来一起学习如何使用它！

## 安装Docker
```bash
$ sudo apt-get install docker.io
```
[菜鸟教程](http://www.runoob.com/docker/ubuntu-docker-install.html)为ubuntu，windows，mac均记录了详细的安装教程。

**注意**：
* 对于win10家庭版，需要按照win7的教程安装。
* 国内推荐修改镜像地址来加速拉取镜像，具体参考菜鸟教程

## 使用Docker 
# 1. 修改当前用户组
Docker命令默认需要root权限，也就是说每个指令需要sudo前缀，非常的麻烦。解决这个麻烦的方法是将当前用户加到`docker`用户组，具体方法是：
```bash
$ sudo usermod -aG docker ${USER}
```
之后要应用新的组，需要重新登陆服务器或者输入下面内容：
```bash
$ su - ${USER}
```
这里需要你的登陆密码。之后，你可以通过下面方法来确认当前用户加入到了`docker`组：
```bash
$ id -nG
wangx sudo docker
```
确认当前用户已经加入到`docker`组.

# 2. Docker命令
Docker命令的基本语法组成为：
```bash
$ docker [option] [command] [arguments]
```
输入`docker`回车可以列出所有的docker子命令，使用：
```bash
$ docker docker-subcommand --help
```
可以获取子命令的帮助，使用`docker info`可以获取系统信息。

# 3. 使用Docker镜像工作
Docker容器从Docker镜像中工作，它默认从Docker hub拉取这些需要的镜像。运行Docker容器的大多数应用和linux的发行版所需要的镜像image都能在Docker hub找到。
为了检查你是否能从Docker hub下载镜像，使用下面指令：
```bash
$ docker run hello-world
```
成功运行后会看到一些欢迎信息，'Hello from Docker!...balabala'。使用docker和`search`子命令，可以搜索镜像，比如搜索ubuntu镜像使用：
```bash
$ docker search ubuntu
```
可以看到ubuntu镜像的搜索结果，然后当你确定了你想用的镜像的时候，使用`pull`子命令，例如：
```bash
$ docker pull ubuntu
```
当镜像下载完成后，你可以使用下载好的镜像和`run`子命令来运行一个容器，如果镜像不存在，docker会先下载这个镜像：
```bash
$ docker run ubuntu
```
要检查当前有那些镜像已经下载到了当前计算机上，使用：
```bash
$ docker images
```
运行容器所使用的镜像可以被修改从而生成新的镜像，新的镜像可以上传或者说push到Docker hub上用来分享。

# 4. 运行Docker容器
之前的`hello-world`程序运行后就退出了，实际上，Docker容器还有更强大的功能，它们可以变得可交互，就像一台虚拟机一样，不过比虚拟机更加节省资源。

使用下面的指令可以使用ubuntu镜像来运行容器，`-i`和`-t`选项可以赋予你以交互式shell形式进入容器的权限：
```bash
$ docker run -it ubuntu
```
然后你的shell提示符会反映出你现在正在容器中，它的形式是这样的：
```bash
root@d9b100f2f636:/#
```
提示符的格式是用户加上容器id，当前用户是root。现在你可以在容器中运行命令，比如，让我们来更新容器中包数据库，并安装nodejs：
```bash
$ apt-get update
$ apt-get install -y nodejs
```

# 5. 提交容器中的变化到Docker镜像
当你启用一个Docker镜像的时候，你可以像在虚拟机中一样创建，修改，删除文件，这些改动只会被保存在容器中。你可以启动或者停止它，但是一旦你使用`docker rm`命令摧毁它的时候，这些变化就会消失。那么如何将容器中的状态保存为镜像呢？

在上面的例子中，当nodejs安装到ubuntu容器中后，你现在拥有一个不同于开始的时候的运行在镜像上的容器。为了保存现在容器中的状态为新的镜像，首先要从它里面退出：
```bash
$ exit
```
将这些变化提交到新的Docker镜像实例使用下面的命令：其中`-m`参数是记录了本次提交的备注信息，而`-a`参数用来定义作者，`container-id`是需要提交的容器的id，`repository`通常是你的Docker hub的用户名，除非你在Docker hub上创建了额外的仓库。
```bash
$ docker commit -m "What did you do to the image" -a "Author Name" container-id repository/new_image_name
```
举一个具体的例子：
```bash
$ docker commit -m "added node.js" -a "Sunday Ogwu-Chinuwa" d9b100f2f636 finid/ubuntu-nodejs
```
**注意**：这里提交的镜像只是保存在本地的镜像

当这个操作完成以后，使用`docker images`可以看到新的镜像已经被添加了进去。下一次需要运行装有nodejs的ubuntu容器的时候，就可以使用这个新的镜像了。除了这种方法，镜像还可以通过DockerFile来创建。

# 6. 列出Docker容器
当使用docker一段时间后，你就会有很多active和inactive的容器，使用下面的指令来列出所有active的容器：
```bash
$ docker ps
```
如果要观察所有active和inactive的容器，则使用
```bash
$ docker ps -a
```
如果要观察最近创建的容器，使用：
```bash
$ docker ps -l
```
停止一个正在运行的active状态的容器使用命令：
```bash
$ docker stop container-id
```
其中`container-id`可以通过`docker ps`命令来找到。

# 7. 本地镜像推到Docker仓库
创建完的镜像当然想要分享给朋友，一个方法是通过上传或者说push到Docker Hub。要想push image首先需要在[Docker hub](https://hub.docker.com/)注册账号。然后通过指令登陆Docker hub：
```bash
$ docker login -u docker-registry-username
```
在根据提示输入完密码后，可以使用下面指令来push镜像：
```bash
$ docker push docker-registry-username/docker-image-name
# 具体来说例如
$ docker push wangxin93/ubuntu-nodejs
$ docker push wangxin93/ubuntu-python3
```
然后等待push完成就可以在Docker hub上看见自己的image。

# 8. 使用Dockerfile

```
docker build -t tensorflow:1.6.0 .
```

# 9. 容器与本地系统的关联

```
docker run -it \
    --runtime=nvidia \
    -p 8888:8888 \
    -p 6006:6006 \
    -v $CURRENT:/root/workdir \
	tensorflow:0.11
```

## 参考链接
* [菜鸟教程Docker安装](http://www.runoob.com/docker/ubuntu-docker-install.html)
* [How To Install and Use Docker on Ubuntu 16.04](https://www.digitalocean.com/community/tutorials/how-to-install-and-use-docker-on-ubuntu-16-04)
* [Docker部署 - Django+MySQL+uWSGI+Nginx](https://zhuanlan.zhihu.com/p/29609591)
* [Other Docker tutorials in the DO Community](https://www.digitalocean.com/community/tags/docker?type=tutorials)
* [Docker blog gives latest information](https://blog.docker.com/)
