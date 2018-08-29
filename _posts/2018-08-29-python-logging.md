---
layout: post
title:  "Python Logging，更漂亮地记录程序运行结果"
date: 2018-08-29 15:13:00 +0800
categories: Python
---

# 前言
对于一般小型程序来说，使用print在控制台打印出结果已经能够满足需求。但是对于长期运行地大型程序，如果有更高地需求，比如同时输出结果到控制台和文件，带有时间戳地输出，那么logging模块可以帮助你。

# Quick Start
从print到logging地转变非常简单：

```python
import logging

logging.debug('debug message')
logging.info('info message')
logging.warn('warn message')
logging.error('error message')
logging.critical('critical message')
```

这段程序会给我们一个类似这样地几行结果：

```
WARNING:root:warn message
ERROR:root:error message
CRITICAL:root:critical message
```

用冒号分隔地三个字段分别意味着日志级别，Logger名称，日志内容：

![msg](https://upload-images.jianshu.io/upload_images/477558-da69f58ffd67989c.png)

# Basic configuration

如果每条日志包含时间戳那会是很有帮助的，可以这样设置时间戳到日志：

```python
import logging

log_format = '%(asctime)s [%(levelname)-5.5s] [%(name)s]  %(message)s'
logging.basicConfig(level=logging.INFO,
                    filename='log.log',
                    format=log_format)

logging.info('Hello')
logging.debug('World')
```

这里使用了`basicConfig`来对输出格式进行控制，格式化字符串的含义参考[这里](https://docs.python.org/3/library/logging.html#logrecord-attributes)。我们添加了时间，日志级别，Logger名称，日志内容四个字段，定义了最小的输出级别别INFO，并把logging内容输出到名为log.log的文件。

补充一下，logging的[日志等级](https://docs.python.org/3/library/logging.html#logging-levels)一共有5个，从小到大分别为：debug, info, warning, error, critical。

由于这里设置了最小等级为info（包含info），所以在当前目录下的log.log文件可以发现以下内容：

```
2018-08-29 15:00:17,071 [INFO ] [__main__]  Hello
```

OK！这就是logging模块的基本使用！

# Advanced logging

但是这样使用logging会有一些问题，比如：

* 你可能发现logging.info记录的时候使用的是名为root的默认logger，这个logger全局只有一个，并且basicConfig只有第一次是有效的，不能重写。这使得在使用的时候会把所有日志输出打同一个文件，这可能不是我们想要的。
* 在设置logging文件后，发现控制台没有输出了。

如果想要满足这些需求，就需要设置多个logger，多花些功夫来实现更多的功能：

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

通过对logger添加handler来添加输出通道，一个logger可以对应多个handler，比如这里的`FileHandler`。通过`setFormatter`设置输出格式，`setLevel`设置最小日志等级。运行这段程序后`log.log`文件只会保留info信息。

我们可以在不同文件，或者说模块来写不同的logger从而输出日志到不同文件。

我们可以给同一个logger设置多个handler来同时输出到控制台和文件。

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



# 参考链接

* [Python logging basic](https://www.youtube.com/watch?v=-ARI4Cz-awo)
* [Python logging advanced](https://www.youtube.com/watch?v=jxmzY9soFXg)
* [logging - Logging facility for Python](https://docs.python.org/3/library/logging.html)
* [Python logging模块使用教程](https://www.jianshu.com/p/feb86c06c4f4)