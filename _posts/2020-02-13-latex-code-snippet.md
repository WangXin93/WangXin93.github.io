---
layout: post
title:  "Code Snippet in Latex（Latex中的代码片段）"
date: 2020-02-13 16:21:44 +0800
categories: LaTeX
toc: true
---

## 前言

```latex
\documentclass[12pt]{article}
\usepackage{listings}
\usepackage{lipsum}
\usepackage{courier}

\lstset{basicstyle=\footnotesize\ttfamily,breaklines=true}
\lstset{framextopmargin=50pt,frame=bottomline}

\begin{document}
\begin{lstlisting}
   a b c
\end{lstlisting}
\lipsum[1]
\end{document}
```

## Reference

* [Listing Package Document](http://texdoc.net/texmf-dist/doc/latex/listings/listings.pdf)
* [set the font family for lstlisting](https://tex.stackexchange.com/questions/33685/set-the-font-family-for-lstlisting)