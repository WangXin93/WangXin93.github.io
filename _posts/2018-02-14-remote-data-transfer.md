---
layout: post
title:  "在本地和远端计算机之间传输文件"
date:   2018-02-14 18:25:00 +0800
categories: Linux
toc: true
---

## 前言

在家中或者学校，经常需要在多台电脑之间传输文件，怎么传文件才方便呢？最简单的方法是存到U盘，再把U盘插到另一台电脑，但是因为家中或者学校的多台电脑通常连接在一个局域网中，我们也可利用局域网来在多台计算机之间传输文件。

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

要想学习如何使用它，首先我们需要创建一些文件作为例子：

```bash
$ mkdir dir1 dir2
$ touch dir1/file{1..100}
```

使用``ls dir1``可以发现创建好了file1到file100这100个文件。

## 同步两个目录

然后可以使用：

```bash
$ rsync -r dir1/ dir2
```
对两个目录下文件进行同步，``-r``选项意味这recursive。另一个替代方案是使用``-a``选项：

```bash
$ rsync -a dir1/ dir2
```

``-a``意味着archive，它不光会recusive地同步文件，还会保留symbolic links，special and device files，文件修改时间，group，owner，permissions。所以比``-r``更加常用。

注意到``dir1/``后面的斜杠，它告诉rsync去同步dir1下的所有内容，如果忘记了这个斜杠，被同步的目录会变为``dir2/dir1/[files]``。你也可以使用``rsync -a dir1/ dir2/``，来避免目录变成上面的情况，关键是``dir1/``需要有斜杠。

### 同步远程系统

