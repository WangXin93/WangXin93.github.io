---
CNcategories: vim
CNtags: ["vim", "command-line-tool"]
CNseries: vim
date: "2018-02-09T19:43:26Z"
title: Vim 无插件条件下的使用建议
---

> 使用额外的插件可以让Vim能够变成功能完成的IDE，但是当你使用远程机器的时候，你无法知道服务器是否有网络和权限允许你将Vim安装好所有的插件，熟悉一套不需要插件仍然高效的Vim工作流程可以解决这些问题。开发环境编辑器需要的功能包括文件列表，模糊搜索，自动补全等等，没有插件的情况下Vim其实可以实现大约90%的插件附加功能。本篇博客将会介绍如何在Vim中不使用插件实现这些开发编辑功能。

## 前言

使用额外的插件可以使得Vim能够满足开发环境的各种编辑功能比如文件列表，模糊搜索，自动补全等等。但是，使用环境中也经常会遇到没有插件的情况，同时由于网络或者用户权限的原因甚至难于对远程服务器上的Vim安装插件。实际上Vim自身在不使用插件的情况下可以实现大多数开发编辑需要的功能，只需要少量的调校就能得到很好的用户体验。本篇博客后面的内容会依次介绍如何实现这些功能。

---

## 基本设置（Basic Setup）

首先要进行的基础设置是需要我们在命令行确保打开的是`vim`，而不是旧版本的`vi`，`vim`相对于`vi`添加了更多的功能。为了保证打开的是`vim`，需要在`~/.vimrc`文件中输入下面语句，

```vim
" enter the current millenium
set nocompatible
```

同时在`~/.vimrc`文件中添加下面的内容，它们的功能是允许语法高亮和允许使用插件，这样vim自带的插件netrw就可以被使用：

```vim
" enable syntax and plugins (for netrw)
syntax enable
filetype plugin on
```
---

## 模糊文件搜索（Fuzzy File Search）

`set path+=**`的功能是告诉`vim`取寻找当前目录的所有子目录，然后可以：
- 在`vim`命令行中输入`:find filename`可以打开指定名字的文件，使用`tab`可以补全文件名。该功能和插件`[ctrlp.vim](https://github.com/kien/ctrlp.vim)`非常相似
- 使用`*`进行模糊搜索。
- 使用`:b`可以打开buffer中的文件，文件名可以自动补全

```vim
" Search down into subfolders
" Provides tab-completion for all file-related tasks
set path+=**

" Display all matching files when we tab complete
set wildmenu
```

---

## Tag 跳转（Tag jumping）

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

## 自动补全（Autocomplete）

`vim`默认的补全快捷键是`^n`，在`INSERT`模式下输入任何内容，按下`^n`，`vim`会为你补全剩下的内容。其他几个非常使用的补全快捷键：

- `^x^n`只从本文件中找寻内容进行补全
- `^x^f`非常有用，补全文件路径
- `^x^]`补全tags

这些快捷键的补全搜索范围更准确。对于搜索到的多个内容，可以通过`^n`和`^p`在它们之间切换。`vim`的文档中将该部分功能记录在了`|ins-completion|`。

---

## 文件浏览（File Browsing）

``netrw``是vim内建的文件浏览器，但是它设计的不是特别的直观好用，并且功能不够全面，不过好的地方在有 vim 的地方就能使用 netrw，你不会遇到任何安装的问题，并且通过简单调整 netrw 可以变得相对好用。

使用netrw进行文件目录浏览：当你使用``vim .``的打开一个目录的时候，这时候 vim 打开的界面会显示当前目录下的所有文件，你已经位于 netrw 的界面之中了。你可以使用``j``，``k``来移动光标到不同的文件，使用``-``会移动到上一级目录，使用回车会进入选中的文件可以进行编辑。

输入``:e .``可以回到 netrw 的界面。在界面的顶端可以看到类似如下的提示，它包含当前netrw的版本（v162），当前目录，排序方式，排序优先级，快速帮助。

* 使用j和k将光标移动到Sort by一行，按下回车，可以切换不同的排序方式
* 使用j和k将光标移动到Sort Sequence一行，按下回车，可以更改排序优先级
* 使用j和k将光标移动到Quick help一行，按下回车，可以切换不同的帮助提示

```
" ============================================================================
" Netrw Directory Listing                                        (netrw v162)
"   /Users/wangx/foo
"   Sorted by      name
"   Sort sequence: [\/]$,\<core\%(\.\d\+\)\=\>,\.h$,\.c$,\.cpp$,\~\=\*$,*,\.o$,\.obj$,\.info$,\.swp$,\.bak$,\~$
"   Quick Help: <F1>:help  -:go up dir  D:delete  R:rename  s:sort-by  x:special
" ==============================================================================
../
./
1.txt
2.txt
```

使用netrw进行文件管理：netrw可以用来添加，移动，复制，删除文件夹和文件。

- `%`: 创建文件 
- `d`: 创建文件夹
- `D`: 删除文件和文件夹
- `R`: 重命名文件，也可以用来移动文件

使用 netrw 复制或者移动文件会有点违反直觉，它需要三步：

