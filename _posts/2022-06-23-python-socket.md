---
layout: post
title:  "Python中的socket编程"
date:   2022-06-23 16:03:00 +0800
categories: Python
---

## 前言

## History

1971 ARPANET

1983 BSD

1990s World Wide Web

Internet Sockets

Unix domain sockets

python的socket module提供了一套Berkeley socket API的接口。socket模块的主要函数有：

- socket
- bind
- listen
- accept
- connect
- `connect_ex`
- send
- recv
- close

Python还实现了一个类[sockerserver](https://docs.python.org/3/library/socketserver.html)来更好地组织底层的socket函数。还有很多模块实现了高层的internet protocol比如HTTP和SMPT，可以参考[Internet Protocols and Support](https://docs.python.org/3/library/socketserver.html)。

## TCP sockets

## Echo Server

```python
# echo_server.py

from socket import *

HOST = '0.0.0.0'
PORT = 5678

# 建立socket
s = socket(AF_INET, SOCK_STREAM)
s.setsockopt(SOL_SOCKET, SO_REUSEADDR, 1)

# 绑定IP和端口
s.bind((HOST, PORT))

# 开始监听，最多连接5个设备
s.listen(5)

print(f"服务器已启动，请访问（{HOST}:{PORT}），等待连接...")

while True:
    # 等待并接收连接
    conn, addr = s.accept()
    print(f'{addr}已连接')

    while True:
        # 接收客户端信息
        indata = conn.recv(1024)
        if len(indata) == 0:
            # 关闭连接
            conn.close()
            print(f'客户端{addr}连接关闭')
            break
        print(f'从{addr}接收到：{indata.decode()}')

        outdata = 'echo ' + indata.decode()
        print(f'发送{indata}到{addr}')
        # 向客户端发送信息
        conn.send(outdata.encode())
```

```python
# echo_client.py

from socket import *

HOST = '127.0.0.1'
PORT = 5678

s = socket(AF_INET, SOCK_STREAM)
s.connect((HOST, PORT))


while True:
    outdata = input('请输入消息：')
    print(f'发送：{outdata}')
    s.send(outdata.encode())

    indata = s.recv(1024)
    if len(indata) == 0:
        s.close()
        print('服务器连接关闭')
        break
    print(f'收到：{indata.decode()}')
```

## Multiple Connection

如果在上面的echo server启动后，当一个客户端访问的时候，另一个客户端如果再次访问，会发现无法建立连接；如果这是第一个客户端退出访问，第二个客户端上立即就会出现回应，这是因为目前编写的服务器只能服务于一个客户端，当它被占用的时候，另一个客户端需要等待前一个客户端退出才能建立连接。

为了让服务器能对多个用户的反应同时作出回应，下面是几个常用方法:

- 多线程，多进程
- 协程
- select, selector
- poll, epoll

使用多线程让服务器能过处理多个客户端请求的方法如下：

```python
TODO
```

多线程和多进程的方法可以解决服务器的阻塞问题，同时语法实现较为简单，但是会耗费较多的系统资源。如果你是在一个系统资源有限的机器上运行服务，比如只有单核单线程，那么如何实现多个连接的服务呢？下面是一种轮询的方法实现服务的多连接，首先是将每个socket设置为非阻塞，然后使用一个循环对每个socket查看是否有接收到信息，这样就不会因为一个socket在等待接收而阻塞整个进程，这是nginx，nodejs，tornado的实现原理。

```python
# noblocking_server.py

from socket import *

HOST = '0.0.0.0'
PORT = 5678

# 建立socket
s = socket(AF_INET, SOCK_STREAM)
s.setsockopt(SOL_SOCKET, SO_REUSEADDR, 1)
s.setblocking(False)

# 绑定IP和端口
s.bind((HOST, PORT))

# 开始监听，最多连接5个设备
s.listen(5)

connlist = []

print(f"服务器已启动，请访问（{HOST}:{PORT}），等待连接...")

while True:
    try:
        # 等待并接收连接
        conn, addr = s.accept()
        print(f'{addr}已连接')
        connlist.append(conn)
    except:
        pass

    for conn in connlist:
        try:
            # 接收客户端信息
            indata = conn.recv(1024)
            if len(indata) == 0:
                # 关闭连接
                connlist.remove(conn)
                conn.close()
                print(f'客户端{conn}连接关闭')
                break
            print(f'从{conn}接收到：{indata.decode()}')

            outdata = 'echo ' + indata.decode()
            print(f'发送{outdata}到{conn}')
            # 向客户端发送信息
            conn.send(outdata.encode())
        except:
            pass
```

使用selector编写的代码例子如下，你可以启动下面的server，使用echoclient进行访问：

```python
from socket import *
import selectors

sel = selectors.DefaultSelector()

def accept(s, mask):
    # 接收连接
    conn, addr = s.accept()
    print(f'来自 {addr} 的 {conn} 已连接')
    conn.setblocking(False)
    sel.register(conn, selectors.EVENT_READ | selectors.EVENT_WRITE , read)

def read(conn, mask):
    # 接收客户端信息
    indata = conn.recv(1024)
    if len(indata) == 0:
        # 关闭连接
        print(f'客户端{conn}连接关闭')
        sel.unregister(conn)
        conn.close()
    else:
        print(f'从{conn}接收到：{indata.decode()}')
        outdata = 'echo ' + indata.decode()
        print(f'发送{outdata}到{conn}')
        # 向客户端发送信息
        conn.send(outdata.encode())


HOST = '0.0.0.0'
PORT = 5678

# 建立socket
s = socket(AF_INET, SOCK_STREAM)
s.setsockopt(SOL_SOCKET, SO_REUSEADDR, 1)

# 绑定IP和端口
s.bind((HOST, PORT))

# 开始监听，最多连接5个设备
s.listen(5)

# 设置不要阻塞
s.setblocking(False)

sel.register(s, selectors.EVENT_READ, accept)

print(f"服务器已启动，请访问（{HOST}:{PORT}），等待连接...")

while True:
    events = sel.select()
    for key, mask in events:
        callback = key.data
        callback(key.fileobj, mask)
```

上面代码需要注意的地方包括：

- 首先设置了`s.setblocking(False)`这样socket不会是一个blocking function。
- `sel.register()`会将一个socket添加到监控中，当`sel.select()`发现一个你指定的event发生的时候，比如`EVENT_READ`，就会对socket进行下一步的动作
- 你可以使用`data`属性在`sel.register()`调用的时候为socket添加额外的数据，这段代码添加了一个函数，你也可以将其它数据加入其中，比如addr
- `sel.select()`在触发event时候返回内容，其中`key.fileobs`是socket本身，`key.data`是register时候添加的data，mask是event mask表示触发的事件的类型
- 可以使用bitwise OR来表示两中event的组合，比如`EVENT_READ | EVENT_WRITE`
- 当conn关闭的时候，不仅要使用close()方法，还要使用`sel.unregister()`让selector不再监控它的事件

你还可以使用协程在一个线程的情况下实现服务器对多个连接进行回应：

```python
TODO
```

编写一个multi-connection client。这里使用了`connect_ex`而不是`connect()`，因为`connect()`会引起BlockingIOError异常。connection建立之后，就可以由select来监控哪个socket需要进行通信。你可以在运行完前面的multi-connection server之后运行这段multi-connection client，由于两次发送包之间间隔较短，你可能看见服务器接收来两个信息，echo了一条合并的信息。

```python
from socket import *
import selectors

HOST = '127.0.0.1'
PORT = 5678

sel = selectors.DefaultSelector()
messages = ["Message 1 from client", "Message 2 from client"]

def start_connections(host, port, num_conns):
    for i in range(num_conns):
        connid = i + 1
        s = socket(AF_INET, SOCK_STREAM)
        s.setblocking(False)
        s.connect_ex((HOST, PORT))
        sel.register(s, selectors.EVENT_READ | selectors.EVENT_WRITE, data=messages.copy())

def service_connection(key, mask):
    s = key.fileobj
    messages = key.data
    if mask & selectors.EVENT_READ:
        indata = s.recv(1024)
        if indata:
            print(f"received {indata!r} from connection {s}")
        if not indata or len(messages) == 0:
            sel.unregister(s)
            s.close()
    if mask & selectors.EVENT_WRITE:
        if len(messages) > 0:
            outdata = messages.pop(0)
            print(f'send {outdata!r} from connection {s}')
            sent = s.send(outdata.encode())

start_connections(HOST, PORT, 2)

try:
    while True:
        events = sel.select(timeout=1)
        if events:
            for key, mask in events:
                service_connection(key, mask)
        # Check for a socket being monitored to continue.
        if not sel.get_map():
            break
except KeyboardInterrupt:
    print("Caught keyboard interrupt, exiting")
finally:
    sel.close()
```

socketserver

twisted

## Custom header and content

你可以在header部分标注length或者其它信息，来保证你的信息完整送达另一边。这是许多其它协议比如HTTP使用的方法。

TODO

## 结语

## 参考

* <https://realpython.com/python-sockets/>
* <https://www.birdpython.com/posts/1/88/>
* <https://docs.python.org/3/library/selectors.html>
* [socket传输文件同时显示进度条](https://www.thepythoncode.com/article/send-receive-files-using-sockets-python)
* [socketserver聊天程序示例](https://shengyu7697.github.io/python-socketserver/)
