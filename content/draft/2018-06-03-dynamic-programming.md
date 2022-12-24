---
categories: Algorithm
date: "2018-06-03T16:29:01Z"
draft: true
title: 动态规划之找零问题
toc: true
---
## 前言
很多程序的目的在数值优化。象计算两地之间的最短距离，一个点集的最佳拟合曲线，符合某些条件的最小集合等。这些问题有很多的求解方法，本节的目标就是向你展示不同的问题解决策略。动态规划就是优化问题的解决方法之一。

找零问题是数值优化的经典问题之一:

> 假设你是一个自动售货机厂商的程序员，公司决定，为每次找交易的找零，计算需要的最小的硬币数量，从而实现流程化。如果一个顾客投入了 1 美元，买了 37 美分的东西，需要最小的硬币是多少？

**答案是 6 个： 2 个 25 美分， 1 个 10 美分， 3 个 1 美分**。

如何得到这样的答案呢？

## 贪婪算法
我们从最大的硬币开始，尽可能多地使用大额硬币，直到余额不够这个面值，然后再尽可能多地使用第二面额的硬币，以此类推。这种方法叫做**“贪婪方法”**，因为我们总是对正在计算的问题，作出当前看来最好的结果。
 
但是，贪婪方法的得到的并不一定是最优解！例如对于上面找零63美分的情况，如果把自动售货机出口到Lower Elbonia（Elbonia 是系列漫画 Dilbert 中一个杜撰的原东欧共产主义国家。Lower Elbonia 指这国家的南部。)，那里除了平时所用的1，5，10和25美分硬币，还有一种21美分的。这时贪婪算法就失灵了，因为它仍然会算出6个硬币，但正确答案是3个21美分的硬币。

## 递归
我们可以考虑使用递归遍历所有的情况的硬币数：

既然是递归，我们考虑从基线情况开始，这里的基线情况是：

* 如果我们要找的零钱，正好是某个硬币的面值，那就简单了，一个硬币。

如果找零和手上的硬币都对不上号，那么答案是以下四种情况的最小值：

* 从要找的零钱中拿掉一个 1 分币，计算余额最少需要多少硬币，然后加上这个硬币
* 从要找的零钱中拿掉一个 5 分币，计算余额最少需要多少硬币，然后加上这个硬币
* 从要找的零钱中拿掉一个 10 币，计算余额最少需要多少硬币，然后加上这个硬币
* 从要找的零钱中拿掉一个 25 分币，计算余额最少需要多少硬币，然后加上这个硬币。

可以使用下面的公式来帮助该递归的理解：

$$
\begin{equation}
numCoins = min
\begin{cases}
1 + numCoins(originalcount - 1)\\
1 + numCoins(originalcount - 5)\\
1 + numCoins(originalcount - 10)\\
1 + numCoins(originalcount - 25)\\
\end{cases}
\end{equation}
$$

OK！现在可以给出递归实现的第一个版本了！
```python
coin_values = [1, 5, 10, 25]

def recMC(coin_values, change):
    minCoins = change
    if change in coin_values:
        return change
    else:
        trys = [c for c in coin_values if c <= change]
        for i in trys:
            numCoins = i + recMC(coin_values, change - i)
            if numCoins < minCoins:
                minCoins = numCoins
    return minCoins

print(recMC(coin_values, 26))
print('Call time: ', cal)
```
可以做一些改变来让它输出找零硬币的具体组合！并且打印出函数被调用的次数。

```python
coin_values = [1, 5, 10, 25]
cal = 0

def recMC(coin_values, change):
    global cal 
    cal += 1 
    minCoins = (1,) * change # Change here!
    if change in coin_values:
        return (change,) # Change here!
    else:
        trys = [c for c in coin_values if c <= change]
        for i in trys:
            numCoins = (i,) + recMC(coin_values, change - i) # Change here!
            if len(numCoins) < len(minCoins): # Change here!
                minCoins = numCoins
    return minCoins

print(recMC(coin_values, 26))
print('Call times: ', cal)
```
现在这个程序已经可以输出一些有趣的结果了！可惜的是，上面的方法非常之差实际上，找到 6 毛 3 分钱的硬币数量，进行了 67,716,925 次递归。为了帮助理解，图 5 显示了一个较小的为了找到 2 毛 6 的硬币 377 次函数调用的过程。

