---
layout: post
title:  "Linux 设置定时任务"
date: 2021-06-16 14:05:35 +0800
categories: Linux
toc: true
---

> 计算机如果能够在固定时机开始任务可以减少很多手工执行命令的精力。本篇博客会介绍如何在linux中如何使用at和crontab命令行工具来在计算机中定时开启任务。

## 前言

## 使用 at

``at`` 命令可以通过包管理器进行安装：

```
sudo apt install at
```

安装完成后，我们需要启动``atd``守护进程，并且将它设置为开机启动。如果使用``systemd``作为init system，可以使用root权限执行下面的命令：

```
systemctl enable --now atd.service
```

设置完成后，如果我们希望在当前1分钟后执行一个命令，可以使用下面的语法：

```
at now + 1 minutes
at> echo "Hello world" > test.txt
at> 
job 4 at Tue Dec 19 11:29:00 2017
```

输入完成指令后，使用``ctrl+d``来退出，这时会得到一个job id和一个任务简介。

如果希望从3天后的4pm执行命令，可以使用：

```
at 4pm + 3 days
```

除了使用命令行交互式地设置任务，你还可以使用``-f``参数来设置任务脚本，或者使用``<``重定向操作符号。

```
at now + 1 minute -f script.sh
```

如果希望查看任务队列，可以使用``atq``命令，如果是root权限运行``atq``，会列出所有用户的任务：

```
atq
```

如果希望删除任务，可以使用``atrm``或者``at -r``，``at -d``，加上job id：

```
atrm 1
```

## 使用 crontab

crontab命令常见于Unix和类Unix的操作系统之中，用于设置周期性被执行的指令。该命令从标准输入设备读取指令，并将其存放于“crontab”文件中，以供之后读取和执行。该词来源于希腊语chronos（χρόνος），原意是时间。

通常，crontab储存的指令被守护进程激活，crond常常在后台运行，每一分钟检查是否有预定的作业需要执行。这类作业一般称为cron jobs。

```
┌───────────── minute (0 - 59)
│ ┌───────────── hour (0 - 23)
│ │ ┌───────────── day of month (1 - 31)
│ │ │ ┌───────────── month (1 - 12)
│ │ │ │ ┌───────────── day of week (0 - 6) (Sunday to Saturday;
│ │ │ │ │                                       7 is also Sunday on some systems)
│ │ │ │ │
│ │ │ │ │
* * * * *  command to execute
```

在每个小时的第一分钟执行 `echo "hello" >> a.txt`。

```
1 * * * * echo "hello" >> a.txt
```

每 2 分钟执行一次 `echo "hello world" >> a.txt`。

```
*/2 * * * * echo "hello world" >> a.txt
```

在每个星期 6 的 23 点 45 分执行这个脚本。

```
45  23 * * 6 /home/oracle/scripts/export_dump.sh
```

## 参考

* <https://linuxconfig.org/how-to-schedule-tasks-using-at-command-on-linux>
* <https://www.howtogeek.com/101288/how-to-schedule-tasks-on-linux-an-introduction-to-crontab-files/>
* <https://askubuntu.com/questions/339298/conveniently-schedule-a-command-to-run-later>
* <https://linuxtools-rst.readthedocs.io/zh_CN/latest/tool/crontab.html#crontab>
