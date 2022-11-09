---
layout: post
title:  "SSH 远程服务器与配置"
date: 2018-05-02 10:15:05 +0800
categories: Linux
toc: true
---

## 前言

在云端进行计算有着自己独特的优势，比如不同担心本地机器因为断电或者其他程序卡死导致计算前功尽弃，并且可以利用云服务器上计算资源实现本地计算机不能胜任的任务。

本篇文字内容会介绍：如何在服务端和客户端配置ssh程序来从命令行中使用服务器，如何使用远程服务器中的图形界面，如何配置远程服务器中的jupyter notebook，还有一些实用的技巧比如使用Wake On Lan来远程开机，ssh隧道。

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


我们一般使用`PuTTY`等`SSH`客户端来远程管理`Linux`服务器。但是，一般的密码方式登录，容易有密码被暴力破解的问题。所以，一般我们会将`SSH`的端口设置为默认的`22`以外的端口，或者禁用`root`账户登录。其实，有一个更好的办法来保证安全，而且让你可以放心地用`root`账户从远程登录:**那就是通过密钥方式登录**。

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
* <https://docs.microsoft.com/en-us/windows/wsl/tutorials/gui-apps>

## VNC 远程登陆 Ubuntu16.04 图形界面

VNC（Virtual Network Computing）是一个允许你远程操作计算的图形界面的系统。本文下面的内容会介绍如何安装服务器端的vnc服务，如何访问vnc，如何通过ssh通道设置更加安全的vnc服务，如何设置vnc开启不同的图形界面，如何设置vnc为系统服务从而开机自动启动。

### 安装桌面环境

如果你安装的是ubuntu桌面版，它应该已经安装了桌面环境，你可以跳过本章节。

如果你安装的是ubuntu服务器版，很可能你没有安装桌面环境。Linux桌面的环境有很多选择，包括：GNOME desktop，KDE Plasma desktop，Mate desktop，Budgie desktop，Xfce/Xubuntu desktop，Cinnamon Desktop。其中Xfce是一个很好的选择，因为它很快，稳定，易于安装。

安装xfce可以通过apt命令：

```
sudo apt install xfce4 xfce4-goodies
```

其中``xfce-goodies``是xfce桌面环境的增强包，它给xfce添加了很多好用的功能。

在安装过程中，你可能会遇到需要你去选择默认的display manager，display manager允许你使用一个图形界面来选择和登入桌面环境，如果使用VNC客户端，由于xfce的会话已经登陆，所有display manager的选择不重要，任意选择一个就可以。

### 快速开始VNC的服务和访问

安装VNC服务可以使用命令：

```
sudo apt install tigervnc-standalone-server
```

安装完成之后，可以在服务器启动vnc服务，命令为

```
vncserver -localhost no
```

``-localhost no``让vnc服务能够被其它主机访问，默认vnc服务开启后只能从本地访问，允许其它机器从网络直接访问只有一次密码作为安全保障，如果希望更加安全地访问vnc服务，可以通过ssh进行端口映射。

之后程序会像你询问登陆密码，密码需求为6-8位，过长会被截断。之后会再询问一个View-Only password，使用这个密码用户可以访问vnc服务器看到桌面，但是不同进行鼠标和键盘操作，如果只是自己访问服务器View-Only可以选择n不进行设置。如果希望重新设置密码，可以使用命令``vncpasswd``。

密码设置完成后，vnc服务器会返回类``:1``的信息，意味着VNC使用5901端口发送信息，再次启动更多的vnc服务，端口会依次使用5902，5903。

连接到VNC服务在不同的系统可以使用的客户端不同，常见的客户端包括：

- Windows 系统可以使用 RealVNC, TightVNC, UltraVNC
- macOS 系统可以使用内建的Screen Shareing程序，或者使用RealVNC
- Linux 系统可以使用 vinagre, krdc, RealVNC, TightVNC, Remmina
- Android 可以使用 RealVNC

进入客户端后，在主机名称部分输入``xxx.xxx.xxx.xxx:5901``就可以看到远程桌面的显示，前面的xxx为ip地址。

如果是使用了防火墙，需要在防火墙上开启5901远程端口（sudo ufw allow 5901）。

关闭vnc服务可以使用命令``vncserver -kill :1``。

### 使用ssh更加安全地访问vnc服务

