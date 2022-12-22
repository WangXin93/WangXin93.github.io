---
categories: Python
date: "2022-10-02T20:42:00Z"
title: 使用Pathlib来操作文件和文件名
toc: true
---

> 这篇博客将会介绍如何使用pathlib中的Path对象来进行文件路径名称的操作，已经系统文件的操作。

## 在python中处理文件和文件名的问题

python中关于文件名和文件操作的功能分散在不同的模块当中，比如列出当前目录需要使用`os.listdir()`，按照通配符匹配文件名需要使用`glob.glob('*.py')`，复制文件需要使用`shutil.copy(src, dst)`。

Windows系统和Unix系统文件名的操作会有不同，windows使用`\`作为分隔符，mac/linux使用`/`作为分隔符，例如下面的路径：

```python
win_path = r"C:\Users\Name\Pictures"

unix_path = "/home/NAME/Pictures"
```

文件名作为字符串处理的时候代码需要嵌套的函数很多。比如如何将mycode.txt的后缀修改为mycode.py? 如何提取文件名的文件目录部分？

```python
os.path.exists(os.path.join(os.path.realpath('.'), 'mycode.txt').rstrip('.txt')+'.py')
```

Python3.4之后提供了一个新的模块pathlib [PEP 428](https://www.python.org/dev/peps/pep-0428/)，它将处理文件和文件名常用的功能整合到一个模块，整合到一个Path对象当中。

```python
(Path.cwd() / 'mycode.txt').with_suffix('.py').exists()
```

## 创建Path对象

Path类是pathlib中的核心，有不同的方法来创建Path对象。

对于当前目录和home目录，可以使用函数来创建：

```python
from pathlib import Path

# 当前目录
Path.cwd()

# home目录
Path.home()
```

也可以直接从字符串创建Path对象，Windows系统的路径和Unix系统的路径都可以，不过会返回不同类型的实例

```python
# 返回PosixPath实例
Path('/home/pi/Downloads/Vaults')

# 返回WindowsPath实例
Path(r'C:\Users\pi\Downloads\Vaults')
```

Path支持使用`/`符号创建多层目录的路径，这样不同系统也可以使用相同的方法创建文件路径。或者可以使用`joinpath`函数来通过喂入函数参数创建Path对象。

```python 
Path.home() / 'Downloads' / 'Vaults'

Path.home().joinpath('Donwloads', 'Vaults')

lst = ['Downloads', 'Vaults']
Path.home().joinpath(*lst)

Path('/home', 'user', 'Downloads', 'mycode.txt')
```

## 文件名处理

当创建完Path实例之后，其中包含很多有用的属性和方法来进行文件名操作，你可以使用`.`符号来找到这些方法而不需要像之前一样调用其它的模块。

```python
p = Path('/home', 'user', 'Downloads', 'mycode.txt')

p.parts
# ('\\', 'home', 'user', 'Downloads', 'mycode.txt')

# 查看后缀
p.suffix
# '.txt
p.suffixes # 如果有多个后缀，可以全部列出

# 查看父目录
p.parent
# WindowsPath('/home/user/Downloads')
list(p.parents) # 列出所有的父目录

# 查看包含后缀的文件名
p.name
# mycode.txt

# 查看不包含后缀的文件
p.stem
# mycode

# 查看目录前的部分
p.anchor
# '\\'
```

使用`with_*`可以改变文件名的不同部分，比如：

```python
p = Path('/home', 'user', 'Downloads', 'mycode.txt')

p.with_suffix('.py')

p.with_name('newcode')
```

使用`relative_to`可以创建相对路径

```python
p.relative_to('/home/user')

p.is_relative_to('/home/user')

p.match('/home/*/*/*.txt')
```

## 文件操作

Path对象还包含对系统中文件的访问和操作函数。比如查看文件的修改时间可以通过：

```python
from pathlib import Path

p = Path('./107653-trophy.json')

p.stat()
# os.stat_result(st_mode=33206, st_ino=15199648743959991, st_dev=1921214934, st_nlink=1, st_uid=0, st_gid=0, st_size=114797, st_atime=1665922310, st_mtime=1658667929, st_ctime=1658667963)

# 最后修改时间
from datetime import datetime
datetime.fromtimestamp(p.stat().st_mtime)

p.owner()

p.group()
```

读和写路径下文件的内容可以通过`read_text()`, `write_text()`, `read_bytes()`, `write_bytes()`来完成：

```python
p.read_text()

p.read_bytes()
```

如果需要列举目录下的文件，那么`iterdir()`, `glob()`, `rglob()`这几个函数可以帮助：

```python
list(Path.cwd().iterdir())

Path.cwd().glob('*.json')
# 递归列举所有匹配的文件路径
Path.cwd().glob('**/*.json')
# 递归列举所有匹配的文件路径
Path.cwd().rglob('*.json')
```

如果希望新建，移动，复制，或者删除文件，可以使用Path对象中的

```python
Path('newdir').mkdir(exist_ok=True)
Path('dir1', 'subdir1').mkdir(parents=True)

Path('newtxt').touch()
```

```python
Path('newtxt').rename('othertxt')
Path('othertxt').replace('anothertxt') # overwrite if existing
```

```python
if Path('newdir').exists() and Path('newdir').is_dir():
    Path('newdir').rmdir()
```

## 结语

pathlib中的Path对象整合了来自其它模块的操作文件路径和系统文件的方法，它对`/`运算发的重载可以让同样的操作文件路径的代码可以运行在不同系统上。它将文件路径可以通过属性parent, suffix, stem, name, anchor，让操作路径的时候语法更加易懂。它包含操作系统文件的方法，不过语法上并不比`os`，`shutil`提供的函数直观，需要适应它的面向对象的语法。

## 参考

* [Pathlib Documentation](https://docs.python.org/3/library/pathlib.html)
* [Pathlib Source Code](https://github.com/python/cpython/blob/3.10/Lib/pathlib.py)
* 'Elegant Filesystem Interactions in Python using pathlib' - Johan Herland
* [Python 3's pathlib Module: Taming the File System](https://realpython.com/python-pathlib/)