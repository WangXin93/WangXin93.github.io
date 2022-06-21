---
layout: post
title:  "Linux磁盘分区和挂载"
date: 2018-05-02 10:00:00 +0800
categories: Linux
toc: true
---

> 本篇博客介绍如何使用fdisk对linux系统上的硬盘进行分区格式化，之后使用mount命令挂载到系统上用于存储文件。如果希望永久挂载这个硬盘，可以编辑fstab文件记录这个磁盘的信息。

<div align="center">
<img src="/assets/2018-05-02-linux-mount-device/fdisk_mount.svg" style="width:100%"/>
</div>

## 前言

当你安装一块新硬盘在电脑上之后，需要对其分区，格式化，之后才能使用它存储文件。如果你使用的是linux系统，同时你能够访问到这台电脑的显示器，你可以使用图形化界面下的工具`GParted`对其分区；如果你只能远程在命令行下使用这台计算机，那么可以`fdisk`命令行工具可以帮你完成分区任务，你还需要`mkfs`命令完成磁盘格式化，需要`mount`命令来挂载磁盘分区；如果你希望永久挂载这个硬盘，可以编辑`fstab`文件将磁盘信息写入，那么电脑就会在每次启动自动挂载这个磁盘分区。本篇博客的下面内容会分别介绍`fdisk`，`mkfs`，`mount`，`fstab`这些命令行下的磁盘分区管理工具。

## 使用fdisk新建分区

fdisk全称Fixed Disk或者Format Disk，fdisk是Linux下管理磁盘分区的最佳工具之一。它允许用户对分区进行查看，创建，调整大小，删除，移动，和复制。fdisk支持MBR，Sun，SGI，BSD分区表，但是不支持GUID分区表（GPT），最大可操作2TB的分区。

使用`sudo fdisk -l`会打印所有磁盘设备的分区表。磁盘设备的名称通常有规律，sata接口的硬盘的设备名称通常为`/dev/sda`，`/dev/sdb`，`/dev/sdc`以此类推，m2接口的硬盘的设备名称类似于`/dev/nvme0n1`。你可以根据设备名称，容量等信息找到新安装的硬盘，避免在安装系统的硬盘上进行操作。

假设你发现`/dev/sdc`是需要分区操作的新硬盘，使用`fdisk -l 设备名称`，比如`fdisk -l /dev/sdc`可以打印指定设备的分区表。分区表的设备名称类似于`/dev/sdc1`，`/dev/sdc2`，该硬盘的分区越多这个数字会继续增加。

在找到了硬盘的设备名称并查看了已有的分区信息后，可以进一步对其分区操作。使用`sudo fdisk /dev/sdc`对`/dev/sdc`设备进行操作，此时命令行显示进入会话界面，你按下制定的按键，fdisk执行对应的操作，使用按键`m`可以列出所有可用的操作：

```
$ sudo fdisk /dev/sdc
Welcome to fdisk (util-linux 2.30.1).
Changes will remain in memory only, until you decide to write them.
Be careful before using the write command.
Device does not contain a recognized partition table.
Created a new DOS disklabel with disk identifier 0xe944b373.
Command (m for help): m
Help:
  DOS (MBR)
   a   toggle a bootable flag
   b   edit nested BSD disklabel
   c   toggle the dos compatibility flag
  Generic
   d   delete a partition
   F   list free unpartitioned space
   l   list known partition types
   n   add a new partition
   p   print the partition table
   t   change a partition type
   v   verify the partition table
   i   print information about a partition
  Misc
   m   print this menu
   u   change display/entry units
   x   extra functionality (experts only)
  Script
   I   load disk layout from sfdisk script file
   O   dump disk layout to sfdisk script file
  Save & Exit
   w   write table to disk and exit
   q   quit without saving changes
  Create a new label
   g   create a new empty GPT partition table
   G   create a new empty SGI (IRIX) partition table
   o   create a new empty DOS partition table
   s   create a new empty Sun partition table
```

