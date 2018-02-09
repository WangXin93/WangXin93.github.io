---
layout: post
title:  "Vim 无插件实现90%的插件功能"
date:   2018-02-09 19:43:26 +0800
categories: Vim
---

## 前言
`vim`是一款控制灵活，功能强大，扩展性很强的编辑器。使用额外的插件可以使得Vim能够满足开发环境的各种编辑功能比如文件列表，模糊搜索，自动补全等等。但是，使用环境中也经常会遇到没有插件的情况，Vim自身就无法实现这些功能了么？答案是：No。没有插件的`vim`其实可以实现大约90%插件附加的功能！一起看看如何实现吧。

---

## Basic SETUP
在`~/.vimrc`文件中输入下面语句，这些语句的功能确保打开的是`vim`，而不是旧版本的`vi`，`vim`相对于`vi`添加了更多的功能。
```vim
" enter the current millenium
set nocompatible

" enable syntax and plugins (for netrw)
syntax enable
filetype plugin on
```

后面代码块中的内容通过添加在`~/.vimrc`文件内容后面或者键入到`vim`命令行中来生效。

---

## Fuzzy File Search
```vim
" Search down into subfolders
" Provides tab-completion for all file-related tasks
set path+=**

" Display all matching files when we tab complete
set wildmenu
```
`set path+=**`的功能是告诉`vim`取寻找当前目录的所有子目录，然后可以：
- 在`vim`命令行中输入`:find filename`可以打开指定名字的文件，使用`tab`可以补全文件名。该功能和插件`[ctrlp.vim](https://github.com/kien/ctrlp.vim)`非常相似
- 使用`*`进行模糊搜索。
- 使用`:b`可以打开buffer中的文件，文件名可以自动补全

---

## Tag jumping
```vim
" Create the `tags` file (may need to install ctags first)
command! MakeTags !ctags -R .
```
`ctags -R .`会在当前目录生成一个`tags`文件，执行完该指令后，我们可以：
- 使用`^]`跳转到当前光标下单词的函数定义部分
- `g^]`来寻找模糊的tags
- `^t`来跳转到上一个tag
- `tselect name`来列出相关的tags

---

## Autocomplete
`vim`默认的补全快捷键是`^n`，在`INSERT`模式下输入任何内容，按下`^n`，`vim`会为你补全剩下的内容。其他几个非常使用的补全快捷键：

- `^x^n`只从本文件中找寻内容进行补全
- `^x^f`非常有用，补全文件路径
- `^x^]`补全tags

这些快捷键的补全搜索范围更准确。对于搜索到的多个内容，可以通过`^n`和`^p`在它们之间切换。`vim`的文档中将该部分功能记录在了`|ins-completion|`。

---

## File Browsing
```vim
" Tweaks for browsing
let g:netrw_banner=0        " disable annoying banner
let g:netrw_browse_split=4  " open in prior window
let g:netrw_altv=1          " open splits to the right
let g:netrw_liststyle=3     " tree view
let g:netrw_list_hide=netrw_gitignore#Hide()
let g:netrw_list_hide.=',\(^\|\s\s\)\zs\.\S\+'

" NOW WE CAN:
" - :edit a folder to open a file browser
" - <CR>/v/t to open in an h-split/v-split/tab
" - check |netrw-browse-maps| for more mappings
```
`vim`自带的文件浏览系统，使用命令`:e.`可以浏览当前目录，常用的指令有：
- `u`: 上一级目录
- `%`: 创建文件 
- `d`: 创建文件夹
- `D`: 删除文件和文件夹

---

## Snippets
```vim
"Shortcut for main in Python
abbreviate ifm if __name__ == "__main__":
```
现在，在插入模式下输入`ifm`, 在后面输入空格或者回车之类只要不是字母，内容会被自动补全为`if __name__ == "__main__":`。比较恼人的一点是如果不希望这几个字母被替换，目前我能想到的方法只有`:unabbreviate ifm`或者`:abclear`来清除abbreviations。如果要看目前有那些abbreviations，使用命令`:ab`。

---

## Build Intergration
```vim
" Configure the `make` command to run python
set makeprg=python
```
进行该设定后，输入：
- `:make`相当于运行`$ python thisfile`
- `:cl`如果运行出错，会跳转到该位置
- `:cc#`用数字指定跳转到第几个错误位置
- `:cn`和`:cp`来在不同的错位位置之间前后跳转

---

## 学会使用Vim手册来学习更多！

- `help`显示一个快速指南
- `help ^n`搜寻`NORMAL`模式下`CTRL n`组合键的作用
- `help i_^n`搜寻`INSERT`模式下`CTRL_n`的作用
- `help c_^n`搜寻`COMMAND-LINE`模式下`CTRL_n`的作用
- `helpgrep windows`寻找整个手册中所有提到`windows`这个词的地方，使用`cn`，`cp`指令前后跳转，`cl`用于列出所有找到的结果。

## 最后一点，如果遇到使用插件更加方便的情况，那就尽情地让插件是我们更加方便吧！

## 参考链接
- Slides: <https://github.com/changemewtf/no_plugins>
- Videos: <https://www.bilibili.com/video/av9799225/>
