---
categories: Python
date: "2021-06-13T09:39:20Z"
title: 使用matplotlib绘图
toc: true
---

> Matplotlib 是适用于 python 语言的最流行的绘图包。你可以使用 matplotlib 可以控制绘制的图片上的方方面面。在程序设计方法，matplotlib 和 Matlab 上的绘图接口设计类似，所以在这两种程序之间切换会很容易。最后，matplotlib 和 numpy 和 pandas 中的数据结构兼容性很好，你可以流畅地使用 numpy 和 pandas 操作数据，同时使用 matplotlib 来绘制数据的图像。

## 前言

安装 matplotlib 可以使用``pip``或者``conda``完成。

```
conda install matplotlib

pip install matplotlib
```

matplotlib 的 官方主页在[这里](https://matplotlib.org/)，你可以在主页上发现 matplotlib 的社区，当你需要查询某个绘图函数的时候，可以查阅官方[文档](https://matplotlib.org/stable/contents.html)，还有一种方法是如果你想绘制某一种图像，比如柱状图，你可以先到主页提供的[例子](https://matplotlib.org/stable/gallery/index.html)去寻找类似的图像，然后在例子的源码中进行修改，这样可以更快地完成任务。

## plot

```python
plt.plot(x, y)
plt.xlabel('x')
plt.ylabel('y')
plt.title('y=sin(x)')
```

## subplot

Functional Programming 方法来绘制多个subplot。

```python
plt.subplot(1, 2, 1)
plt.plot(x, y, 'r')
plt.subplot(1, 2, 2)
plt.plot(y, x, 'b')
```

Object Oriented 方法允许我们进行更多的绘图设置。

```python
# fig 就好像一个空白的画纸，你可以在上面添加 axes
fig = plt.figure()

# 添加axes到figure，括号中的参数含义为left, bottom, width, height，单位为相对于整个figure的百分比
axes = fig.add_axes([0.1, 0.1, 0.8, 0.8])

# 在axes中绘制图像
axes.plot(x, y)

axes.set_xlabel('x')
axes.set_ylabel('y')
axes.set_title('y = sin(x)')
```

下面来使用Object Oriented 方法在一个figure上绘制两个axes。

```python
fig = plt.figure()

# 这会得到两个有重叠的axes
axes1 = fig.add_axes([0,1, 0.1, 0.8, 0.8])
axes2 = fig.add_axes([0.2, 0.5, 0.4, 0.4])

axes1.plot(x, y)
axes2.plot(y, x)

axes1.set_title('main plot')
axes2.set_title('inner plot')
```

``add_axes())``可以让你在figure上的任意位置摆放axes。

下面展示如何使用 Object Oriented 方法来实现和 Functional Programming 方法一样的subplot，得到一个按行和按列排列的subplots。

```python
fig, axes = plt.subplots(nrows=1, ncols=2)

axes[0].plot(x, y)
axes[1].plot(y, x)

axes[0].set_title('Title 1')
axes[1].set_title('Title 2')

# 解决多个子图的重叠问题
plt.tight_layout()
```

设置图像尺寸和DPI

```python
# 单位为inch
fig, axes = plt.subplots(figsize=(8, 8), nrows=1, ncols=1)
plt.savefig('myfig.pdf', dpi=200)
```

legend 或者说图例是用一个标记来表示哪个图对应哪个数据

```python
fig = plt.figure()

ax = fig.add_axes([0, 0, 1, 1])

ax.plot(x, x**2, label='X Squared')
ax.plot(x, x**3, label='X Cubed')

# 你可以设置图例在figure上的什么位置，从而避免和其它图像重叠
# 可以字符串来使用预先定义的常见位置
ax.legend(loc='upper left')
# 或者设置数字，来自定义图例的位置
ax.legend(loc=[0.1, 0.1])
```

## line and marker style

```python
fig = plt.figure()
ax.plot(x, y, color='#FF8C00') # RGB Hex Code
ax.plot(x, y, color='blue') # Named color

ax.plot(x, y, linewidth=3)
ax.plot(x, y, lw=3, alpha=0.3)
ax.plot(x, y, linestyle='--')
ax.plot(x, y, ls='steps')

ax.plot(x, y, ls='-', marker='o', markersize=10, markerfacecolor='yellow', markeredgewidth=3) # Markers
```

## configure x axis and y axis

```python
ax.set_xlim([0, 1])
ax.set_ylim([0, 2])
```

## text

## colormap

## style

## 3D plot

## animation

## pandas plot

## 常见问题

中文字体，其他小语种字体。

绘制包含时间轴的图像

## 结语

## 参考

* [Gallery](https://matplotlib.org/stable/gallery/index.html)
