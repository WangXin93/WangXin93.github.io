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
\draw (0,0) -- (4,0) -- (4,4) -- (0,4) -- (0,0) -- cycle;
\end{tikzpicture}

\end{document}
```

### 绘制网格与圆

```latex
\begin{tikzpicture}
\draw[red,thick,dashed] (3,3) circle (3cm);
\draw[step=1cm,gray,very thin] (0.1,0.1) grid (5.9,5.9);
\end{tikzpicture}
```

### 绘制填充颜色

```latex
\begin{tikzpicture}
\filldraw[blue!40!white, draw=black] (0,0) rectangle (4,4);
\shade[left color=blue,right color=red] (-4,-4) rectangle (0,0);
\shade[inner color=blue,outer color=red] (-4,4) rectangle (0,0);
\shade[left color=red,right color=blue] (0,0) rectangle (4,-4);
\end{tikzpicture}
```

### 绘制坐标轴
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

## Create Flowcharts

The general steps for creating flowchart in TikZ is:

1. Create node component with ``\tikzstyle`` command
2. Draw node in tex file with ``\node`` command
3. Connect node with arrow

### Create one node component

As a start, the following script can draw a start node on pdf, you can save it as ``startnode.tex`` and run ``pdflatex startnode.tex`` to get the pdf file.

```latex
\documentclass[]{article}

\usepackage{tikz}
\usetikzlibrary{shapes.geometric, arrows}

\tikzstyle{startstop} = [rectangle, rounded corners, minimum width=3cm, minimum height=1cm,text centered, draw=black, fill=red!30]

\begin{document}

\begin{tikzpicture}[node distance=2cm]
\node (start) [startstop] {Start};
\end{tikzpicture}

\end{document}
```

Note that in the ``\node`` command, ``(start)`` is the label for reference between nodes, ``{Start}`` is the text shown in the node, ``[startstop]`` is the node name we defined in the ``\tikestyle`` command, along with any other formatting options.

### Create multiple node components

Based on this, we can create more nodes:

```latex
\documentclass[]{article}

\usepackage{tikz}
\usetikzlibrary{shapes.geometric, arrows}

\tikzstyle{startstop} = [rectangle, rounded corners, minimum width=3cm, minimum height=1cm,text centered, draw=black, fill=red!30]
\tikzstyle{io} = [trapezium, trapezium left angle=70, trapezium right angle=110, minimum width=3cm, minimum height=1cm, text centered, draw=black, fill=blue!30]
\tikzstyle{process} = [rectangle, minimum width=3cm, minimum height=1cm, text centered, draw=black, fill=orange!30]
\tikzstyle{decision} = [diamond, minimum width=3cm, minimum height=1cm, text centered, draw=black, fill=green!30]
\tikzstyle{arrow} = [thick,->,>=stealth]

\begin{document}

\begin{tikzpicture}[node distance=2cm]
\node (start) [startstop] {Start};
\node (in1) [io, below of=start] {Input};
\node (dec1) [decision, below of=in1, yshift=-0.5cm] {Decision 1};
\node (pro1) [process,   left of=dec1, yshift=-2.5cm] {Process 1};
\node (pro2) [process,  right of=dec1, yshift=-2.5cm] {Process 2};
\node (ou1) [io, below of=pro1] {Ouput1};
\node (ou1) [io, below of=pro2] {Ouput2};
\end{tikzpicture}

\end{document}
```

Note in the option part, the square bracket, we use ``yshift`` to alter the position of a node, use ``below of``, ``left of``, or ``right of`` to tell the relative position of a node.

### Connect nodes

Then, the following script add arrow between nodes:

```latex
\documentclass[]{article}

\usepackage{tikz}
\usetikzlibrary{shapes.geometric, arrows}

\tikzstyle{startstop} = [rectangle, rounded corners, minimum width=3cm, minimum height=1cm,text centered, draw=black, fill=red!30]
\tikzstyle{io} = [trapezium, trapezium left angle=70, trapezium right angle=110, minimum width=3cm, minimum height=1cm, text centered, draw=black, fill=blue!30]
\tikzstyle{process} = [rectangle, minimum width=3cm, minimum height=1cm, text centered, draw=black, fill=orange!30]
\tikzstyle{decision} = [diamond, minimum width=3cm, minimum height=1cm, text centered, draw=black, fill=green!30]
\tikzstyle{arrow} = [thick,->,>=stealth]

\begin{document}

\begin{tikzpicture}[node distance=2cm]
\node (start) [startstop] {Start};
\node (in1) [io, below of=start] {Input};
\node (dec1) [decision, below of=in1, yshift=-0.5cm] {Decision 1};
\node (pro1) [process,   left of=dec1, yshift=-2.0cm] {Process 1};
\node (pro2) [process,  right of=dec1, yshift=-2.0cm] {Process 2};
\node (ou1) [io, below of=pro1] {Ouput1};
\node (ou2) [io, below of=pro2] {Ouput2};

\draw [arrow] (start) -- (in1);
\draw [arrow] (in1) -- (dec1);
\draw [arrow] (dec1) -| node[anchor=south] {yes} (pro1);
\draw [arrow] (dec1) -| node[anchor=south] {no} (pro2);
\draw [arrow] (pro1) -- (ou1);
\draw [arrow] (pro2) -- (ou2);
\end{tikzpicture}

\end{document}
```

The ``node[anchor=east] {yes}`` add some text upon the arrows, while the ``anchor`` helps to position these text. The ``|-`` symbol make the arrow go in a horizontal direction before going in a vertical direction.

![flowchart](/assets/2019-04-10-tikz-tutorial/flowchart.svg)

## Create MindMap

## Reference

* [LaTeX Graphics using TikZ: Basic Drawing](https://www.overleaf.com/learn/latex/LaTeX_Graphics_using_TikZ:_A_Tutorial_for_Beginners_(Part_1)%E2%80%94Basic_Drawing)
* [LaTeX Graphics using TikZ: A Tutorial for Beginners (Part 3)—Creating Flowcharts](https://www.overleaf.com/learn/latex/LaTeX_Graphics_using_TikZ:_A_Tutorial_for_Beginners_(Part_3)%E2%80%94Creating_Flowcharts)
