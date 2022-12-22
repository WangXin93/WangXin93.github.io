---
categories: Python
date: "2018-02-01T17:25:46Z"
title: Python 版本管理
toc: true
---

## 前言

使用Python开发程序的工作者会使用[``pip``](https://en.wikipedia.org/wiki/Pip_(package_manager)或者[``easy_install``](https://pythonhosted.org/setuptools/easy_install.html)来安装其它开发者编写的软件包来帮助自己的开发过程。大多数情况下，Python可以自动地寻找已经安装好的软件包用户不需要额外操作，但是如果在同时开发多个项目的时候可能会遇到问题。

这个问题是不同的项目可能需要不同的软件包，但是Python这时候还不能够同时处理两个不同版本的软件包。如果对Python寻找软件包的原理稍作了解就可以知道其中的原因。Python寻找安装包的方法是从预定义的路径中去搜索，有的包被称为system package，它们是Python标准库中的一部分，你可以在自己的电脑用命令``python -c "import sys; print(sys.prefix)"``来看到这个路径；另一些包被称为site package，它们是从第三方下载安装的包，你可以通过命令``python -c "import site; print(site.getsitepackages())"``来看到这个路径。所有的项目都会从上面打印出的路径中寻找包，但是如果*项目A*使用v1.0的第三方包，*项目B*使用v2.0的第三方包，如果同时安装两个版本的包，这两个包都会被放在同一个存放site package的路径，这时候Python就不能够区分到底为你调用哪个版本的包。

这个问题的解决办法是使用*Python虚拟环境*（[virtual environment](https://docs.python.org/3/library/venv.html#venv-def)）。一个虚拟环境是一个独立的Python环境，这个独立的环境提供独立的Python解释器，库，以及脚本，它和其它虚拟环境以及系统安装的Python分开，从而避免了其它项目安装的软件包的带来的冲突。你可以使用不同的工具来创建这样的虚拟环境，比如[virtualenv](https://virtualenv.pypa.io/en/latest/)，[venv](https://docs.python.org/3/library/venv.html)，pyenv，conda等。

## ``virtualenv``

### 安装

```
$ pip install python-virtualenv
```

### 基本使用

```
$ virutalenv .env -p python3
$ source .env/bin/activate
$ deactivate
```

## ``venv``

### 安装

```
$ python3 -m venv .env -p python3
```

### 基本使用

```
$ source .env/bin/activate
$ deactivate
```

## ``virtualenvwrapper``

Virtualenvwrapper是virtualenv的进一步扩展，它将所有的虚拟环境集中到一个目录下进行管理，避免了每个项目创建不同的虚拟环境，因此它的好处有：

* 在一个目录下避免了找不到安装好的虚拟环境的情况
* 便于统一的环境添加，删除，复制操作
* 能够在不同虚拟环境间快速切换

### 安装

使用virtualenvwrapper需要先进行安装配置：

```
$ pip install virtualenvwrapper
```

然后创建目录用来存放虚拟环境：

```
$ mkdir ~/.virutalenvs
```

最后在``~/.bashrc``中添加下面内容，使得每次bash启动时候自动加载：

```
export WORKON_HOME=~/.virtualenvs
source /usr/local/bin/virtualenvwrapper.sh
```

### 常用命令

Virutalenvwrapper 常用的命令包括：

* workon:列出虚拟环境列表
* lsvirtualenv:同上
* mkvirtualenv :新建虚拟环境
* workon [虚拟环境名称]:切换虚拟环境
* rmvirtualenv :删除虚拟环境
* deactivate: 离开虚拟环境


## ``pipenv``
`pipenv`是`python`项目的依赖管理器，近来社区不断推广使用之，比如董伟明的[这篇](http://www.dongwm.com/archives/%E4%BD%BF%E7%94%A8pipenv%E7%AE%A1%E7%90%86%E4%BD%A0%E7%9A%84%E9%A1%B9%E7%9B%AE/), 不光介绍了`pipenv`的特性，还介绍了一个利用`pipenv`的特性来卸载已安装的包及其所有依赖项的方法，点赞。本文为`pipenv`的速成介绍，适合熟悉`virtualenv`的用户，可以帮助`python`用户从`virtualenv`平滑过渡到`pipenv`。

---

### 安装pipenv
`pipenv`可以用`pip`安装，过程非常简单直接。这里以Mac为例：
```bash
$ brew install python3
$ pip3 install pipenv --user ##  安装在个人目录下
$ export PATH="/Users/username/Library/python/3.6/bin:$PATH" ## 将pipenv路径加入环境变量
```

---

### 基本使用

#### 1. 创建虚拟环境
通过下面语句可以分别创建`python3`, `python2`, `python3.6`虚拟环境。
```bash
$ pipenv --three
$ pipenv --two
$ pipenv --python 3.5
```
如果成功执行，可以看到类似下面的消息：
```bash
Virtualenv location: /home/wangx/.local/share/virtualenvs/testpipenv-kyMeQK-Y
Creating a Pipfile for this project…
```
同时目录中会多出一个`Pipfile`文件，该命令的作用类似于`$ virutalenv .env`。

#### 2. 安装依赖项
##### 2.1 基本使用
在有`Pipfile`的目录执行下面命令会安装存储于`Pipfile`文件中的依赖项，作用类似于`$ pip install -r requirements.txt`。
```bash
$ pipenv install
```
成功执行该命令可以发现目录中多了一个`Pipfile.lock`文件。

如果目录没有`Pipfile`，该命令会自动先创建一个虚拟环境和`Pipfile`，然后安装依赖项。

如果除了`Pipfile`中的包还有其他的包需要安装，使用下面的命令。

```bash
$ pipenv install flask
```
如果希望从`virtualenv`生成的`requirements.txt`导入依赖项，可以使用下面的命令：
```bash
$ pipenv install -r path/to/requirements.txt
```
##### 2.2 管理开发环境
下面的指令可以更新Pipfile.lock文件，来冻结软件包名称，版本，以及依赖关系列表：
```bash
$ pipenv lock
```
通常有一些Python包只在你的开发环境需要而不是生产环境，比如单元测试包，Pipenv使用`-dev`标志保持两个环境分开：
```bash
$ pipenv install --dev nose2
```
这时如果执行`pipenv install`将会只安装生产环境需要的包，而不会安装`nose`。如果使用：
```bash
$ pipenv install -dev
```
将安装所有的依赖项，包括开发包。

#### 3. 进入虚拟环境
##### 3.1 交互环境
使用下面命令可以进入新建的虚拟环境。作用类似于`$ source .env/bin/active`。
```bash
$ pipenv shell
```
执行完成后发现命令行提示符号变为类似如下形式：
```bash
(testpipenv-kyMeQK-Y) wangx test_pipenv $ 
```
##### 3.2 运行代码
下面的指令将在虚拟环境中运行`which python`：
```bash
$ pipenv run which python
```
如果想在虚拟环境中运行项目文件，可以使用：
```bash
$ pipenv run python my_project.py
```
我们可以设置一个alias来缩短该命令的长度：
```bash
alias prp="pipenv run python"
prp my_project.py
```

#### 4. 查看已安装依赖项
```bash
$ pipenv graph
```

#### 5. 退出虚拟环境
使用`exit`可以退出虚拟环境。可以发现命令行提示符号变为正常形式。
```bash
(testpipenv-kyMeQK-Y) wangx test_pipenv $ exit
exit
wangx test_pipenv $
```
至此利用`pipenv`实现`python`虚拟环境的工作流程介绍完毕。相信越来越多的`python`用户在熟悉`pipenv`之后会选择使用它作为自己的好搭档。

#### 6. 其他功能
查看`pipenv`文档帮助。网页文档的链接在[这里](https://docs.pipenv.org/)。
```bash
pipenv --man
```
用`Flake8`检查`python`代码规范。
```bash
pipenv check --style project.py
```
将`pipenv`中的依赖项以`requirements.txt`形式打印出来：
```
$ pipenv run pip freeze
```

## ``pyenv``

[Pyenv](https://github.com/pyenv/pyenv)是另一种切换不同python版本的解决方案。它的解决思路是：

* 变换全局的python版本
* 提供了不同项目的python版本
* 允许使用一个环境变量来重写python版本
* 允许通过命令来搜寻多个python版本，这对于跨python版本的测试（比如使用tox）会有帮助。

## ``pipx``

[Pipx](https://github.com/pipxproject/pipx)用来帮助安装使用python编写的命令行工具。和pip相比，pip是用来安装python编写的库，而pipx是用来安装已经发布的python应用。使用pipx的优点在于：

* pipx是在一个独立的环境中安装包和应用，所有不会和机器上已有的环境发生冲突。
* 方便应用的管理，查询，升级，删除。
* 用一个临时环境（run command）来运行最新的python应用。
* 没有了权限的限制，pip安装包的时候经常会需要需要sudo的情况，这是由于需要在根目录下写入内容，pipx可以避免这个情况。

### 安装

```
$ python3 -m pip install --user pipx
$ python3 -m pipx ensurepath
```

如果需要命令行不全需要执行：

```
pipx completions
```

pipx文档在[这里](https://pipxproject.github.io/pipx/)。

## conda

Anaconda 是 Python 和 R 编程语言为数据科学，机器学习而制作的发行版，它的特色是简化了软件包的管理和配置，并且包含了大量常见的数据科学用到的软件包。当你安装好 anaconda 发行版之后，你会发现同时会得到一个 conda 软件，conda 是一个跨平台的软件包和环境的管理器，你可以在 Mac，Windows，Linux 上都可以使用 conda 来安装，运行，升级软件包，你可以创建，更新，或者切换不同的 conda 环境来管理不同程序的运行环境。conda 是针对 python 开发的，但是你也可以用它来为其它编程语言管理环境，比如R, Ruby, Lua, Scala, Java, JavaScript, C/ C++, FORTRAN。

### 创建Python虚拟环境

```
conda create -n env_name python=X.X
```

这里env_name是即将创建的虚拟环境的名字，python=X.X可以设定虚拟环境中的Python版本。创建完成后可以用``conda env list``确认虚拟环境已经成功创建。

###  激活虚拟环境

```
source activate env_name  # Linux and Mac
activate env_name         # Windows
```

激活成功后可以使用``python --version``来检查当前Python版本是否是想要的。如果要退出虚拟环境使用：

```
source deactive           # Linux and Max
deactive                  # Windows
```

对于不想要的虚拟环境使用下面指令删除：

```
conda remove -n env_name --all
```

### 包管理

如果想要安装Anaconda发行版中所有的包可以使用：

```
$ conda install anaconda
```

这会把这个包安装到当前的conda环境，如果希望安装到指定的conda环境可以使用：

```
conda install -n env_name pandas
```

安装完成后可以使用``conda list``来查看已经安装了哪些包或者使用``conda list -n env_name``查看指定环境中有哪些包。使用：

```
conda search pyqtgraph
```

可以搜索包，如果要更新包可以使用：

```
conda update numpy
conda update anaconda
```

对于不想要的包可以使用下面指令卸载：

```
conda remove numpy
conda remove --name env_name numpy
```

conda 目前还不支持对于已有的环境进行重命名，但是如果你一定要重命名一个环境，可以先复制一个已有的环境换上新的名字，然后将原来的环境删除。

```
conda create --name new_name --clone old_name
conda remove --name old_name --all # or its alias: `conda env remove --name old_name`
```

### 设置下载镜像

访问国外资源网速太慢，使用镜像可以加速包的下载速度非常之多。使用国内镜像的具体方法如下：

```
$ conda config --add channels https://mirrors.tuna.tsinghua.edu.cn/anaconda/pkgs/free/
$ conda config --set show_channel_urls yes
```

或者修改`.condarc`文件，Windows下它的目录为：`C://Users/username/.condarc`，Linux或者Max下它的路径为：`~/.condarc`。修改它为如下内容：

```
channels:
 - https://mirrors.tuna.tsinghua.edu.cn/anaconda/pkgs/free/
 - defaults
show_channel_urls: yes
```

## 参考链接

* [Python Virtual Environments: A Primer](https://realpython.com/python-virtual-environments-a-primer/)
* [There’s no magic: virtualenv edition](https://www.recurse.com/blog/14-there-is-no-magic-virtualenv-edition)
* [Managing Multiple Python Versions With pyenv](https://realpython.com/intro-to-pyenv/)
* [Conda Documentation](https://conda.io/projects/conda/en/latest/user-guide/tasks/manage-environments.html)
