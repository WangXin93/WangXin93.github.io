---
layout: post
title:  "Figure in Latex（Latex中的图片）"
date: 2018-12-18 02:09:44 +0800
categories: LaTeX
toc: true
---

## 前言

[上节](http://wangxin93.github.io/latex/2018/11/06/latex-table.html)记录了如何用LaTeX给论文插入表格。本节记录了如何用LaTeX给论文中插入图片和Caption。

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


同样的可以用`subtable`来创建子表格。

```latex
\begin{table}[h]
	\begin{subtable}[h]{0.16\textwidth}
		\centering
		\begin{tabular}{|l|l|}
		XXX & YYY\\
		\hline
		value X   & value Y\\
	
		\end{tabular}
		\caption{Caption Subtable A}
		\label{tab:label subtable A}
	\end{subtable}
	\hfill
	\begin{subtable}[h]{0.15\textwidth}
		\centering
		\begin{tabular}{|l|l|}
		XXX & YYY\\
		\hline
		 value X    & value Y\\
		 
		\end{tabular}
		\caption{Caption Sub Table B}
		\label{tab:label subtable B}
	\end{subtable}
	\hfill
	\begin{subtable}[h]{0.16\textwidth}
		\centering
		\begin{tabular}{|l|l|}
		XXX & YYY\\
		\hline
	 	 value X   & value Y\\
		
		\end{tabular}
		\caption{Caption SubTable C}
		\label{tab:label subtable C}
	\end{subtable}
	\caption{Caption Main/ All Table}
	\label{tab:label all table}
\end{table}
```

注意这里的`\hfill`可以帮助各个子表格水平排列。

## 使用Inkscape绘制数学图形

在论文和研究报告中绘制数学图形并且希望加入数学符号是一个常见的需求，完成这一目标的一个方法是使用[TikZ]({{ site.baseurl }}{% post_url 2019-04-10-tikz-tutorial %})，但是它在绘制过程中不能即时预览绘制结果，同时不适合绘制随手绘制的任意图形。因此，解决任意图形绘制（比如随手绘制的曲线，图形任意位置的移动）的方法就是使用开源矢量图软件Inkscape。然而虽然Inkscape有很好的绘制矢量图形的能力，对于数学符号的处理的能力却不是特别突出。目前据我可以知道的比较优美地在Inkscape加入数学符号有两种办法：

1. 在Inkscape导出PDF文件时候设置tex的兼容
2. 在使用Inkscape绘制SVG图形时候添加外部的latex编译后的pdf文件

### 在Inkscape导出PDF文件时候设置tex的兼容

假设你使用Inkscape编辑好了一个SVG文件，你需要在希望添加数学符号的地方使用latex行内公式的形式先添加文字，如下图：

![raw-inkscape](https://castel.dev/static/c21062130180ff44b3bca5b48bf35b90/80659/riemman-inkscape.png)

然后选择导出为PDF文件，导出时候注意勾选``Omit text in PDF and create LaTeX file``，如下图。导出完成后你会得到一个后缀为``.pdf``的文件和一个后缀为``.pdf_tex``的文体。

![export-pdf](https://castel.dev/static/1f4576e71da68bcf723d4b75a264dd8b/737a0/saveas.png)

接着在你需要编辑的latex文件的preamble部分加入下面的代码，这里假设所有图片都被存在latex文件所在目录的一个``figures``文件夹下。

```latex
\usepackage{import}
\usepackage{xifthen}
\usepackage{pdfpages}
\usepackage{transparent}
\newcommand{\incfig}[1]{
    \def\svgwidth{\columnwidth}
    \import{./figures/}{#1.pdf_tex}
}
```

最后在你需要插入图片的地方加入下面的代码既可以插入刚才创建的图片。

```latex
\begin{figure}[ht]
    \centering
    \incfig{riemmans-theorem}
    \caption{Riemmans theorem}
    \label{fig:riemmans-theorem}
\end{figure}
```

这样的做法的好处你你可以仅使用Inkscape就完成全部的添加数学符号的任务，但是缺点是你需要编译后才能知道数学符号显示的效果比如字体大小，内容等。如果希望在添加数学符号的时候即时显示数学符号，可以见下一节。

### 在Inkscape编辑时添加PDF格式的数学符号

对于Mac用于可以使用LaTeXiT，其它平台用户可以使用KLatexFormula将latex公式转换为一个pdf文件并导入剪切板，你可以在Inkscape中直接使用粘贴就可以插入并显示数学符号。

但是这样的方法有一个问题是如果粘贴后的数学符号不理想你希望更改，那么你需要返回公式编辑器重新输入公式一遍，再次粘贴时候Inkscape也忘记了你原来的粘贴位置。如果你希望能够在Inkscape的原位置继续上次插入的公式，可以使用下面的Inkscape插件：

<https://textext.github.io/textext/>

如果你是vim的热爱者，你可能会感兴趣Gilles制作了一个Inkscape的插件可以帮助你使用类似vim的快捷键插入公式，比如使用``t``在鼠标位置插入文字，使用``shift+t``在鼠标位置插入数学公式：

<https://github.com/gillescastel/inkscape-shortcut-manager>

## Reference

* [Wiki: LaTeX/Floats, Figures and Captions](https://en.wikibooks.org/wiki/LaTeX/Floats,_Figures_and_Captions)
* [Wiki: LaTeX/Importing Graphics](https://en.wikibooks.org/wiki/LaTeX/Importing_Graphics)
* [How I draw figures for my mathematical lecture notes using Inkscape](https://castel.dev/post/lecture-notes-2/)
