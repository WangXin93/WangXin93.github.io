---
layout: post
title:  "設置ssh密鑰登錄"
date: 2018-05-02 10:15:05 +0800
categories: Linux
toc: true
---

## 前言
我们一般使用`PuTTY`等`SSH`客户端来远程管理`Linux`服务器。但是，一般的密码方式登录，容易有密码被暴力破解的问题。所以，一般我们会将`SSH`的端口设置为默认的`22`以外的端口，或者禁用`root`账户登录。其实，有一个更好的办法来保证安全，而且让你可以放心地用`root`账户从远程登录:**那就是通过密钥方式登录**。

## 設置方法
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

## 參考資料
* [ubuntu设置 SSH 通过密钥登录](https://blog.csdn.net/permike/article/details/52386868)
* [Ubuntu下修改SSH端口以及使用密匙登录](https://www.linuxidc.com/Linux/2012-11/75086.htm)
* [ubuntu开启SSH服务](http://www.cnblogs.com/nodot/archive/2011/06/10/2077595.html)
