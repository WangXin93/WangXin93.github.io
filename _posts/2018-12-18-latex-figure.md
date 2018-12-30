---
layout: post
title:  "Figure in Latex（Latex中的图片）"
date: 2018-12-18 02:09:44 +0800
categories: latex
toc: true
---

## 前言

[上节](http://wangxin93.top/latex/2018/11/06/latex-table.html)记录了如何用LaTeX给论文插入表格。本节记录了如何用LaTeX给论文中插入图片和Caption。

## A quick example:

```latex
\documentclass[a4paper,12pt]{article}
\usepackage{graphicx}

\begin{document}
\begin{figure}[t]
  \centering
    \includegraphics[width=0.5\textwidth]{gull}
    \caption{A picture of a gull.} \label{fig:gull}
\end{figure}
\end{document}
```
 
要想给文档插入图片和caption，表格和captionn，需要使用LaTeX中的floats。Floats是一个容器，它在文档中不能被分页显示。LaTeX默认将table和figure环境视为floats。你也可以定义自己的floats，floats适合用来解决一个文档对象不能在当前页显示完整，同时这个对象也不需要立刻显示在源码书写的位置。

Floats的位置和源码文本的位置不一定一致，而是插入到页面的一个位置（比如top，middle，bottom，left，right等其他定义的位置）。它们都有一个caption描述，并且被自动标号，这样可以方便文档从其他位置进行引用。LaTeX默认将table和figure视为floats，当当前页面空间不够的时候，会移到下一页进行插入。可以通过调节table和figure的参数来告诉LaTeX如何自动选择插入位置。

上面是一个figure加caption的例子，这里需要`\usepackage{graphicx}`来插入图片，在定义figure环境的一行中，`[t]`定义了floats的插入方法，称为placement specifier，它的可选项有：

- `h`:	Place the float here, i.e., approximately at the same point it occurs in the source text (however, not exactly at the spot)
- `t`:	Position at the top of the page.
- `b`:	Position at the bottom of the page.
- `p`:	Put on a special page for floats only.
- `!`:	Override internal parameters LaTeX uses for determining "good" float positions.
- `H`:	Places the float at precisely the location in the LaTeX code. Requires the float package, i.e., \usepackage{float}.

最后`\caption{...}`描述了caption的内容。`\label{...}`定义了一个label用于交叉引用。需要注意的是label需要紧接着caption定义，否则引用位置会变成section的序号而不是figure的序号。

## Subfigure

论文中经常遇到需要网格排列的形式插入多个图片，这时候subcaption扩展会是你的好帮手，下面给出一个直接的例子：

```latex
\usepackage{graphicx}
\usepackage{subcaption}

\begin{figure}
    \centering
    \begin{subfigure}[b]{0.3\textwidth}
        \includegraphics[width=\textwidth]{gull}
        \caption{A gull}
        \label{fig:gull}
    \end{subfigure}
    ~ %add desired spacing between images, e. g. ~, \quad, \qquad, \hfill etc.
      %(or a blank line to force the subfigure onto a new line)
    \begin{subfigure}[b]{0.3\textwidth}
        \includegraphics[width=\textwidth]{tiger}
        \caption{A tiger}
        \label{fig:tiger}
    \end{subfigure}
    ~ %add desired spacing between images, e. g. ~, \quad, \qquad, \hfill etc.
    %(or a blank line to force the subfigure onto a new line)
    \begin{subfigure}[b]{0.3\textwidth}
        \includegraphics[width=\textwidth]{mouse}
        \caption{A mouse}
        \label{fig:mouse}
    \end{subfigure}
    \caption{Pictures of animals}\label{fig:animals}
\end{figure}
```

关注其中包含在figure环境中的subfigure环境，成功的话你可以得到这样一个1行3列的figure。

![subfigure](https://upload.wikimedia.org/wikipedia/commons/thumb/e/e5/Latex_example_subfig.png/500px-Latex_example_subfig.png)

## Reference

* [Wiki: LaTeX/Floats, Figures and Captions](https://en.wikibooks.org/wiki/LaTeX/Floats,_Figures_and_Captions)
* [Wiki: LaTeX/Importing Graphics](https://en.wikibooks.org/wiki/LaTeX/Importing_Graphics)
