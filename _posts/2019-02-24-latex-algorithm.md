---
layout: post
title:  "Algorithm Pseudo Code in Latex（Latex中的算法伪代码）"
date: 2019-02-24 15:29:44 +0800
categories: LaTeX
toc: true
---

## 前言

如何在LaTeX当中插入算法伪代码？

可以用两种package来写伪代码：algorithmic，algorithm2e

## algorithmic

```latex
\documentclass{article}
\usepackage{algorithm}
\usepackage{algpseudocode}

\begin{document}
\begin{algorithm}
    \caption{Sample Algorithm}
    \begin{algorithmic}[1]
        \State $i \gets 1 $
        \While {$ i > 10 $}
        \State statement
        \If{condition}
        \State statement
        \State statement
        \Else
        \State statement
        \EndIf
        \EndWhile
    \end{algorithmic}
\end{algorithm}
\end{document}
```

## algorithm2e

```latex
\documentclass{article}
\usepackage{algpseudocode}
\usepackage[linesnumbered,ruled,vlined]{algorithm2e}

\begin{document}
\begin{algorithm}
    \caption{Sample Algorithm}
    \SetAlgoLined
    \DontPrintSemicolon

    $i \gets 1$ \;
    \While{$i>10$}{
    statement\;
    \eIf{condition}{
        statement\;
        statement\;}
        {statement\;}
    }
\end{algorithm}
\end{document}
```

## Reference

* [How to write an algorithm in latex (2 methods)](https://www.youtube.com/watch?v=l7Z7tvCkQrg)
* [Write pseudo code in latex](https://tex.stackexchange.com/questions/163768/write-pseudo-code-in-latex)
* [WikiBooks: LaTeX/Algorithms](https://en.wikibooks.org/wiki/LaTeX/Algorithms)