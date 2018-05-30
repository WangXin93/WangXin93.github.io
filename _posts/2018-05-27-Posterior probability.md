---
layout: post
title:  "先验概率，后验概率，贝叶斯公式，似然函数"
date: 2018-05-27 14:29:00 +0800
categories: Math
---

## 前言
现代机器学习运用了很多统计学的思想，经常出现先验概率，后验概率，贝叶斯公式，似然函数这些概念，为了理清思路，整理它们如下。

## 对比先验概率与后验概率
| 先验概率|后验概率|
|:-------:|:-------:|
| 是根据以往经验和分析得到的概率。| 事情已经发生，要求这件事情发生的原因是由某个因素引起的可能性的大小。|
| 先验概率常用于预测。|后验概率常用于追责。 |
| 先验概率是在缺乏某个事实的情况下描述一个变量，通常是经验丰富的专家的纯主观估计。 | 后验概率可以通过贝叶斯公式，用先验概率和似然函数计算出来。后验概率是在考虑了一个事实之后的条件概率。|

先验概率的例子：比如在法国大选中女候选罗雅尔的支持率 p,在进行民意调查之前, 可以先验概率来表达这个不确定性。
后验概率的例子：桌子上如果有一块肉和一瓶醋,你如果吃了一块肉,然后你觉得是酸的,那你觉得肉里加了醋的概率有多大?你说:80%可能性加了醋.这时,你已经进行了一次后验概率的猜测。
![img](/assets/posterior_probability/vinegar.png)

    "概率论只不过是把常识用数学公式表达了出来"---拉普拉斯

更为广泛的，令B为事件的结果，这里为肉变酸，A和C为事件的不同原因，那么有：
$$
P(A|B) = \frac{P(A,B)}{P(B)} = \frac{P(B|A)*P(A)}{P(B|A)*P(A) + P(B|C)*P(C)}
$$
其中$P(A|B)$就是后验概率，$P(B)$的展开使用了全概率公式。

## 小测验

> 问题：有三个门，里面有一个里有汽车，如果选对了就可以得到这辆车，当应试者选定一个门之
> 后，主持人打开了另外一个门，空的。问应试者要不要换一个选择。假设主持人知道车所在的那
> 门。

**解法：**
* 应试者第一次选中有车的门的概率是$\frac{1}{3}$，这时主持人打开一个空门，另外一个门100%没有车；
* 应试者第一次选中没车的门的概率是$\frac{2}{3}$，这时主持人打开一个空门，另外一个门100%有车。

所以如果坚持原来的选择，选到车的概率为：$ \frac{1}{3} \times 1 + \frac{2}{3} \times 0 = \frac{1}{3}$，如果选择另一个门，那么选到车的概率为：$\frac{2}{3} \times 1 + \frac{1}{3} \times 0 = \frac{2}{3} $。可知换一个门更可能选到车。

**疑问：**
现在主持人已经打开一个空门了（而且主持人是有意打开这个门的），在这一“信息” 出现后，还能说当初选错的概率是2/3吗？这一后验事实不会改变我们对于先验概率的看法吗？

对于这个问题，可以用贝叶斯公式进行解释：
假设我选了B门，假设主持人打开了C门，那么他在什么情况下会打开C门呢？
* 如果A有车（先验概率=$\frac{1}{3}$），那么主持人100%会打开C门
* 如果B有车（先验概率=$\frac{1}{3}$），那么主持人有A和C两个选择，假设他以K的概率打开C（K一般为$\frac{1}{2}$，这里为变量）
* 如果C有车（先验概率=$\frac{1}{3}$），主持人打开C的概率为0
所以在主持人打开C门的条件下，B有车的概率可以表示为：
$$
\begin{aligned}
P((B\ have\ car|C\ open) &= \frac{P(C\ open|B\ have\ car) P(B\ have\ car)}{P(C\ open)} \\
& = \frac{P(C\ open|B\ have\ car) P(B\ have\ car)}{|P(C\ open|A\ have\ car)P(A\ have\ car)+ P(C\ open|B\ have\ car)P(B\ have\ car)} \\
& = \frac{\frac{1}{3} \times K}{\frac{1}{3} \times 1 + \frac{1}{3} \times K} \\
& = \frac{K}{1 + K}
\end{aligned}
$$
当$K=\frac{1}{2}$的受，C门打开的情况下B有车的概率为$\frac{1}{3}$，这时C门打开的这个事实并没有影响B有车的概率。如果偏好打开右边的门（假设C在右边），这时K就会改变，假设为$\frac{3}{4}$，那么B有车的概率就变成了$\frac{3}{7}$，不再是$\frac{1}{3}$，后验事实改变了先验概率的估计！

所以，我们还需要改变选择另一个门么？另一个门（A门）有车的概率为多大呢？
$$
\begin{aligned}
P((A\ have\ car|C\ open) &= \frac{P(C\ open|A\ have\ car) P(A\ have\ car)}{P(C\ open)} \\
& = \frac{P(C\ open|A\ have\ car) P(A\ have\ car)}{P(C\ open|A\ have\ car)P(A\ have\ car)+ P(C\ open|B\ have\ car)P(B\ have\ car)} \\
& = \frac{1 \times 1/3}{1 \times 1/3 + K \times 1/3} \\
& = \frac{1}{1 + K}
\end{aligned}
$$
由于主持人不会极端到非C不选，所以$k < 1$所以在C门打开的情况下，A有车的概率始终比B有车的概率大。也就是说，换一个门选中车的概率更大。

最后，用Wikipedia的解释来总结先验概率，后验概率，贝叶斯公式，似然函数之间的关系：

> A prior probability is a marginal probability, interpreted as a description of
> what is known about a variable in the absence of some evidence. The posterior > probability is then the conditional probability of the variable taking the
> evidence into account. The posterior probability is computed from the prior 
> and the likelihood function via Bayes' theorem.

## 似然函数
似然函数（likelihood function），也称作似然，是一个关于统计模型参数的函数。也就是这个函数中自变量是统计模型的参数。对于结果 x ，在参数集合 θ 上的似然，就是在给定这些参数值的基础上，观察到的结果的概率 L(θ|x)=P(x|θ) 。也就是说，似然是关于参数的函数，在参数给定的条件下，对于观察到的 x 的值的条件分布。

**概率与似然**
概率是用于描述一个函数，这个函数是在给定参数值的情况下的关于观察值的函数。例如，已知一个硬币是均匀的（在抛落中，正反面的概率相等），那连续10次正面朝上的概率是多少？这是个概率。

似然是用于在给定一个观察值时，关于用于描述参数的情况。例如，如果一个硬币在10次抛落中正面均朝上，那硬币是均匀的（在抛落中，正反面的概率相等）概率是多少？这里用了概率这个词，但是实质上是“可能性”，也就是似然了。
## 参考资料
* [贝叶斯公式的直观理解(先验概率/后验概率)](https://www.cnblogs.com/yemanxiaozu/p/7680761.html)
* [先验概率与后验概率及贝叶斯公式](https://blog.csdn.net/passball/article/details/5859878)
* [先验概率、似然函数与后验概率](http://www.cnblogs.com/wjgaas/p/4523779.html)