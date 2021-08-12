---
layout: post
title:  "Latex to MS Word（Latex文件转Word文档）"
date: 2020-11-17 11:20:22 +0800
categories: LaTeX Word
toc: true
---

> LaTeX 是非常适合排版和编写论文的工具，但是很多情况下我们还是需要按要求提交 Word 文件。如果有一个将 LaTeX 文档转化为 Word 文档的方案就可以帮助 LaTeX 用户专心在一个工具上编写，而将提交的 Word 文件交给转化工具。这篇文章将会介绍如何使用 pandoc 来将 LaTeX 文件转化为 Word 文件，同时保留其中的文字内容，公式，图片，表格，引用和参考文献。

## TLDR

```bash
pandoc --filter pandoc-crossref --filter pandoc-citeproc --bibliography=ref.bib --csl chinese-gb7714-2005-numeric.csl -M pandoc-crossref.yaml -s main.tex -o main.docx
```

## 前言

在研究论文的写作中，需要将一个latex文件转化为word的时候，可能需要满足的转化后的要求包括：

* 文字内容
* 公式
* 图片和表格
* 交叉引用
* 参考文献引用
* 文献引用格式
* Word格式

### 文字内容，公式，图片，表格

```bash
pandoc mydoc.tex -o mydoc.docx
```

### 交叉引用

```bash
pandoc --filter pandoc-crossref mydoc.tex -o mydoc.docx
```

Currently, there is no good way to right numbering the equations in MS Word using Equation Editor, the common way is to create a three-column table, to put the equation in the center column and the equation number in the right column. If we have a lot of equations, which is typically true in a lot of academic publications, it is very time-consuming to edit the numbering of equations.

### 参考文献引用

```bash
pandoc --filter pandoc-crossref --filter pandoc-citeproc 
--bibliography=ref.bib mydoc.tex -o mydoc.docx
```

### 文献引用格式

```bash
pandoc --filter pandoc-crossref --filter pandoc-citeproc --bibliography=ref.bib 
--csl ieee.csl mydoc.tex -o mydoc.docx
```

### Word格式

```bash
pandoc --filter pandoc-crossref --filter pandoc-citeproc --bibliography=ref.bib 
--csl ieee.csl --reference-docx=IEEE_template.doc mydoc.tex -o mydoc.docx
```

### Pandoc 自定义设置

如果需要修改转化时候的Metadata，比如将图片的caption由``figure 1``变为``图 1``，你需要修改pandoc配置文件，参考：

<http://lierdakil.github.io/pandoc-crossref/#settings-file>

```bash
pandoc --filter pandoc-crossref --filter pandoc-citeproc --bibliography=ref.bib 
--csl ieee.csl --reference-docx=IEEE_template.doc 
-M pandoc-crossref.yaml mydoc.tex -o mydoc.docx
```

## References

* [How to Convert from Latex to MS Word with ‘Pandoc’](https://medium.com/@zhelinchen91/how-to-convert-from-latex-to-ms-word-with-pandoc-f2045a762293)
* [使用 Pandoc Markdown 进行学术论文写作](http://www.zale.site/articles/2016/05/Academia-Writing-Using-Markdown-and-Pandoc.html)
* [pandoc-crossref documentation](http://lierdakil.github.io/pandoc-crossref/)
