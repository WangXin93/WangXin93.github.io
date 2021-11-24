---
layout: post
title:  "Matplotlib 入门简介"
date:   2021-10-20 11:57:00 +0800
categories: Python Matplotlib
toc: true
---

> Matplotlib 是一个使用 Python 语言的绘图软件包。它主要用来绘制 2D 的图形，比如折线图，统计直方图，散点图，柱状图，饼图，箱型图等，也可以用来绘制有限的 3D 图形。这篇博客会介绍 Matplotlib的框架概要，基本绘图方法，常见的属性修改，和动图的绘制方法。

## 背景

**Matplotlib 的结构层级**： Matplotlib有3层结构：Backend，Artist 和 Scripting。Scripting是用户绘制图形的层级，Artist是内部绘图任务的层级，Backend是图象显示的层级。

* Backend 层：这时最底部的接近输出设备的层级，Matplotlib支持不同的用户界面，可以分类两种类型：User Interface Backend，比如pygtk，wxpython，tkinter，qt4，macosx等，通常被称为可以交互的backend；另一种类型是bu绘制图像文件，比如PNG，SVG，PDF，PS，通常被称为不可交互的backend。通过配置可以使用不同的backend。
* Artist 层：这是介于中间的一个层，Matplotlib使用artist object来绘制不同的图像元素，每一个图像中的元素都是artist。这一层提供了面向对象的API来灵活地绘图，它适合于熟练的Python程序员，可以创建复杂的绘图报告和仪表盘。
* Scripting 层：这是最顶部的一层，这一层提供了用户绘图的简单接口，这适用于没有过多编程经验的用户，被称为 pyplot API。

Matplotlib 的最高层级的 matplotlib 对象称为 Figure，它包含不同的绘图元素，每个元素都是可以定制的，常见的元素类型如下图所示：

![img](/assets/2021-10-20-matplotlib-intro/elements.png)

* Figure: 完整的图片即 Figure，它包含所有的其它元素。
* Axes：Axes 是 Figure 的一个部分，是图像绘制的地方，Axes 包含 title，x-label 和 y-label。一个 Figure 可以包含许多的 Axes。
* Axis：坐标轴可以表示绘图的数值范围，2D 图像包含X轴，Y轴，3D 图像有X，Y和Z轴。
* Label：是在X轴，Y轴的标注或者图上的其它标注。
* Legend：图例，一般标注在图像角落，用来表示不同标注的含义。
* Title：图像的标题，一般出现在图像的顶部，每个Axes都可以有自己的标题，因此一个figure可能有多个标题。
* Tick Label：坐标的刻度，它们会等距地出现在x轴，y轴上。坐标刻度可以分为major bins（0，1，2，3）和 minor bins（0，0.25，0.5，0.75）。
* Spines: figure 周围的边界，每个figure有4个spines，分为top，bottom，left和right。
* Grid：图像上的网格会把图像区域分为不同的部分，会有助于图像山数值的估计，通常grid会在major tick的位置构成。

maplotlib的图像分为interactive mode和non-interactive mode，interactive mode会在状态改变时候更新图像，而non-interactive mode不能。使用``pyplot.ion()``可以开启interactive mode，使用``pyplot.ioff()``可以关闭，使用``matplotlib.is_interactive()``可以检测interactive的状态。

