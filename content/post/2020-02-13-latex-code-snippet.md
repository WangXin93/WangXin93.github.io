---
categories: LaTeX
date: "2020-02-13T16:21:44Z"
title: Code Snippet in Latex（Latex中的代码片段）
toc: true
---

## 前言

LaTeX默认的代码环境是verbatim，但是lstlisting包是更常用的选择。

### 插在其它文字间的代码

这里设置了一个代码背景颜色和字体：

```latex
\definecolor{codegray}{gray}{0.9}
\newcommand{\code}[1]{\colorbox{codegray}{\texttt{#1}}}
```

### 整段代码

使用lstlisting环境：

```latex
\begin{lstlisting}[language=Python]
import numpy as np
    
def incmatrix(genl1,genl2):
    m = len(genl1)
    n = len(genl2)
    M = None #to become the incidence matrix
    VT = np.zeros((n*m,1), int)  #dummy variable
    
    #compute the bitwise xor matrix
    M1 = bitxormatrix(genl1)
    M2 = np.triu(bitxormatrix(genl2),1) 

    for i in range(m-1):
        for j in range(i+1, m):
            [r,c] = np.where(M2 == M1[i,j])
            for k in range(len(r)):
                VT[(i)*n + r[k]] = 1;
                VT[(i)*n + c[k]] = 1;
                VT[(j)*n + r[k]] = 1;
                VT[(j)*n + c[k]] = 1;
                
                if M is None:
                    M = np.copy(VT)
                else:
                    M = np.concatenate((M, VT), 1)
                
                VT = np.zeros((n*m,1), int)
    
    return M
\end{lstlisting}
```

添加颜色，使用文件导入代码，和caption：

```latex
\documentclass{article}
\usepackage[utf8]{inputenc}

\usepackage{listings}
\usepackage{xcolor}

\definecolor{codegreen}{rgb}{0,0.6,0}
\definecolor{codegray}{rgb}{0.5,0.5,0.5}
\definecolor{codepurple}{rgb}{0.58,0,0.82}
\definecolor{backcolour}{rgb}{0.95,0.95,0.92}

\lstdefinestyle{mystyle}{
    backgroundcolor=\color{backcolour},   
    commentstyle=\color{codegreen},
    keywordstyle=\color{magenta},
    numberstyle=\tiny\color{codegray},
    stringstyle=\color{codepurple},
    basicstyle=\ttfamily\footnotesize,
    breakatwhitespace=false,         
    breaklines=true,                 
    captionpos=b,                    
    keepspaces=true,                 
    numbers=left,                    
    numbersep=5pt,                  
    showspaces=false,                
    showstringspaces=false,
    showtabs=false,                  
    tabsize=2
}

\lstset{style=mystyle}

\begin{document}
The next code will be directly imported from a file

\lstinputlisting[language=python, , caption=Python example]{scirpt.py}
\end{document}
```

这些caption可以被用在``\lstlistoflistings``来列出所有的代码块。

## Reference

* [Listing Package Document](http://texdoc.net/texmf-dist/doc/latex/listings/listings.pdf)
* [set the font family for lstlisting](https://tex.stackexchange.com/questions/33685/set-the-font-family-for-lstlisting)
* [Code listing](https://www.overleaf.com/learn/latex/code_listing)
