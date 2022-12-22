---
categories: Linux Python
date: "2021-07-03T19:18:55Z"
title: Python运行外部程序的两个模块:os和subprocess
toc: true
---

> subprocess 模块可以帮助用户使用python来运行其它程序并且得到程序的结果。Python3.5之后推荐使用run()函数作为接口，你可以使用run()实现命令调用，检查返回状态，获得stdout，自定义输入。但是run()函数会阻塞当前的进程，如果希望不阻塞地运行process同时实时交互，可以使用Popen类，它的功能更加强大不过语法稍微复杂。

## 前言

一个运行的程序被称为进程（process）。每个进程都有自己的系统状态，包括内存，打开文件，程序计数器，调用栈。通常情况下，一个程序在一串控制流中一次执行一个指令，这被称为程序的主线程。程序一次只做一件事情。

程序可以调用库中的函数来产生新的进程，这些程序被称为子进程（subprocess），它们之间互相独立，每个子进程都有自己的系统状态和执行线程。

由于子进程有相互独立，它可以和原来的进行并发运行。即创建子进程的进程可以继续自己的工作，子进程在后台进行自己的工作。

Python中有两个模块可以帮助创建和运行子进程，分别是os模块和subprocess模块。

## os 模块

最简单的运行UNIX命令的方法是``os.system()``。它可以把命令和参数都传递给shell，这样可以方便地运行多个命令，设置管线和重定向输入/输出。例如：

```python
os.system("some_command < input_file | another_command > output_file")
```

但是这也有不方便的地方，比如需要注意转义字符。

``os.popen()`` 的功能和``os.system()``一样，不过会返回一个类似文件的对象，你可以用它读取到标准输入和输出。除此以外，还有其它3中popen，它们处理输入输出的方式略有不同。

## subprocess 模块

subprocess 模块可以用来启动child process，Python是parent process，新启动的process是child process，这是subprocess名称的由来。child process可以是图形界面应用也可以是一个shell。

### 使用subprocess的run()接口

