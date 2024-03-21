---
layout: post
title:  "如何使用Bash中的参数扩展（Parameter Expansion）"
date: 2018-12-08 00:29:05 +0800
categories: Bash
toc: true
---

> Bash中的变量经常需要经过一些简单的编辑或者替换在使用，比如得到的文件名称需要去掉前面的文件路径，参数扩展（paremter expanison）可以帮你快速完成这些任务，比如使用`${VAR##*/}`就可以去除文件路径仅保留文件名，而不需要一些外部工具（perl，python，sed，awk）的帮忙，这样可以使得我们更加高效地完成一些任务。

## 前言

在 Bash 中可以使用 `${VAR}` 得到变量的值，但是这个值通常要经过编辑和替换才能用于后续的处理，比如去除文件路径，去除文件名后缀等，这些需求可以使用 Bash 中的参数扩展（paramter expansion）方便地完成。这篇博客会介绍参数扩展的常用语法以及常见的用途。

在 Bash 中`$VAR`和`${VAR}`都可以得到变量值，但是参数扩展功能需要使用`${VAR}`语法，它会在两个花括号中间添加一些额外的语句，比如`${VAR##*/}`。那么现在来看看parameter expansion可以有哪些更多的变化功能！

## 1. Setting Up Default Shell Variables Value

基本语法为：

```bash
${parameter:-defaultValue}
var=${parameter:-defaultValue}
```

两者的功能相似。``:``的作用只有在``$parameter``已经被声明但是被赋值为null的时候才会体现：

```bash
username0=
echo "username0 has been declared, but is set to null."
echo "username0 = ${username0-`whoani`}"

echo "username1=${username1-`whoami`}"

username2=1
echo "username2=${username2:-`whoami`}"
```

### 1.1 Setting Default Values

```bash
${var:=value}
var=${USER:=value}
```

## 2. Display an Error Message If $VAR Not Passed

```bash
${varName?Error varName is not defined}
${varName:?Error varName is not defined or is empty}
${1:?"mkjail: Missing operand"}
MESSAGE="Usage: mkjail.sh domainname IPv4"             ### define error message
_domain=${2?"Error: ${MESSAGE}"}  ### you can use $MESSAGE too
```

### 2.1. Display an Error Message and Run Command
```bash
#!/bin/bash
_file="$HOME/.input"
_message="Usage: chkfile commandname"

# Run another command (compact format)
_cmd="${2:? $_message $(cp $_file $HOME/.output)}"

$_cmd "$_file"
```

## 3. Find Variable Length
```bash
${#variableName}
echo ${#variableName}
len=${#var}
```

## 4. Remove Pattern (Front of $VAR)

```bash
${var#Pattern}
${var##Pattern}
```

比如：
```bash
f="/etc/resolv.conf"
echo ${f#/etc/}
```

这里将文件名之前的``/etc/``去除掉了。这里的一个``#``代表非贪婪模式，``##``代表贪婪模式。

在实际场景中，如果需要去除很长的文件名前的所有目录名，只保留文件名，可以这样：
```bash
_version="20090128"
_url="http://dns.measurement-factory.com/tools/dnstop/src/dnstop-${_version}.tar.gz"
echo "${_url##*/}"
```

### 4.1: Remove Pattern (Back of $VAR)
```bash
${var%pattern}
${var%%pattern}
```
```bash
FILE="xcache-1.3.0.tar.gz"
echo ${FILE%.tar.gz}
```

## 5. Find And Replace
```bash
${varName/Pattern/Replacement}
${varName/word1/word2}
${os/Unix/Linux}
```

可以使用这个expand来进行文件重命名：
```bash
y=/etc/resolv.conf
cp "${y}" "${y/.conf/.conf.bak}"
```

```bash
${var//pattern/string}	Find and replace all occurrences
```

```bash
${var/#Pattern/Replacement} # If prefix of var matches Pattern, then substitute Replacement for Pattern.

${var/%Pattern/Replacement} # If suffix of var matches Pattern, then substitute Replacement for Pattern.
```

## 6. Substring Starting Character

语法为：
```bash
${parameter:offset}
${parameter:offset:length}
```

```bash
x="nixcraft.com"
echo ${x:3:5}"
```
这样会只提取其中的craft这个词。

```bash
phone="022-124567887"
# strip std code
echo "${phone:4}"
```
这样只提取电话号码。

## 7. Get list of matching variable names
得到以指定prefix开头的变量名，可以使用：
```bash
VECH="Bus"
VECH1="Car"
VECH2="Train"
echo "${!VECH*}"
```

## 参考

* [How To Use Bash Parameter Substitution Like A Pro](https://www.cyberciti.biz/tips/bash-shell-parameter-substitution-2.html)
* [Parameter Substitution](https://www.tldp.org/LDP/abs/html/parameter-substitution.html)
* [Shell 截取文件名和后缀](http://zuyunfei.com/2016/03/23/Shell-Truncate-File-Extension/)
