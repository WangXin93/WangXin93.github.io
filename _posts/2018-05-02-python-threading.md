---
layout: post
title:  "Python threading"
date: 2018-05-04 09:51:01 +0800
categories: Python
---

## 前言
**threading**模块Python1.5.2开始被引入，作为**thread**模块的增强版本。threading模块可以帮助我们更方便的使用线程工作，运行程序同时执行多个操作。

由于Python有Global Interpreter Lock（GIL）的存在，Python将所有线程在主线程内部运行。所以，当你想去运行多个CPU密集的操作的时候，你会发现它比仅使用单线程时候运行更慢了！所以在Python中使用thread去做它更适合>的事情，比如I/O操作。如果需要更短的运行时间，考虑使用multiprocessing模块。

```python
import threading

def doubler(nbr):
    print(threading.currentThread().getName() + '\n')
    print(nbr * 2)
    print()

if __name__ == "__main__":
    for i in range(5):
        my_thr = threading.Thread(target=doubler, args=(i,))
        my_thr.start()
```

## 参考链接
* [python-201-a-tutorial-on-threads](https://www.blog.pythonlibrary.org/2016/07/28/python-201-a-tutorial-on-threads/)
* [Threading in Python](https://www.linuxjournal.com/content/threading-python)
* [python_multithreading_Daemon_join_method_threads](http://www.bogotobogo.com/python/Multithread/python_multithreading_Daemon_join_method_threads.php)
