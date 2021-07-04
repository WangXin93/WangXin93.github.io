---
layout: post
title:  "阿里云服务器上jupyter与pyspark的配置"
date:   2018-02-26 8:48:33 +0800
categories: Linux
toc: true
---

## 前言
在云端进行计算有着自己独特的优势，比如不同担心本地机器因为断电或者其他程序卡死导致计算前功尽弃，并且可以利用云服务器上计算资源实现本地计算机不能胜任的任务。

Apache Spark 是专为大规模数据处理而设计的快速通用的计算引擎。Spark是UC Berkeley AMP lab (加州大学伯克利分校的AMP实验室)所开源的类Hadoop MapReduce的通用并行框架，Spark，拥有Hadoop MapReduce所具有的优点；但不同于MapReduce的是——Job中间输出结果可以保存在内存中，从而不再需要读写HDFS，因此Spark能更好地适用于数据挖掘与机器学习等需要迭代的MapReduce的算法。

本文记录如何在阿里云服务器ECS上配置Spark环境包括：
- 通过jupyter notebook在云端进行机器学习
- pyspark配置方法

## 通过jupyter notebook在云端进行机器学习

1. 购买阿里云[学生套餐ECS](https://promotion.aliyun.com/ntms/campus2017.html)，价格为10元/月，购买完成后收到短信，内容包含登录账户名和IP，如果购买时候未设置密码需要使用充值密码选项。

2. [使用ssh登录云服务器ecs](https://help.aliyun.com/document_detail/25425.html?spm=a2c4g.11186623.2.6.JZ5nEF)
```bash
$ ssh root@39.108.1.141
password: 
```

3. [添加sudo用户](https://www.digitalocean.com/community/tutorials/how-to-create-a-sudo-user-on-ubuntu-quickstart)
使用root用户直接操作系统会增加风险，可以创建一个自己的新账户登录云服务器，并将其添加到sudo组里，这样使用sudo指令时候可以得到root权限。
```bash
# adduser username
# usermod -aG sudo username
# su username
```
使用`who`可以查看到当前有哪些用户登录，使用`sudo pkill -u username`可以强行让某个用户退出登录。

4. 安装anaconda
搜索引擎搜索[anaconda archive](https://repo.continuum.io/archive/)，找到最新下载包的地址，然后用wget下载：
```bash
$ wget https://repo.continuum.io/archive/Anaconda3-5.0.1-Linux-x86_64.sh
```
下载完成后安装程序，当询问是否添加path到.bashrc的时候选择yes，将anaconda路径加入环境变量，默认为`/home/username/anaconda3/bin`
```bash
$ bash ./Anaconda2-5.0.1-Linux-x86_64.sh
$ source .bashrc # 程序包自动添加内容到到.bashrc，该句添加环境变量
```

5. 配置jupyter

- 使用openssl加密
```bash
# Generate configuration file
$ jupyter notebook --generate-config
# Create certification for connections in the format of .gem file
$ mkdir certs
$ cd certs
$ sudo openssl req -x509 -nodes -days 365 -newkey rsa:1024 -keyout mycert.pem -out mycert.pem
```
```bash
# Edit configuration file
$ cd ~/.jupyter/
$ vim jupyter_notebook_config.py 
```
在`jupyter_notebook_config.py`中添加如下内容：
```python
c = get_config()
c.NotebookApp.certfile = u'/home/wangx/certs/mysert.pem' # Path to .pem file just created
c.NotebookApp.ip = '*' # Means all ip addresses on your system
c.NotebookApp.open_browser = False # Not open browser
c.NotebookApp.port = 8888
c.NotebookApp.token = '' # Not need token in url at first time login
```

- 使用jupyter password加密
使用jupyter notebook自带的password功能部署起来更加方便。首先设定登陆密码：

```
$ jupyter notebook password
```

然后在配置文件`jupyter_notebook_config.py`中添加内容：

```python
c = get_config()
c.NotebookApp.ip = '*'  
c.NotebookApp.open_browser = False  
c.NotebookApp.port = 8888  
```

这比前者的配置内容少多了！

6. [给云服务器开放端口](https://jingyan.baidu.com/article/03b2f78c31bdea5ea237ae88.html)
阿里云服务器默认开放的端口只有三个，包括22，-1, 3389端口。为了从外部访问jupyter notebook，需要给云服务器开放访问端口，根据前文设置，开放8888端口，端口号可以根据`jupyter_notebook_config.py`变更。

7. 运行jupyter notebook
```bash
$ jupyter notebook
[I 10:14:46.671 NotebookApp] Writing notebook server cookie secret to /run/user/1000/jupyter/notebook_cookie_secret
[W 10:14:47.628 NotebookApp] WARNING: The notebook server is listening on all IP addresses and not using authentication. This is highly insecure and not recommended.
[I 10:14:47.674 NotebookApp] JupyterLab beta preview extension loaded from /home/wangx/anaconda3/lib/python3.6/site-packages/jupyterlab
[I 10:14:47.674 NotebookApp] JupyterLab application directory is /home/wangx/anaconda3/share/jupyter/lab
[I 10:14:47.681 NotebookApp] Serving notebooks from local directory: /home/wangx/test
[I 10:14:47.681 NotebookApp] 0 active kernels
[I 10:14:47.681 NotebookApp] The Jupyter Notebook is running at:
[I 10:14:47.682 NotebookApp] https://[all ip addresses on your system]:8888/
[I 10:14:47.682 NotebookApp] Use Control-C to stop this server and shut down all kernels (twice to skip confirmation).
```
然后在浏览器输入url如：`http://your_ip:8888`就可以看见jupyter notebook的界面啦。这时浏览器可以用来输入计算指令，而计算任务则是由云服务器来完成并将结果通过网络返回到浏览器上。


8. 关于ssh连接阿里云时间过长会自动断开的解决方法
ssh连上阿里云的服务后，总是会自动断开。
可能阿里云LVS的限制，空闲TCP连接过一分多钟就会中断。解决办法：设置ServerAliveInterval，让本地客户端空闲时发送noop。
```bash
$ sudo vi /etc/ssh/ssh_config
```
连接SSH时，每60秒会发一个KeepAlive请求，避免被踢。
```
ServerAliveInterval 60
```

### 参考链接
- <https://www.alibabacloud.com/help/zh/doc-detail/53650.htm>
- <http://blog.csdn.net/ys676623/article/details/77848427>
- <https://yq.aliyun.com/articles/98527>

## 给Jupyter配置登录密码
从`jupyter notebook 5.0`版本开始，提供了一个命令来设置密码：`jupyter notebook password`，生成的密码存储在`jupyter_notebook_config.json`
```bash
$ jupyter notebook password
Enter password:  ****
Verify password: ****
[NotebookPasswordApp] Wrote hashed password to /Users/you/.jupyter/jupyter_notebook_config.json
```
之后在`jupyter_notebook_config.py`中找到下面的行，取消注释并修改。
```
c.NotebookApp.password = u'sha:ce...刚才复制的那个密文'
```
使用`jupyter notebook`再次启动notebook，可以发现已经添加了登录索要密码的界面。

对于5.0版本之前的用户可以使用下面方法生成密码：
```bash
PASSWD=$(python -c 'from notebook.auth import passwd; print(passwd("jupyter"))')
echo "c.NotebookApp.password = u'${PASSWD}'"
```

## 将jupyter notebook 配置为service

创建一个 ``jupyter.service`` 文件，内容如下：

```
[Unit]
Description=Jupyter Notebook
[Service]
Type=simple
PIDFile=/run/jupyter.pid
ExecStart=/home/lab2033/miniconda3/bin/jupyter-notebook
User=lab2033
Group=lab2033
WorkingDirectory=/home/lab2033/parttime
Restart=always
RestartSec=10
[Install]
WantedBy=multi-user.target
```

然后安装这个service：

```
sudo cp jupyter.service /etc/systemd/system/

# Use the enable command to ensure that the service starts whenever the system boots
sudo systemctl enable jupyter.service

sudo systemctl daemon-reload

sudo systemctl start jupyter.service

systemctl status jupyter.service
```

### 参考链接
* [jupyter Notebook 安装使用](https://cloud.tencent.com/developer/article/1019832)
* [十分钟配置云端数据科学开发环境](https://cloud.tencent.com/developer/article/1004749)
* [Jupyter notebook as a service on Ubuntu 18.04 with Python 3](https://naysan.ca/2019/09/07/jupyter-notebook-as-a-service-on-ubuntu-18-04-with-python-3/)

## 配置pyspark

1. Spark使用Scala写的，Scala依赖Java。先安装Java。
```bash
$ sudo apt-get install default-jre
$ java -version # 检查java是否安装成功
```

2. 安装Scala：
```bash
$ sudo apt-get install scala
$ scala -version # 检查scala是否安装成功
```

3. 保证pip安装的是anaconda版本的python而不是ubuntu默认的python，安装py4j：
```bash
$ export PATH=$PATH:$HOME/anaconda3/bin
$ conda install pip
$ which pip # 确认使用的是anaconda安装的pip
$ pip install py4j # Python interface for Java
```

4. 下载并解压spark
```bash
$ get http://apache.mirrors.tds.net/spark/spark-2.2.1/spark-2.2.1-bin-hadoop2.7.tgz
$ tar -zxvf spark-2.2.1-bin-hadoop2.7.tgz
```

5. 配置环境变量
```bash
$ export SPARK_HOME='/home/username/spark-2.2.1-bin-hadoop2.7'
$ export PATH=$SPARK_HOME:$PATH
$ export PYTHONPATH=$SPARK_HOME/python:$PYTHONPATH
```
执行`$ python -c 'from pyspark import SparkContext;sc=SparkContext()'`如果顺利通过，说明pyspark安装成功。

6. 如果报出[`Py4JJavaError`](https://stackoverflow.com/questions/23353477/trouble-installing-pyspark)，可能由于阿里云ECS主机名不能被resolve，需要执行`$ export SPARK_LOCAL_IP=172.18.181.193`或者
```bash
$ sudo vim /etc/hosts
```
添加内容：
```
127.0.1.1       hostname
```
hostname可以通过命令`hostname`查询。


### 参考内容
* [PySpark Setup](https://www.udemy.com/python-for-data-science-and-machine-learning-bootcamp/learn/v4/t/lecture/5784658?start=0)
