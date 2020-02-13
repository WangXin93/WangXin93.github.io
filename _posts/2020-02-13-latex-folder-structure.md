---
layout: post
title:  "Folder Structure in Latex（Latex中的文件树）"
date: 2020-02-13 16:21:44 +0800
categories: LaTeX
toc: true
---

## 前言

```latex
\documentclass{article}
\usepackage{dirtree}
\usepackage{hyperref}

\begin{document}

\dirtree{
.1 root.
.2 dir1.
.3 \hyperref[dir1-file1]{''file1''}.
.3 \hyperref[dir1-file2]{''file2''}.
.2 dir2.
.3 \hyperref[dir2-file1]{''file1''}.
.3 \hyperref[dir2-file2]{''file2''}.
.2 dir3.
}

\section{dir1/file1}
\label{dir1-file1}

\section{dir1/file2}
\label{dir1-file2}

\section{dir2/file1}
\label{dir2-file1}

\section{dir2/file2}
\label{dir2-file2}

\end{document}
```

## Reference

* [Make a simple directory tree](https://tex.stackexchange.com/questions/5073/making-a-simple-directory-tree)
* [Easiest way of having directory tree with hyperref links](https://tex.stackexchange.com/questions/55449/easiest-way-of-having-directory-tree-with-hyperref-links)
* [Centering a dirtree](https://tex.stackexchange.com/questions/100177/centering-a-dirtree/100182#100182)