同步远程系统需要有[SSH权限](https://www.digitalocean.com/community/articles/how-to-set-up-ssh-keys--2)，之后，就可以使用类似``scp``的格式进行远端系统同步：

```bash
$ rsync -a ~/dir1 username@remote_host:destination_directory
```

它的作用就像``git push``，反过来如果想从远端pull，这样就可以：

```bash
$ rsync -a username@remote_host:/home/username/dir1 place_to_sync_on_local_machine
```

### Dry run

你可能希望在执行同步之前检查一下rsync指令，rsync提供了这样的方法：通过``-n``或者``--dry-run``选项，它意味着模拟一下同步的过程而不真的修改文件内容，加上``-v``选项输出程序过程。最终，一个常用的combo就是：

```bash
$ rsync -anv dir1/ dir2
```

### Zip

如果希望提高传输效率，将文件压缩以后再传输，你可以使用``-z``参数：

```bash
$ rsync -az source destination
```

通常文件压缩后传输会更快，``pigz``是一个利用多核并行提高压缩速度的工具。

```bash
## Compress everything found in a directory named 'my_data' to a compressed tar file named my_data.tar.gz in a group area
$ tar cf - my_data | pigz -p $NUM_CORE > /mnt/username/my_data.tar.gz
       #
       #
       # Note that a '-' here means the output is sent through the
       # pipe (the | symbol) to the pigz command, not to an intermediate
       # tar file.

## Extract
$ pigz -dc target.tar.gz | tar xf -
$ tar -xvf --use-compress-program=pigz filename # alternative
```

### Progress Bar

``-P``参数也是非常有用的，它结合了``--progress``和``--partial``参数，前者可以输出一个进度条，后者运行你进行断点续传：

```bash
$ rsync -azP source destination
```

### Delete option and Backup

rsync默认不会删除destination那边一边的文件，所以如果在source一端删除了文件，destination一端默认不会删除。你可以通过``--delete``选项强制删除destination一端的文件：

```bash
$ rsync -a --delete source destination
```

### Exclude

如果希望在同步两个目录的时候忽略一些不必要的文件，比如``.pyc``文件，``large_data``文件，可以通过配置``--exclude``选项来实现功能。
有两个有用的选项：``--exclude``和``--include``，exclude可以指定不去匹配某个文件或者目录。

如果仅有一个文件需要忽略，可以输入命令：

```bash
$ rsync -anv --exclude='file.txt' dir1/ wangx@my-ip-address:/home/wangx/dir1
```

如果有一个整个目录需要被忽略，你可以输入命令：

```bash
$ rsync -anv --exclude='somedir' dir1/ wangx@my-ip-address:/home/wangx/dir1
```

如果你仅仅希望忽略目录下的内容，但是需要保留目录本身，可以将``somedir``替换成``somedir/*``。

如果有多个文件和目录需要同步，一种方法是使用pattern来匹配多个文件，比如如果希望屏蔽所有的``jpg``格式的文件，可以使用命令：

```bash
$ rsync -anv --exclude='*.jpg' dir1/ wangx@my-ip-address:/home/wangx/dir1
```

``rsync``还有一个``--include``选项，它可以对exclude选项重载，让能够匹配的文件参与同步。比如如果希望仅仅同步所有的``jpg``文件，可以使用命令：

```bash
$ rsync -anv -m --include='*.jpg' --include='*/' --exclude='*' dir1/ wangx@my-ip-address:/home/wangx/dir1
```

这里``--include='*.jpg'``告诉软件去匹配所有的``jpg``文件，``--include='*/'``告诉软件对于子目录的``jpg``文件也要同步，``-m``选项会清除空白的目录。

另一种匹配多个文件目录的方法是使用多个``--exclude``选项。比如希望同时屏蔽``jpg``和``png``文件，还有``log``目录下面的内容，那么可以使用下面的命令：

```bash
$ rsync -anv --exclude='*.jpg' --exclude='*.png' --exclude='log/*' dir1/ wangx@my-ip-address:/home/wangx/dir1
```

``--exclude``选项支持你使用``{}``和``,``来合并多一个选项，比如上面的命令可以写成：

```bash
$ rsync -anv --exclude={'*.jpg','*.png','log/*'} dir1/ wangx@my-ip-address:/home/wangx/dir1
```

如果需要写入的屏蔽条目过多，那么这个命令就会过长。这时候你可以将要屏蔽的条目写入一个文件比如``exclude_file.txt``，然后使用``--exclude-from``编写命令：

```bash
$ rsync -anv --exclude-from='exclude_file.txt' dir1/ wangx@my-ip-address:/home/wangx/dir1
```

``exclude_file.txt``的内容如下，和``.gitignore``格式相似：

```
file1.txt
dir1/*
dir2
```

### Delete option

最后是``--backup``选择可以对重要的文件在同步后进行备份，备份在destination那一端的目录下。它通常``--backup-dir``选项一起使用，它制定了备份的目录：

```bash
$ rsync -a --delete --backup --backup-dir=/path/to/backups /path/to/source destination
```

### Zsh Integration

``zsh``包含一个[`rsync``的插件](https://github.com/ohmyzsh/ohmyzsh/blob/master/plugins/rsync/rsync.plugin.zsh)，它实际上设置了多个alias来缩短了``rsync``的指令：

```bash
alias rsync-copy="rsync -avz --progress -h"
alias rsync-move="rsync -avz --progress -h --remove-source-files"
alias rsync-update="rsync -avzu --progress -h"
alias rsync-synchronize="rsync -avzu --delete --progress -h"
```

使用``man rsync``可以查看更多选项的说明。 如果希望对多个机器进行同步，可以考虑[rdist](https://linux.die.net/man/1/rdist)命令工具。

### Reference

* <https://linuxize.com/post/how-to-exclude-files-and-directories-with-rsync/>
* <https://www.digitalocean.com/community/tutorials/how-to-use-rsync-to-sync-local-and-remote-directories>

## SSHFS

sshfs是实现远程文件和本地文件互相传输的另一个思路，它实际上是将远程机器中的某个目录作为本地的一个挂载目录，这样就能通过本地文件管理实现文件传输。

你的操作系统可以支持不同的文件后端，只要你有一个操作不同文件系统的共同语言。比如你运行``touch``创建一个文件，``touch``命令在内核部分进行系统调用，然后内核进行文件系统调用才创建了文件。[``FUSE``](https://en.wikipedia.org/wiki/Filesystem_in_Userspace)（Filesystem in User Space）让用户程序来实现文件系统变成可能，FUSE给用户空间的代码和内核接口的文件系统调用驾了一座桥。比如，FUSE可以用来在你给虚拟文件系统进行操作的时候，这个操作通过SSH来传输到一个远端的机器上，并在远端执行并把结果返回到本地。这样远端服务器的文件就好像在本地程序中一样。这个就是``sshfs``的功能。

在linux机器上，可以使用``sshfs``指令实现，例如：

```bash
# make a directory to use as an access point for your remote home-directory
$ mkdir remote

# mount remote directory to local directory named remote
$ sshfs username@hostname:/home/username remote

# unmount
$ fusemount -u remote # linux
$ umount remote # mac
```

注意，Mac OS使用``sshfs``需要安装 [FUSE for macOS](https://github.com/osxfuse/osxfuse/releases) 和 [SSHFS](https://github.com/osxfuse/sshfs/releases).

Windows下可以考虑[WinFSP](http://www.secfs.net/winfsp/)和[SSHFS-Win](https://www.google.com/search?q=sshfs+win&oq=sshfs+win&aqs=chrome..69i57j0l7.2105j0j1&sourceid=chrome&ie=UTF-8).

还有一些其它使用FUSE文件系统的例子比如：
* [rclone](https://rclone.org/commands/rclone_mount/) - Mount cloud storage services like Dropbox, GDrive, Amazon S3 or Google Cloud Storage and open data locally.
* [gocryptfs](https://nuetzlich.net/gocryptfs/) - Encrypted overlay system. Files are stored encrypted but once the FS is mounted they appear as plaintext in the mountpoint.
* [kbfs](https://keybase.io/docs/kbfs) - Distributed filesystem with end-to-end encryption. You can have private, shared and public folders.
* [borgbackup](https://borgbackup.readthedocs.io/en/stable/usage/mount.html) - Mount your deduplicated, compressed and encrypted backups for ease of browsing.

### 参考：

- [How To Use Rsync to Sync Local and Remote Directories on a VPS](https://www.digitalocean.com/community/tutorials/how-to-use-rsync-to-sync-local-and-remote-directories-on-a-vps)
- [Copying files to and from compute systems](http://ri.itservices.manchester.ac.uk/userdocs/file-transfer/)
- [File Management FAQ](http://ri.itservices.manchester.ac.uk/userdocs/file-management/)
- [Fastest way to extract tar.gz](https://serverfault.com/questions/270814/fastest-way-to-extract-tar-gz)
- <https://missing.csail.mit.edu/2020/potpourri/#fuse>

## Samba

A Samba file server enables file sharing across different operating systems over a network. It lets you access your desktop files from a laptop and share files with Windows and macOS users.

使用命令行安装samba：

```bash
sudo apt install samba
```

运行命令结束后后使用``whereis samba``来确认安装完成，如果命令行返回下面内容说明安装成功：

```
samba: /usr/sbin/samba /usr/lib/samba /etc/samba /usr/share/samba /usr/share/man/man7/samba.7.gz /usr/share/man/man8/samba.8.gz
```

然后需要配置samba的服务，这包括选择一个需要共享的位置和编写配置文件让samba知道如何从这个位置共享。选择一个共享位置比如``/home/<username>/sambashare/``，如果这个位置不存在你需要创建一个这样的目录。接着编写samba的配置文件，使用命令``sudo vim /etc/samba/smb.conf``，在文件底部加上下面的内容：

```
[sambashare]
    comment = Samba on Ubuntu
    path = /home/username/sambashare
    read only = no
    browsable = yes
```

这里内容的含义是：

* comment: A brief description of the share.
* path: The directory of our share.
* read only: Permission to modify the contents of the share folder is only granted when the value of this directive is no.
* browsable: When set to yes, file managers such as Ubuntu’s default file manager will list this share under “Network” (it could also appear as browseable).

文件内容修改后，将它保存然后重启samba来让配置文件生效：

```
sudo service smbd restart
```

还需要配置防火墙规则来允许samba通过：

```
sudo ufw allow samba
```

由于samba不使用系统的账户，所以需要给samba设立账户密码。需要注意这里的username必须是系统账户中的一个，不然会失败。

```
sudo smbpasswd -a username
```

最后，在另一台计算机上连接到samba服务器：

* 在windows系统可以在我的电脑的地址栏中输入``\\id-address\sambashare``来访问
* 在linux的系统可以在默认的文件管理器中找到Connect to server选项输入``smb://ip-address/sambashare``来访问
* 在OSX的系统中可以到finder的Go -> Connect to Server 选项输入地址``smb://ip-address/sambashare``来访问

### 参考

* <https://ubuntu.com/tutorials/install-and-configure-samba>
