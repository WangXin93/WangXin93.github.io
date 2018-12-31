---
layout: post
title:  "Mac 挂载NTFS移动硬盘进行读写操作"
date: 2018-04-14 14:41:17 +0800
categories: OSX
toc: true
---

## 前言
在Mac上直接向移动硬盘写入文件会遇到“read-only filesystem”这样的错误。这是由于移动硬盘使用的是windows的NTFS磁盘格式。解决这个问题的一种方法是将移动硬盘[转化为FAT格式](https://business.tutsplus.com/tutorials/quick-tip-solving-read-only-external-drive-problems-on-your-mac--mac-52507)，但是这种方法的问题是需要格式化硬盘。下面介绍一个稍微花一些功夫就可以向“read-only filesystem”的硬盘写入文件的办法。

1. 找到`Device Node`例如：

```
$ diskutil info /Volumes/YOUR_NTFS_DISK_NAME

Device Node:              /dev/disk1s1
```

2. 弹出你的硬盘

```
$ hdiutil eject /Volumes/YOUR_NTFS_DISK_NAME

"disk1" unmounted.
"disk1" ejected.
```

3. 创建一个目录，稍后将mount到这个目录

```
$ sudo mkdir /Volumes/MYHD
```

4. 将NTFS硬盘挂载到mac：

```
$ sudo mount_ntfs -o rw,nobrowse /dev/disk1s1 /Volumes/MYHD/
```

5. 使用完成后umount硬盘：

```
$ umount /Volumes/MYHD/
```

## 参考链接
* [Mac 挂载NTFS移动硬盘进行读写操作](https://blog.csdn.net/sunbiao0526/article/details/8566317)
