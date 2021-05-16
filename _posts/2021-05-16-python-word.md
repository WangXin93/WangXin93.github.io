---
layout: post
title:  "使用Python自动化操作Word文档"
date:   2021-05-16 09:28:29 +0800
categories: Python
toc: true
---

## 前言

Word 是最常用的办公软件之一，它蛀牙用来写作和排版文档。Word 有好用的界面来帮助用户阅读和写作文件，但是仍然有一些情况下操作 Word 是重复琐碎的：

* 当用户要批量更改 Word 文件的时候，用鼠标频繁地打开和关闭文件管理器中的 Word 文件是非常耗时且繁琐的；
* 当用户需要根据固定内容生成多个 Word 文档的时候，重复创建文件再粘贴内容修改的过程是非常无聊的；
* 当用户需要使用其他语言处理软件来修改 Word 的内容的时候，需要有一个软件能够读取和修改 Word 文档的内容。

Python 程序语言可以通过第三方的库来开发出多种多样的功能，其中之一就是对 Word 文档的自动化操作，包括 Word 文档内容的读取和写作。结合 Python 其他的关于[自然语言处理](https://stackabuse.com/what-is-natural-language-processing/)的库，我们更可以将更多功能结合到 Word 自动化操作的过程中。这篇文章下面的内容会介绍如何使用 Python 来读和写 Word 文档。

## 安装``python-docx``库

Python 中有不止一个能够读写 Word 文档的库。这里我们使用``python-docx``库，

```
pip install python-docx
```

## 读取 Word 文件

为了使用``python-docx``库读取 Word 文件，你需要先导入``docx``模块，然后创建一个``Document``类，把 Word 文件的路径比如``word_file.docx``作为参数传入 ``Document``，这个``Document``对象就会读取 Word 文件的内容。这个过程的代码如下：

```python
import docx

doc = docx.Document("./word_file.docx")
```

### 读取段落

一个 Word 文件的所有内容可以按照段落（paragraphs）划分，下面的代码展示了如何从``Document``对象中得到所有的段落，并且在控制台中打印出来，你可以发现一个空白行也是一个段落：

```python
all_paras = doc.paragraphs

print("There is totally {} paragraphs.".format(len(all_paras)))

for para in all_paras:
    print(para.text)
    print("--------")

single_para = doc.paragraphs[4]
print(single_para.text)
```

这段代码可以得到的输出是：

```
-------
Introduction
-------

-------
Welcome to my home page
-------
The site is for learning Python and Other Programming Languages
-------
Learn to program and write code in the most efficient manner
-------

-------
Details
-------

-------
This website contains useful programming articles for Java, Python, C and C++ etc.
-------
```

如果希望得到某一个段落的内容，可以对``paragraphs``进行索引，比如要想得到第6段的内容，可以编写代码：

```python
single_para = doc.paragraphs[5]
```

### 读取 Runs

在 Word 文档中，一个 run 是连续的一段具有相同属性（包括字体，大小，格式）的词语。比如“欢迎来到我的主页，**这个网站介绍如何使用Python**_和其他的编程语言_”这句话，其中“欢迎来到我的蛀牙，”是一个run，“**这个网站介绍如何使用Python**”是另一个run，“_和其他的编程语言_”是又一个run。一个paragraph可以含一个或者一个以上的run。对这些run逐一读取可以使用下面的代码：

```python
second_para = doc.paragraphs[1]
for run in second_para.runs:
    print(run.text)
```

## 写入Word文件


使用``python-docx``读取 Word 文件可以方便的得到文件中关键的内容，但更有用的是使用``python-docx``编写 Word 文档，这可以帮助我们批量修改和生成 Word 文件。写入 Word 文件和读取文件一样需要先创建一个``Document`` 类，但是这里可以先不将路径写入``Document``类的构建函数的参数：

```python
doc = docx.Document()
```

### 添加段落

你可以使用``add_paragraph()``方法来对``Document``类添加一个段落，添加段落完成后，使用``save()``方法来保存文件到一个路径，如果这个路径的文件不存在，那么这时会创建一个新的文件：

```python
doc.add_paragraph("The first paragraph in a MS Word file")

doc.save("word_file.docx")
```

### 添加 run

如果你希望在一个段落后面添加一个run，你可以先得到这个段落的handle，然后就可以使用``add_run()``方法来添加run在后面。下面的代码中，``add_paragraph()``方法不仅会创建一个段落，还会返回这个段落的handle：

```
third_para = mydoc.add_paragraph("This is the third paragraph.")
third_para.add_run(" this is a section at the end of third paragraph")
doc.save("word_file.docx")
```

### 添加标题

在 Word 文件中添加标题可以使用``add_heading()``方法，这个方法的第一个参数是传入的标题内容，第二个参数是标题的尺寸。标题的尺寸从0开始到1，2，3，数字越大标题的字越小，0是最顶部的标题：

```
doc.add_heading("This is level 1 heading", 0)
doc.add_heading("This is level 2 heading", 1)
doc.add_heading("This is level 3 heading", 2)
```

### 添加图片

在 Word 文件中添加图片可以使用``add_images()``方法，这个方法的第一个参数为图片文件的路径，你还可以在后面的参数设置图片的宽度和高度，单位是``docx.shared.Inches()``。

```
doc.add_picture("flower.jpg", width=docx.shared.Inches(4), height=docx.shared.Inches(3))
```

## 结语

Python 可以使用``python-docx``库完成对 Word 文件内容的读取，文件的段落，run，标题，图片的写入，从而完成 Word 文件的自动化操作，这可以用在批量修改或者生成 Word 文件，以及使用其他自然语言处理应用来处理 Word 文件的内容，比如批量给 Word 文档添加结尾，使用马尔可夫链随机生成文字内容来生成多个 Word 文档。在[官方文档](https://python-docx.readthedocs.io/en/latest/)中，还可以找到更多``python-docx``的操作方法比如字体和表格等等。

除了 Word 软件，Python还可以使用[``openpyxl``](https://realpython.com/openpyxl-excel-spreadsheets-python/)库操作 Excel 表格，使用[``python-ppt``](https://python-pptx.readthedocs.io/en/latest/)库来操作 PPT，从而可以通过编写代码完成这两个软件的自动化操作，减少重复工作的时间。

## 参考

* [Documentation](https://python-docx.readthedocs.io/en/latest/)
* <https://stackabuse.com/reading-and-writing-ms-word-files-in-python-via-python-docx-module/>
