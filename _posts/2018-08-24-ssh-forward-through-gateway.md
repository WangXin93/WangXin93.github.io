---
layout: post
title:  "SSH穿越跳板机登陆内网机器"
date: 2018-08-24 10:38:00 +0800
categories: Linux
---

## 前言
堡垒机，即在一个特定的网络环境下，为了保障网络和数据不受来自外部和内部用户的入侵和破坏，而运用各种技术手段实时收集和监控网络环境中每一个组成部分的系统状态、安全事件、网络活动，以便集中报警、及时处理及审计定责。
但是堡垒机的使用给用户登陆，上传下载文件，开启服务带来了更多的麻烦。那么如何解决呢？

## 通过跳板机登陆到内网机器的方法

### 方法1：登陆两次ssh
```
ssh <userb>@<ipb> -p <portb>
[Enter]<pwdb>
[type :]ssh <userc>@<ipc> -p <portc> [default: 22]
[Enter]<pwdc>
```

### 方法2：ssh端口前传
```
ssh -L <porta>:<ipc>:<portc> <userb>@<ipb> -p <portb>
[Enter]<pwdb>
[open a new terminal]
ssh <userc>@localhost -p <porta>
[Enter]<pwdc>
```
其中：A: local host, B: auth host, C: remote host

下面来一个具体的例子，比如我想穿越192.168.182.36这个中间机器登陆到内网中的172.28.230.11，首先开启一个终端输入：

```
ssh -L 122:172.28.230.11:22 lyx@192.168.182.36
```

这里开启了一个ssh隧道通过中间机器192.168.182.36，到最终的host也就是172.28.230.11。这会在localhost上开启122端口并与最终机器172.28.230.11的22端口连接，传输中穿过了中间机器。
接着就可以利用locahost的122端口进行ssh和sftp到最终的机器：

```
ssh wangx@localhost -p 122
sftp -P 122 wangx@localhost
```

注意到ssh和sftp定义端口的参数一个是`-p`，一个是`-P`。

## 通过隧道的tensorboard服务。

类似的道理，首先将本地的16006端口通过“隧道”（192.168.182.36）连接到内部的机器的6006端口：

```
ssh -NfL 16006:172.28.231.16:6006 lyx@192.168.182.46
```

然后，需要在内部机器开启tensorboard服务：

```
tensorboard --logdir=results
```

你知道本地的16006端口可以得到内部机器6006端口发来的消息，于是在浏览器上输入地址`localhost:16006`，然后就可以在本地监控内网机器的训练情况啦！！！

同样的，开启一个Jupyter服务也是可以轻松实现的，动手试试吧！


## 参考

* [SSH 跳板机（堡垒机）登录大法](https://blog.csdn.net/Albert0420/article/details/51729583)
* [Must I sftp to an intermediate server?](https://superuser.com/questions/262926/must-i-sftp-to-an-intermediate-server)
* [從家裡存取 Server端的 Tensorboard 服務](https://github.com/JeremyCCHsu/SLAM-Tensorflow-Tutorial/blob/master/Note90-Remote-Access.md)