1. 使用``mt``指定目标文件夹
2. 使用``mf``标记一个或者多个文件
3. 使用``mm``来移动文件或者使用``mc``来复制文件

使用netrw打开文件侧边栏：netrw 可以像NERDTree一样在编辑区域左边调出侧边栏，你只需要打开文件后输入``Vex``或者``Vexplore``就可以打开侧边栏，使用``Sex``或者``Sexplore``会水平分割打开侧边栏。如banner提示，使用``o``，``v``或者``t``键可以分别在水平分割，垂直分割，或者新的tab中打开文件，这时光标也会移动到新打开的编辑区域。如果希望让光标保持在 netrw，可以使用``p``间进行预览。

```
" ============================================================================
" Netrw Directory Listing                                        (netrw v162)
"   /Users/wangx/foo
"   Sorted by      name
"   Sort sequence: [\/]$,\<core\%(\.\d\+\)\=\>,\.h$,\.c$,\.cpp$,\~\=\*$,*,\.o$,\.obj$,\.info$,\.swp$,\.bak$,\~$
"   Quick Help: <F1>:help  (windows split&open) o:horz  v:vert  p:preview
" ==============================================================================
```

默认的``v``键会在左边打开pane，如果希望在右边打开pane，可以进行如下设置。默认preview会水平打开pane，可以通过设置调整为垂直打开pane：

```vim
" Open vertical split on the right
let g:netrw_altv=1

" Open preview in the vertical split
let g:netrw_preview=1

" - <CR>/v/t to open in an h-split/v-split/tab
" - check |netrw-browse-maps| for more mappings
```

如果熟悉了 netrw 的操作不需要顶部的 banner 提示，可以在 ``.vimrc`` 中加入下面的设置来取消 banner 的显示：

```vim
" Tweaks for browsing
let g:netrw_banner=0        " disable annoying banner
let g:netrw_browse_split=4  " open in prior window
let g:netrw_altv=1          " open splits to the right
let g:netrw_liststyle=3     " tree view
let g:netrw_list_hide=netrw_gitignore#Hide()
let g:netrw_list_hide.=',\(^\|\s\s\)\zs\.\S\+'
```

---

## 代码片段（Snippets）

```vim
"Shortcut for main in Python
abbreviate ifm if __name__ == "__main__":
```

现在，在插入模式下输入`ifm`, 在后面输入空格或者回车之类只要不是字母，内容会被自动补全为`if __name__ == "__main__":`。比较恼人的一点是如果不希望这几个字母被替换，目前我能想到的方法只有`:unabbreviate ifm`或者`:abclear`来清除abbreviations。如果要看目前有那些abbreviations，使用命令`:ab`。

---

## 内容搜索

在当前文件进行内容搜索可以使用``/somthing``然后回车来进行搜索，使用``n``跳转到下一个搜索位置，使用``N``跳转到上一个搜索位置。

对一个或者多个文件使用正则表达式搜索：如果希望对一个文件或者多个文件的内容进行搜索，可以使用 vim 内建的工具``vimgrep``。使用vim打开要编辑的文件后，输入命令``:vimgrep /something/g %``或者``:vim /something/g %``可以对当前文件进行搜索内容something，这里可以填写其它正则表达式。使用``:copen``可以在下方看到弹出的quickfix窗口，其中显示所有搜索到的条目，可以使用j和k键将光标移动到不同条目，按回车进入搜索到的位置。使用``:cnext``可以跳转到下一个搜索到的位置，使用``:cprev``可以跳转到上一个搜索到的位置。

如果希望对多个搜索，可以使用命令``:vim /something/g **/*``对当前目录和所有子目录下所有的文件搜索字符串something，或者``:vim /something/g **/*.py``对当前目录以及子目录下所有的py文件进行搜索

---

## 构建项目（Build Intergration）

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

## 使用Vim手册来获得帮助

- `help`显示一个快速指南
- `help ^n`搜寻`NORMAL`模式下`CTRL n`组合键的作用
- `help i_^n`搜寻`INSERT`模式下`CTRL_n`的作用
- `help c_^n`搜寻`COMMAND-LINE`模式下`CTRL_n`的作用
- `helpgrep windows`寻找整个手册中所有提到`windows`这个词的地方，使用`cn`，`cp`指令前后跳转，`cl`用于列出所有找到的结果。

**最后一点，如果遇到使用插件更加方便的情况，那就尽情使用插件吧!**

## 参考链接

- Slides: <https://github.com/changemewtf/no_plugins>
- Videos: <https://www.bilibili.com/video/av9799225/>
- [Using Netrw, vim's builtin file explorer](https://vonheikemen.github.io/devlog/tools/using-netrw-vim-builtin-file-explorer/)
- [Vim (31) netrw pt1 - Intro to netrw](https://www.youtube.com/watch?v=3lqzc77carU)
- [Vim (32) netrw pt2](https://www.youtube.com/watch?v=VNDoMhKVdQM)
- [Vim (33) NetRW copyVimrc](https://www.youtube.com/watch?v=9UxMvz6u1K4)