你可以之后再逐个查看每个操作的含义，如果仅仅希望新建分区，下面是常用的按键。首先可以使用按键`F`查看磁盘剩余空间，确保仍有剩余空间用于分区。输入`n`开始创建分区，此时fdisk会提示你输入其它的必要的信息来创建分区，包括，分区类型Partition type，分区号Partition number，接着是开始扇区First sector（默认的开始扇区是未使用空间的第一个扇区），结束扇区End sector（默认使用未使用空间的最后一个扇区，或者使用+1G来创建一个1G的分区）。完成这个操作之后，输入`p`可以发现原有的分区之外的新建的分区。但是这时fdisk只是保存了这些操作，还没有对磁盘进行改动，如果发现需要修改的地方可以使用`q`按键退出会话重新操作。如果确认这些操作没有问题之后，使用`w`按键进行保存，这是你的磁盘就会有一个新的分区。

fdisk运行在每块硬盘上最多创建4个主分区，其中一个可以作为扩展分区，扩展分区中可以设置多个逻辑分区。所以如果磁盘已经有一个3个分区，你应该用剩下的所有空间创建一个扩展分区，之后在这个扩展分区中创建更多的逻辑分区。

如果不再使用某个分区，可以在会话中使用`d`按键删除。

## 格式化分区 

磁盘分区必须格式化分区之后才能存储数据。格式化创建文件系统有不同的方法：

```
$ sudo mkfs.ext4 /dev/sdc1
或
$ sudo mkfs -t ext4 /dev/sdc1
或
$ sudo mke2fs /dev/sdc1
mke2fs 1.43.5 (04-Aug-2017)
Creating filesystem with 262144 4k blocks and 65536 inodes
Filesystem UUID: c0a99b51-2b61-4f6a-b960-eb60915faab0
Superblock backups stored on blocks:
    32768, 98304, 163840, 229376
Allocating group tables: done
Writing inode tables: done
Creating journal (8192 blocks): done
Writing superblocks and filesystem accounting information: done
```

成功格式化后，会得到下面信息：

- UUID：识别设别的识别符，是32个16进制数字
- Superblock：超级快存储文件系统元数据，超级块破坏会导致硬盘无法挂载
- Inode：Inode 是类 Unix 系统中文件系统的数据结构，它储存了所有除名称以外的文件信息和数据
- Journal：日志式文件系统包含了用来修复电脑意外关机产生下错误信息的日志

## 使用mount挂载分区

### 临时挂载

在分区和格式化操作完成后，需要挂载硬盘，我们才能在其中读取写入数据；或者你有个新的硬盘安装到了电脑，它没有自动挂载，这时你需要手动完成挂载。

使用mount命令可以挂载硬盘。先创建创建一个挂载点，例如`sudo mkdir /mnt/mymount`，之后这个分区从这个挂载点访问。如果遇到权限问题，可以用类似下面的命令改变用户权限： 

```
sudo chown -R $USER /mnt/mymount
sudo chgrp -R $USER /mnt/mymount
```

接着使用mount命令 `mount /dev/sdc3 /mnt/mymount` 完成挂载，之后就可以`cd /mnt/mymount`进入到目录进行读写了。

取消挂载分区使用`sudo umount /mnt/mymount`。

## 开机启动自动挂载

临时挂载点会在计算机重启之后丢失，需要你再次手动挂载。如果希望永久挂载一个分区，可以将分区信息写入到``/etc/fstab``文件。

为了安全起见，可以首先对旧的`fstab`文件进行备份`sudo cp /etc/fstab /etc/fstab.old`。

之后使用编辑器在`/etc/fstab`中添加一个行，包含设备名称和挂载点：

```
/dev/sdc1 /mnt/mymount ext4 defaults 0 0
```

之后重启就会发现挂载点仍然保留。

除了设备名称，你还可以使用UUDI（用blkid来获取）进行永久挂载：

```
$ sudo blkid
/dev/sdc1: UUID="d17e3c31-e2c9-4f11-809c-94a549bc43b7" TYPE="ext2" PARTUUID="8cc8f9e5-01"
/dev/sda1: UUID="d92fa769-e00f-4fd7-b6ed-ecf7224af7fa" TYPE="ext4" PARTUUID="eab59449-01"
/dev/sdc3: UUID="ca307aa4-0866-49b1-8184-004025789e63" TYPE="ext4" PARTUUID="8cc8f9e5-03"
/dev/sdc5: PARTUUID="8cc8f9e5-05"
# vi /etc/fstab
UUID=d17e3c31-e2c9-4f11-809c-94a549bc43b7 /mnt/2g-new ext4 defaults 0 0
```

