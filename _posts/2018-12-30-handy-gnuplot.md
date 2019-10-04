---
layout: post
title:  "Handy GNUPlot"
date: 2018-12-31 10:22:24 +0800
categories: Linux
toc: true
---

## 前言

Linux下有非产多的用于绘制图表的工具，比如使用python语言的matplotlib。但是如果希望快速了解一个函数的情况，gnuplot是一个更方便的选择。

## Get started

### 使用plot指令

```gnuplot
plot sin(x)
```

```gnuplot
set xrange [-pi:pi]
replot
reset
```

### 自定义函数与变量

```gnuplot
w = 2
q = floor(tan(pi/2 - 0.1))
f(x) = sin(w*x)
sinc(x) = sin(pi*x)/(pi*x)
delta(t) = (t == 0)
ramp(t) = (t > 0) ? t : 0
min(a,b) = (a < b) ? a : b
comb(n,k) = n!/(k!*(n-k)!)
len3d(x,y,z) = sqrt(x*x+y*y+z*z)
plot f(x) = sin(x*a), a = 0.2, f(x), a = 0.4, f(x)
```

### 自定义plot

`plot`有这样的语法结构：

```
plot {[ranges]}
    {[function] | {"[datafile]" {datafile-modifiers}}}
    {axes [axes] } { [title-spec] } {with [style] }
    {, {definitions,} [function] ...}
```

`set`指令有下面这些用法：

```
Create a title:                  > set title "Force-Deflection Data" 
Put a label on the x-axis:       > set xlabel "Deflection (meters)"
Put a label on the y-axis:       > set ylabel "Force (kN)"
Change the x-axis range:         > set xrange [0.001:0.005]
Change the y-axis range:         > set yrange [20:500]
Have Gnuplot determine ranges:   > set autoscale
Move the key:                    > set key 0.01,100
Delete the key:                  > unset key
Put a label on the plot:         > set label "yield point" at 0.003, 260 
Remove all labels:               > unset label
Plot using log-axes:             > set logscale
Plot using log-axes on y-axis:   > unset logscale; set logscale y 
Change the tic-marks:            > set xtics (0.002,0.004,0.006,0.008)
Return to the default tics:      > unset xtics; set xtics auto
```

绘制多张plot：

```gnuplot
set multiplot;                          # get into multiplot mode
set size 1,0.5;  
set origin 0.0,0.5;   plot sin(x); 
set origin 0.0,0.0;   plot cos(x)
unset multiplot                         # exit multiplot mode
```

## 从文件数据绘制

创建下面文件命名为`force.dat`:

```
# This file is called   force.dat
# Force-Deflection data for a beam and a bar
# Deflection    Col-Force       Beam-Force 
0.000              0              0    
0.001            104             51
0.002            202            101
0.003            298            148
0.0031           290            149
0.004            289            201
0.0041           291            209
0.005            310            250
0.010            311            260
0.020            280            240
```

```
gnuplot>  plot  "force.dat" using 1:2 title 'Column', \
                "force.dat" using 1:3 title 'Beam'
```

## 执行plot scripts

创建下面的文件并命名为`force.p`：

```gnuplot
# Gnuplot script file for plotting data in file "force.dat"
# This file is called   force.p
set   autoscale                        # scale axes automatically
unset log                              # remove any log-scaling
unset label                            # remove any previous labels
set xtic auto                          # set xtics automatically
set ytic auto                          # set ytics automatically
set title "Force Deflection Data for a Beam and a Column"
set xlabel "Deflection (meters)"
set ylabel "Force (kN)"
set key 0.01,100
set label "Yield Point" at 0.003,260
set arrow from 0.0028,250 to 0.003,280
set xr [0.0:0.022]
set yr [0:325]
plot    "force.dat" using 1:2 title 'Column' with linespoints , \
    "force.dat" using 1:3 title 'Beam' with points
```

执行`gnuplot> load 'force.p'`绘制图形，这里需要上一个章节的`force.dat`文件。

## 从文档获得帮助

使用``help <command>``来从命令行获得关于指令的帮助，比如``help reset``，查询完成后使用``q``键退出。


## Reference

* [gnuplot 让您的数据可视化](https://www.ibm.com/developerworks/cn/linux/l-gnuplot/index.html)
* 要大概了解如何从命令行使用 ImageMagick， 参考[通过命令行处理图形](https://www.ibm.com/developerworks/cn/linux/l-graf/)
* [GNUPLOT 4.2 - A Brief Manual and Tutorial - Duke University](https://people.duke.edu/~hpgavin/gnuplot.html)
