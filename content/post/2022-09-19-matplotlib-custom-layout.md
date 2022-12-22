---
categories: Python Matplotlib
date: "2022-09-19T20:34:00Z"
title: Matplotlib 绘图如何自定义布局
toc: true
---

> 这篇博客将会介绍如何使用matplotlib绘图的时候自由地控制布局，包括网格布局，图中图布局，跨单元的网格布局。

## 使用subplots

如果是需要绘制网格排布的多个图像，可以调用subplots，其中通过nrows声明行数，ncols声明列数，使用constrained_layout为True可以让其它绘图元素比如legend，axis保持合理的布局

```python
fig, axes = plt.subplots(ncols=2, nrows=2, constrained_layout=True)
```

![img](/assets/2022-09-19-matplotlib-custom-layout/subplots.png)

## 使用add_axes

如果希望绘制一个图片在另一个图里的效果，额可以通过add_axes在指定的区域放置axis，坐标的范围是0到1，左下角为(0, 0)，右上角为(1, 1)。

```python
import numpy as np
import matplotlib.pyplot as plt

fig = plt.figure()

X = [1, 2, 3, 4, 5, 6, 7]
Y = [1, 3, 4, 2, 5, 8, 6]

axes1 = fig.add_axes([0.1, 0.1, 0.9, 0.9]) # main axes
axes2 = fig.add_axes([0.2, 0.6, 0.4, 0.3]) # inset axes

# main figure
axes1.plot(X, Y, 'r')
axes1.set_xlabel('x')
axes1.set_ylabel('y')
axes1.set_title('title')

# insert
axes2.plot(Y, X, 'g')
axes2.set_xlabel('y')
axes2.set_ylabel('x')
axes2.set_title('title inside');
```

![img](/assets/2022-09-19-matplotlib-custom-layout/add_axes.png)

## 使用gridspec

如果希望更自由地控制子图地位置摆放，边缘距离，那么可以使用gridspec。你可以使用它让一个axis跨越多个grid上的位置。

```python
import matplotlib
import matplotlib.pyplot as plt
import matplotlib.gridspec as gridspec

fig = plt.figure(constrained_layout=True)
gs = fig.add_gridspec(3, 3)
ax1 = fig.add_subplot(gs[0, :])
ax1.set_title('gs[0, :]')
ax2 = fig.add_subplot(gs[1, :-1])
ax2.set_title('gs[1, :-1]')
ax3 = fig.add_subplot(gs[1:, -1])
ax3.set_title('gs[1:, -1]')
ax4 = fig.add_subplot(gs[-1, 0])
ax4.set_title('gs[-1, 0]')
ax5 = fig.add_subplot(gs[-1, -2])
ax5.set_title('gs[-1, -2]')
```

![img](/assets/2022-09-19-matplotlib-custom-layout/gridspec.png)

## 使用subfigure

如果希望为每一个子图建立独立的colorbar或者suptitle，在matplotlib的3.4版本之后，可以使用subfigures。

```python
fig = plt.figure(constrained_layout=True)
fig.suptitle('Figure title')

# create 3x1 subfigs
subfigs = fig.subfigures(nrows=3, ncols=1)
for row, subfig in enumerate(subfigs):
    subfig.suptitle(f'Subfigure title {row}')

    # create 1x3 subplots per subfig
    axs = subfig.subplots(nrows=1, ncols=3)
    for col, ax in enumerate(axs):
        ax.plot()
        ax.set_title(f'Plot title {col}')
```

![img](/assets/2022-09-19-matplotlib-custom-layout/subfigures.png)

## 参考

* <https://stackoverflow.com/questions/27426668/row-titles-for-matplotlib-subplot>
* [Gridspec in Matplotlib](https://python-course.eu/numerical-programming/gridspec-in-matplotlib.php)