---
categories: LaTeX
date: "2018-11-06T18:48:00Z"
title: Table in Latex（Latex中的表格）
toc: true
---

## 前言

## Basics table in latex: **tabular** environment

A quick example:

```latex
\begin{center}
  \begin{tabular}{ l | c | r }
    \hline
    1 & 2 & 3 \\ \hline
    4 & 5 & 6 \\ \hline
    7 & 8 & 9 \\
    \hline
  \end{tabular}
\end{center}
```

如何理解这个例子？

这里使用``tabular``environment来进行表格排版。LaTeX会自动帮你决定列的宽度。

第一行定义environment的时候用这样的形式：

```latex
\begin{tabular}[pos]{table spec}
```

其中``table spec``的参数可以从下面选择：

- ``l``
- ``c``
- ``r``
- ``p['width']``
- ``m['width']``
- ``b['width']``
- ``|``
- ``||``

可选参数``pos``可以从下面选择中挑选：

- ``b``：bottom
- ``c``：center(default)
- ``t``：top

它决定了表格相对于环绕文本的垂直相对位置。大多情况下不用设定它。

在第一行定义完你需要多少列， 如何对齐，需不需要vertical line之后，就可以开始填写内容了。 你将会用下到下面的命令：

- ``&``：分隔一列
- ``\\``：新的一行
- ``\hline``：水平分割线
- ``\newline``：在一个cell中开始新的一行
- ``cline{i-j}``：partial horizontal line 从第i列到第j列

## Spanning 跨越多行或者多列的表格

### 跨越多列的表格
跨越多列需要用到命令：``\multicolumn{num_cols}{alignment}{contents}``。它意味着将``num_cols``列进行合并，``alignment``可以选择``l``，``c``，``r``，``p{5.0cm}``。然后``contents``是你想要填入cell的内容。下面是一个简单的例子：

```latex
\begin{tabular}{ |l|l| }
  \hline
  \multicolumn{2}{|c|}{Team sheet} \\
  \hline
  GK & Paul Robinson \\
  LB & Lucas Radebe \\
  DC & Michael Duberry \\
  DC & Dominic Matteo \\
  RB & Dider Domi \\
  MC & David Batty \\
  MC & Eirik Bakke \\
  MC & Jody Morris \\
  FW & Jamie McMaster \\
  ST & Alan Smith \\
  ST & Mark Viduka \\
  \hline
\end{tabular}
```

### 跨越多行的表格
首先要做的事情是将``\usepackage{multirow}``加入到preamble中。这个package提供了跨行的命令``\multirow{''num_rows''}{''width''}{''contents''}``。（如果width为``*``那么意味着使用内容的自然宽度）

```latex
...
\usepackage{multirow}
...

\begin{tabular}{ |l|l|l| }
\hline
\multicolumn{3}{ |c| }{Team sheet} \\
\hline
Goalkeeper & GK & Paul Robinson \\ \hline
\multirow{4}{*}{Defenders} & LB & Lucas Radebe \\
 & DC & Michael Duburry \\
 & DC & Dominic Matteo \\
 & RB & Didier Domi \\ \hline
\multirow{3}{*}{Midfielders} & MC & David Batty \\
 & MC & Eirik Bakke \\
 & MC & Jody Morris \\ \hline
Forward & FW & Jamie McMaster \\ \hline
\multirow{2}{*}{Strikers} & ST & Alan Smith \\
 & ST & Mark Viduka \\
\hline
\end{tabular}
```

### 为表格添加脚注

为表格添加脚注需要用到[threeparttable](https://www.ctan.org/pkg/threeparttable?lang=en)包。

```latex
 \documentclass{article}
    \usepackage[flushleft]{threeparttable}
    \begin{document}
    \begin{table*}[ht]
    \caption{Revisions}
     \begin{threeparttable}
    \centering
        \begin{tabular}{p{0.10\linewidth}
                        p{0.15\linewidth}
                        p{0.45\linewidth}
                        p{0.20\linewidth}}
        \hline
            Title 1 & Title 2 & Title 3 & Title 4          \\
        \hline
            Cell 1  & Cell 1  & Cell 3  & Cell 4 \tnote{a} \\
            Cell 1  & Cell 1  & Cell 3  & Cell 4 \tnote{b} \\
        \hline
        \end{tabular}
        \begin{tablenotes}
            \item[a] My Note.
            \item[b] My Other Note.
        \end{tablenotes}
     \end{threeparttable}
    \end{table*}
    \end{document}
```

## Reference

* [Wiki: LaTeX/Tables](https://en.wikibooks.org/wiki/LaTeX/Tables)
* [How can I insert simple Table Notes?](https://tex.stackexchange.com/questions/146127/how-can-i-insert-simple-table-notes/146129)
