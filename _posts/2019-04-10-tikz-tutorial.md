---
layout: post
title:  "TikZ Tutorial"
date: 2019-04-10 19:58:42 +0800
categories: LaTeX
toc: true
---

## 前言

## Get Started

```latex
\documentclass[10pt,a4paper]{article}
\usepackage{tikz}

\begin{document}

\begin{tikzpicture}
\draw (0,0) -- (4,0) -- (4,4) -- (0,4) -- (0,0);
\end{tikzpicture}

\end{document}
```

# 绘制网格与圆

```latex
\begin{tikzpicture}
\draw[red,thick,dashed] (3,3) circle (3cm);
\draw[step=1cm,gray,very thin] (0.1,0.1) grid (5.9,5.9);
\end{tikzpicture}
```

# 绘制填充颜色

```latex
\begin{tikzpicture}
\filldraw[blue!40!white, draw=black] (0,0) rectangle (4,4);
\shade[left color=blue,right color=red] (-4,-4) rectangle (0,0);
\shade[inner color=blue,outer color=red] (-4,4) rectangle (0,0);
\shade[left color=red,right color=blue] (0,0) rectangle (4,-4);
\end{tikzpicture}
```

# 绘制坐标轴
```latex
\begin{tikzpicture}
\draw[thick,->] (0,0) -- (4.5,0) node[anchor=north west] {x axis};
\draw[thick,->] (0,0) -- (0,4.5) node[anchor=south east] {y axis};
\foreach \x in {0,1,2,3,4}
\draw (\x cm,1pt) -- (\x cm,-1pt) node[anchor=north] {$\x$};
\foreach \y in {0,1,2,3,4}
\draw (1pt,\y cm) -- (-1pt,\y cm) node[anchor=east] {$\y$};
\end{tikzpicture}
```


## Reference

* [LaTeX Graphics using TikZ: Basic Drawing](https://www.overleaf.com/learn/latex/LaTeX_Graphics_using_TikZ:_A_Tutorial_for_Beginners_(Part_1)%E2%80%94Basic_Drawing)