这主要的原因在于重复计算太多了，例如 15 分的数值至少有 3 次计算，每次计算包括 52 次函数调用，很明显我们很多时间浪费在重复计算上。

优化它的方法之一将已经计算出最小值的找钱保存在表里，每次计算之前，先查一下表看看这个结果是否已知。如果已知就直接使用表里的结果不再重复计算。
```python

coin_values = [1, 5, 10, 25]
cal = 0

def recMC(coin_values, change, knownResults):
    global cal
    cal += 1
    minCoins = (1,) * change
    if change in coin_values:
        knownResults[change] = (change,)
        return (change,)
    elif knownResults.get(change):
        return knownResults[change]
    else:
        trys = [c for c in coin_values if c <= change]
        for i in trys:
            numCoins = (i,) + recMC(coin_values, change - i, knownResults)
            if len(numCoins) < len(minCoins):
                minCoins = numCoins
                knownResults[change] = minCoins
    return minCoins


print(recMC(coin_values, 26, {}))
print('Call time: ', cal)
```
这时，可以发现找零26美分，函数调用的次数减少为58次！然而，上面的算法不能称之为动态规划，只是利用了记忆或缓冲的做法优化了我们程序的性能。

真正的动态规划算法要更加系统化地逼近问题答案。解决方法 从一个硬币开始，逐步靠近我们要计算的数值，在中间过程中每个找钱数字我们都得到了所需的最少硬币数量。下面来介绍动态规划解决该问题的方法。

## 动态规划
我们来研究一下，对于 11 分的找钱计算最小需要的硬币数量，怎样填表。如图 4 所示的过程，从 1 分开始，唯一可能是 1 个硬币。下一行显示的是 1 分和 2 分的情况，当然， 2 分也只有一个答案就是 2 个硬币。从第 5 行开始事情变得有意思起来，我们有 2 个选择，是 5 个 1 分币或 1 个 5 分币。哪个方案好？我们查表发现对要找 4 分钱的情况是 4 个硬币，加上 1 个就 5 个硬币，或者是 0 个 5 分币加上 1 个 5 分币为 1 个硬币。因为最小值是 1 ，我们在表中填上 1 。继续向前到表的末端考虑 11 分的情况，下面为我们要考虑的 3 个选项。

* 1个1分币加上10分找钱的最小硬币数量（1个）
* 1个5分币加上6分找钱的最小硬币数量（2个）
* 1个10分币加上1分找钱的最小硬币数量（1个）

第 1 和第 3 项都给出了最小值 2 的答案。

下面给出一个代码实现：
```python
def dpMakeChange(coin_values, change, minCoins):
    for cents in range(change + 1):
        coinCount = (1,) * cents
        for j in [c for c in coin_values if c <= cents]:
            if len(minCoins[cents - j]) + 1 < len(coinCount):
                coinCount = minCoins[cents - j] + (j,)
        minCoins[cents] = coinCount
    return minCoins[change]

print(dpMakeChange([1, 5, 10, 21, 25], 63, dict()))
```
这个函数的大部分工作是从第 4 行开始的循环中完成的，这个循环里，我们通过 cents 值考虑了所有可能的硬币找法，象在上面我们找 11 分的例子一样，把小于 change 值的所有最小找法存放在 minCoins 列表里。

现在，你可以告诉程序任意数量的零钱，比如63，和硬币种类，比如1, 5, 10, 25美分，然后程序会返回一个最优的找零结果``(25, 25, 10, 1, 1, 1)``，如果你添加一种新的硬币类型，比如21美分，程序则会返回给你``(21, 21, 21)``，真的是非常的酷！

## 参考资料
* [python数据结构与算法 26 动态规划](https://www.tuicool.com/articles/QFJnQf)