### Mount挂载U盘到服务器

你的U盘或者其他系统移植过来的硬盘不一定是ext4文件系统，那么就需要告诉mount不同的文件系统才能正确挂载。为了分区的查看文件系统类型，可以使用`fdisk`或者`blkid`。

使用`fdisk`可以查看你目前有哪些分区的方法，例如下面：

```bash
$ sudo fdisk -l
   Device Boot      Start         End      Blocks   Id  System
/dev/sda1   *          63   204796619   102398278+   7  HPFS/NTFS
/dev/sda2       204797952   205821951      512000   83  Linux
/dev/sda3       205821952   976773119   385475584   8e  Linux LVM
```

如果你希望挂载设别`/dev/sda1`，你可以发现最后一列它的文件类型是NTFS，假如要挂载sda1分区到系统，可以使用这样的命令：

```
$ sudo mount -t ntfs /dev/sda1 /mnt/
```

其中`-t ntfs`告诉了mount挂载何种类型的硬盘。顺便一提，USB设备通常是vfat的种类，Linux通常是ext。

使用`blkid`查看当前有哪些分区和分区的属性，可以使用：

```bash
sudo blkie

/dev/loop0: TYPE="squashfs"
/dev/loop1: TYPE="squashfs"
/dev/sda1: LABEL="HDD1" UUID="8272B69572B68D83" TYPE="ntfs" PARTLABEL="Basic data partition" PARTUUID="0d7217ab-700e-4f9a-8dcf-f4fff4255e44"
/dev/sdb1: LABEL="M-gM-3M-;M-gM-;M-^_M-dM-?M-^]M-gM-^UM-^Y" UUID="1212364412362D5B" TYPE="ntfs" PARTUUID="2523bfb3-01"
/dev/sdb2: LABEL="Windows" UUID="C4CC857BCC85690E" TYPE="ntfs" PARTUUID="2523bfb3-02"
/dev/sdb3: LABEL="SSD" UUID="A86CD9406CD909C8" TYPE="ntfs" PARTUUID="2523bfb3-03"
/dev/sdb5: UUID="1ce6fc0e-09c0-4123-b5f6-48a7a6253b78" TYPE="ext4" PARTUUID="2523bfb3-05"
/dev/sdb6: UUID="e7a08d25-0a46-40c5-a493-33ae24a6b70f" TYPE="ext4" PARTUUID="2523bfb3-06"
/dev/sdb7: UUID="b90b94e2-2d1a-4e1c-bc5e-6ce15925cda8" TYPE="swap" PARTUUID="2523bfb3-07"
/dev/sdb8: UUID="61378844-3c13-4050-bdad-f01ad643514f" TYPE="ext4" PARTUUID="2523bfb3-08"
```

选择一个ntfs分区进行挂载：

```bash
sudo mount -t ntfs -o nls=utf8,umask=0222 /dev/sdb3 /media/SSD
```

如果遇见不能挂载的错误，可以尝试``sudo ntfsfix /dev/sdb3``，参考[这里](http://www.sohu.com/a/219081225_100098990).

## 结语

`fdisk`是linux中进行磁盘分区管理的常用工具，你可以用它进行小于2TB的分区进行操作。对于新建的分区需要`mkfs`命令格式化文件系统后才能存储数据。分区需要使用挂载到一个挂载点才能访问，可以使用`mount`进行临时挂载，或者修改`/ets/fstab`进行永久挂载。`mount`需要设置不同的文件类型才能正确挂载，linux文件系统通常文件ext4，windows为ntfs，u盘文件系统可能为vfat，可以用`fdisk`或者`blkid`查看文件系统类型。

## 参考资料

* [fdisk管理磁盘分区](https://gnu-linux.readthedocs.io/zh/latest/Chapter01/fdisk.html)
* [How-to-mount-a-device-in-linux](https://unix.stackexchange.com/questions/18925/how-to-mount-a-device-in-linux)
* [How to Mount NTFS partition in Ubuntu 16.04](https://askubuntu.com/questions/978746/how-to-mount-ntfs-partition-in-ubuntu-16-04/978750)
* [How to make partitions mount at startup?](https://askubuntu.com/questions/164926/how-to-make-partitions-mount-at-startup)
* <https://freesvg.org/hard-disk-vector-illustration>