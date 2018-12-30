---
layout: post
title:  "Linux mount device"
date: 2018-05-02 10:00:00 +0800
categories: Linux
toc: true
---

## 前言
使用`mount`命令挂载device到Linux上。

## Mount
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

## 参考资料
* (How-to-mount-a-device-in-linux)[https://unix.stackexchange.com/questions/18925/how-to-mount-a-device-in-linux]