vnc在不使用``-localhost no``选项的情况下只能通过本地环路访问，但是这是一种安全的访问方式。使用ssh 通道可以在加密的情况下将本地环路的5901端口映射到本机的端口，从而访问vnc。可以通过下面的命令来完成这个目的：

```
ssh -NfL 5901:127.0.0.1:5901 user@hostname
```

之后通过vnc客户端访问``127.0.0.1:5901``就能够访问到远程服务器上的vnc桌面。

### 修改vnc的配置

配置vnc的一个重要目标是告诉vnc使用哪个桌面环境访问，这里以xfce桌面环境为例子。配置xfce需要配置``xstartup``文件：

```
sudo vim ~/.vnc/xstartup
```

添加如下内容：

```
#!/bin/sh
xrdb $HOME/.Xresources
startxfce4 &
```

配置文件的解释内容如下：

* ``#!/bin/sh``，这一行被称为设棒，它会告诉系统这个脚本需要用什么解释器运行
* ``xrdb $HOME/.Xresources``，这一行告诉VNC服务器阅读``.Xresources``文件，这样用户可以修改图形桌面的设置，比如字体，颜色。
* ``startxfce4 &``，这一行告诉VNC启动什么桌面环境，``startxfce4``是一个启动Xfce会话的脚本。

编写完成后，将``xstartup``权限更改为可执行：

```
chmod +x ~/.vnc/xstartup
```

之后使用下面的命令重启已经运行的vnc服务：

```
vncserver -localhost no :1
```

如果希望配置vnc使用gnome桌面，可以先安装gnome桌面环境：

```
sudo apt install gnome-session gnome-terminal
```

修改``~/.vnc/xstartup``为如下内容：

```
#!/bin/sh
# Start Gnome 3 Desktop
[ -x /etc/vnc/xstartup ] && exec /etc/vnc/xstartup
[ -r $HOME/.Xresources ] && xrdb $HOME/.Xresources
vncconfig -iconic &
dbus-launch --exit-with-session gnome-session &
```

### 设置vnc为系统服务

将vnc设置为服务可以让我们像其它服务一样start，stop，restart它，同时可以使用systemd在开机时候启动vnc。如果要把vnc配置为系统服务首先需要编写一个service文件：

```
sudo vim /etc/systemd/system/vncserver@.service
```

在其中填写下面内容：

```
[Unit]
Description=Start TigerVNC server at startup
After=syslog.target network.target

[Service]
Type=forking
User=YOUR_USERNAME
Group=YOUR_USERNAME
WorkingDirectory=/home/YOUR_USERNAME

PIDFile=/home/YOUR_USERNAME/.vnc/%H:%i.pid
ExecStartPre=-/usr/bin/vncserver -kill :%i > /dev/null 2>&1
ExecStart=/usr/bin/vncserver -depth 24 -geometry 1280x800 -localhost :%i
ExecStop=/usr/bin/vncserver -kill :%i

[Install]
WantedBy=multi-user.target
```

之后需要系统注意到这个文件：

```
sudo systemctl daemon-reload
sudo systemctl enable vncserver@1.service
```

启动，停止，重启，查看vnc服务的命令分别为：

```
sudo systemctl start vncserver@1
sudo systemctl restart vncserver@1
sudo systemctl status vncserver@1
sudo systemctl stop vncserver@1
```

### 参考资料

除了VNC，还有其它远程桌面解决方案，比如xRDP，X2Go（使用一个更改后的NX 3 协议），还有Chrome Remote Desktop。

