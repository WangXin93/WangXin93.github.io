---
layout: post
title:  "Python 并行编程入门"
date: 2018-05-04 09:51:01 +0800
categories: Python
toc: true
---

## 前言

Python作为一种解释性语言，它的速度并不慢。如果对计算速度有很高的要求的话，可以考虑的方法有：（1）使用更快的语言比如C/C++来实现然后Python调用; （2）Python的解释器就是用C语言写的，即CPython。解释器将Python转换成一种中间语言，叫做Python字节码，类似于汇编语言，但是包含一些更高级的指令。当一个运行一个Python程序的时候，评估循环不断将Python字节码转换成机器码。使用即时编译器来替换CPython例如PyPy可以提高运行速度。（3）利用Python提供的很多并行的模块。

进程是应用程序的一个执行实例，比如，在桌面上双击浏览器图标将会运行一个浏览器。线程是一个控制流程，可以在进程内与其他活跃的线程同时执行。“控制流程”指的是顺序执行一些机器指令。进程可以包含多个线程，所以开启一个浏览器，操作系统将创建一个进程，并开始执行这个进程的主线程。每一个线程将独立执行一系列的指令（通常就是一个函数），并且和其他线程并行执行。然而，同一个进程内的线程可以共享一些地址空间和数据结构。

## 进程



```python
# called_Process.py
print("Hello Python Parallel Cookbook!!")        
closeInput = input("Press ENTER to exit")
print("Closing calledProcess")  
```

```python
# calling_Process.py
import os
import sys

program = "python"
print("Process calling")
arguments = ["called_Process.py"]

os.execvp(program, (program,) + tuple(arguments))
print("Good Bye!")
```

运行``python calling_Process.py``，这里``os.execvp``开启了一个新的进程，替换了当前的进程，注意"Good Bye!"永远不会打印出来。

## 线程

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

创建一个线程：

```python
# HelloThread.py
# To use threads you need import Thread using the following code:
from threading import Thread
# Also we use the sleep function to make the thread "sleep"
from time import sleep

# To create a thread in Python you'll want to make your class work as a thread.
# For this, you should subclass your class from the Thread class
class CookBook(Thread):
    def __init__(self):
        Thread.__init__(self)
        self.message = "Hello Parallel Python CookBook!!\n"

    # this method prints only the message
    def print_message(self):
        print(self.message)

    # The run method prints ten times the message
    def run(self):
        print("Thread Starting\n")
        x = 0
        while (x < 10):
            self.print_message()
            sleep(2)
            x += 1
        print("Thread Ended\n")

# start the main process
print("Process Started")

# create an instance of the HelloWorld class
hello_Python = CookBook()

# print the message...starting the thread
hello_Python.start()

# end the main process
print("Process Ended")
```

执行``python HelloThread``会每两秒打印一条消息。主程序执行结束的时候，线程依然会每个两秒钟就打印一次信息。此例子证实了线程是在父进程下执行的一个子任务。

需要注意的一点是，永远不要留下任何线程在后台默默运行。否则在大型程序中这将给你带来无限痛苦。

## [守护线程](http://www.bogotobogo.com/python/Multithread/python_multithreading_Daemon_join_method_threads.php)

守护线程会在不打断主线程的情况下在背后运行。对于非守护线程，它们会插入到主线程的运行中间，我们需要追踪它们并且告诉它们该何时推出了。对于守护线程，我们完全让他们自己去运行，当主程序退出的时候，所有的守护线程都会被自动杀死。

```python
import threading
import time
import logging

logging.basicConfig(level=logging.DEBUG,
                    format='(%(threadName)-9s) %(message)s',)

def n():
    logging.debug('Starting')
    time.sleep(1)
    logging.debug('Exiting')

def d():
    logging.debug('Starting')
    time.sleep(5) # comment this to print out exit information of d
    logging.debug('Exiting')

if __name__ == '__main__':

	t = threading.Thread(name='non-daemon', target=n)

	d = threading.Thread(name='daemon', target=d)
	d.setDaemon(True)

	d.start()
	t.start()
```

上面的程序输出：
```
(daemon   ) Starting
(non-daemon) Starting
(non-daemon) Exiting
```

可以看到并没有守护线程退出的消息，这结果的原因是由于主程序在1秒即退出了，而守护线程需要5秒才能得到结果，在主程序推出时候守护线程提前被杀死因此没有输出。如果将守护线程的时间缩短为1秒内，便可以看到：

```
(daemon   ) Starting
(non-daemon) Starting
(daemon   ) Exiting
(non-daemon) Exiting
```


为了等待到一个守护线程去完成它的工作，可以使用``t.join()``。例如：

```python
import threading
import time
import logging

logging.basicConfig(level=logging.DEBUG,
                    format='(%(threadName)-9s) %(message)s',)

def n():
    logging.debug('Starting')
    time.sleep(1)
    logging.debug('Exiting')

def d():
    logging.debug('Starting')
    time.sleep(5)
    logging.debug('Exiting')

if __name__ == '__main__':

    t = threading.Thread(name='non-daemon', target=n)

    d = threading.Thread(name='daemon', target=d)
    d.setDaemon(True)

    d.start()
    t.start()
    d.join()
    t.join()
```

可以看到先等到主程序等到守护线程退出才继续退出。虽然t线程后开始，但是由于它运行时间短，所以我们先得到它退出的消息。

这里也可以理解为所有的非守护进程是自动进行join的。

```
(daemon   ) Starting
(non-daemon) Starting
(non-daemon) Exiting
(daemon   ) Exiting
```


## 参考链接
* [Python 并行编程中文版](https://python-parallel-programmning-cookbook.readthedocs.io/zh_CN/latest/)
* [python-201-a-tutorial-on-threads](https://www.blog.pythonlibrary.org/2016/07/28/python-201-a-tutorial-on-threads/)
* [Threading in Python](https://www.linuxjournal.com/content/threading-python)
