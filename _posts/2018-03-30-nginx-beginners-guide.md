---
layout: post
title:  "开始使用nginx吧"
date: 2018-03-30 13:26:27 +0800
categories: Linux
---

## 前言
Nginx是一个服务器，可以帮助我们建立服务来回应静态文件的请求, 或者动态的请求。通过一个简单的任务来了解nginx可以做什么吧！

## 安装nginx
对于Ubuntu系统，使用安装命令即可安装nginx：
```
$ sudo apt-get install nginx
```
安装完成后从浏览器访问`localhosta`, 就可以看到nginx的欢迎页面。

## 配置nginx
只有欢迎页面当然是不够的。让我们来配置nginx定制自己的文件服务吧！

首先创建两个文件夹`/data/www/`，和`/data/images/`，作为存放文件的目录。在其中创建一些内容比如创建`/data/www/index.html`，`/data/images/flowers.jpg`。创建什么内容是读者的自由:)

Nignx的配置文件位于`/etc/nginx/nginx.conf`，使用`vim`或者其它编辑器打开后可以发现已经有很多内容。先不要管它们，把它们都注释掉。下面开始写我们自己的配置：
```
http {
    server {
    }
}
```
Nginx的配置文件中`{ }`包含的部分被称为块指令（block directives），一个块中包含另一个块的话，它就被称为一个context，例如这里server是在http的context中，而http不在任何块中，所以称它在main context中。

下面添加location块到server context中：
```
location / {
    root /data/www;
}
```
在Nginx中，一条指令directive包含名称和参数值，格式如这里的`root /data/www;`，location指令定义了用`/`来对比请求中的URL。如果请求中的URL和`/`匹配成功，那么URL就会被加入到`root`指令后面对于的路径，这里是`/data/www`，这样就形成了请求本地文件系统的路径。如果URL和多个`location`匹配，那么nginx会选择最长的那个`location`块。

下面再添加一个`location`块：
```
location /images/ {
    root /data;
}
```
这个`location`块会匹配以`/images/`为开始的URL。（`location \`也满足这个匹配，但是nginx会选择`location`后面路径更长的那个)

这里还需要配置events快来避免运行时候的错误，此时，完整的nginx.conf的内容为
```
events {
    worker_connections 768;
    # multi_accept on;
}

http {
    server{
        location / {
            root /data/www;
        }

        location /images/ {
            root /data;
        }
    }
}
```
这已经是一个能正常工作的服务器配置了，服务器能监听通过`http://localhost/`来访问本地机器的80端口。如果有云服务器并开启了80端口，那么访问`http://<公网ip>`那么就能得到服务器的响应。访问`/images/`开始的URL，服务器会给出`/data/images`目录下的文件。比如访问`http://localhost/images/flowers.jpg`，那么nginx会回应`/data/images/flowers.jpg`文件。对于不是以`/images/`开始的URL，则会被映射到`/data/www`目录。比如访问`http://localhost/seme/example.html`，那么nginx会返回`/data/www/some/example.html`文件。

要应用这个配置文件到nginx，首先确保nginx已经打开，然后执行：
```
$ nginx -s reload
```
其中`-s`的意思是signal，它的选择包括:

* stop — fast shutdown
* quit — graceful shutdown
* reload — reloading the configuration file
* reopen — reopening the log files

该命令对nginx主进程送出了一个信号，要求重新加载配置文件。关于`-s`的用法比如关闭nginx：
```
ps -ax | grep nginx     # 找到运行中的nginx进程
kill -s QUIT 1628       # 使用kill传递signal
```


## 参考资料
* [Nignx beginner's guide](http://nginx.org/en/docs/beginners_guide.html)
* [Start/Restart/Stop Nginx Web Server](https://www.cyberciti.biz/faq/nginx-restart-ubuntu-linux-command/)
