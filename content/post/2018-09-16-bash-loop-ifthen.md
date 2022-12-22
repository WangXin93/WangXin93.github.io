---
categories: Bash
date: "2018-09-16T21:16:00Z"
title: Bash中的循环与选择结构
toc: true
---

## 前言

在Bash中用好**循环**和**选择**结构可以更高效的执行批量命令，一起来学习它。

## 循环结构

### While loop

基本语法：

```bash
while 
    command list 1
do
    command list
done
```

该循环会在`command list 1`为真的时候循环执行。

下面给一个例子：

```bash
#!/bin/bash
x=1
while
    ((x<10))
do
    echo loop $x; date >date.$x
    ((x=x+1))
done
```

这段指令会循环9次将``date``的指令输入到名称为``date.{1..9}``的文件。其中``((x<10))``的双括号是bash中arithmetic计算的语法。

更加tricky的，可以联合使用while和read从文件中读取内容，当read读到文件的最后一行的时候就会返回False，终止循环。

```bash
while
    read a b c
do
    echo a: $a b: $b c: $c
done << EOF
    one two three four
    five six seven eight nine ten
    eleven twelve
EOF
```

``read``指令的作用是可以将文件或者stdin输入的一行内容分配给后面的几个变量，和Python中的unpacking非常类似。下面是一个从pipe得到输入进行while循环的例子：

```bash
#!/bin/bash
ls -l /etc | while
    read a b c d
do
    echo owner is $c
done
```

### For loop

For使用的时候比while更加直观，下面是for loop的基本语法：

```bash
for <var> in <list>
do
    command list
done
```

最简单的用法如下，直接从多个值中循环：

```bash
for i in dog egg elephant
do
    echo i is $i
done
```

Bash提供了一些方便的语法对连续的值做循环，那就是``seq``，你可以使用``$ seq 1 5``看到1到5的输出。使用两个back tick在bash的作用是运行两个back tick之间的命令将其结果返回到现在的指令中。将它和for loop一起用就像这样：

```bash
for i in `seq 1 5`
do
    echo i is $i
done
```

实际上还有更加简单的语法就是使用两个花括号来实现``seq``的功能，就像这样：

```bash
# Then same
for i in {1..5} {A..Z}
# ...
```

下面再给出一些例子：

```bash
# 从文件内容做loop（但是要注意这里会根据每个单词做循环）
for i in $(<data_file)
do
    echo i is $i
done

# 使用globbing做loop
for i in *.py
# ...

# 使用指令的输出内容做loop
for i in $(find . -name *.py)
# ...

# 另外新建一个变量，对变量做loop
arr=(a b c)
for i in $arr
# ...
```

这就循环部分的内容，下面来看看基本的选择结构！

## 选择结构

### If-then 选择结构

```bash
#!/bin/bash
if
    test -x /bin/ls
then
    echo we have ls
fi
```

这段代码的功能是说：如果存在``/bin/ls``这个可执行文件，那么就打印we have ls。其中``test -x``的功能就是检查是否存在可执行文件，在bash中也可以写成``[[ -x /bin/ls ]]``。

### Case 选择结构

和JavaScript，C/C++一样，bash语言中也有case结构，一种**多选择**结构。下面的例子的功能模仿了很多命令行工具中询问用户是否要执行程序：

```bash
#!/bin/bash
echo -n "Print message? "
valid=0
while
[ $valid == 0 ]
do
    read ans
    case $ans in
        yes|YES|y|Y )
            echo Will print the message
            echo The Message
            valid=1
            ;;
        [nN][oN]    )
            echo Will NOT print the message
            valid=1
            ;;
        *           )
            echo Yes or No of some form please
            ;;
    esac
done
```

That's all! Congratulations!

## Reference

* [Linux Bash Shell Scripts: P13, Loop](https://www.bilibili.com/video/av23774844/?p=13)
* [Linux Bash Shell Scripts: P16, Control Flow](https://www.bilibili.com/video/av23774844/?p=16)
* [命令行的艺术](https://github.com/jlevy/the-art-of-command-line/blob/master/README-zh.md)

