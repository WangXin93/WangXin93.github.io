---
layout: post
title:  "TensorFlow 对模型的save和restore操作"
date: 2018-03-30 22:48:13 +0800
categories: Python, Tensorflow
---

## 前言
使用Tensorflow的时候经常需要对训练好的模型参数进行save和restore，具体来说比如评估模型，再训练模型，迁移学习，风格转移这些应用都包括对于训练好的参数的再利用。所以这里一起讨论一下如何正确地save和restore模型吧。


## Save模型
```python
import tensorflow as tf

#Prepare to feed input, i.e. feed_dict and placeholders
w1 = tf.placeholder(tf.float32, name="w1")
w2 = tf.placeholder(tf.float32, name="w2")
b1= tf.Variable(2.0, name="bias")
feed_dict ={w1:4, w2:8}

#Define a test operation that we will restore
w3 = tf.add(w1,w2)
w4 = tf.multiply(w3,b1,name="op_to_restore")
sess = tf.Session()
sess.run(tf.global_variables_initializer())

#Create a saver object which will save all the variables
saver = tf.train.Saver()

#Run the operation by feeding input
print sess.run(w4,feed_dict)
#Prints 24 which is sum of (w1+w2)*b1

#Now, save the graph
saver.save(sess, 'my_saved_model',global_step=1000)
```
执行上面的代码，完成后可以在当前目录发现存储好的文件：
```
$ ls
checkpoint                              my_saved_model-1000.index
my_saved_model-1000.data-00000-of-00001 my_saved_model-1000.meta
```

## Restore模型
```
import tensorflow as tf

sess=tf.Session()
#First let's load meta graph and restore weights
saver = tf.train.import_meta_graph('/my_saved_model-1000.meta')
saver.restore(sess,tf.train.latest_checkpoint('./'))


# Access saved Variables directly
print(sess.run('bias:0'))
# This will print 2, which is the value of bias that we saved


# Now, let's access and create placeholders variables and
# create feed-dict to feed new data

graph = tf.get_default_graph()
w1 = graph.get_tensor_by_name("w1:0")
w2 = graph.get_tensor_by_name("w2:0")
feed_dict ={w1:13.0,w2:17.0}

#Now, access the op that you want to run.
op_to_restore = graph.get_tensor_by_name("op_to_restore:0")

print sess.run(op_to_restore,feed_dict)
#This will print 60 which is calculated
```

## 技巧
1. 命名存储目录为时间名
2. 每个model目录存放三个model文件
```python
saver = tf.train.Saver(tf.trainable_variables(), max_to_keep=3)
```
3. 寻找目录中的meta文件
```python
import glob
glob.glob('*.meta')
# ['my_saved_model-1000.meta']
```

## 参考链接
* [save-restore-tensorflow-models-quick-complete-tutorial](http://cv-tricks.com/tensorflow-tutorial/save-restore-tensorflow-models-quick-complete-tutorial/)
* [tensorflow-how-to-save-restore-a-model](https://stackoverflow.com/questions/33759623/tensorflow-how-to-save-restore-a-model)
