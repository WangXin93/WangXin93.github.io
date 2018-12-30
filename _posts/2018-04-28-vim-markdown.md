---
layout: post
title:  "Vim 下书写 Markdown 配置"
date: 2018-04-28 21:32:00 +0800
categories: Vim
toc: true
---

## 前言
用了Vim编辑器之后总是希望能够用它做更多!这得益于Vim良好的扩展性。本文介绍了如何配置Vim，使得它更加美观，高效地编辑Markdown语言。

## Vundle
### 使用Vundle安装Vim插件
[Vundle](https://github.com/VundleVim/Vundle.vim)是一个Vim的插件管理器，使用它可以安装，更新，搜索Vim的各种插件，使得Vim的工具体验更佳良好。使用它的方法很简单。
首先创建文件`~/.vim/Plugins.vim`，在文件中添加如下内容：
```vim
set nocompatible              " be iMproved, required
filetype off                  " required

" set the runtime path to include Vundle and initialize
set rtp+=~/.vim/bundle/Vundle.vim
call vundle#begin()

" let Vundle manage Vundle, required
Plugin 'VundleVim/Vundle.vim'

" All of your Plugins must be added before the following line
call vundle#end()            " required
filetype plugin indent on    " required
```
对于Github上所有的Vim插件，只需使用对应URL中的仓库名称就可以安装。比如如果要安装著名的`nerdtree`插件，只需要在上面的文件中添加`Plugin 'scrooloose/nerdtree'`这一行，文件内容变为：
```vim
set nocompatible              " be iMproved, required
filetype off                  " required

" set the runtime path to include Vundle and initialize
set rtp+=~/.vim/bundle/Vundle.vim
call vundle#begin()

" let Vundle manage Vundle, required
Plugin 'VundleVim/Vundle.vim'
Plugin 'scrooloose/nerdtree'

" All of your Plugins must be added before the following line
call vundle#end()            " required
filetype plugin indent on    " required
```
然后保存这个文件，在`~/.vimrc`文件中添加：
```vim
so ~/.vim/plugins.vim
```
接着在`~/.vimrc`文件中执行命令`:so %`，表示source当前文件。然后执行命令`:PluginInstall`就可以安装所需的插件。

## 语法高亮
Vim本来也支持Markdown的语法高亮，但是做得还不够。这里使用[gabrielelana/vim-markdown](https://github.com/gabrielelana/vim-markdown)插件来增强高亮。这个插件对于markdown本身的语法如标题，列表等都更加合理的高亮了。对于代码块内的高亮，推荐使用[joker1007/vim-markdown-quote-syntax](https://github.com/joker1007/vim-markdown-quote-syntax)插件。可以使用Vundle安装它们。在`~/.vim/plugins.vim`中添加：
```vim
Plugin 'gabrielelana/vim-markdown'
Plugin 'joker1007/vim-markdown-quote-syntax'
```
然后执行`:so $MYVIMRC`和`:PluginInstall`就可以完成安装。

## 渲染预览
[iamcco/markdown-preview.vim](https://github.com/iamcco/markdown-preview.vim)是一个同时支持Windows, Linux和MacOS的Markdown预览插件。安装该插件并通过以下配置，基本就可以做到一个按键预览当前笔记了。使用Vundle配置需要在`~/.vim/plugins.vim`中添加下面内容：
```vim
Plugin 'iamcco/mathjax-support-for-mkdp'    " MathJax support for typesetting math
Plugin 'iamcco/markdown-preview.vim'
```
然我们可以配置快捷键来让markdown预览更容易：
```vim
let mapleader = ','    " The default leader is \, but a comma is better"    
let g:mkdp_path_to_chrome="google-chrome"
let g:mkdp_auto_close=0
nmap <leader>mm <Plug>MarkdownPreview
nmap <leader>ms <Plug>StopMarkdownPreview
```
然后在编辑一个markdown文件的时候执行`,mm`就可以同步预览文件，执行`,ms`就可以关闭浏览器和停止预览文件啦。

## 大纲
大纲快速查找章节标题，有助于编写的时候时刻抓住文章的结构，对文章有一个整体的控制。提到大纲，肯定不能不提鼎鼎大名的[majutsushi/tagbar](https://github.com/tamlok/vnote)。
首先使用Vundle安装tagbar：
```vim
Plugin 'majutsushi/tagbar'
```
然后执行`:so $MYVIMRC`和`:PluginInstall`。
tagbar 正常工作依赖于 Vim 7.0+ 和 ctags。Ubuntu用户可以使用apt安装它：
```bash
$ sudo apt-get install ctags
```
但是，该插件默认是不支持Markdown的。我们需要做一些配置：
1. 给`~/.ctags`文件（Windows 下是`C:\Users\<username>\.ctags`里增加如下内容，没有这个文件就新建一个：
```
--langdef=markdown
--langmap=markdown:.md
--regex-markdown=/^#{1}[ \t]*([^#]+.*)/. \1/h,headings/
--regex-markdown=/^#{2}[ \t]*([^#]+.*)/.   \1/h,headings/
--regex-markdown=/^#{3}[ \t]*([^#]+.*)/.     \1/h,headings/
--regex-markdown=/^#{4}[ \t]*([^#]+.*)/.       \1/h,headings/
--regex-markdown=/^#{5}[ \t]*([^#]+.*)/.         \1/h,headings/
--regex-markdown=/^#{6}[ \t]*([^#]+.*)/.           \1/h,headings/
```
这表示提取 Markdown 文件里的一到六级标题，并使用空格缩进表示层次。
2. 然后在`~/.vimrc`文件添加如下内容：
```vim
let g:tagbar_type_markdown = {
        \ 'ctagstype' : 'markdown',
        \ 'kinds' : [
                \ 'h:headings',
        \ ],
    \ 'sort' : 0
\ }
```
3. 现在你可以使用`:TagbarToggle<CR>`来打开导航窗格了，但每次开关导航窗格都要敲这么长一串命令毕竟不够方便，配置快捷键来操作更顺手，在你的`vimrc`文件里增加一个映射：
```vim
nnoremap <leader>b :TagbarToggle<CR>
```
现在你可以使用`<leader>b`来随时开/关导航窗格了。
导航窗格默认是在右边，如果你也像我一样喜欢它在左边，也想指定它的宽度，可以在你的 vimrc 文件里配置：
```vim
let g:tagbar_width = 30
let g:tagbar_left = 1
```

## 笔记管理
笔记管理直接使用插件[scrooloose/nerdtree](https://github.com/scrooloose/nerdtree)即可。该插件还支持收藏夹，可以对应到笔记本的概念。

## 查找
Vim有着强大的查找、搜索功能，所以对于纯文本的Markdown来说，完全可以拿过来用。这里就不多啰嗦了，比如`:vimgrep`, [ggreer/the_silver_searcher](https://github.com/ggreer/the_silver_searcher)等。

## VNote
[VNote](https://github.com/tamlok/vnote)针对Vim在编辑Markdown时候不能显示图片和需要手动管理图片的问题。非常适合需要应用于使用markdown书写笔记本。



## 参考链接
* [Vim与Markdown共舞](https://segmentfault.com/a/1190000008321057)
* [在 Vim 里为 Markdown 文档展示导航窗格](http://mazhuang.org/2016/08/03/add-outline-for-markdown-in-vim/)