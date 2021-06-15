---
layout: post
title:  "SSH远程远程服务器与配置"
date: 2018-05-02 10:15:05 +0800
categories: Linux
toc: true
---

## 前言
我们一般使用`PuTTY`等`SSH`客户端来远程管理`Linux`服务器。但是，一般的密码方式登录，容易有密码被暴力破解的问题。所以，一般我们会将`SSH`的端口设置为默认的`22`以外的端口，或者禁用`root`账户登录。其实，有一个更好的办法来保证安全，而且让你可以放心地用`root`账户从远程登录:**那就是通过密钥方式登录**。

## SSH Server設置方法

### 安裝openssh
使用apt安裝openssh：

```bash
$ sudo apt-get install openssh-server
```

可以通過`ps -e |grep ssh`來確認一下，如果看到sshd那说明ssh-server已经启动了。

### 添加用戶

```bash
# useradd subsir -m
# su subsir //切换到subsir用户，以下的操作必须用subsir账号操作，subsir必须有权限
```

### 建立密鑰對

```bash
$ ssh-keygen  <== 建立密钥对

Generating public/private rsa key pair.
Enter file in which to save the key (/root/.ssh/id_rsa): <== 按 Enter
Created directory '/root/.ssh'.
Enter passphrase (empty for no passphrase): <== 输入密钥锁码，或直接按 Enter 留空
Enter same passphrase again: <== 再输入一遍密钥锁码
Your identification has been saved in /root/.ssh/id_rsa. <== 私钥
Your public key has been saved in /root/.ssh/id_rsa.pub. <== 公钥
The key fingerprint is:
0f:d3:e7:1a:1c:bd:5c:03:f1:19:f1:22:df:9b:cc:08 root@host
```

### 在服務器上安裝公鑰
在需要被登錄的服務器上鍵入下面命令：

```bash
$ cd ~/.ssh
$ cat id_rsa.pub >> authorized_keys
```

如此便完成了公钥的安装。为了确保连接成功，请保证以下文件权限正确：

```bash
$ chmod 600 authorized_keys
$ chmod 700 ~/.ssh
```

### 設置ssh，打開密鑰登錄功能
使用sudo權限編輯`/etc/ssh/sshd_config`文件，進行如下設置：

```
RSAAuthentication yes
PubkeyAuthentication yes
```

可以通過該條內容設置是否允許root用戶通過ssh登錄：

```
PermitRootLogin yes
```

当你完成全部设置，并以密钥方式登录成功后，再禁用密码登录：

```
PasswordAuthentication no
```

最后，重启 SSH 服务：

```bash
$ sudo service sshd restart
```

### 將私鑰下載到客戶端，使用客戶端登錄服務器

* PuTTY

