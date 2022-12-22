---
categories: LaTeX
date: "2019-04-10T19:58:42Z"
title: TikZ Tutorial
toc: true
---

## 前言

[TikZ](http://cremeronline.com/LaTeX/minimaltikz.pdf)是一个[LaTeX包](https://ctan.org/pkg/pgf?lang=en)，它可以帮助你来创造高质量的图片，尤其是复杂的图片。

根据TikZ的作者Till Tantau，PGF/TikZ分别代表着"Portable Graphics Format"和"TikZ ist kein Zeichenprogramm"。PGF是引擎，TikZ是一个前端程序，也就是说如果你愿意的话也可以用PGF做引擎编写一个自己的前端程序。

TikZ可以用在PostScript的输出文件上（dvips），或者用在PDF文件的生成上（pdflatex，dvipdfmx）。它和LaTeX以及Beamer结合地很好。

很多用户使用TikZ来绘制二维图片，对于3D图片，还有其它的工具可以选择，比如Asymptote。

## TikZ基础

### Environment配置

在绘制复杂的图片之前，首先需要对TikZ的绘图环境配置进行了解。使用``TikZ``需要在tex文件中先加载对应的包：``\usepackage{tikz}``。你可以使用``\usetikzlibrary{arrows,shapes,trees,...}``来加载对应的TikZ扩展。

你可以选择在一行文字内容中间插入绘制的图片，或者选择单独的行来绘整幅的图片。

行内图片需要使用``\tikz ...;``来表示后面的内容是绘制的图片；绘制整幅图片的代码需要写在``tikzpicture``环境中。一个最简单的TikZ代码的模版如下所示：

```latex
\documentclass{article}
\usepackage[utf8]{inputenc}
\usepackage{tikz}
%\usetikzlibrary{arrows,shapes,trees,...}

\begin{document}

The inline commands are like ``\tikz \draw (0pt, 0pt) -- (20pt, 6pt);`` and ``\tikz \fill[orange] (0,0) circle (1ex);``.

\begin{tikzpicture}
% draw somthing here
\end{tikzpicture}

\end{document}
```

或者如果需要编译出一个单独的TikZ图片，你可以将documentclass变更为standalone，添加一个bounding box来规定画布的范围：

```latex
\documentclass[tikz]{standalone}
\begin{document}
\begin{tikzpicture}
% \useasboundingbox (-5,-5) rectangle (5,5);
% draw something here
\end{tikzpicture}
\end{document}
```

### ``\draw``命令绘制简单的线条和形状

``TikZ``中最简单也最常用的命令是``\draw``命令，如果希望绘制一个直线，需要使用输入这个命令同时给出开始位置的坐标，两个dash符号，接着是结束位置的坐标，然后使用分号结束一个statement。绘图的坐标系统是从图纸的左下角开始的。

```latex
\draw (0, 0) -- (4, 0);
```

![line](/assets/2019-04-10-tikz-tutorial/line.svg)

你可以使用``pdflatex templatex.tex``来编译文档，然后使用打开``template.pdf``来预览文件。如果你喜欢使用[``latexmk``](https://mg.readthedocs.io/latexmk.html)，你也可以使用``latexmk -pdf -pv template.tex``来编译和预览文件。

通过加入更多的坐标可以让它变成一个正方形：

```latex
\draw (0,0) -- (4,0) -- (4,4) -- (0,4) -- (0,0);
```

![rect](/assets/2019-04-10-tikz-tutorial/rect.svg)

这里的格式并不方便阅读，如果我们确定一条线的结尾是和开始的位置一样，就可以将上面的结尾位置的坐标用``cycle``替代：

```latex
\draw (0,0) -- (4,0) -- (4,4) -- (0,4) -- circle;
```

如果确定是要画一个矩形，我们可以进一步简化语句，使用``rectangle``关键词和矩形的开始坐标和对角坐标：

```latex
\draw (0,0) rectangle (4,4);
```

如果是画一条抛物线，可以使用``parabola``关键词和矩形的开始坐标和对角坐标：

```latex
\draw (0, 0) parabola (4,4);
```

![parabola](/assets/2019-04-10-tikz-tutorial/parabola.svg)

如果希望添加一个曲线，我们可以使用**控制点**。首先需要有一个开始坐标，然后使用``controls``关键词来定义控制点坐标，如果有多个关键词，可以用``and``隔开，最后再写上终点位置。这些控制点会像磁铁一样吸引线的走向：

```latex
\draw (0,0) .. controls (0,4) and (4,0) .. (4,4);
```

![controls](/assets/2019-04-10-tikz-tutorial/controls.svg)

如果希望画一个园，可以使用``circle``关键词，statement中的第一个作弊啊哦是圆心的位置，后面使用括号写上圆的半径：

```latex
\draw (2,2) circle (3cm);
```

![circle](/assets/2019-04-10-tikz-tutorial/circle.svg)

如果希望画一个椭圆，需要使用``ellipse``关键词，在后面的括号中需要分别写上x轴半径和y轴半径，用``and``关键词分开：

```latex
\draw (2,2) ellipse (3cm and 1cm);
```

![ellipse](/assets/2019-04-10-tikz-tutorial/ellipse.svg)

如果希望画一个圆弧，可以使用``arc`` 关键词，在下面命令的括号中，分别定义了开始角度，结束角度和半径并用冒号分开：

```latex
\draw (3,0) arc (0:75:3cm);
```

![arc](/assets/2019-04-10-tikz-tutorial/arc.svg)

如果希望对绘制线条进行自定义，可以在``\draw``命令后面写入属性，比如下面的例子我们绘制了一个红色，加粗，虚线的圆：

```latex
\draw[red,thick,dashed] (3,3) circle (3cm);
```

![circle2](/assets/2019-04-10-tikz-tutorial/circle2.svg)

绘制图形的时候经常需要绘制网格。我么你可以使用``\draw``命令结合``grid``关键词同时在后面加上一些参数来设置属性。例如下面的例子中，使用了``step=``来设置步长，同时设置了颜色和粗细，接着括号里先设置了左上角位置的坐标，然后是右下角位置的坐标：

```latex
\draw[step=1cm,gray,very thin] (-2,-2) grid (6,6);
```

![grid](/assets/2019-04-10-tikz-tutorial/grid.svg)

如果你想去边框线，你可以略微改变网格的裁剪坐标位置：

```latex
\draw[step=1cm,gray,very thin] (-2,-2) grid (6,6);
```

![grid2](/assets/2019-04-10-tikz-tutorial/grid2.svg)

### 填充颜色

如果要添加一个带有颜色填充的形状，可以使用``\fill``指令而不是``\draw``指令，同时在方括号中添加颜色。例如下面的例子中绘制了一个40%的蓝色混合60%的白色的矩形：

```latex
\fill[blue!40!white] (0,0) rectangle (4,4);
```

![fill](/assets/2019-04-10-tikz-tutorial/fill.svg)

如果希望绘制边框，可以将指令替换成``\filldraw``，然后在方括号中的参数写上填充的颜色和边框绘制的颜色：

```latex
\filldraw[blue!40!white, draw=black] (0,0) rectangle (4,4);
```

![filldraw](/assets/2019-04-10-tikz-tutorial/filldraw.svg)

如果希望填充渐变的颜色，可以使用``\shade``命令，然后在方括号中写上左边的颜色和右边的颜色：

```latex
\shade[left color=blue,right color=red] (0,0) rectangle (4,4);
```

![shade1](/assets/2019-04-10-tikz-tutorial/shade1.svg)

如果希望将渐变色颜色的方向改变为从上向下，可以修改方括号中的参数为top color和bottom color：

```latex
\shade[top color=red,bottom color=blue] (0,0) rectangle (4,4);
```

![shade2](/assets/2019-04-10-tikz-tutorial/shade2.svg)

同样，如果希望将渐变色颜色的方向改变为从内向外，可以修改方括号中的参数为inner color和outer color：

```latex
\shade[inner color=blue,outer color=red] (0,0) rectangle (4,4);
```

![shade3](/assets/2019-04-10-tikz-tutorial/shade3.svg)

如果希望对渐变色区域添加外边框，需要将命令改变为``\shadedraw``，同时在方括号中写入边框的颜色：

```latex
\shadedraw[inner color=blue,outer color=red,draw=black] (0,0) rectangle (4,4);
```

![shadedraw](/assets/2019-04-10-tikz-tutorial/shadedraw.svg)

### 使用``\clip``和``scope``对绘制图形进行剪裁

``\clip``指令让后续的绘图只有在剪裁的区域内部分才会被显示。为了闲置``\clip``的作用范围，可以使用``scope``环境进行限制。在下面的代码中，灰色的矩形只有在两个圆相交的区域内的部分被显示了出来，由于``scope``的作用，之后绘制的两个圆可以被完全显示。

```latex
\begin{tikzpicture}
\draw (-2, 1.5) rectangle (2, -1.5);
\begin{scope}
\clip (-0.5, 0) circle (1);
\clip (0.5, 0) circle (1);
\fill[color=gray] (-2, 1.5) rectangle (2, -1.5);
\end{scope}
\draw (-0.5, 0) circle (1);
\draw (0.5, 0) circle (1);
\end{tikzpicture}
```

![clip](/assets/2019-04-10-tikz-tutorial/clip.svg)

> ``\draw``，``\fill``，``\shade``，``\filldraw``分别是``\path[draw]``，``\path[fill]``，``\path[shade]``，``\path[fill,draw]``的缩写。一个Path是一系列的直线或者曲线线段。Path和Node是最基本的绘图元素。

### 使用``node``绘制带点的坐标轴

将上面的内容进行结合，可以绘制一个包含网络的坐标系，同时每个坐标轴上标有坐标。要想完成这个图的绘制，首先需要绘制两条普通的直线，它们分别从原点(0,0)出发，需要进行加粗并添加箭头，箭头可以在方括号中写入``->``来添加属性：

```latex
\draw[thick,->] (0,0) -- (4.5,0);
\draw[thick,->] (0,0) -- (0,4.5);
```

![axes1](/assets/2019-04-10-tikz-tutorial/axes1.svg)

给坐标轴添加标识需要使用``node``关键字。它的使用方法是在``\draw``命令中的坐标值后面添加``node``关键字，同时在后面的方括号中使用``anchor``关键字，最后在花括号中写上标注的内容，比如要给x轴添加标注，就要在第二个终点的后面写上``node``关键字和属性。每一个我们创建的node都有多个anchor，当我们给x轴的node定义``north west``anchor的时候，我们就是在告诉TikZ去使用位于左上角的anchor来和前面的坐标值对齐：

```latex
\draw[thick,->] (0,0) -- (4.5,0) node[anchor=north west] {x axis};
\draw[thick,->] (0,0) -- (0,4.5) node[anchor=south east] {y axis};
```

![axes2](/assets/2019-04-10-tikz-tutorial/axes2.svg)

完成这样的坐标轴还需要添加一些ticks。这使用了``\foreach``循环来减少代码的重复，循环中的每一个语句执行一次``\draw``命令，使用``\x``和``\y``变量来表示不同的值：

```latex
\foreach \x in {0,1,2,3,4}
        \draw (\x cm,1pt) -- (\x cm,-1pt) node[anchor=north] {$\x$};
\foreach \y in {0,1,2,3,4}
        \draw (1pt,\y cm) -- (-1pt,\y cm) node[anchor=east] {$\y$};
```

![axes3](/assets/2019-04-10-tikz-tutorial/axes3.svg)

### 使用``\node``预先绘制节点再连接

另一种将标注连接起来的方法是先使用``\node``指令绘制多个节点，然后再绘制线条将这些节点连接起来。

对于绘制单个节点，你可以使用``\path (x,y) node[Options] (node name) {TeX content of node}``或者``\node[Options] (node name) at (x,y) {TeX content of node}``。下面的例子预先绘制了3个节点，然后使用``\draw``命令绘制箭头将它们连接起来：

```latex
\begin{tikzpicture}[scale=.9, transform shape]
\tikzstyle{every node} = [circle, fill=gray!30]
\node (a) at (0, 0) {A};
\node (b) at +(0: 1.5) {B};
\node (c) at +(60: 1.5) {C};
\foreach \from/\to in {a/b, b/c, c/a}
\draw [->] (\from) -- (\to);
\end{tikzpicture}
```

![node](/assets/2019-04-10-tikz-tutorial/node.svg)

## 从GeoGebra生成TikZ代码

[参考](https://www.overleaf.com/learn/latex/LaTeX_Graphics_using_TikZ:_A_Tutorial_for_Beginners_(Part_2)%E2%80%94Generating_TikZ_Code_from_GeoGebra)

## 创建流程图

使用TikZ来创建flowchart的步骤为：
1. 使用 ``\tikzstyle`` 命令来创建node元素
2. 在tex文件中使用 ``\node`` 命令来绘制node
3. 使用arrow来连接node

### 创建单个节点元素

在开始绘图之前，我们需要先定义flowchart用到的node元素，node元素定义了一种类型的节点的格式。创建node元素需要使用``\tikzstyle``命令。在下面的文件中，我们创建了一个名称为``startstop``的node，这个名称的意思是这个节点的格式将会被用作开始和结束位置的节点，后面用了一个等号接上方括号，方括号里的内容定义了这个类型节点的格式，这里我们定义了矩形，圆角，最小宽度为3cm，最小高度为1cm，文字居中，黑色边框，填充颜色为30%的红色和70%的白色。

```latex
\documentclass[tikz]{standalone}

\usepackage{tikz}
\usetikzlibrary{shapes.geometric, arrows}

\tikzstyle{startstop} = [rectangle, rounded corners, minimum width=3cm, minimum height=1cm,text centered, draw=black, fill=red!30]

\begin{document}

\begin{tikzpicture}[node distance=2cm]
\node (start) [startstop] {Start};
\end{tikzpicture}

\end{document}
```

在文件中绘制这个节点需要使用``\node``命令，在``\node``命令的语法中，``(start)``是用来代表这个node的label，``{Start}``是显示在node中的文字，``[startstop]``是刚刚用``\tikestyle``命令定义的node元素类型，这样这个节点就可以套用对应元素的格式了。

在``tikzpicture``环境后的方括号里的``node distance=2cm``让node之间自动分开到中心相距2cm。

![flowchart1](/assets/2019-04-10-tikz-tutorial/flowchart1.svg)

### 创建多个节点元素

创建一个流程图往往需要多个多种类型的节点，因此需要使用``\tikzstyle``命令创建多个node元素：

```latex
\tikzstyle{startstop} = [rectangle, rounded corners, minimum width=3cm, minimum height=1cm,text centered, draw=black, fill=red!30]
\tikzstyle{io} = [trapezium, trapezium left angle=70, trapezium right angle=110, minimum width=3cm, minimum height=1cm, text centered, draw=black, fill=blue!30]
\tikzstyle{process} = [rectangle, minimum width=3cm, minimum height=1cm, text centered, draw=black, fill=orange!30]
\tikzstyle{decision} = [diamond, minimum width=3cm, minimum height=1cm, text centered, draw=black, fill=green!30]
```

将多个节点绘制在flowchart中，我们需要告诉每个节点绘制相对于其它节点的位置。为了设置位置，需要在方括号中的不仅输入node元素类型，还要用``below of``和等号接上另一个node的label。也还可以使用类似的``above of``，``right of``，``left of``来将node放到上方，右边，和左边。

```latex
\node (start) [startstop] {Start};
\node (in1) [io, below of=start] {Input};
\node (dec1) [decision, below of=in1, yshift=-0.5cm] {Decision 1};
\node (pro1) [process,   left of=dec1, yshift=-2.5cm] {Process 1};
\node (pro2) [process,  right of=dec1, yshift=-2.5cm] {Process 2};
\node (ou1) [io, below of=pro1] {Ouput1};
\node (ou2) [io, below of=pro2] {Ouput2};
```

如果希望手动调整一个节点的位置，可以在方括号中修改``yshift``或者``xshift``属性，比如上面的``dec1``节点的通过修改``yshift``向下移动了0.5cm，这样使得它的距离看起来更正常。

![flowchart2](/assets/2019-04-10-tikz-tutorial/flowchart2.svg)

### 连接节点

完成流程图，还需要使用箭头连接不同的节点。在绘制箭头之前，现需要向上一节一样在preamble部分使用``\tikzstyle``命令来定义用来画箭头的arrow的格式：

```latex
\tikzstyle{arrow} = [thick,->,>=stealth]
```

然后我们可以使用``\draw``命令来绘制箭头，在``\draw``命令的方括号中定义``[arrow]``的格式，然后使用``--``连接两个节点，每个节点用括号包裹起来。

如果希望在箭头上添加文字，可以在第二个节点前使用``\node``命令，并在后面的花括号中写上文字。例如 ``node[anchor=east] {yes}`` 添加了文字yes在箭头上，``anchor``参数设置了文字的位置。

如果希望将连接线有原来的直线设置为直线，可以将``--``，符号替换为``-|``符号，这样箭头会先走水平方向再走垂直方向。

```latex
\draw [arrow] (start) -- (in1);
\draw [arrow] (in1) -- (dec1);
\draw [arrow] (dec1) -| node[anchor=south] {yes} (pro1);
\draw [arrow] (dec1) -| node[anchor=south] {no} (pro2);
\draw [arrow] (pro1) -- (ou1);
\draw [arrow] (pro2) -- (ou2);
```

![flowchart3](/assets/2019-04-10-tikz-tutorial/flowchart3.svg)

TikZ中用于positioning nodes的库和方法是不断更新的，现在学习的画推荐去使用``positioning``库来放置nodes，使用``below=of-style``语法。``positioning``库的语法更加灵活和强大。上文中过去的语法还能使用但是官方已经废弃了。此外，``arrow``库现在已经废弃了，新的``arrows.meta``库在取而代之。其它TikZ命令和库也会逐渐被现代的库所更新。

## 使用``circuitikz``绘制电路图

使用TikZ绘制电路图可以使用[``circuitikz``](https://ctan.org/pkg/circuitikz?lang=en)包。因此在tex文件的preamble部分需要先调用包，

```latex
\usepackage{circuitikz}
```

### 串行电路

调用``circuitikz``之后就不用在调用``tikz``包了， 因为它会随着``circuitikz``包自动调用。绘制电路图要在``circuitikz``环境中绘制，使用一行``\draw``命令就可以绘制，以``;``结尾：

```latex
\begin{circuitikz} \draw
(0,0) to[battery] (0,4)
  to[ammeter] (4,4) -- (4,0)
  to[lamp] (0,0)
;
\end{circuitikz}
```

![circuit1](/assets/2019-04-10-tikz-tutorial/circuit1.svg)

绘制电路的代码格式是一对坐标和中间的连接线，这样组成的一个链式结构，你可以在这个链条后面继续添加坐标和连接线来增加元素。两个坐标之间如果使用``--``连接，那么就是绘制一个简单的直线，比如``(4,4)--(4,0)``；如果希望绘制电子元器件，需要使用``to``关键字，并在后面的方括号中写上元器件名称比如``to[battery]``。

### 并行电路

上图绘制了一个简单的串行电流表和灯泡。如果希望绘制并行的电路，可以在原来电路的基础上添加一个分支：

```latex
\begin{circuitikz} \draw
(0,0) to[battery] (0,4)
  to[ammeter] (4,4) -- (4,0)
  to[lamp] (0,0)
  (0.5,0) -- (0.5,-2)
  to[voltmeter] (3.5,-2) -- (3.5,0)
;
\end{circuitikz}
```

![circuit2](/assets/2019-04-10-tikz-tutorial/circuit2.svg)

### 绘制电路交点

如果希望在线路的交点绘制加粗的点，可以在方括号中加入``*-*``属性。例如下面的例子中，如果希望在灯泡两端绘制交点，需要缩短原本的线路，然后修改方括号内的属性，这样灯泡两边就会绘制出交点：

```latex
\begin{circuitikz} \draw
(0,0) to[battery] (0,4)
  to[ammeter] (4,4) -- (4,0) -- (3.5,0)
  to[lamp, *-*] (0.5,0) -- (0,0)
  (0.5,0) -- (0.5,-2)
  to[voltmeter] (3.5,-2) -- (3.5,0)
;
\end{circuitikz}
```

### 添加文字单位

![circuit3](/assets/2019-04-10-tikz-tutorial/circuit3.svg)

如果希望在电路上添加文字信息，首先需要在``\usepackage``命令上添加``siunitx``选项从而将电子单位加入到符号：

```latex
\usepackage[siunitx]{circuitikz}
```

在电流表上添加符号可以写成：

```latex
to[ammeter, l=2<\ampere>]
```

如果希望将符号写到电流表下面，可以将``l``替换成``l_``：

```latex
to[ammeter, l_=2<\milli\ampere>]
```

如果希望将电流标注在旁边的线上，可以将``l_``替换成``i_``：

```latex
to[ammeter, i_=2<\milli\ampere>]
```

用类似的方法可以将标注添加到电压表和电容器，``color``参数可以修改电器原件的颜色：

```latex
\begin{circuitikz} \draw
(0,0) to[battery] (0,4)
  to[ammeter, i_=2<\milli\ampere>] (4,4)
  to[C=3<\farad>] (4,0) -- (3.5,0)
  to[lamp, *-*] (0.5,0) -- (0,0)
  (0.5,0) -- (0.5,-2)
  to[voltmeter,l=3<\kilo\volt>, color=red] (3.5,-2) -- (3.5,0)
;
\end{circuitikz}
```

![circuit4](/assets/2019-04-10-tikz-tutorial/circuit4.svg)

### 两极电子元器件

除此之外，``circuitikz``还可以绘制其它电子元器件：

```latex
\begin{circuitikz} \draw
(0,0) to[R, o-o] (2,0)
(4,0) to[vR, o-o] (6,0)
(0,2) to[transmission line, o-o] (2,2)
(4,2) to[closing switch, o-o] (6,2)
(0,4) to[european current source, o-o] (2,4)
(4,4) to[european voltage source, o-o] (6,4)
(0,6) to[empty diode, o-o] (2,6)
(4,6) to[full led, o-o] (6,6)
(0,8) to[generic, o-o] (2,8)
(4,8) to[sinusoidal voltage source, o-o] (6,8)
;
\end{circuitikz}
```

![circuit5](/assets/2019-04-10-tikz-tutorial/circuit5.svg)

From the bottom left we have; a resistor, a variable resistor, a transmission line, a closing switch, a european current source, a european voltage source, an empty diode, a full led, a generic bipole and a sinusoidal voltage source.

### 多极电子元器件

Bipoles aren't the only type of component we can use. We can also add in monopoles, tripoles, double bipoles, logic gates and amplifiers. However we can't use the to keyword to add these in as we've done before, because they don't naturally fit on a single line. Instead we use node notation. For example, this is how we would display an antenna:

```latex
\begin{circuitikz} \draw
(0,0) node[antenna] {}
(4,0) node[pmos] {}
(0,4) node[op amp] {}
(4,4) node[american or port] {}
(0,8) node[transformer] {}
(4,8) node[spdt] {}
;
\end{circuitikz}
```

![circuit6](/assets/2019-04-10-tikz-tutorial/circuit6.svg)

You can add text to the symbol using the curly brackets, but note that we still need to enter curly brackets even if we don't want to use them.

To link these with other components we would use the predefined node anchors. For more information about all the components available and how you link components using node anchors, take a look at the [documentation](http://mirrors.ctan.org/graphics/pgf/contrib/circuitikz/doc/circuitikzmanual.pdf).

## 绘制 MindMap

### 绘制树状分支图

这个小节将会介绍如何使用TikZ绘制mindmap，这里使用的例子是来自[TikZ documentation](http://mirrors.ctan.org/graphics/pgf/base/doc/pgfmanual.pdf)的简化版本，你可以到原文档找到更多的细节。

使用TikZ绘制mindmap需要使用``\\usetikzlibrary{mindmap}``调用相关的库，然后在``tikz``环境中进行绘制：

```latex
\usepackage{tikz}
\usetikzlibrary{mindmap}
\pagestyle{empty}
\begin{document}
\begin{tikzpicture}

# Draw mindmap here

\end{tikzpicture}
\end{document}
```

绘制mindmap的命令有树形的嵌套结构，``\node``关键字可以定义一个节点，节点的分支节点用关键字``child``定义，后面用花括号来包裹分支节点。一行``\node``命令使用``;``符号结束。下面的例子绘制了一个包含4个分支节点的树形图，视觉效果会有些凌乱，我们需要继续调整参数来将它改成mindmap：

```latex
\node{ShareLaTeX Tutorial Videos}
  child { node {Beginners Series}}
  child { node {Thesis Series}}
  child { node {Beamer Series}}
  child { node {TikZ Series}}
;
```

![mindmap1](/assets/2019-04-10-tikz-tutorial/mindmap1.svg)

### 从树状图到MindMap图

为了将树形图整理成mindmap，可以对``tikzpicture``环境的参数进行修改。``grow cyclic``选项将每个分支节点设置为围绕这中心节点进行分布，``text width``选项设置了节点的文字宽度，``flush center``让文字居中对齐。然后对于每一个层级进行我们需要设置参数，离中心节点最近的节点用关键字level1来设置，第一代节点的分支节点用level2来设置，以此类推。设置一个层级的格式需要写成类似于``level1/.style={level distance=5cm,sibling angle=90}``的格式，在花括号中``level distance``定义了分支到上一代节点的距离，``sibling angle``定义了同代节点旋转的角度：

```latex
\begin{tikzpicture}[grow cyclic, text width=2.7cm, align=flush center,
  level 1/.style={level distance=5cm,sibling angle=90}]
```

![mindmap2](/assets/2019-04-10-tikz-tutorial/mindmap2.svg)

下面的代码展示了一个具有两个层级level1和level2的绘制效果。其中level1的节点到上一代节点的距离为5cm，同代节点旋转90度；level2的节点到上一代节点的距离为3cm，同代节点的旋转角度为45度：

```latex
\documentclass[tikz]{standalone}

\usepackage{tikz}
\usetikzlibrary{mindmap}

% \pagestyle{empty}

\begin{document}
\begin{tikzpicture}[grow cyclic, text width=2.7cm, align=flush center,
	level 1/.append style={level distance=5cm,sibling angle=90},
	level 2/.append style={level distance=3cm,sibling angle=45},]

\node{ShareLaTeX Tutorial Videos}
child { node {Beginners Series}
	child { node {First Document}}
	child { node {Sections and Paragraphs}}
	child { node {Mathematics}}
	child { node {Images}}
	child { node {bibliography}}
	child { node {Tables and Matrices}}
	child { node {Longer Documents}}
}
child { node {Thesis Series}
	child { node {Basic Structure}}
	child { node {Page Layout}}
	child { node {Figures, Subfigures and Tables}}
	child { node {Biblatex}}
	child { node {Title Page}}
}
child { node {Beamer Series}
	child { node {Getting Started}}
	child { node {Text, Pictures and Tables}}
	child { node {Blocks, Code and Hyperlinks}}
	child { node {Overlay Specifications}}
	child { node {Themes and Handouts}}
}
child { node {TikZ Series}
	child { node {Basic Drawing}}
	child { node {Geogebra}}
	child { node {Flow Charts}}
	child { node {Circuit Diagrams}}
	child { node {Mind Maps}}
};

\end{tikzpicture}
\end{document}
```

![mindmap3](/assets/2019-04-10-tikz-tutorial/mindmap3.svg)

### Mindmap颜色绘制

到现在为止绘制的图片已经有MindMap的结构了，如果希望更加美观还可以对它添加颜色。添加颜色首先需要给tikzpicture环境添加``mindmap``选项，然后需要对每个节点设置concept选项，这在tikzpicture环境添加``every node/.style=concept``即可实现。每个节点的默认颜色可以在后面写上``concept color=orange!40``来设置：

```latex
\begin{tikzpicture}[mindmap, grow cyclic, text width=2.7cm, align=flush center, every node/.style=concept, concept color=orange40!,
	level 1/.append style={level distance=5cm,sibling angle=90},
	level 2/.append style={level distance=3cm,sibling angle=45},]
```

![mindmap4](/assets/2019-04-10-tikz-tutorial/mindmap4.svg)

为不同的节点添加不同的颜色可以在``child``关键字的方括号中添加选项来设置，修改完成后当前位置的所有后代节点的颜色都会被修改：

```latex
child [concept color=blue!30] { node {Beginners Series}
...
child [concept color=yellow!30] { node {Thesis Series}
...
child [concept color=teal!40] { node {Beamer Series}
...
child [concept color=purple!50] { node {TikZ Series}
	...
	child [concept color=green!40] { node {Mind Maps}}
```

![mindmap5](/assets/2019-04-10-tikz-tutorial/mindmap5.svg)

## 使用 TikZ 绘制 Neural Network

使用TikZ绘制Neural Network的工具之一是开源包 [PlotNeuralNet](https://github.com/HarisIqbal88/PlotNeuralNet).

一个最小化的绘制Neural Network的例子如下，它的功能是绘制了两个连续的卷积层。首先需要使用``git``下载PlotNeuralNet软件包，然后到其下的``example``目录，新建一个``tex``文件，输入下面的内容。

其中在preamble部分的``\subimport{../../layers/}{init}``导入了软件宝中的``init.tex``文件，之后是导入了tikz扩展``positioning``和``3d``，``\dev\Convolor{rgb:yellow,5;red,2.5;white,5}``定义了用于填充的颜色，``\tikzstyle{connection}``定义了一个``connectin``风格用于连接不同的卷积层。卷积层的绘制部分使用``\pic``指令来绘制``Box``元素，``\draw[connection]``用来绘制之前定义好的``connection``风格的连接线。

```latex
\documentclass[border=8pt, multi, tikz]{standalone} 
\usepackage{import}
\subimport{../../layers/}{init}
\usetikzlibrary{positioning}
\usetikzlibrary{3d} %for including external image 

\def\ConvColor{rgb:yellow,5;red,2.5;white,5}
\def\PoolColor{rgb:red,1;black,0.3}

\begin{document}
\begin{tikzpicture}
\tikzstyle{connection}=[ultra thick,every node/.style={sloped,allow upside down},draw=\edgecolor,opacity=0.7]

\pic[shift={(0,0,0)}] at (0,0,0) 
    {Box={
        name=conv0,
        caption=conv0,
        xlabel={{1, }},
        zlabel=32,
        fill=\ConvColor,
        height=32,
        width=1,
        depth=32
        }
    };


\pic[shift={(1,0,0)}] at (conv0-east) 
    {Box={
        name=conv1,
        caption=conv1,
        xlabel={{6, }},
        zlabel=28,
        fill=\ConvColor,
        height=28,
        width=6,
        depth=28
        }
    };


\draw [connection]  (conv0-east)    -- node {\midarrow} (conv1-west);


\end{tikzpicture}
\end{document}
```

![minimal](/assets/2019-04-10-tikz-tutorial/minimal.svg)

## 参考

* [LaTeX Graphics using TikZ Series](https://www.overleaf.com/learn/latex/LaTeX_Graphics_using_TikZ:_A_Tutorial_for_Beginners_(Part_1)%E2%80%94Basic_Drawing)
* [PGF/TikZ - Graphics for LaTeX A Tutorial from Uni Leipzig](https://www.math.uni-leipzig.de/~hellmund/LaTeX/pgf-tut.pdf)
* [A very minimal introduction to TikZ](http://cremeronline.com/LaTeX/minimaltikz.pdf)
* [TikZ & PGF Manual](http://cremeronline.com/LaTeX/minimaltikz.pdf)
* [A great source of examples: TEXample.net](http://www.texample.net/tikz/)
* [PlotNeuralNet Github](https://github.com/HarisIqbal88/PlotNeuralNet)