* [How to Install & Configure VNC Server on Ubuntu 20.04](https://bytexd.com/how-to-install-configure-vnc-server-on-ubuntu-20-04/#:~:text=%20How%20to%20Install%20%26%20Configure%20VNC%20Server,to%20this%20point%2C%20we%20have%20successfully...%20More%20)
* [digitalocean vnc tutorial](https://www.digitalocean.com/community/tutorials/how-to-install-and-configure-vnc-on-ubuntu-20-04)
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

## 使用xrdp远程登录ubuntu图形化桌面环境

### 安装桌面环境

[xrdp](http://xrdp.org/)是一个开源的Microsoft RDP (Remote Desktop Protocol) Server 实现方案。你可以使用来以图形化界面的方式登录非Microsoft的系统，并且提供完整的RDP远程桌面环境一样的体验。它的工作原理是从X window系统桥接出一个图形界面，同时将收到的客户端的控制返回到X window系统。 xrdp支持双向剪切板粘贴，声音传输，硬盘共享。你可以使用不同的RDP客户端来登录远程机器：比如FreeRDP，rdesktop，NeutrinoRDP，Microsoft Remote Desktop Client（Windows，macOS，IOS，Android）。

首选需要安装桌面环境。Ubuntu Server Desktop版本是已经安装好桌面环境的因此可以跳过这一步，如果是Ubuntu Server版本，它默认是没有安装桌面环境的，因此需要添加桌面环境到系统。你可以使用``tasksel``工具来安装桌面环境：

```
sudo apt install tasksel -y
tasksel
```

使用键盘找到Ubuntu Desktop，使用空格键确认安装

![tasksel](https://tecadmin.net/wp-content/uploads/2020/11/tasksel-ubuntu-desktop.png)

安装完成后，你需要设置系统来启动到图形界面，需要执行下面的命令来实现：

```
systemctl set-default graphical.target
```

### 安装XRDP

xrdp在系统软件源中已经伯阿汉，你可以通过下面的命令来安装：

```
sudo apt install xrdp -y
```

安装完成后，服务会自动启动，你可以通过下面的命令来确认服务的状态：

```
sudo systemctl status xrdp
```

### 配置 xrdp

在安装过程中，xrdp会添加一个名为``xrdp``的用户到系统中，xrdp会话使用证书文件``“/etc/ssl/private/ssl-cert-snakeoil.key``，对于远程桌面非常重要。

首先需要添加xrdp用户到ssl-cert群组：

```
sudo usermod -a -G ssl-cert xrdp 
```

如果用户遇到背景为黑色的情况，可以通过下面的步骤解决。需要编辑``/etc/xrdp/startwm.sh``文件，然后加入下面的两行在test Xsession 和 execute Xsession之前：

```
Unset DBUS_SESSION_ADDRESS
Unset XDG_RUNTIME_DIR
```

![xsession](https://tecadmin.net/wp-content/uploads/2021/06/xrdp-fix-black-screen-in-background.png)

保存文件后重启服务：

```
sudo systemctl restart xrdp 
```

### 调节防火墙

xrdp 监听 3389 端口，这是RDP的默认端口，你需要调节防火墙来允许远端访问 3389 端口。

如果系统正在运行防火墙，使用下面的命令来打开 LAN 网络下的 3389 端口：

```
sudo ufw allow from 192.168.1.0/24 to any port 3389 
```

然后重启UFW来应用新规则：

```
sudo ufw reload 
```

### 登录到远程桌面

最后，使用RDP客户端连接到服务器。在windows系统上可以在命令行输入``mstcs``然后输入ip地址。

在macOS系统可以使用Miscrosoft Remote Desktop 软件。

Ubuntu系统下一个不错的RDP客户端是Remmina。

### 参考

* <https://tecadmin.net/how-to-install-xrdp-on-ubuntu-20-04/>

## 使用anydesk进行远程桌面操作

下载 anydesk 的 linux 客户端后使用命令行进行安装：

```
sudo dpkg -i anydesk.deb
```

使用[anydesk的命令行工具](https://support.anydesk.com/Command_Line_Interface#Linux)进行设置。首先设置登录密码：

```
echo password | sudo anydesk --set-password
```

然后通过``anydesk --get-id``得到身份码。

在客户端通过输入身份码就可以操作远程的机器了。

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

## 使用Wake On LAN 远程开机Ubuntu

主板开启 Wake On LAN

```
sudo apt install -y ethtool
```

```
ip a
```

```
sudo ethtool -s enp2s0 wol g
```

```
wakeonlan macaddr
```

2033lab
2033lab02 wakeonlan -i 10.199.166.102 4c:cc:6a:2f:c5:9d
2033lab04 wakeonlan -i 10.199.167.238 50:46:5d:53:88:11
2033lab   wakeonlan -i 10.199.167.1   ac:22:0b:c7:4a:e1

```
[Unit]
Description=Configure Wake On Lan

[Service]
Type=oneshot
ExecStart=/sbin/ethtool -s INTERFACE wol g

[Install]
WantedBy=basic.target
```

```
sudo nano /etc/systemd/systemd/wol.service
```

```
sudo systemctl daemon-reload
sudo systemctl enable wol.service
sudo systemctl start wol.service
```

* <https://www.youtube.com/watch?v=tdzrnGh94n8>

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


## 通过jupyter notebook在云端进行机器学习

1. 购买阿里云[学生套餐ECS](https://promotion.aliyun.com/ntms/campus2017.html)，价格为10元/月，购买完成后收到短信，内容包含登录账户名和IP，如果购买时候未设置密码需要使用充值密码选项。

2. [使用ssh登录云服务器ecs](https://help.aliyun.com/document_detail/25425.html?spm=a2c4g.11186623.2.6.JZ5nEF)
```bash
$ ssh root@39.108.1.141
password: 
```
3. [添加sudo用户](https://www.digitalocean.com/community/tutorials/how-to-create-a-sudo-user-on-ubuntu-quickstart)
使用root用户直接操作系统会增加风险，可以创建一个自己的新账户登录云服务器，并将其添加到sudo组里，这样使用sudo指令时候可以得到root权限。
```bash
# adduser username
# usermod -aG sudo username
# su username
```
使用`who`可以查看到当前有哪些用户登录，使用`sudo pkill -u username`可以强行让某个用户退出登录。

4. 安装anaconda
搜索引擎搜索[anaconda archive](https://repo.continuum.io/archive/)，找到最新下载包的地址，然后用wget下载：
```bash
$ wget https://repo.continuum.io/archive/Anaconda3-5.0.1-Linux-x86_64.sh
```
下载完成后安装程序，当询问是否添加path到.bashrc的时候选择yes，将anaconda路径加入环境变量，默认为`/home/username/anaconda3/bin`
```bash
$ bash ./Anaconda2-5.0.1-Linux-x86_64.sh
$ source .bashrc # 程序包自动添加内容到到.bashrc，该句添加环境变量
```

5. 配置jupyter

- 使用openssl加密
```bash
# Generate configuration file
$ jupyter notebook --generate-config
# Create certification for connections in the format of .gem file
$ mkdir certs
$ cd certs
$ sudo openssl req -x509 -nodes -days 365 -newkey rsa:1024 -keyout mycert.pem -out mycert.pem
```
```bash
# Edit configuration file
$ cd ~/.jupyter/
$ vim jupyter_notebook_config.py 
```
在`jupyter_notebook_config.py`中添加如下内容：
```python
c = get_config()
c.NotebookApp.certfile = u'/home/wangx/certs/mysert.pem' # Path to .pem file just created
c.NotebookApp.ip = '*' # Means all ip addresses on your system
c.NotebookApp.open_browser = False # Not open browser
c.NotebookApp.port = 8888
c.NotebookApp.token = '' # Not need token in url at first time login
```

- 使用jupyter password加密
使用jupyter notebook自带的password功能部署起来更加方便。首先设定登陆密码：

```
$ jupyter notebook password
```

然后在配置文件`jupyter_notebook_config.py`中添加内容：

```python
c = get_config()
c.NotebookApp.ip = '*'  
c.NotebookApp.open_browser = False  
c.NotebookApp.port = 8888  
```

这比前者的配置内容少多了！

6. [给云服务器开放端口](https://jingyan.baidu.com/article/03b2f78c31bdea5ea237ae88.html)
阿里云服务器默认开放的端口只有三个，包括22，-1, 3389端口。为了从外部访问jupyter notebook，需要给云服务器开放访问端口，根据前文设置，开放8888端口，端口号可以根据`jupyter_notebook_config.py`变更。

7. 运行jupyter notebook
```bash
$ jupyter notebook
[I 10:14:46.671 NotebookApp] Writing notebook server cookie secret to /run/user/1000/jupyter/notebook_cookie_secret
[W 10:14:47.628 NotebookApp] WARNING: The notebook server is listening on all IP addresses and not using authentication. This is highly insecure and not recommended.
[I 10:14:47.674 NotebookApp] JupyterLab beta preview extension loaded from /home/wangx/anaconda3/lib/python3.6/site-packages/jupyterlab
[I 10:14:47.674 NotebookApp] JupyterLab application directory is /home/wangx/anaconda3/share/jupyter/lab
[I 10:14:47.681 NotebookApp] Serving notebooks from local directory: /home/wangx/test
[I 10:14:47.681 NotebookApp] 0 active kernels
[I 10:14:47.681 NotebookApp] The Jupyter Notebook is running at:
[I 10:14:47.682 NotebookApp] https://[all ip addresses on your system]:8888/
[I 10:14:47.682 NotebookApp] Use Control-C to stop this server and shut down all kernels (twice to skip confirmation).
```
然后在浏览器输入url如：`http://your_ip:8888`就可以看见jupyter notebook的界面啦。这时浏览器可以用来输入计算指令，而计算任务则是由云服务器来完成并将结果通过网络返回到浏览器上。


8. 关于ssh连接阿里云时间过长会自动断开的解决方法
ssh连上阿里云的服务后，总是会自动断开。
可能阿里云LVS的限制，空闲TCP连接过一分多钟就会中断。解决办法：设置ServerAliveInterval，让本地客户端空闲时发送noop。
```bash
$ sudo vi /etc/ssh/ssh_config
```
连接SSH时，每60秒会发一个KeepAlive请求，避免被踢。
```
ServerAliveInterval 60
```

### 给Jupyter配置登录密码

从`jupyter notebook 5.0`版本开始，提供了一个命令来设置密码：`jupyter notebook password`，生成的密码存储在`jupyter_notebook_config.json`
```bash
$ jupyter notebook password
Enter password:  ****
Verify password: ****
[NotebookPasswordApp] Wrote hashed password to /Users/you/.jupyter/jupyter_notebook_config.json
```
之后在`jupyter_notebook_config.py`中找到下面的行，取消注释并修改。
```
c.NotebookApp.password = u'sha:ce...刚才复制的那个密文'
```
使用`jupyter notebook`再次启动notebook，可以发现已经添加了登录索要密码的界面。

对于5.0版本之前的用户可以使用下面方法生成密码：
```bash
PASSWD=$(python -c 'from notebook.auth import passwd; print(passwd("jupyter"))')
echo "c.NotebookApp.password = u'${PASSWD}'"
```

### 为Jupyter notebook安装kernel

可以通过为不同的conda环境安装kernel，从而jupyter可以使用不同的conda环境来运行代码。如果希望为一个conda环境安装kernel，可以使用下面的命令：

```
source activate envname
conda install ipykernel
python -m ipykernel install --user --name envname --display-name "envname"
```

其中``--name``是Jupyter内部使用的名字，这个命令会覆盖掉重名的kernel。``--display-name``是你在jupyter前端页面看到的名字。

你还可以将virtualenv中的kernel安装到另一个conda环境。R和Julia也可以作为内核安装到Julia中。官方文档链接在[这里](https://docs.jupyter.org/en/latest/install/kernels.html)。

### Jupyter的SSL加密配置

自己建一个文件夹或者干脆在~/.jupyter/ 文件夹下面执行下面命令：

```
openssl req -x509 -nodes -days 365 -newkey rsa:2048 -keyout mycert.pem -out mycert.pem
```

接着编辑``jupyter_notebook_config.py``：

```
# browser auto-opening
c.NotebookApp.certfile = u’路径名/mycert.pem’
```

保存后重启jupyter服务。

### 将jupyter notebook 设置为开机后台启动

为了将jupyter notebook设置为开机后台启动，可以通过配置systemd unit文件来实现。

> systemd是目前linux发行版中默认使用的初始化系统和后台服务管理系统，由 Lennart Poettering 和 Kay Sievers 编写。systemd有强大的并行能力和任务依赖控制逻辑，让机器启动速度更快。systemd 和之前系统中使用的 SysV 初始化脚本兼容，不过systemd不仅管理系统的初始化，还提供其它的功能，比如 cron 和 syslog。由于systemd对 linux user space做了很多操作，所以有人批判它没有遵循强调简洁性和模块化的[unix哲学](https://en.wikipedia.org/wiki/Unix_philosophy)。

systemd引入了system unit的概念来管理服务。unit有不同的类型，包括service unit，mount unit，socket unit，slice unit。不同的类型对应这不同的服务，比如mount对应着硬盘挂载服务。服务的配置定义在了文件的内容中。

下面来从头编写一个service unit，定义一个在后台运行的jupyter notebook服务。使用命令`touch jupyter.service`创建一个 ``jupyter.service`` 文件，内容如下：

```
[Unit]
Description=Jupyter Notebook

[Service]
Type=simple
PIDFile=/run/jupyter.pid
Environment=PATH="/usr/local/bin"
ExecStart=/home/lab2033/miniconda3/bin/jupyter-notebook
User=lab2033
Group=lab2033
WorkingDirectory=/home/lab2033/parttime
Restart=always
RestartSec=10

[Install]
WantedBy=multi-user.target
```

这个文件的内容有三个章节：

- 在`[Unit]`章节，定义了这个unit的描述内容
- 在`[Unit type]`章节，这里是`[Service]`章节，定义了具体的指令
- 在`[Intsall]`章节，定义了使用`systemctl enable`安装unit时候相关的信息

你可以在[Working with systemd unit files](https://access.redhat.com/documentation/en-us/red_hat_enterprise_linux/8/html/configuring_basic_system_settings/assembly_working-with-systemd-unit-files_configuring-basic-system-settings#ref_important-unit-section-options_assembly_working-with-systemd-unit-files)这个网址看到更多选项的含义。

将这个unit文件放到`/etc/systemd/system`目录service。运行`systemctl daemon-reload`让systemd知道有一个新的`jupyter.service`存在，之后启动它。

```
sudo cp jupyter.service /etc/systemd/system/

sudo systemctl daemon-reload

sudo systemctl start jupyter.service
```

查看运行输出可以使用`systemctl status`命令或者[`journalctl`](https://www.linode.com/docs/guides/how-to-use-journalctl/):

```
systemctl status jupyter.service

journalctl -u jupyter.service -b
```

如果希望设置为开机启动可以使用`systemctl enable`命令：

```
systemctl enable jupyter.service
```

### 参考链接

* <https://www.linode.com/docs/guides/introduction-to-systemctl/>
* [jupyter Notebook 安装使用](https://cloud.tencent.com/developer/article/1019832)
* [十分钟配置云端数据科学开发环境](https://cloud.tencent.com/developer/article/1004749)
* [Jupyter notebook as a service on Ubuntu 18.04 with Python 3](https://naysan.ca/2019/09/07/jupyter-notebook-as-a-service-on-ubuntu-18-04-with-python-3/)
* <https://www.alibabacloud.com/help/zh/doc-detail/53650.htm>
* <http://blog.csdn.net/ys676623/article/details/77848427>
* <https://yq.aliyun.com/articles/98527>

## 配置pyspark

Apache Spark 是专为大规模数据处理而设计的快速通用的计算引擎。Spark是UC Berkeley AMP lab (加州大学伯克利分校的AMP实验室)所开源的类Hadoop MapReduce的通用并行框架，Spark，拥有Hadoop MapReduce所具有的优点；但不同于MapReduce的是——Job中间输出结果可以保存在内存中，从而不再需要读写HDFS，因此Spark能更好地适用于数据挖掘与机器学习等需要迭代的MapReduce的算法。

1. Spark使用Scala写的，Scala依赖Java。先安装Java。
```bash
$ sudo apt-get install default-jre
$ java -version # 检查java是否安装成功
```

2. 安装Scala：
```bash
$ sudo apt-get install scala
$ scala -version # 检查scala是否安装成功
```

3. 保证pip安装的是anaconda版本的python而不是ubuntu默认的python，安装py4j：
```bash
$ export PATH=$PATH:$HOME/anaconda3/bin
$ conda install pip
$ which pip # 确认使用的是anaconda安装的pip
$ pip install py4j # Python interface for Java
```

4. 下载并解压spark
```bash
$ get http://apache.mirrors.tds.net/spark/spark-2.2.1/spark-2.2.1-bin-hadoop2.7.tgz
$ tar -zxvf spark-2.2.1-bin-hadoop2.7.tgz
```

5. 配置环境变量
```bash
$ export SPARK_HOME='/home/username/spark-2.2.1-bin-hadoop2.7'
$ export PATH=$SPARK_HOME:$PATH
$ export PYTHONPATH=$SPARK_HOME/python:$PYTHONPATH
```
执行`$ python -c 'from pyspark import SparkContext;sc=SparkContext()'`如果顺利通过，说明pyspark安装成功。

6. 如果报出[`Py4JJavaError`](https://stackoverflow.com/questions/23353477/trouble-installing-pyspark)，可能由于阿里云ECS主机名不能被resolve，需要执行`$ export SPARK_LOCAL_IP=172.18.181.193`或者
```bash
$ sudo vim /etc/hosts
```
添加内容：
```
127.0.1.1       hostname
```
hostname可以通过命令`hostname`查询。

### 参考内容
* [PySpark Setup](https://www.udemy.com/python-for-data-science-and-machine-learning-bootcamp/learn/v4/t/lecture/5784658?start=0)
