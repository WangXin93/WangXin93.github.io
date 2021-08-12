---
layout: post
title:  "Make和CMake的使用"
date: 2019-08-28 10:16:00 +0800
categories: Linux
toc: true
---

## Make

``make`` is an automation tools help you run and compile program more efficiently. ``make`` need a special file ``Makefile`` in your working directory, which defines a set of tasks for automation.

A basie example of make file is as following. You can use ``make`` command to print a 'hi' in the console.

```make
say_hi:
	echo "hi"
```

This example contains only one task, each task has a structure like:

```make
target: prerequisties
<TAB> recipe
```

> Remember to use tab instead of 4 spaces in ``Makefile``.

```make
target: prerequisties
<TAB> command1
<TAB> -commend1  # ignore errors
<TAB> @comand3  # suppress echoing
```

| Automatic Variable | Value                                  |
|--------------------|----------------------------------------|
| $@                 | target                                 |
| $<                 | first prerequisite                     |
| $?                 | all newer prerequisities               |
| $^                 | all prerequisities                     |
| $*                 | "%" matched item in the target pattern |


| Variable Expansion | Description         |
|--------------------|---------------------|
| foo1 := bar        | one-time expansion  |
| foo2 = bar         | recursive expansion |
| foo3 += bar        | append              |


Run ``make -p -f /dev/null`` to see automatic internal rules.

```make
# Usage:
# make        # compile all binary
# make clean  # remove ALL binaries and objects

.PHONY = all clean

CC = gcc                        # compiler to use

LINKERFLAG = -lm

SRCS := foo.c
BINS := foo

all: foo

foo: foo.o
        @echo "Checking.."
        gcc -lm foo.o -o foo

foo.o: foo.c
        @echo "Creating object.."
        gcc -c foo.c

clean:
        @echo "Cleaning up..."
        rm -rvf foo.o foo
```

### 参考资料
* [GNU manual make](https://www.gnu.org/software/make/manual/make.html)
* [Introduce make from debian reference](https://www.debian.org/doc/manuals/debian-reference/ch12.en.html#_make)
* [Using make and writing Makefiles](https://www.cs.swarthmore.edu/~newhall/unixhelp/howto_makefiles.html)
* [CMake](https://www.cs.swarthmore.edu/~adanner/tips/cmake.php)
* [What is phony in a makefile](https://stackoverflow.com/questions/2145590/what-is-the-purpose-of-phony-in-a-makefile)

## CMake

```cmake
cmake_minimum_required(VERSION 3.10)

# set the project name
project(Tutorial)

# add the executable
add_executable(Tutorial tutorial.cxx)
```

## 参考资料

* [Source code](https://github.com/Kitware/CMake/tree/master/Help/guide/tutorial)
* [CMake Tutorial](https://cmake.org/cmake/help/latest/guide/tutorial/index.html)
* [Learn Makefiles With the tastiest examples](https://makefiletutorial.com/)
