---
layout: post
title:  "XPath 关键概念"
date:   2018-02-02 18:47:00 +0800
categories: Python
---

## 1. 前言
`xpath`是一门在`XML`文档中查找信息的语言。 [`BeautifulSoup`](https://www.crummy.com/software/BeautifulSoup/)不支持`xpath`，但是`python`中的很多库比如（[`lxml`](http://lxml.de/)，`selenium`，`scrapy`等）都支持。它的使用方式通常和`CSS Selector`（比如`mytag#idname`）一样。它原本被设计用于处理更规范的`XML`文档而不是`HTML`文档。

---

## 2. 学习准备 
这里使用`scrapy shell`作为`xpath`语法的实现环境，如果熟悉`scrapy`可以跳过这段。本文的解析目标为：http://quotes.toscrape.com/，这是[`scrapy`](https://docs.scrapy.org/en/latest/intro/tutorial.html)教学使用的网站。`scrapy`库的安装方法如下：
```
$ pipenv install # 创建虚拟环境并安装Pipfile中的依赖项
$ pipenv shell # 进入虚拟环境
$ pipenv install scrapy # 安装scrapy
```
[`scrapy shell`](https://docs.scrapy.org/en/latest/topics/shell.html#topics-shell)是一个可以对接收到的网页信息进行交互式提取的`shell`环境。在安装好`scrapy`后，打开`scrapy shell`的方法为：`$ scrapy shell http://quotes.toscrape.com/`。执行该命令后会看到类似如下内容：
```python
[s] Available Scrapy objects:
[s]   scrapy     scrapy module (contains scrapy.Request, scrapy.Selector, etc)
[s]   crawler    <scrapy.crawler.Crawler object at 0x7f7ca6803978>
[s]   item       {}
[s]   request    <GET http://quotes.toscrape.com/>
[s]   response   <200 http://quotes.toscrape.com/>
[s]   settings   <scrapy.settings.Settings object at 0x7f7ca6812b00>
[s]   spider     <DefaultSpider 'default' at 0x7f7ca5002c18>
[s] Useful shortcuts:
[s]   fetch(url[, redirect=True]) Fetch URL and update local objects (by default, redirects are followed)
[s]   fetch(req)                  Fetch a scrapy.Request and update local objects 
[s]   shelp()           Shell help (print this help)
[s]   view(response)    View response in a browser
In [1]: response.headers
Out[1]: 
{b'Content-Type': b'text/html; charset=utf-8',
 b'Date': b'Fri, 02 Feb 2018 13:39:41 GMT',
 b'Server': b'nginx/1.12.1',
 b'X-Upstream': b'spidyquotes-master_web'}
```
在`scrapy shell`中`response`是一个已经定义好的变量，它的含义为从服务器接收到的响应。使用`response.headers`可以得到它的头信息。之后就可以使用`xpath`语法对`response`中的内容进行进一步抓取解析。

---

## 3. XPath语法的四个重要概念
# 根节点和非根节点
- `/div`选择`div`节点，只有当它是文档的根节点时
- `//div`选择所有的`div`节点（包括非根节点）

# 通过属性选择节点
- `//@href`选择带`href`属性的所有节点
- `//a[@href='http://google.com']`选择页面中所有指向Google网站的链接

# 通过位置选择节点
- `//a[3]`选择文档中的第三个链接
- `//table[last()]`选择文档中的最后一个表
- `//a[position()<3]`选择文档中的前三个链接

# 星号(*)匹配任意字符或节点，可以在不同条件下使用。
- `//table/tr/*`选择所有表格行`tr`标签的所有子节点
- `//div[@*]`选择带任意属性的所有`div`标签

---

## 4. 在Scrapy中使用XPath
这里回到之前打开的`scrapy shell`环境，执行下面指令可以抓取网页标题：
```python
In [17]: response.xpath('//title') # 抓取标题节点并提取
Out[17]: [<Selector xpath='//title' data='<title>Quotes to Scrape</title>'>]
In [18]: response.xpath('//title/text()').extract_first() # 抓取标题节点内容并提取
Out[18]: 'Quotes to Scrape' 
```
这里`text()`的作用是定位到标签的内容。

下面的命令可以抓取网页所有内容为about的`a`标签节点中的`href`属性值。值得注意的是`@href`代表定位到属性值`href`。
```python
In [6]: response.xpath("/html/body/div/div[2]/div[1]//span//a/@href").extract()
Out[6]:
['/author/Albert-Einstein',
 '/author/J-K-Rowling',
 '/author/Albert-Einstein',
 '/author/Jane-Austen',
 '/author/Marilyn-Monroe',
 '/author/Albert-Einstein',
 '/author/Andre-Gide',
 '/author/Thomas-A-Edison',
 '/author/Eleanor-Roosevelt',
 '/author/Steve-Martin']
```
下面指令的效果是抓取所有网页中的所有quote:
```python
In [74]: esponse.xpath("/html/body/div/div[2]/div[1]/div//span[@class='text']/text()").extract()
Out[74]:
['“The world as we have created it is a process of our thinking. It cannot be changed without changing our thinking.”',
 '“It is our choices, Harry, that show what we truly are, far more than our abilities.”',
 '“There are only two ways to live your life. One is as though nothing is a miracle. The other is as though everything is a miracle.”',
 '“The person, be it gentleman or lady, who has not pleasure in a good novel, must be intolerably stupid.”',
 "“Imperfection is beauty, madness is genius and it's better to be absolutely ridiculous than absolutely boring.”",
 '“Try not to become a man of success. Rather become a man of value.”',
 '“It is better to be hated for what you are than to be loved for what you are not.”',
 "“I have not failed. I've just found 10,000 ways that won't work.”",
 "“A woman is like a tea bag; you never know how strong it is until it's in hot water.”",
 '“A day without sunshine is like, you know, night.”']
```
这里要注意的是`//span[@class='text']`的含义是寻找所有`class`属性值为'text'的`span`标签，`//span`意味着非根节点。

---

## 5. 更多关于XPath的资料：
- Use XPath with Scrapy Selectors: <https://docs.scrapy.org/en/latest/topics/selectors.html#topics-selectors>
- Learn XPath through examples: <http://zvon.org/comp/r/tut-XPath_1.html>
- How to think in XPath: <http://plasmasturm.org/log/xpath101/>
- w3c教程: <http://www.w3school.com.cn/xpath/>
- 微软XPath语法界面: <https://msdn.microsoft.com/en-us/enus/library/ms256471>