使用[`WinSCP`](https://winscp.net/eng/docs/lang:chs),`SFTP`等工具将私钥文件`id_rsa`下载到客户端机器上。然后打开`PuTTYGen`，单击`Actions`中的`Load`按钮，载入你刚才下载到的私钥文件。如果你刚才设置了密钥锁码，这时则需要输入。

载入成功后，PuTTYGen 会显示密钥相关的信息。在`Key comment`中键入对密钥的说明信息，然后单击`Save private key`按钮即可将私钥文件存放为`PuTTY`能使用的格式。

今后，当你使用`PuTTY`登录时，可以在左侧的`Connection -> SSH -> Auth`中的`Private key file for authentication:`处选择你的私钥文件，然后即可登录了，过程中只需输入密钥锁码即可。

* SSH

```bash
$ ssh -i /path/to/id_rsa username@hostname
```

如果剛才設置了密鑰鎖碼，這時則需要輸入。完成後即可登錄服務器。

### 參考資料
* [ubuntu设置 SSH 通过密钥登录](https://blog.csdn.net/permike/article/details/52386868)
* [Ubuntu下修改SSH端口以及使用密匙登录](https://www.linuxidc.com/Linux/2012-11/75086.htm)
* [ubuntu开启SSH服务](http://www.cnblogs.com/nodot/archive/2011/06/10/2077595.html)


## 用X11打开远程GUI应用

* 在远程机器安装X11 Client

```
sudo apt-get install xauth
```

* 在本地机器安装X11 Server

本地Ubuntu使用:

```
sudo apt-get install xorg
sudo apt-get install openbox
```

Windows 可以使用[Xming](https://sourceforge.net/projects/xming/)

Max 可是使用[XQuatz](https://www.xquartz.org/)

* [“can't open display” error](https://serverfault.com/questions/765606/xming-cant-open-display-error/800464)

尝试在``/etc/ssh/sshd_config``加上一行：

```
X11UseLocalhost no
```

### 参考资料

* <https://askubuntu.com/questions/213678/how-to-install-x11-xorg>

## VNC 远程登陆 Ubuntu16.04 图形界面

### 安装相关工具

```
sudo apt-get install xfce4 vnc4server xrdp
```

### 初始化

```
vncserver
#启动vncserver，第一次需要输入设置登录密码, 可以使用vncpasswd重置密码
```

### 修改配置文件xstartup

```
sudo gedit ~/.vnc/xstartup

# 修改为如下内容:

#!/bin/sh
# Uncomment the following two lines for normal desktop:
# unset SESSION_MANAGER
# exec /etc/X11/xinit/xinitrc
#[ -x /etc/vnc/xstartup ] && exec /etc/vnc/xstartup
#[ -r $HOME/.Xresources ] && xrdb $HOME/.Xresources
#xsetroot -solid grey
#vncconfig -iconic &
#x-terminal-emulator -geometry 80x24+10+10 -ls -title "$VNCDESKTOP Desktop" &
#x-window-manager &
unset SESSION_MANAGER
unset DBUS_SESSION_BUS_ADDRESS
[ -x /etc/vnc/xstartup ] && exec /etc/vnc/xstartup
[ -r $HOME/.Xresources ] && xrdb $HOME/.Xresources
vncconfig -iconic &
xfce4-session &
```

### 重新启动vncserver和xrdp

```
sudo vncserver -kill :1
#杀死关闭vncserver

vncserver
#vncserver再次重启

sudo service xrdp restart
#重新启动xrdp
```

### 从客户端连接VNC Server

Ubuntu用户使用自带的Remmina远程桌面

【新建】->协议选择【SVN-虚拟网络计算】->服务器【IP:1】

输入VNC密码就可以连接了。

再次关闭，然后使用【IP:5901】进行连接。

如果是使用了防火墙，需要在防火墙上开启5901远程端口（sudo ufw allow 5901）。

Mac和Windows用户可以使用Real VNC做客户端。可以先用ssh将服务器端口映射到本地, 然后客户端填写127.0.0.1:5901

```
ssh -NfL 5901:127.0.0.1:5901 user@hostname
```

### 参考资料
* [Ubuntu 16.04配置VNC进行远程桌面连接](https://www.cnblogs.com/EasonJim/p/7529156.html)
* [Ubuntu 16.04 安装 VNC 及 gnome 桌面环境](https://www.htcp.net/2524.html)
* [Ubuntu16.04 远程桌面连接（VNC）](https://blog.csdn.net/qq_28284093/article/details/80166614)

## 使用x2go远程使用Ubuntu图形化桌面

[X2Go](https://wiki.x2go.org/doku.php) 是另一个实现“云端计算机”的方案，它可以实现一直在线，并且易于扩展，响应速度和安全性比VNC方案更高。下面的内容会介绍如何如何使用x2go来远程访问Ubuntu20.04[XFCE](https://www.xfce.org/)桌面环境，从而获得和本地桌面一样的体验。

首先安装完整的``xubuntu-desktop``环境，当遇到选择display manager的时候，选择lightdm。

```
sudo apt-get install xubuntu-desktop
```

X2Go包含两个部分，一端是Server，负责管理和启动图形程度到client；一端是Client，负责查看和控制桌面应用。 在18.04版本之前，你需要[手动配置软件源](https://wiki.x2go.org/doku.php/wiki:repositories:ubuntu)，在Ubuntu20.04 Focal Fossa，X2Go已经包含在了软件源中，所以可以直接使用包管理器安装：

```
sudo apt-get install x2goserver x2goserver-xsession
```

服务端的配置已经完成，然后需要配置本地机器上的客户端。Ubuntu和Mac用户可以使用包管理器下载client，Windows用户可以从[这里](https://wiki.x2go.org/doku.php/download:start)下载安装包。Mac用户还需要安装[Xquartz](https://www.xquartz.org/)来运行X11。

```
sudo apt-get install x2goclient # ubuntu
brew install x2goclient # mac
```

安装完成client后将它打开，找到session的偏好设置，输入IP，如果有ssh keys，输入key的地址，就可以连接到xfce桌面。

![client](https://assets.digitalocean.com/articles/67306/x2goblur.png)

如果有长期运行的桌面任务希望在后台运行，到一段时间后再查看，可以在连接后选择client的suspend按钮即可暂时退出桌面连接，但是这时任务仍然在运行。再次登录这个session，x2goclient会提示你是否要继续上次的环境。如果不希望在后台运行，可以在xfce桌面里选择log out在退出登录。

### 参考资料

* <https://www.digitalocean.com/community/tutorials/how-to-set-up-a-remote-desktop-with-x2go-on-ubuntu-20-04>
* <https://biomedicalhub.github.io/openstack/08-managing-x2go.html>

## ssh Client Configuration

如果在登陆remote machine的时候有很多的参数，为了减少输入，一个方法是使用``alias``，

```bash
alias my_server="ssh -i ~/.id_ed25519 --port 2222 -L 9999:localhost:8888 foobar@remote_server
```

更好的方法是配置文件``~/.ssh/config``。

```
Host vm
    User foobar
    HostName 172.16.174.141
    Port 2222
    IdentityFile ~/.ssh/id_ed25519
    LocalForward 9999 localhost:8888

# Configs can also take wildcards
Host *.mit.edu
    User foobar
```

这里``LocalForward``的配置是将remote machine的``localhost:8888``绑定到本地的``9999``端口，这样你就能直接从本地的``localhost:9999``来浏览远端的端口接收的数据，这对于使用``jupyter``非常方便。更多关于端口转发的解释在[这里](https://unix.stackexchange.com/questions/115897/whats-ssh-port-forwarding-and-whats-the-difference-between-ssh-local-and-remot)。

配置完文件后就可以使用``ssh vm``来登陆remote machine了。

服务端的配置一般在``/etc/ssh/sshd_config``。你可以设置它来取消密码验证，改变ssh端口，提供X11 forwarding等。

### 参考资料

* <https://missing.csail.mit.edu/2020/command-line/>

## SSH穿越跳板机登陆内网机器

堡垒机，即在一个特定的网络环境下，为了保障网络和数据不受来自外部和内部用户的入侵和破坏，而运用各种技术手段实时收集和监控网络环境中每一个组成部分的系统状态、安全事件、网络活动，以便集中报警、及时处理及审计定责。
但是堡垒机的使用给用户登陆，上传下载文件，开启服务带来了更多的麻烦。那么如何解决通过跳板机登陆到内网机器呢？

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

更加棒的做法是：你可以使用下面指令让端口前传的服务**在后台运行**：

```
ssh -NfL 122:172.28.230.11:22 lyx@192.168.182.36
```

其中``-N``的作用是连线后不执行指令，``-f``的作用是在输入完密码后让指令在后台执行。

### 通过隧道的tensorboard服务

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

### 常见问题

* 使用Mac做端口前传的时候可能会遇到**Privileged ports can only be forwarded by root.**。

解决方法：将端口设置到1024以上，或者使用root账户设置ssh隧道。

* 我想查询本地那些端口是开启了服务。

解决方法：Linux下使用``$ netstat -a | grep LISTEN``，Mac下使用``$ lsof -i -P | grep LISTEN``


### 参考

* [SSH 跳板机（堡垒机）登录大法](https://blog.csdn.net/Albert0420/article/details/51729583)
* [Must I sftp to an intermediate server?](https://superuser.com/questions/262926/must-i-sftp-to-an-intermediate-server)
* [從家裡存取 Server端的 Tensorboard 服務](https://github.com/JeremyCCHsu/SLAM-Tensorflow-Tutorial/blob/master/Note90-Remote-Access.md)
* [SSH Port Forwarding on Mac OS X](https://manas.tungare.name/blog/ssh-port-forwarding-on-mac-os-x)
