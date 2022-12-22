---
categories: Python
date: "2018-08-29T15:13:00Z"
title: Python Logging，更工整地记录程序运行结果
toc: true
---

## 前言
对于一般小型程序来说，使用print在控制台打印出结果已经能够满足需求。但是如果遇到下面的情况：

* 对于长期运行地大型程序，希望监控程序的中间结果
* 长期运行的程序遇到了一个error需要被输出而不是程序报错

那么logging模块可以帮助你。

## 一个简单的开始

logging函数的输出按严重性由低到高分为``DEBUG``，``INFO``，``WARNING``，``ERROR``，``CRITICAL`` 5个等级。

默认的等级是``WARNING``，这就是说只有``WARNING``和它之上的等级``ERROR``，``CRITICAL``会被输出。

logging打印输出和print类似，下面的例子分别打印5个等级的日志：

```python
import logging

logging.debug('debug message')
logging.info('info message')
logging.warning('warn message')
logging.error('error message')
logging.critical('critical message')
```

这段程序会给我们一个类似这样地几行结果：

```
WARNING:root:warn message
ERROR:root:error message
CRITICAL:root:critical message
```

用冒号分隔地三个字段分别意味着``日志级别:Logger名称:日志内容``。这里只显示了``WARNING``和它等级之上的日志，如果希望输出``INFO``，``DEBUG``，可以将程序修改为：

```python
import logging

logging.basicConfig(level=logging.INFO)
logging.debug('debug message')
logging.info('info message')
logging.warning('warn message')
```

这里使用了``logging.basicConfig``函数对日志进行设置，将输出等级设置为``INFO``，运行该段程序会发现``DEBUG``等级的程序还不会被输出。

## 给日志添加时间戳

如果每条日志包含时间戳那会是很有帮助的，可以这样设置时间戳到日志：

```python
import logging

log_format = '%(asctime)s [%(levelname)-5.5s] [%(name)s]  %(message)s'
logging.basicConfig(level=logging.INFO, format=log_format)

logging.info('Hello')
logging.debug('World')
```

