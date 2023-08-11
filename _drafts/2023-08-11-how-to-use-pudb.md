---
layout: post
title: "How to Use pudb to debug python visually"
date: 2023-08-11 21:41
---

> Pudb Provides a graphical interface in terminal during debugging the python code. This interface has a panel to show code around breakpoints, a panel for watching variables, a panel for stack trace, a panel for breakpoints, and a panel for command line. It is very convenient for debugging python code. This blog will show how to use pudb to debug python code with example.

## Install pudb

```bash
pip install pudb
```

## Run pudb

```bash
python -m pudb.run binary_search.py
```

## Reference

* [Introduction to the PuDB Python Debugging Tool](https://heather.cs.ucdavis.edu/~matloff/pudb.html)