---
layout: post
title:  "Linux mount device"
date: 2018-05-02 10:00:00 +0800
categories: Linux
toc: true
---

## 前言
使用`mount`命令挂载device到Linux上。

## Mount 挂载U盘到服务器
使用`fdisk`可以查看你目前有哪些分区，比如
```bash
$ sudo fdisk -l
   Device Boot      Start         End      Blocks   Id  System
/dev/sda1   *          63   204796619   102398278+   7  HPFS/NTFS
/dev/sda2       204797952   205821951      512000   83  Linux
/dev/sda3       205821952   976773119   385475584   8e  Linux LVM
```
现在，你只有你有sda1，sda2，sda3三个分区。文件系统的种类有NTFS，FAT，EXT。
mount的基本语法为：
```
$ mount -t type device directory
```
这里，假如要挂载sda1分区到系统，可以使用这样的命令：
```
$ sudo mkdir /mnt # 首先创建挂载点
$ sudo mount -t ntfs /dev/sda1 /mnt/
```

顺便一提，USB设备通常是vfat的种类，Linux通常是ext。

## Mount 挂载NTFS分区到服务器上

首先创建一个目录作为挂载点，比如：

```bash
sudo mkdir /media/SSD
```

查看当前有哪些分区和分区的属性，可以使用：

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

取消挂载分区使用：

```bash
sudo umount /media/SSD
```

## 开机启动自动挂载

开机启动自动挂载需要修改``/etc/fstab``文件，首先对旧文件进行备份：

```bash
sudo cp /etc/fstab /etc/fstab.old
```

查看分区和它们对uuid，使用：

```bash
sudo blkid
```

使用``sudo vim /etc/fstab``修改文件，在文件最后添加例如下面的内容：

```
/dev/sda1 /media/HDD1 ntfs defaults  0 0
```

记得在挂载点先创建好目录，例如：

```bash
sudo mkdir /media/HDD1
```

使用``sudo reboot``重启查看效果。

## 参考资料
* (How-to-mount-a-device-in-linux)[https://unix.stackexchange.com/questions/18925/how-to-mount-a-device-in-linux]
* (How to Mount NTFS partition in Ubuntu 16.04)[https://askubuntu.com/questions/978746/how-to-mount-ntfs-partition-in-ubuntu-16-04/978750]
* (How to make partitions mount at startup?)[https://askubuntu.com/questions/164926/how-to-make-partitions-mount-at-startup]