subprocess的[官方文档](https://docs.python.org/3/library/subprocess.html#using-the-subprocess-module)推荐尽量使用run()函数来运行child process。run()函数是一个blocking function，python会等到新进程结束之后才继续。如果需要更多的控制，可以使用Popen类。Popen是subprocess模块底层的类，subprocess的其它功能都是包裹Popen的类和方法而来。Python3.5以前会使用subprocess的旧接口比如call(), `check_call()`, `check_output()`,它们的功能和新的run()接口重复，为了向前兼容所以才保留。如果你正在编写新的程序，可以直接从run()接口开始了解而不是了解全部的接口，新的接口更加鲁棒。

你可以在REPL中或者在python脚本中运行subprocess。run()的函数如下，在run中输入的是一个列表，列表每个元素是命令的token, 例如`subprocess.run(["echo", "hello"])`。 shlex模块可以帮助你将POSIX compliant的系统命令分解为多个token。比如你可以使用`subprocess.run(shlelx.split("python time.py 5"))`，这等同于`subprocess.run(["python", "time.py", "5"])`。这里的split()函数不仅仅是以空格分割字符串，它将命令按照命令参数的需要进行分割，比如`shelx.split("echo 'hello, world'")，你会得到两个token`['echo', 'hello, world']`，引号中的空格不会作为分割符。shelx对于windows命令不一定有效。

你可以使用subprocess运行任何由命令行启动的程序，比如在mac使用`subprocess.run(["open", "-e"])`，可以打开TextEdit编辑器（在windows可以使用notepad，linux使用gedit）。run()是i 个blocking function，这是python会等待process完成后才会继续后面的代码，所以子进程如果运行时间太长你不希望等待其完成，可以结合其他模块来实现concurrency。

### CompletedProcess对象

运行结束后会返回一个CompletedProcess类其中包含进程运行的参数，和返回状态码。如果process顺利运行，返回的状态码为0，否则返回的状态码为非0数字比如2。即使process没有成功运行，在python中也不会引起exception，除非设置check为True，例如

```python
subprocess.run(["python", "time.py"], check=True)

import sys
result = subprocess.run([sys.executable, "-c", "print('ocean')"])
```

CompletedProcess还包含一些和IO相关的属性。

### subprocess的异常处理

如果在run()中设置check为True，当子进程运行失败的时候才会引起一个异常，默认情况只会返回一个非0的状态码。在编写代码的时候应该希望程序在运行的时候返回异常而不是仅仅返回状态码然后继续到下一行。下面是一些subprocess运行中3个常见的exception：

- CalledProcessError: 会在子进程返回非0状态码的时候引起。如果程序卡住，不会引起CalledProcessError，你应该设置timeout参数
- TimeoutExpired: 如果程序运行过长，你希望判断这种情况为异常，可以首先在run函数中设置timeout参数例如`subprocess.run(["python", "time.py", "5"], timeout=1)`，如果子程序运行超过1秒就会引起TimeoutExpired异常。
- FileNotFoundError: 如果系统找不到程序或者命令，会引起FileNotFoundError异常，这个异常即使不输入`check=True`也会报出。

对于复杂的程序，为了稳定运行，可以编写try except结构来处理这些异常，例如：

```python
import subprocess

try:
    subprocess.run(
        ["python", "timer.py", "5"], timeout=10
    )
except FileNotFoundError as exc:
    print(f"Process failed because the executable could not be found.\n{exc}")
except subprocess.CalledProcessError as exc:
    print(
        f"Process failed because did not return a successful return code. "
        f"Returned {exc.returncode}\n{exc}"
    )
except subprocess.TimeoutExpired as exc:
    print(f"Process timed out.\n{exc}")
```

### Shell和Text-based Program

在run中如果设置`shell=True`可以模拟在emulator terminal中输入命令，否则subprocess会绕过emulator直接执行命令行程序。shell这个参数有影响的一个例子是如果在windows系统上运行`subprocess.run(["ls"])`，它会报出错误，因为ls是powershell上关于`Get-ChildItem`的别名，所以必须在powershell中运行ls才能成功，因此`subprocess.run(["ls"], shell=True)`可以避免在windows平台的这个错误。

```python
subprocess.run(["bash", "-c", "ls /usr/bin | grep pycode"])
```

### 进程间通信

当一个process初始化的时候，它会使用3个stream用于处理输入输出：stdin用于输入，stdout用于输出，stderr用于报错错误，这三个stream被成为standard stream。有时候child process可以继承parent process的stream，所以你会看到subprocess的输出显示在同一个命令行中。当你使用python的REPL的时候，这时的stdin和模拟终端一样是键盘输入，stdou和stderr是模拟中断的界面的输出，它们显示在显示器上。

如果希望将subprocess的stdout不要导入到终端中，可以使用`capture_output`参数，例如

```python
p = subprocess.run(["date"], capture_output=True)
print(p.stdout)
print(p.stdout.decode())
```

之后subprocess的运行输出可以由`p.stdout`得到，这个结果是一个bytes数据，需要使用decode才能得到字符串数据。

你可以使用input参数向stdin输入参数。例如：

```python
subprocess.run(["python", "reaction_game.py"], input="\n\n", encoding="utf-8")
```

```python
# reaction_game.py
from time import perf_counter, sleep
from random import random

print("Press enter to play")
input()
print("Ok, get ready!")
sleep(random() * 5 + 1)
print("go!")
start = perf_counter()
input()
end = perf_counter()
print(f"You reacted in {(end - start) * 1000:.0f} milliseconds!\nGoodbye!")
```

你可以使用subprocess运行上面的reaction game达到0毫秒的结果。

### Pipes

Pipe是一个特殊的stream，它在一端执行读取数据，在另一端执行写入数据，所以它可以连接两个进程最终得到一个输出结果。在bash中，pipe的语法是使用`|`符号，例如`ls /usr/bin | grep python`，它会列出`/usr/bin/`目录下所有包含python的结果，通过pipe连接`ls`的输出到`grep`的输入来实现的这个功能。（在Powershell同样有`|`的语法，例如`ls "C:\Program Files" | Out-String -stream | Select-String windows`，但是它不是连接两个process的结果而是在powershell内部进行的输出结果重定向，所以使用subprocess的pipe连接两个process在powershell上会在unix系统上的操作不一样）。

如果希望在subprocess中使用pipe，你可以将整个bash命令输入其中运行，例如：

```python
subprocess.run(["sh", "-c", "ls /usr/bin | grep python"])
```

这个方法可以运行，它将pipe功能的实现交给了bash，而不是由python实现。如果希望由python实现pipe功能，需要使用Popen()接口，这会在介绍了Popen之后讲解。使用run()接口不能实时地上一个process的stdout输入到下一个process的stdin，但是有一个稍作妥协的解决方法是使用将所有的stdout得到之后再输入到下一个process，例如：

```python
import subprocess
ls_process = subprocess.run(["ls", "/usr/bin"], stdout=subprocess.PIPE)
grep_process = subprocess.run(
    ["grep", "python"], input=ls_process.stdout, stdout=subprocess.PIPE
)
print(grep_process.stdout.decode("utf-8"))
```

这里的`stdout=subprocess.PIPE`(`stderr=subprocess.PIPE`)和`capture_output=True`是相同的写法，它将输出结果存放到pipe中，之后保存到CompletedProcess的stdout属性中。但是取得stdout属性要等带当前的process完成，这不是一个实时的输入输出重定向。

除了使用PIPE你还可以使用打开的文件实现同样的功能：

```python
import subprocess
from tempfile import TemporaryFile
with TemporaryFile() as f:
    ls_process = subprocess.run(["ls", "/usr/bin"], stdout=f)
    f.seek(0)
    grep_process = subprocess.run(
        ["grep", "python"], stdin=f, stdout=subprocess.PIPE
    )
```

### 实用建议

创建一个列表，每个元素为要执行的命令，然后使用循环执行每个命令并使用try except语法检查异常。

为不同平台创建相同功能不同语法的命令。使用面向对象的方法将不同平台的命令和参数封装其中。

### 相关模块

os模块是subprocess之前的替代方案，在一些内部的代码和早前的代码可以看到os调用系统命令，这里有一份[文档](https://docs.python.org/3/library/subprocess.html#replacing-older-functions-with-the-subprocess-module)描述os和subprocess的等价转换，比如``subprocess.Popen()``是被开发希望用来替代``os.popen``的。

``subprocess.call()``是另一类subprocess的接口，它在python3.4及之前可以使用，它和``Popen``类似，但是它会一直等到命令结束，然后返回给你一个状态码，比如

```python
return_code = subprocess.call("echo Hello World", shell=True)  
```

如果希望将subprocess和concurrency结合，有一些模块可以帮助你，如果希望功能实现更加稳定，可以考虑 multiprocessing, threading，asyncio在一些任务上更加适合，asyncio正对创建subprocess有一个[高层的API](https://docs.python.org/3/library/asyncio-subprocess.html)。

### Popen类

Popen类是实现subprocess模块其它功能的一个底层的类，所以它的功能更加强大不过也稍微复杂一点。

run()接口是由Popen实现的，主要过程为创建Popen类，之后进行设置，然后调用communicate()方法来与Popen对象交互，communicate是一个blocking的函数，它会在process完成后返回stdout和stderr。

run()是一个blocking function，你不能实时地和process交互，需要等到它完成之后才能继续运行。但是Popen创建的对象是可以允许你并行地运行process，在未完成之前和它交互。这也是之前说的run()不能完全地实现pipe，不过Popen可以实现pipe的原因。

展示Popen类non-blocking特性的例子如下，这里使用with语句创建了一个process，poll()方法会确认process是否运行完成，如果运行完成会返回0，否则会返回None。read1()是另一个non-blocking的函数，它会从process的stdout中读取尽可能多的bytes，注意read()是一个blocking的函数它会在process运行完成后读取全部的bytes。这段代码会看见程序的输出，由于中途读取的时刻不同，被分割成了多个部分。

```python
import subprocess
from time import sleep

with subprocess.Popen(
    ["python", "timer.py", "5"], stdout=subprocess.PIPE
) as process:

    def poll_and_read():
        print(f"Output from poll: {process.poll()}")
        print(f"Output from stdout: {process.stdout.read1().decode("utf-8")}")

    poll_and_read()
    sleep(3)
    poll_and_read()
    sleep(3)
    poll_and_read()
```

使用Popen可以实时地将一个process的输出导入到另一个process的输入，run()函数返回的CompletedProcess中的stdout是bytes，Popen返回的对象中的stdout是一个stream，它不需要等待process完成才能访问，例如：

```
import subprocess

ls_process = subprocess.Popen(["ls", "/usr/bin"], stdout=subprocess.PIPE)
grep_process = subprocess.Popen(
    ["grep", "python"], stdin=ls_process.stdout, stdout=subprocess.PIPE
)

for line in grep_process.stdout:
    print(line.decode("utf-8").strip())
```

你可以使用Popen实时访问stdout的属性完成run()函数不能完成的任务，比如破解下面的reaction game:

```python
# reaction_game_v2.py

from random import choice, random
from string import ascii_lowercase
from time import perf_counter, sleep

print(
    "A letter will appear on screen after a random amount of time,\n"
    "when it appears, type the letter as fast as possible "
    "and then press enter\n"
)
print("Press enter when you are ready")
input()
print("Ok, get ready!")
sleep(random() * 5 + 2)
target_letter = choice(ascii_lowercase)
print(f"=====\n= {target_letter} =\n=====\n")

start = perf_counter()
while True:
    if input() == target_letter:
        break
    else:
        print("Nope! Try again.")
end = perf_counter()

print(f"You reacted in {(end - start) * 1000:.0f} milliseconds!\nGoodbye!")
```

```python
# reaction_game_v2_hack.py

import subprocess

def get_char(process):
    character = process.stdout.read1(1)
    print(
        character.decode("utf-8"),
        end="",
        flush=True,  # Unbuffered print
    )
    return character.decode("utf-8")

def search_for_output(strings, process):
    buffer = ""
    while not any(string in buffer for string in strings):
        buffer = buffer + get_char(process)

with subprocess.Popen(
    [
        "python",
        "-u",  # Unbuffered stdout and stderr
        "reaction_game_v2.py",
    ],
    stdin=subprocess.PIPE,
    stdout=subprocess.PIPE,
) as process:
    process.stdin.write(b"\n")
    process.stdin.flush()
    search_for_output(["==\n= ", "==\r\n= "], process)
    target_char = get_char(process)
    stdout, stderr = process.communicate(
        input=f"{target_char}\n".encode("utf-8"), timeout=10
    )
    print(stdout.decode("utf-8"))
```

破解的脚本使用Popen实时读取stdout中的输出，一但发现匹配的字符立即按下回车，结果得到不属于正常人的反应时间。

## 结语

subprocess可以在python中运行另一个child process，所以你可以使用python调用其它的CLI，或者GUI程序。在Python3.5之后，推荐使用run()函数调用外部命令，它的check参数可以根据返回的状态码引起错误，shell参数可以在终端模拟器中输入命令，`capture_output`参数可以得到stdout的内容。实际开发复杂的功能时候，建议使用列表存储多个命令之后使用try except语法逐个调用；对不同的shell建立不同的对象存储命令和参数。如果希望实现pipe功能，可以在run中调用完整指令，或者设置stdout，stderr为PIPE。但是run是一个blocking函数，如果希望实时地读取和对process交互，需要使用Popen类。


## 参考

* <https://realpython.com/python-subprocess/>
* <bogotobogo.com/python/python_subprocess_module.php>
* <https://www.digitalocean.com/community/tutorials/how-to-use-subprocess-to-run-external-programs-in-python-3>
* <https://docs.python.org/3/library/subprocess.html>
* <https://www.digitalocean.com/community/tutorials/how-to-use-subprocess-to-run-external-programs-in-python-3>
* <https://stackoverflow.com/questions/89228/how-to-execute-a-program-or-call-a-system-command?rq=1>