这里使用了`basicConfig`来对输出格式进行控制，格式化字符串的含义参考[这里](https://docs.python.org/3/library/logging.html#logrecord-attributes)。我们添加了时间，日志级别，Logger名称。运行上面的程序可以得到下面的日志输出：

```
2018-08-29 15:00:17,071 [INFO ] [__main__]  Hello
```

## 输出日志到文件

如果希望将日志记录到一个文件来保存，可以继续使用``logging.basicConfig``进行设置：

```python
import logging

log_format = '%(asctime)s [%(levelname)-5.5s] [%(name)s]  %(message)s'
logging.basicConfig(level=logging.INFO,
                    filename='ex.log',
                    format=log_format)

logging.info('Hello')
logging.debug('World')
```

运行上面的程序在工作目录下的``ex.log``文件发现记录的日志。

但是当把日志输出设置到文件后会发现控制台没有输出，可以通过添加``handler``来实现控制台和文件同时输出日志。

```python
import logging

log_format = "%(asctime)s [%(levelname)-5.5s] %(message)s"
filename = "ex.log"
logging.basicConfig( 
    level=logging.INFO,
    format=log_format,
    handlers=[logging.FileHandler(filename), logging.StreamHandler()],
)  
logging.info("This is info.")
logging.debug("This is debug.")
```

## 在多个文件使用同一个日志设置

如果希望在多个python module运行的时候使用同样的配置，即输出同样的格式，输出到同样的文体，一个简单的方法是将上面的设置语句放在所有程序的前面，例如：

```python
# app.py
import logging
import lib

def set_log():
    log_format = "%(asctime)s [%(levelname)-5.5s] %(message)s"
    logging.basicConfig(format=log_format)

if __name__ == "__main__":
    set_log()
    lib.foo())

# lib.py
import logging

def foo():
    logging.info("hello")
```

这个方法虽然简单，但是这样就可以在多个文件的日志输出都使用同样的设置了。这个方法的局限性是无法知道日志从哪输出来，无法对不同模块的设置进行再修改。

## 使用logger

更复杂的日志功能可以使用logging库提供的另一种方法来输出日志，使用一个对象``logger``，``handler``，``filter``，``formatter``来模块化地输出日志，日志信息在这四个元素之间进行处理和传递。

```python
import logging

logger = logging.getLogger(__name__)
logger.setLevel(logging.DEBUG)

file_handler = logging.FileHandler('log.log')
log_format = '%(asctime)s [%(levelname)-5.5s] [%(name)s]  %(message)s'
formatter = logging.Formatter(log_format)
file_handler.setFormatter(formatter)
file_handler.setLevel(logging.INFO)

logger.addHandler(file_handler)

logger.info('Hello')
logger.debug('World')
```

注意到这里使用自定义的logger来记录信息，而不是logging。用logging记录时候记录的logger名称为root。对logger命名的时候通常习惯使用`__name__`。

另一个注意点是在对logger进行输出设置的时候使用了handler机制。

通过对logger添加handler来添加输出通道，一个logger可以对应多个handler，比如这里的`FileHandler`。通过`setFormatter`设置输出格式，`setLevel`设置最小日志等级。运行这段程序后`ex.log`文件只会保留info信息。

我们可以在不同文件，或者说模块来写不同的logger从而输出日志到不同文件。我们可以给同一个logger设置多个handler来同时输出到控制台和文件。

```python
import logging

logger = logging.getLogger(__name__)
logger.setLevel(logging.DEBUG)

file_handler = logging.FileHandler('log.log')
log_format = '%(asctime)s [%(levelname)-5.5s] [%(name)s]  %(message)s'
formatter = logging.Formatter(log_format)
file_handler.setFormatter(formatter)
file_handler.setLevel(logging.INFO)

stream_handler = logging.StreamHandler()
stream_handler.setFormatter(formatter)

logger.addHandler(stream_handler)
logger.addHandler(file_handler)

logger.info('Hello')
logger.debug('World')
```

这里给添加了`logger`添加了`StreamHandler`，它的日志等级是logger在上面给出的debug。所以可以完成在控制台输出所有等级消息，而在日志文件记录info等级以上的消息啦!

Logging的flow，或者说称为控制流程的整体过程如下：

![img](https://docs.python.org/3/_images/logging_flow.png)

通过配置handler还可以将日志通过HTTP GET/POST发送到网络上的位置，使用SMTP发邮件，使用socket，queue，或者给系统写日志。

## 使用配置文件设置日志

logging的设置方法其实一共有3种：

1. 使用``logging.basicConfig``，或者设置``logger``来在python代码中配置日志。这是到此之前所用的方法。
2. 还可以使用[``fileConfig``](https://docs.python.org/3/library/logging.config.html#logging.config.fileConfig)从配置文件设置logging。
3. 使用``dictConfig``从一个字典中配置logging。

下面的程序从一个``logging.conf``配置文件中配置了一个简单的logger，一个console handler，一个简单的formatter：

```python
import logging
import logging.config

logging.config.fileConfig('logging.conf')

# create logger
logger = logging.getLogger('simpleExample')

# 'application' code
logger.debug('debug message')
logger.info('info message')
logger.warning('warn message')
logger.error('error message')
logger.critical('critical message')
```

配置文件内容如下：

```
[loggers]
keys=root,simpleExample

[handlers]
keys=consoleHandler

[formatters]
keys=simpleFormatter

[logger_root]
level=DEBUG
handlers=consoleHandler

[logger_simpleExample]
level=DEBUG
handlers=consoleHandler
qualname=simpleExample
propagate=0

[handler_consoleHandler]
class=StreamHandler
level=DEBUG
formatter=simpleFormatter
args=(sys.stdout,)

[formatter_simpleFormatter]
format=%(asctime)s - %(name)s - %(levelname)s - %(message)s
datefmt=
```

使用配置文件的好处是可以将配置代码过程和配置参数分开，方便没有代码基础的使用者也能调整日志。

## 使用[``coloredlogs``](https://pypi.org/project/coloredlogs/)给日志添加颜色

``coloredlogs``包让日志在终端的输出文字能够显示颜色。它使用一个 ColoredFormatter 类来继承 logging.Formatter 然后使用 ANSI escape sequences 来渲染终端信息，所以UNIX终端都可以让日志显示颜色。

```bash
pip install coloredlogs --user
```

```python
import coloredlogs, logging

# Create a logger object.
logger = logging.getLogger(__name__)

# By default the install() function installs a handler on the root logger,
# this means that log messages from your code and log messages from the
# libraries that you use will all show up on the terminal.
coloredlogs.install(level='DEBUG')

# If you don't want to see log messages from libraries, you can pass a
# specific logger object to the install() function. In this case only log
# messages originating from that logger will show up on the terminal.
coloredlogs.install(level='DEBUG', logger=logger)

# Some examples.
logger.debug("this is a debugging message")
logger.info("this is an informational message")
logger.warning("this is a warning message")
logger.error("this is an error message")
logger.critical("this is a critical message")
```

## [命令行中的进度条tqdm](https://github.com/tqdm/tqdm)

使用进度条，并给进度条添加说明：

```python
from tqdm import tqdm
import time

loss = 100
acc = 0

with tqdm(total=50) as pbar:
    pbar.set_description("Train")
    for batch_idx, batch in enumerate(range(50)):
        time.sleep(0.1)
        loss -= 0.1
        acc += 1
        postfix = {'acc':"{:.2f}".format(acc), 'loss':"{:.2f}".format(loss)}
        pbar.set_postfix(**postfix)
        pbar.update()
```

在bash中记录拷贝和压缩文件的进度：

```bash
# copy many files
cp -v src/* dest | tqdm --total $(ls src | wc -l) --unit file >> /dev/null

# backuping a large directory
7z a -bd -r backup.7z docs/ | grep Compressing | tqdm --total $(find docs/ -type f | wc -l) --unit files >> backup.log

## Unzip a zipfile
unzip filename.zip | tqdm --total $(unzip -l filename.zip | wc -l) >> /dev/null
unzip filename.zip | tqdm --total $(less filename.zip | wc -l) >> /dev/null
```

## 参考链接

* [Python logging basic](https://www.youtube.com/watch?v=-ARI4Cz-awo)
* [Python logging advanced](https://www.youtube.com/watch?v=jxmzY9soFXg)
* [logging - Logging facility for Python](https://docs.python.org/3/library/logging.html)
* [Logging HOWTO](https://docs.python.org/3/howto/logging.html)
