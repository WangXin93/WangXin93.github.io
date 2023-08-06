---
layout: post
title:  "linux screen 的使用方法"
date:   2023-08-06 20:36:00 +0800
categories: Linux
toc: true
---

> screen是一个linux命令行中的终端复用工具，你可以使用screen在一个终端会话中打开多个终端窗口，还可以在离开终端后让screen在后台继续任务并保持程序输出。

## 简介

screen可以让你在一个终端中运行多个终端会话，你可以在一个终端中切换到不同的会话；或者detach所有的会话，当程序运行一段世界后再attach到之前的会话中。

screen的具体应用场景例如下面：
- 当你使用ssh登录到服务器运行一个长时间的任务的时候，如果离开了终端，那么任务就会停止。那么这时候可以让这个命令运行在screen的会话中，这样即使离开终端，程序仍然会继续。你可以在之后访问终端时候继续screen的会话；
- 当你通过很多安全验证通过ssh登录到一个终端的时候，你需要一边运行程序同时执行其它操作的话，可以通过screen打开在一个终端内打开多个终端窗口，避免了反复登录ssh。

和screen类似的程序还有tmux，byobu，screen不如后面的程序现代化，但是大多数linux都自带了screen所以你不需要再去安装，如果没有网络的时候也可以直接使用。

你可以使用`screen --version`来查看当前的版本。如果没有安装可以使用`apt install screen`来安装。

## start, detach, then attach

开始一个screen会话，可以通过下面的命令：

```bash
screen -R test
```

它会创建一个名为test的会话，如果已经存在一个名为test的会话，那么它会attach到之前的会话中。一些博客推荐使用`screen -S test`来创建会话，但是这有时候会导致创建了两个名为test的会话。

之后你可以在这个终端中输入一些内容比如`echo hello screen`。

接着按下 ctrl a + d ，就会发现退出了screen，回到了原来的shell，同时下面显示detached。刚才的screen会话被放在了后台运行并没有消失。

如果运行：

```bash
screen -ls
```

可以发现后台运行的全部screen会话。

如果希望attach到之前的会话，可以使用下面的命令，其中test是之前会话的标签：

```bash
screen -R test
```

你还可以尝试使用`screenie`来attach到之前的会话，在终端输入screenie（需要先安装），之后在弹出的对话中按下数字选择会话就可以进入。

## 自定义配置

如何知道自己当前在screen的会话中？可以使用ctrl+a 然后按下t键，如果显示日期那么说明当前的终端是在screen中。

当时在实际使用不能实时按键检查，另一个方法是修改配置文件`.screenrc`

```
# Turn off the welcome message
startup_message off

# Disable visual bell
vbell off

# Set scrollback buffer to 10000
defscrollback 10000

# Customize the status line
hardstatus alwayslastline
hardstatus string '%{= kG}[ %{G}%H %{g}][%= %{= kw}%?%-Lw%?%{r}(%{W}%n*%f%t%?(%u)%?%{r})%{w}%?%+Lw%?%?%= %{g}][%{B} %m-%d %{W}%c %{g}]'
```

之后看到状态栏有提示就说明在screen中了。

## 基本按键

下面是一些常用的快捷键：

| 快捷键             | 描述                                   |
| ------------------- | ---------------------------------------- |
| Ctrl+a c          | 创建一个新窗口（带shell）。              |
| Ctrl+a "          | 列出所有窗口。                          |
| Ctrl+a 0          | 切换到窗口0（按编号）。                 |
| Ctrl+a A          | 重命名当前窗口。                        |
| Ctrl+a S          | 将当前区域水平分割成两个区域。           |
| Ctrl+a \|         | 将当前区域垂直分割成两个区域。           |
| Ctrl+a tab        | 切换输入焦点到下一个区域。               |
| Ctrl+a Ctrl+a     | 在当前窗口和上一个窗口之间切换。         |
| Ctrl+a Q          | 关闭所有区域，但保留当前区域。           |
| Ctrl+a X          | 关闭当前区域。                          |

## 参考

- <https://linuxize.com/post/how-to-use-linux-screen/>