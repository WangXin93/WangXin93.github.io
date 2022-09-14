---
layout: post
title:  "Latex to MS Word（Latex文件转Word文档）"
date: 2020-11-17 11:20:22 +0800
categories: LaTeX Word
toc: true
---

> LaTeX 是非常适合排版和编写论文的工具，但是在一些情况下我们还是需要按要求提交 Word 文件，比如为了和合作者更好配合，提交系统的限制等。这时候如果有一个将 LaTeX 文档转化为 Word 文档的方案就可以省去从 tex 文件大量搬运内容的时间。帮助 LaTeX 用户专心在一个工具上编写，而将提交的 Word 文件交给转化工具。这篇博客将会介绍如何使用 pandoc 来将 LaTeX 文件转化为 Word 文件，保留其中的文字内容，公式，图片，表格，引用和参考文献。

## TLDR

Pandoc版本信息：

```
pandoc.exe 2.18
Compiled with pandoc-types 1.22.2, texmath 0.12.5, skylighting 0.12.3,
citeproc 0.7, ipynb 0.2, hslua 2.2.0
Scripting engine: Lua 5.4
```

假设要转变的tex文件名称为`main.tex`，文献数据保存在了`ref.bib`文件，文献引用使用了`ieee.csl`格式，下面的脚本会转出文档到`main.docx`并且较为完整的论文排版要求：

```bash
pandoc --filter pandoc-crossref \
    --citeproc --bibliography=ref.bib --csl ieee.csl \
    -M autoEqnLabels -M tableEqns \
    -s main.tex -o main.docx
```

## 前言

在将一个latex文件转化为word的时候，需要转化后的文档能够满足下面的要求：

* 文字内容，所有文字内容保留完整
* 图片和表格的交叉引用，
* 公式，公式内容正确而且自动标号，并且能够正确引用
* 参考文献及其引用
* Word排版样式

不是所有的文档都需要满足上面的全部要求，可以通过调节pandoc的参数选择需要实现哪些功能，功能要求越多那么需要调节的参数也会越多。下面分别介绍如何调整pandoc参数来满足上面的要求。

### 基本使用 - 保留文字内容

如果对转换后的 Word 文档没有任何特别的特别要求，只希望保证文字，图片等内容均完整，使用下面的命令:

```bash
pandoc -s main.tex -o main.docx
```

### 图片，表格的交叉引用

如果希望 LaTeX 中对图标的交叉引用，比如`\Figure ref{fig:fig1}`在word中依然显示为`Figure 1`，你可以使用加上`pandoc-crossref`参数：

```bash
pandoc --filter pandoc-crossref \
    -s mydoc.tex -o mydoc.docx
```

[`pandoc-crossref`](https://github.com/lierdakil/pandoc-crossref)是另一个项目中的程序，所有需要先进行下载。可以到release页面中找到一个版本下载，可以放到环境变量指定的路径下，或者放到当前目录。


### 参考文献及其引用

过往版本的pandoc需要使用另外一个项目[`pandoc-citeproc`](https://github.com/jgm/pandoc-citeproc)中的程序，对于较新版本的pandoc，可以直接添加`--citeproc`参数来解析 bibliography 文件和 csl 风格文件来处理文献引用。

一个命令的例子如下，下面使用了`ieee.csl`作为引用风格设置的文件，使用`ref.bib`存放文献数据。

```bash
pandoc --filter pandoc-crossref \
    --citeproc \
    --bibliography=ref.bib --csl ieee.csl \
    -s mydoc.tex -o mydoc.docx
```

如果需要使用中文的引用风格，可以使用其它的csl文件，比如`chinese-gb7714-2005-numeric.csl`。

## 公式

如果希望命令能在 Word 文档中的公式的右边自动按照1，2，……，编号，可以添加额外的参数，其中`-M autoEqnLabels`设置给公式编号，`-M tableEqns`让所有的编号靠右对齐，到目前为止完整的命令如下：

```bash
pandoc --filter pandoc-crossref \
    -M autoEqnLabels -M tableEqns \
    --citeproc \
    --bibliography=ref.bib --csl ieee.csl \
    -s mydoc.tex -o mydoc.docx
```

你会发现这个命令输出的公式编号虽然正确，但是在引用的位置没有按照 公式1，公式2 这样引用，而是类似于 公式{eq:eq1}。并且有些情况下编号没有靠右对齐。目前据我所知使用pandoc还不能完全解决这个问题，可以在输出文档上进行手动调节来满足提交要求。

### Word排版样式

你可以将输出的 Word 文件按照模板文件进行排版，这可以在pandoc中输入额外的参数`--reference-doc=IEEE_template.docx`来实现。IEEE的模板文件可以在[IEEE template selector](https://template-selector.ieee.org/)找到一个进行试验。

```bash
pandoc --filter pandoc-crossref \
    -M autoEqnLabels -M tableEqns \
    --citeproc \
    --bibliography=ref.bib --csl ieee.csl \
    --reference-doc=IEEE_template.docx \
    -s mydoc.tex -o mydoc.docx
```

### Pandoc-crossref 自定义设置

如果需要修改转化时候的Metadata，比如将图片的caption由``figure 1``变为``图 1``，你需要修改pandoc-crossref配置文件，参考<http://lierdakil.github.io/pandoc-crossref/#settings-file>：

```bash
pandoc --filter pandoc-crossref --filter pandoc-citeproc --bibliography=ref.bib 
--csl ieee.csl --reference-docx=IEEE_template.doc 
-M pandoc-crossref.yaml mydoc.tex -o mydoc.docx
```

## References

* [How to Convert from Latex to MS Word with ‘Pandoc’](https://medium.com/@zhelinchen91/how-to-convert-from-latex-to-ms-word-with-pandoc-f2045a762293)
* [使用 Pandoc Markdown 进行学术论文写作](http://www.zale.site/articles/2016/05/Academia-Writing-Using-Markdown-and-Pandoc.html)
* [pandoc-crossref documentation](http://lierdakil.github.io/pandoc-crossref/)
* <https://tex.stackexchange.com/questions/586959/pandoc-crossref-does-not-resolve-proper-equation-referencing-from-latex-to-word>
* [LaTeX to Word Conversion with Pandoc](https://ja01.chem.buffalo.edu/tutorials/latex-pandoc-word.html#:~:text=Conversion%20of%20pandoc-template.tex%20to%20Word%20file%20converted.docx%20is,-f%20latex%20-t%20docx%20-o%20converted.docx%20--bibliography%3Dthecitations.bib%20--csl%3Djournal-of-the-american-chemical-society.csl)