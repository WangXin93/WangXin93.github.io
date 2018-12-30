---
layout: post
title:  "开始使用nginx吧"
date: 2018-03-30 13:26:27 +0800
categories: Linux
toc: true
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

## 配置一个简单代理
首先在上面的nginx配置文件的基础上再添加一个`server`块：
```
server {
    listen 8080;
    root /data/up1;

    location / {
    }
}
```
这个块的作用是创立了一个服务于8080端口的服务器，所有的请求会被映射到本地目录的`/data/up1`位置上。如果listen指令没有被添加，那么server会服务于默认的80端口。在`/data/up1`位置创建一个`index.html`。注意这里`root`指令放在了`server`上下文中，这样的`root`指令适用于`location`块被用来服务请求但是又没有自己的`root`指令的情况。

下面，修改上一节内容给出的`server`配置让它成为一个代理服务器。首先在第一个`location`模块中，将`proxy_pass`指令和被代理的服务器的协议，名称，端口写为参数：
```
server {
    location / {
        proxy_pass http://localhost:8080;
    }

    location /images/ {
        root /data;
    }
}
```
然后我们将修改第二个`location`块，它目前的作用是将所有`/images/`前缀的请求映射到`/data/images`目录。我们希望将它改为匹配所有以图片文件扩展为结尾的请求：
```
location ~ \.(gif|jpg|png)$ {
    root /data/images;
}
```
这里的参数是匹配所有以`.gif`，`.jpg`，`.png`结尾的URL。使用`~`来告诉nginx后面是一个正则表达式。对应的请求会被映射到`/data/images`目录。

当nginx要去选择一个`location`来服务一个请求的时候，它首先检查给出具体URL前缀的指令，记住匹配的指令中最长的那个，然后去检查正则表达式。如果有可以匹配的正则表达式，nginx就会选择这个`location`，否则会选择之前记住的那个。

代理服务器的完整配置如下：
```
server {
    location / {
        proxy_pass http://localhost:8080/;
    }

    location ~ \.(gif|jpg|png)$ {
        root /data/images;
    }
}
```
这个服务器可以将所有以`.gif`，`.jpg`，`.png`结尾的URL映射到`/data/images`目录，其它的请求会传递到被代理的服务器那里。

记住要先给nginx传递`reload`信号然后配置才会生效。

此外还有[更多指令](http://nginx.org/en/docs/http/ngx_http_proxy_module.html)可以用用来配置代理连接。

## 参考资料
* [Nignx beginner's guide](http://nginx.org/en/docs/beginners_guide.html)
* [Start/Restart/Stop Nginx Web Server](https://www.cyberciti.biz/faq/nginx-restart-ubuntu-linux-command/)
