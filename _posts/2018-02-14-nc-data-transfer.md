---
layout: post
title:  "使用nc在局域网内传输文件"
date:   2018-02-14 18:25:00 +0800
categories: Linux
---

## 前言
**情人节快乐!**

在家中或者学校，经常需要在多台电脑之间传输文件，怎么传文件才方便呢？
1. 存到U盘，再把U盘插到另一台电脑
2. 家中或者学校的多台电脑通常连接在一个局域网中，可以用它吗？

可以！

## 如何在局域网内传输文件？

这里UNIX系统携带的工具`nc`或者叫`netcat`，使用`man nc`可以查看关于它的介绍与说明。`nc`可以帮助在一台计算机打开一个端口，而在另一台计算机可以使用`nc`访问这个端口，从而可以在两台计算机之间传输数据。

假定需要讲文件从电脑A传输到电脑B，首先，需要在电脑B终端输入：
```bash
$ nc -l 1234 > filename.out
```
这里做的事情是在电脑B开放一个端口，端口号为1234，就像一幢大楼的号码为1234的房间门打开来等待其他计算机的访问。传输的数据会被存放在命名为`filename.out`的文件，如果没有这个文件，`nc`会自己创建一个。

然后，要知道电脑B端的局域网IP地址，在电脑B终端输入：
```bash
$ ifconfig
enp3s0    Link encap:以太网  硬件地址 f0:de:f1:f3:ce:9e  
          UP BROADCAST MULTICAST  MTU:1500  跃点数:1
          接收数据包:0 错误:0 丢弃:0 过载:0 帧数:0
          发送数据包:0 错误:0 丢弃:0 过载:0 载波:0
          碰撞:0 发送队列长度:1000 
          接收字节:0 (0.0 B)  发送字节:0 (0.0 B)

lo        Link encap:本地环回  
          inet 地址:127.0.0.1  掩码:255.0.0.0
          inet6 地址: ::1/128 Scope:Host
          UP LOOPBACK RUNNING  MTU:65536  跃点数:1
          接收数据包:3290 错误:0 丢弃:0 过载:0 帧数:0
          发送数据包:3290 错误:0 丢弃:0 过载:0 载波:0
          碰撞:0 发送队列长度:1000 
          接收字节:1265913 (1.2 MB)  发送字节:1265913 (1.2 MB)

wlp9s0    Link encap:以太网  硬件地址 44:6d:57:5e:b0:42  
          inet 地址:192.168.2.102  广播:192.168.2.255  掩码:255.255.255.0
          inet6 地址: fe80::6eb3:6513:bb2c:cfbe/64 Scope:Link
          UP BROADCAST RUNNING MULTICAST  MTU:1500  跃点数:1
          接收数据包:150949 错误:0 丢弃:0 过载:0 帧数:0
          发送数据包:97071 错误:0 丢弃:0 过载:0 载波:0
          碰撞:0 发送队列长度:1000 
          接收字节:193005806 (193.0 MB)  发送字节:11263841 (11.2 MB)
```
关注`wlp9s0`这一行，可以知道电脑B的局域网IP为`192.168.2.102`。

然后，在电脑A的终端输入：
```bash
$ nc 192.168.2.102 1234 < filename.in
```
等待命令执行完成，命名为`filename.in`的文件会被传输到电脑B。文件传输完成后，连接会自动断开。大功告成～利用局域网成功在两台计算机之间传输文件。

**完整帮助参考命令`man nc`,然后键入`/DATA TRANSFER`，寻找到相关章节**


## 使用scp向Linux云服务器上传和下载文件
随着时间推移，我发现了更多向云端传输数据的方法。使用nc传输数据时，有时候因为`<`符号弄反了导致待复制文件被重写真的太恐怖了。
下面介绍scp指令的使用。scp指令的基本格式如下：
```
scp <name@ip-address>:</path/of/file> <name@ip-address>:</path/of/file>
```
举例来说：
```
scp ./warm_up_train_20180201.tar wangx@111.233.77.222:/home/wangx/test
```
这行指令就能够将本地的这个tar文件上传到云端的test目录。按下回车确认后，还能够显示传输进度，比nc真的美丽多了。

