---
categories: Python Excel
date: "2021-06-02T13:28:17Z"
title: 使用Python自动化操作Excel文档
toc: true
---

> Excel 是日常生活中最普遍易用的数据存储软件，在很多情况下你只能发现被存储为 Excel 格式的数据文件，因此数据分析不能忽略对于 Excel 文件的读取和分析处理。Python 有多个库来帮助处理 Excel 数据，从而减少办公中的重复劳动，这些库包括 pandas，openpyxl，xlwings，每个库都有不同的擅长。本篇文章将会介绍如何使用他们来自动处理 Excel 数据。

## 前言

## pandas

### 读取文件

pandas 是一个用python编写的用于数据分析的第三方库，它提供了强大而又灵活的用于数据分析的数据结构和函数方法，只要将数据读取为 pandas 的 DataFrame 数据结构，它就可以和很多 pandas 自身的函数和其它库比如 sklearn 进行配合。pandas 提供了将 excel 文件读取为DataFrame的方法[read_excel](https://pandas.pydata.org/pandas-docs/stable/reference/api/pandas.read_excel.html)。如果是第一次运行这个函数，你可能会遇到错误，这是因为 pandas 还需要额外的 engine 来读取 excel 数据。可以使用 pip 来安装这些必要的 engine。其中``xlrd``可以打开 Excel 2003 （.xls）和 Excel 2007+（.xlsx）文件，openpyxl 只能打开 Excel 2007+ （.xlsx）的文件。

```
pip install pandas xlrd openpyxl
```

安装完成后，读取 excel 文件就可以用一行代码来完成。在这行代码中``sheet_name``参数可以用来指定 pandas 来读取 excel 文件中的哪一个 sheet，它可以是一个数字，一个字符串，或者一个list，如果 ``sheet_name`` 为一个列表，那么返回的值会是一个字典，其中字典的 key 为 sheet 的名字，value 为对应的数据。如果``sheet_name=None``，那么这时会返回全部的 sheet。

```python
df = pd.read_excel('path_to_excel_file', sheet_name='sheet1')
```

但是这样得到的 DataFrame 会由于 excel 文件头部的不同表头而出现混乱，为了解决这个问题，你需要告诉 pandas 应该将哪一行作为表头，以及读取到哪一行为止，这个可以通过设置 ``header`` 和 ``skipfooter`` 两个参数来实现，如果表头超过一行，可以给``header``设置一个列表，比如``header=[1,2]``。

```python
df = pd.read_excel('path_to_excel_file', sheet_name='sheet1', header=2, skipfooter=3)
```

另一种读取excel文件的方法是使用``ExcelFile``对象。你可以使用``pd.ExcelFile('excel_file_path')``来构建对象，构建完成后的对象包含``.sheet_name``属性，这对应着原来excel文件中的不同sheet。可以使用``ExcelFile``中的``.parse()``方法来解析sheet然后得到返回的DataFrame。读取完成后的``ExcelFile``对象需要即使关闭，因此可以使用``with``语句在读取完成后关闭对象。总结来说，使用``ExcelFile``对象来读取excel文件可以使用类似下面结构的代码：

```python
df_dict{}
with pd.ExcelFile('excel_file_path') as xlsx:
    for sheet_name in xlsx.sheet_names:
        df_dict[sheet_name] = xlsx.parse(sheet_name)
```

### 写入文件

和读取 excel 文件类似，pandas 在写入 excel 文件的时候会使用不同的 engine，其中 ``xlwt`` 只能适用于 Excel 2003（xls）文件，不能使用 append mode；``xlsxwriter`` 只能适用于 Excel 2007+（xlsx）文件，不能使用append mode，``openpyxl``只能适用于 Excel 2007+（xlsx）文件，支持append mode。你可以使用：

```
pip install xlwt xlsxwriter openpyxl
``

来安装这些engine。

将 DataFrame 写入 Excel 一种方法是使用``to_excel()``方法，你需要设置``index=False``来去掉DataFrame中的index显示在输出的 excel 文件中。

```python
df.to_excel('output.xlsx', sheet_name='sheet1', index=False)
```

另一种写入方法是使用 ``ExcelWriter`` 对象：

```python
with pd.ExcelWriter('output.xlsx') as writer:
    df.to_excel(writer, sheet_name='sheet1', index=False)
    df2.to_excel(writer, sheet_name='sheet2', index=False)
```

DataFrame 在写入到 excel 文件时候，如果其中存在公式，输出结果时候会得到公式计算后的结果。比如下面的例子：

```python
df = pd.DataFrame(data=[[1, 2, '=SUM(A2:B2)', [3, 4, '=SUM(A3:B3)'], [5, 6], '=SUM(A4:B4)']],
                  columns=['A', 'B', 'SUM'])
df.to_excel('output.xlsx', index=False)
```

## openpyxl

## xlwings

```
pip install xlwings
```

从github下载[xlwings插件](https://github.com/xlwings/xlwings/releases)并添加。

### Excel Addin

```
xlwings addin install
```

The xlwings add-in is the preferred way to be able to use the Run main button, RunPython or UDFs. Note that you don’t need an add-in if you just want to manipulate Excel by running a Python script.

The Run main button is the easiest way to run your Python code: It runs a function called main in a Python module that has the same name as your workbook. This allows you to save your workbook as xlsx without enabling macros. The xlwings quickstart command will create a workbook that will automatically work with the Run button.

### Automating Excel

```python
import xlwings as xw

wb = xw.Book() # 这会打开一个新的excel窗口
wb.save('test.xlsx') # 这会保存当前窗口的excel文件到test.xlsx
```

```python
wb.sheets[0]
print(wb.name)

wb.sheets.add('Sheet2')
wb.sheets.add('Sheet3', after=ws.sheets[0])
```

```python
ws.range('A1').value = 100
ws.range('A1:D20').value = 100


ws.clear_contents()

ws.cell(2, 3).value = 100
```

```python
ws.range('A1').options(transpose=True).value = [10, 20, 30]
# ws.range('A1').value = df

print(ws.range('A1').expand().values)
```

### Write a macro in Python and run in Excel

### Write a user-defined function in Python and call it within Excel

### Debugging

Two common errors you might experience as a beginner are:

Automation error 404. We talked about how to fix this error, make sure the Excel Macro setting is correct.
When you type the user defined function, “Object Require” shows up in the cell. Make sure xlwings is checked in VBA Editor -> Tools -> References, and the change is saved for the appropriate Excel file. Sometimes, when we have multiple Excel sheets open, we might end up applying this change to another file unintentionally.

## 结语

## 参考

* <https://zhuanlan.zhihu.com/p/82783751>
* <https://www.dataquest.io/blog/python-excel-xlwings-tutorial/>
* <https://towardsdatascience.com/how-to-work-with-excel-files-in-pandas-c584abb67bfb>
* <https://docs.xlwings.org/_/downloads/zh_CN/latest/pdf/>
