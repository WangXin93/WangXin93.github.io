---
layout: post
title:  "Pytorch中的hook有什么用？"
date: 2018-10-25 15:39:00 +0800
categories: PyTorch
toc: true
---

## 前言

打个比方，有这么个函数$$x in \mathbb{R}^2, y=x+2, z=\frac{1}{2} ({y_1}^2 + {y_2}^2)$$，你想通过梯度下降法求最小值。在PyTorch里面很容易实现，你只需要：

```python
import torch
from torch.autograd import Variable

x = Variable(torch.randn(2, 1), requires_grad=True)
y = x+2
z = torch.mean(torch.pow(y, 2))
lr = 1e-3
z.backward()
x.data -= lr*x.grad.data
```

但问题是，如果我想要求中间变量 的梯度，系统会返回错误。事实上，如果你输入：``type(y.grad)``

系统会告诉你：``NoneType``

这个问题在PyTorch的论坛上有人提问过，开发者说是因为当初开发时设计的是，对于中间变量，一旦它们完成了自身反传的使命，就会被释放掉。

因此，hook就派上用场了。简而言之，``register_hook``的作用是，当反传时，除了完成原有的反传，额外多完成一些任务。你可以定义一个中间变量的hook，将它的grad值打印出来，当然你也可以定义一个全局列表，将每次的grad值添加到里面去。

```python
import torch
from torch.autograd import Variable

grad_list = []

def print_grad(grad):
    grad_list.append(grad)

x = Variable(torch.randn(2, 1), requires_grad=True)
y = x+2
z = torch.mean(torch.pow(y, 2))
lr = 1e-3
y.register_hook(print_grad)
z.backward()
x.data -= lr*x.grad.data
```

需要注意的是，``register_hook``函数接收的是一个函数，这个函数有如下的形式：

```
hook(grad) -> Variable or None
```

也就是说，这个函数是拥有改变梯度值的威力的！


至于``register_forward_hook``和``register_backward_hook``的用法和这个大同小异。只不过对象从``Variable``改成了你自己定义的``nn.Module``。当你训练一个网络，想要提取中间层的参数、或者特征图的时候，使用hook就能派上用场了。

## Reference

* [pytorch中的钩子（Hook）有何作用？](https://www.zhihu.com/question/61044004)