## 使用sftp向Linux云服务器上传和下载文件
sftp提供了交互式的文件传输方案，使文件传输任务更加可爱方便了！如何使用sftp？
```
scp user@ip-address
```
举例来说：
```
scp ubuntu@192.168.0.1
```
然后命令行的提示符号会变为`sftp> `，现在你就可以使用sftp的指令了，常用指令包括：
```
put filename # 上传文件
put -r dirname # 上传文件夹
get filename # 下载文件
get -r dirname # 下载文件夹
cd # 改变远程服务器目录
lcd # 改变当前主机目录
pwd # 显示远程服务器当前工作目录
lpwd # 显示当前主机（本地）的当前工作目录
```

## Next: rsync

rsync的意思是'remote sync'，它可以把远端或者本地的文件进行同步。rsync使用[差分编码](https://zh.wikipedia.org/zh-hans/%E5%B7%AE%E5%88%86%E7%B7%A8%E7%A2%BC)来最小化数据传输的量。

rsync通常既可以指使用该工具的网络协议，也可能指这个工具本身。由于它的普遍性，大多数Unix系统已经默认安装了它。

先学习如何在本地使用它！首先我们需要创建一些文件作为例子：

```bash
$ mkdir dir1 dir2
$ touch dir1/file{1..100}
```

使用``ls dir1``可以发现创建好了file1到file100这100个文件。

然后可以使用：

```bash
$ rsync -r dir1/ dir2
```
对两个目录下文件进行同步，``-r``选项意味这recursive。另一个替代方案是使用``-a``选项：

```bash
$ rsync -a dir1/ dir
```

``-a``意味着archive，它不光会recusive地同步文件，还会保留symbolic links，special and device files，文件修改时间，group，owner，permissions。所以比``-r``更加常用。

注意到``dir1/``后面的斜杠，它告诉rsync去同步dir1下的所有内容，如果忘记了这个斜杠，被同步的目录会变为``dir2/dir1/[files]``。

### 同步远程系统

同步远程系统需要有[SSH权限](https://www.digitalocean.com/community/articles/how-to-set-up-ssh-keys--2)，之后，就可以使用类似``scp``的格式进行远端系统同步：

```bash
$ rsync -a ~/dir1 username@remote_host:destination_directory
```

它的作用就像``git push``，反过来如果想从远端pull，这样就可以：

```bash
$ rsync -a username@remote_host:/home/username/dir1 place_to_sync_on_local_machine
```

### Tricks or options

你可能希望在执行同步之前检查一下rsync指令，rsync提供了这样的方法：通过``-n``或者``--dry-run``选项，它意味着模拟一下同步的过程而不真的修改文件内容，加上``-v``选项输出程序过程。最终，一个常用的combo就是：

```bash
$ rsync -anv dir1/ dir2
```

如果希望提高传输效率，将文件压缩以后再传输，你可以使用``-z``参数：

```bash
$ rsync -az source destination
```

``-P``参数也是非常有用的，它结合了``--progress``和``--partial``参数，前者可以输出一个进度条，后者运行你进行断点续传：

```bash
$ rsync -azP source destination
```

rsync默认不会删除destination那边一边的文件，所以如果在source一端删除了文件，destination一端默认不会删除。你可以通过``--delete``选项强制删除destination一端的文件：

```bash
$ rsync -a --delete source destination
```

还有两个有用的选项：``--exclude``和``--include``，exclude可以指定不去匹配某个文件或者目录，你可以用``:``来连接这些目录，include在exclude给出一个模板的情况下重载这个文件是否要同步：

```bash
$ rsync -anv --include=file2* --exclude=* dir1/ wangx@my-ip-address:/home/wangx/dir1
```

上面的指令可以选择只同步开头为file2的文件。

最后是``--backup``选择可以对重要的文件在同步后进行备份，备份在destination那一端的目录下。它通常``--backup-dir``选项一起使用，它制定了备份的目录：

```bash
$ rsync -a --delete --backup --backup-dir=/path/to/backups /path/to/source destination
```

## 参考：

- [How To Use Rsync to Sync Local and Remote Directories on a VPS](https://www.digitalocean.com/community/tutorials/how-to-use-rsync-to-sync-local-and-remote-directories-on-a-vps)