matplotlib使用``matplotlibrc``文件来存放自定义的变量值。使用``matplotlib.rc``可以改变一组变量的值，``matplotlib.rcParams``可以改变一个变量的值，``matplotlib.rcdefaults()``可以重置为默认值。[官方文档](https://matplotlib.org/stable/tutorials/introductory/customizing.html)有一个自定义matplotlib属性的教程。

```python
# Get the location of matplotlibrc file
import matplotlib
matplotlib.matplotlib_fname()

# changing default values for multiple parameters within the group 'lines'
matplotlib.rc('lines', linewidth=4, linestyle='-', marker='*')

#changing default values for parameters individually
matplotlib.rcParams['lines.markersize'] = 20
matplotlib.rcParams['font.size'] = '15.0'
```
## 基础绘图功能

**折线图（Line Plot）** 折线图可以用来表示两个连续变量之间的关系，通常用于可视化变量的变化趋势，比如GDP的变化，股价的变化，利率的变化等。

```python
import matplotlib.pyplot as plt
#正常显示画图时出现的中文和负号
plt.rcParams['font.sans-serif'] = ['simhei']  #用来正常显示中文标签
plt.rcParams['axes.unicode_minus'] = False   #用来正常显示负号

import pandas as pd

# 获取股票信息
import tushare as ts
hs300 = ts.get_hist_data('hs300')
hs300.sort_values('date', inplace=True)

fig = plt.figure(figsize=(16, 7))
plt.plot(pd.to_datetime(hs300.index), hs300['close'])
plt.title('沪深300指数')
plt.show()
```

![img](/assets/2021-10-20-matplotlib-intro/hs300.png)

**柱状图（Bar Plot）** 柱状图可以用来对比不同类别的数据之间的区别。柱状图可以水平绘制或者垂直绘制。

```python
import matplotlib.pyplot as plt
import calendar
import numpy as np

daily_incomes = [100, 300, 500, 200, 300, 400, 600]

fig = plt.figure(figsize=(8, 6))
plot = plt.bar(np.arange(7), daily_incomes)

# 绘制额外文字
for rect in plot:
    height = rect.get_height()
    plt.text(rect.get_x() + rect.get_width()/2., 1.002*height,'%d' % int(height), ha='center', va='bottom')
    
# 绘制x轴ticks
plt.xticks(np.arange(7), calendar.day_name[0:7], rotation=20)

plt.title('Daily Income in a Week')
plt.show()
```

![img](/assets/2021-10-20-matplotlib-intro/bar.png)

```python
daily_incomes = [100, 300, 500, 200, 300, 400, 600]

fig = plt.figure(figsize=(8, 6))
plot = plt.barh(np.arange(7), daily_incomes)
    
# 绘制x轴ticks
plt.yticks(np.arange(7), calendar.day_name[0:7], rotation=20)

plt.title('Daily Income in a Week')
plt.show()
```

![img](/assets/2021-10-20-matplotlib-intro/barh.png)

**统计直方图（Histogram）** 可以用来描述连续变量的分布，统计直方图绘制时将连续变化分到不同的范围，每个范围成为一个bin，对落到每个bin内的样本数量进行计数。

```python
from sklearn.datasets import load_boston
import matplotlib.pyplot as plt

X, y = load_boston(return_X_y=True)

fig = plt.figure(figsize=(8, 6))
plt.hist(y, bins=20, color='green', alpha=0.5)
plt.title('Boston House Price Historgram')
```

![img](/assets/2021-10-20-matplotlib-intro/boston_hist.png)

**散点图（Scatter Plot）**可以用来观察两个变量之间是否存在关联，或者数据点是否存在聚类中心。

```python
from sklearn.datasets import load_iris
import matplotlib.pyplot as plt

X, y = load_iris(return_X_y=True)

plt.figure(figsize=(8, 6))
plt.scatter(X[:, 1], X[:, 2], c = y)
plt.title('Iris Dataset Scatter Plot')

# 取消spines
ax = plt.gca()
ax.spines['right'].set_visible(False)
ax.spines['top'].set_visible(False)

plt.show()
```

![img](/assets/2021-10-20-matplotlib-intro/iris_scatter.png)

**饼图（Pie Plot）**适用于显示每个类别的群体对于总体的贡献，比如每月生活开支的组成，学生不同年级的组成，国家GDP的来源组成等。

```python
methods = ['微信', '支付宝', '银行卡', '现金', '信用卡']
amount = [70, 90, 65, 50, 110]
money = pd.DataFrame({'methods': methods, 'amount':amount})

# 按数量从高到低排序
money = money.sort_values('amount', ascending=True)

fig = plt.figure(figsize=(8, 6))

exploValue=[0.01,0.01,0.01,0.01,0.1]

plt.pie(
    money.amount, 
    exploValue,
    autopct='%1.1f%%',
    colors=['#FFB6C1','#6495ED','#40E0D0','#b0a4e3','#808080'],
    labels=[str(money.methods[i])+': '+str(money.amount[i]) for i in range(len(money))],
)

plt.title('不同支付方式对应顾客的总金额图')
plt.legend(money.methods, bbox_to_anchor=(1.1,1), loc="upper left")
plt.show()
```

![img](/assets/2021-10-20-matplotlib-intro/pie.png)

**展示图片** matplotlib 可以使用 imread 函数读取图片，使用 imshow 函数显示图片。

```python
import requests
import io

f = "http://matplotlib.sourceforge.net/_static/logo2.png"
r = requests.get(f)
img = plt.imread(io.BytesIO(r.content))

plt.imshow(img)
plt.axis('off')

plt.show()
```

![img](/assets/2021-10-20-matplotlib-intro/logo2.png)

**热力图（Heatmap）** 可以用来显示不同位置上的数值，例如显示不同变量组合的相关性。

```python
df = load_diabetes(as_frame=True)

corr = df['data'].corr()

plt.figure(figsize=(8, 6))
plt.imshow(corr,cmap='hot')
plt.colorbar()
plt.xticks(range(len(corr)),corr.columns, rotation=20)
plt.yticks(range(len(corr)),corr.columns)
plt.show()
```

![img](/assets/2021-10-20-matplotlib-intro/heatmap.png)

**轮廓图（Contour Plot）** 可以用来显示连续空间上的数值变化，比如可视化函数在二维空间上的数值。创建轮廓图需要先创建一个meshgrid，meshgrid上每一个点对应二维空间上一个点，然后告诉matplotlib每一个点上的数值，就可以完成轮廓图的绘制。

```python
import numpy as np
import matplotlib.pyplot as plt

delta = 0.025
x = np.arange(-3.0, 3.0, delta)
y = np.arange(-2.0, 2.0, delta)
X, Y = np.meshgrid(x, y)
Z1 = np.exp(-X**2 - Y**2)
Z2 = np.exp(-(X - 1)**2 - (Y - 1)**2)
Z = (Z1 - Z2) * 2

fig, ax = plt.subplots()
CS = ax.contour(X, Y, Z)
ax.clabel(CS, inline=True, fontsize=10)
ax.set_title('Simplest default with labels')
```

![img](/assets/2021-10-20-matplotlib-intro/contour.png)

**盒型图（Box Plot）** 可以用来描述连续变量的统计特征。盒型图上的突起表示上四分位点和下四分位点，额外的点表示异常点。

```python
X, y = load_iris(return_X_y=True)

plt.figure(figsize=(8, 6))
plt.boxplot(X)
plt.title('Iris Dataset Boxplot')
plt.show()
```

![img](/assets/2021-10-20-matplotlib-intro/iris_boxplot.png)

**极坐标图（Polar Plot）** 极坐标图使用极坐标系进行绘制。

```python
import numpy as np
import matplotlib.pyplot as plt

Depts = ["网络","数据结构","操作系统","算法", "前端"]
rp = [80, 60, 80, 70, 50, 80]
ra = [90, 70, 70, 65, 80, 90]

plt.figure(figsize=(10,6))
plt.subplot(polar=True)

# 将360度等分，matplotlib.pyplot使用 radian
theta = np.linspace(0, 2 * np.pi, len(rp))

# 布局 theta grid
(lines,labels) = plt.thetagrids(range(0,360, int(360/len(Depts))), (Depts))

# 绘制实际数据，填充数据使用极坐标系
plt.plot(theta, rp)
# 填充中间区域
plt.fill(theta, rp, 'b', alpha=0.1)

# 绘制计划数据
plt.plot(theta, ra)

plt.legend(labels=('计划','实际'),loc=1)
plt.title("极坐标图")

plt.show()
```

![img](/assets/2021-10-20-matplotlib-intro/polar.png)

流体场图（Stream Plot）

```python
import numpy as np
import matplotlib.pyplot as plt
import matplotlib.gridspec as gridspec

x, y = np.linspace(-3,3,100), np.linspace(-2,4,50)
xx, yy = np.meshgrid(x, y)
U = 1 - xx**4
V = 1 + yy**4 
plt.figure(figsize=(8, 6))
plt.streamplot(xx, yy, U, V)
plt.title('Basic Stremplot')
plt.show()
```

![img](/assets/2021-10-20-matplotlib-intro/streamplot.png)

绘制路径（Path）

```python
import matplotlib.pyplot as plt
from matplotlib.path import Path
import matplotlib.patches as patches


# 定义绘制路径经过的店
verts1 = [(-1.5, 0.),        # left, bottom
          (0., 1.),          # left, top
          (1.5, 0.),         # right, top
          (0., -1.0),        # right, bottom
          (-1.5, 0.)]        # ignored
# 定义如何绘制路径
codes1 = [Path.MOVETO,       # Go to first point specified in vert1
         Path.LINETO,        # Draw a line from first point to second point
         Path.LINETO,        # Draw another line from current point to next point
         Path.LINETO,        # Draw another line from current point to next point
         Path.CLOSEPOLY]     # Close the loop
# 完成路径
path1 = Path(verts1, codes1)

ax = plt.gca()
patch1 = patches.PathPatch(path1, lw=4, zorder=2)
ax.add_patch(patch1)

ax.set_xlim(-2,2)
ax.set_ylim(-2,2)

plt.show()
```

![img](/assets/2021-10-20-matplotlib-intro/path.png)

三角化图（Triangulations）

```python
import matplotlib.tri as tri

data = np.random.rand(50, 2)
triangles = tri.Triangulation(data[:,0], data[:,1])
plt.triplot(triangles)
plt.show()
```

![img](/assets/2021-10-20-matplotlib-intro/tri.png)

## 动画制作

[pause](https://matplotlib.org/stable/api/_as_gen/matplotlib.pyplot.pause.html) 指令可以用来制作简单的动画，复杂的动画可以使用[matplotlib.animation](https://matplotlib.org/stable/api/animation_api.html#module-matplotlib.animation)。pause 可以运行GUI的事件循环数秒。

下面的代码可以在GUI显示 sin 函数的动画，其中``plt.pause(1/24)``会停止1/24秒，同时更新绘图区域。如果希望保存每一帧的图像可以使用``plt.savefig()``。

```python
import matplotlib.pyplot as plt
import numpy as np

for i in range(100):
    plt.figure(2)
    plt.clf()
    x = np.linspace(-10, 10)
    y = np.sin(x + 1/24 + i)
    plt.plot(x, y)
    plt.savefig('frame{:0>2d}.png'.format(i))
    plt.pause(1/24) # pause a bit so that plots are updated

plt.show()
```

可以使用[ImageMagick](http://www.imagemagick.org/)在命令行将多幅png文件转换为gif文件：

```bash
convert -loop 0 frame{00..99}.png sin.gif
```

![img](/assets/2021-10-20-matplotlib-intro/sin.gif)

[Animation](https://matplotlib.org/stable/api/animation_api.html) 类可以用来使用 matplotlib 生成动画。Animation 类分为 FuncAnimation （通过重复调用函数制作动画） 和 ArtistAnimation（使用一系列的 Artist 对象制作动画）。

当使用 FuncAnimation 的时候，当使用``blit=True``使用[Blitting](https://en.wikipedia.org/wiki/Bit_blit)的时候，需要让func和init_func保持能够得到一个对象知道在哪个artists上绘制，在下面的代码中为ln，ln被保存在globa scope中，此外也可以使用function.partial将artist绑定到函数上，使用函数闭包，或者使用一个类。

```python
import numpy as np
import matplotlib.pyplot as plt
from matplotlib.animation import FuncAnimation, PillowWriter

fig, ax = plt.subplots()
xdata, ydata = [], []
ln, = plt.plot([], [], 'go')

writer = PillowWriter(fps=24, metadata=dict(artist='Me'), bitrate=1800)

def init():
    ax.set_xlim(0, 2*np.pi)
    ax.set_ylim(-1, 1)
    return ln,

def update(frame):
    xdata.append(frame)
    ydata.append(np.sin(frame))
    ln.set_data(xdata, ydata)
    return ln,

ani = FuncAnimation(fig, update, frames=np.linspace(0, 2*np.pi, 128),
                    init_func=init, blit=True)

ani.save('im.gif', writer=writer)
```

![img](/assets/2021-10-20-matplotlib-intro/sin_go.gif)

ArtistAnimation会对一系列已经固定的artist创建动画。

```python
fig2 = plt.figure()

x = np.arange(-9, 10)
y = np.arange(-9, 10).reshape(-1, 1)
base = np.hypot(x, y)
ims = []
for add in np.arange(15):
    ims.append((plt.pcolor(x, y, base + add, norm=plt.Normalize(0, 30)),))

im_ani = animation.ArtistAnimation(fig2, ims, interval=50, repeat_delay=3000,
                                   blit=True)
im_ani.save('im.mp4', writer=writer)
```

保存动画可以使用 Animation.save, Animation.to_html5_video, or Animation.to_jshtml。你需要将 writer 给到 save 函数，有不同的 writer 可以选择，包括 PillowWriter，HTMLWriter，FFMpegWriter，ImageMagickWriter，FFMpegFileWriter，ImageMagickFileWriter。

## 参考

* <https://github.com/PacktPublishing/Matplotlib-3.0-Cookbook>
* <https://matplotlib.org/2.0.2/examples/animation/basic_example_writer.html>
* <https://matplotlib.org/stable/api/animation_api.html#module-matplotlib.animation>