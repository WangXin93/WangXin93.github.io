---
categories: TensorFlow
date: "2019-01-09T00:00:00Z"
draft: true
title: What is TFRecords？
toc: true
---

## 前言

TFRecords是 TensorFlow子集的binary storage format。

如果你正在一个很大的数据集上工作，使用一个binary file来存储data对于提升数据导入的pipeline的性能有很大作用，结果就是训练时间的减少。Binary data占据更少的磁盘空间，copy的时间更少，并且读起来更高效，这个差距在机械硬盘上体现的更明显，因为机械硬盘比SSD读写的速度慢很多。

另外，不光是性能上的优势，TFRecords在多个方面被优化以用于Tensorflow。首先，它非常方便联合多个datasets并且和libarary中提供的预处理方法无缝连接。尤其在datasets太大的时候，这个优势体现在只有当前的data（比如batch）需要load和process。另一个主要优势是TFRecords在存储序列数据（比如时间序列，单词序列）的时候非常高效和方便导入。查看(Reading Data)(https://www.tensorflow.org/api_guides/python/reading_data)来查看更多如何读取TFRecord files。

当然它很不便的地方就是必须要把数据转化为TFRecords格式。[官方文档](https://github.com/tensorflow/tensorflow/blob/master/tensorflow/examples/how_tos/reading_data/convert_to_records.py)给出了例子，但是在实际使用时候仍然只能看到表面。

## Convert to TFRecord

<div align="center" style="width:80%">
<img height="20%" width="20%" src="https://i.imgur.com/3FJgAKN.jpg"/>
<img height="20%" width="20%" src="https://i.imgur.com/gBdL5Uk.jpg"/>
<img height="20%" width="20%" src="https://i.imgur.com/smSVbtm.jpg"/>
<img height="20%" width="20%" src="https://i.imgur.com/IEp3RlQ.jpg"/>
</div>

将上面面四张图片存入本地，然后在相同目录下新建一个文件`convert.py`粘贴下面的内容，就可以将图片转为`samples.tfrecord`。

```python
import tensorflow as tf
import os
import numpy as np
from PIL import Image
import glob

def _bytes_feature(value):
    return tf.train.Feature(bytes_list=tf.train.BytesList(value=[value]))

def _int64_feature(value):
    return tf.train.Feature(int64_list=tf.train.Int64List(value=[value]))

filename = "samples.tfrecords"
print("Writing", filename)

img_paths = glob.glob("*.jpg")
                            
with tf.python_io.TFRecordWriter(filename) as writer:
    for img_path in img_paths:
        print(img_path)
        img = np.array(Image.open(img_path))
        height, width = img.shape[0], img.shape[1]
        img_raw = img.tostring()
        example = tf.train.Example(
            features = tf.train.Features(
                feature = {
                    'img_raw': _bytes_feature(img_raw),
                    'width': _int64_feature(width),
                    'height': _int64_feature(height),
                    'label': _int64_feature(1)
                }
            )
        )
        writer.write(example.SerializeToString())
```

官方文档中对于`tf.train.Example`的描述并不充分。这是由于`tf.train.Example`不是一个Python class，而是一个[protocol buffer](https://en.wikipedia.org/wiki/Protocol_Buffers)。Protocol buffer是Google开发的序列化结构数据的方法。TFRecords有两类主要结构`tf.train.Example`和[`tf.train.SequenceExample`](https://medium.com/mostly-ai/tensorflow-records-what-they-are-and-how-to-use-them-c46bc4bbb564)。这里只用到了前者。 因为`tf.train.Example`适合**每个特征都有相同的类型的时候，比如所有年龄都用一个整型表示**。

上面的代码，为每个样本，也就是每个图片定一个四个feature（img_raw, width, height, label)，每一个feature都用`tf.train.Feature`来表示，包装好同类型的list of data。

`tf.train.Feature`的核心是`tf.train.BytesList`, `tf.train.FloatList`, `tf.train.Int64List`，这三者在创建的时候分别需要赋值一个包含bytes, float, int数据的list作为value。

多个Feature组成`tf.train.Features`。它在创建的时候只有一个关键字`feature=`，需要输入一个字典，key是feature的名字，value是`tf.train.Feature`。

最后，Features会被包装进`tf.train.Example`，然后`tf.python_io.TFRecordWriter`会将序列化后的`tf.train.Example`写入磁盘。和file handler一样，`tf.python_io.TFRecordWriter`包含write，flush，close方法，这是使用with语句来保证写入完成后关闭writer。

## Read TFRecord

实际使用中经常会看到两类方法来读取TFRecord, 一类使用[Threading and Queues](https://github.com/tensorflow/docs/blob/master/site/en/api_guides/python/threading_and_queues.md)，另一类使用[`tf.data` API](https://www.tensorflow.org/guide/datasets)。实际上在tensorflow1.2之前，推荐使用多线程队列的方法，而在tensorflow1.4之后，这个老旧的方法逐渐被抛弃，`tf.data`的接口更加简单，使得数据输入的pipeline的构建更加容易。

这里对两种方法都会给出例子：

### Using tf.data API

```python
import tensorflow as tf
import numpy as np
import os

filename = "samples.tfrecords"
IMG_HEIGHT = 224
IMG_WIDTH = 224
BATCH_SIZE = 2
NUM_EPOCHS = 2

def decode(serialized_example):
    features = tf.parse_single_example(
        serialized_example,
        features={
            'img_raw': tf.FixedLenFeature([], tf.string),
            'width': tf.FixedLenFeature([], tf.int64),
            'height': tf.FixedLenFeature([], tf.int64),
            'label': tf.FixedLenFeature([], tf.int64)
        }
    )
    image = tf.decode_raw(features['img_raw'], tf.uint8)
    label = tf.cast(features['label'], tf.int32)
    height, width = features['height'], features['width']
    image = tf.reshape(image, [height, width, 3])
    return image, label

def resize(image, label):
    resized_img = tf.image.resize_image_with_crop_or_pad(
        image=image,
        target_height=IMG_HEIGHT,
        target_width=IMG_WIDTH
    )
    return resized_img, label

def inputs(batch_size, num_epochs):
    with tf.name_scope("input"):
        dataset  = tf.data.TFRecordDataset(filename)
        dataset = dataset.map(decode)
        dataset = dataset.map(resize)
        dataset = dataset.repeat(num_epochs)
        dataset = dataset.batch(batch_size)
        iterator = dataset.make_one_shot_iterator()
    return iterator.get_next()

def run():
    with tf.Graph().as_default():
        image_batch, label_batch = inputs(BATCH_SIZE, NUM_EPOCHS)
        with tf.Session() as sess:
            try:
                while True:
                    images, labels = sess.run([image_batch, label_batch])
                    print(images.shape, labels)
            except tf.errors.OutOfRangeError:
                print("done.")

if __name__ == "__main__":
    run()
```

官方文档中的[Importing Data](https://www.tensorflow.org/guide/datasets)章节对于`Dataset`这个类如何使用给出了详细描述。

### Using Queue

```python
import tensorflow as tf


filename = 'samples.tfrecords'

def read_and_decode(filename_queue):
    reader = tf.TFRecordReader()

    _, serialized_example = reader.read(filename_queue)

    feature = {
        'img_raw':tf.FixedLenFeature([], tf.string),
        'width':tf.FixedLenFeature([], tf.int64),
        'height': tf.FixedLenFeature([], tf.int64),
        'label': tf.FixedLenFeature([], tf.int64)
    }
    features = tf.parse_single_example(serialized_example, features=feature)

    image = tf.decode_raw(features['img_raw'], tf.uint8)
    height = tf.cast(features['height'], tf.int32)
    width = tf.cast(features['width'], tf.int32)
    image = tf.reshape(image, tf.stack([height, width, 3]))
    resized_image = tf.image.resize_image_with_crop_or_pad(image=image, target_height=224, target_width=224)
    label = tf.cast(features['label'], tf.int32)

    images, labels = tf.train.shuffle_batch([resized_image, label], batch_size=2, capacity=30, num_threads=2, min_after_dequeue=10)
    return images, labels

if __name__ == "__main__":
    filename_queue = tf.train.string_input_producer([filename], num_epochs=2)
    _, labels = read_and_decode(filename_queue)
    init_op = tf.group([tf.global_variables_initializer(), tf.local_variables_initializer()])
    with tf.Session() as sess:
        sess.run(init_op)
        coord = tf.train.Coordinator()
        threads = tf.train.start_queue_runners(coord=coord)

        try:
            while True:
                lbl = sess.run([labels])
                print(lbl)
        except tf.errors.OutOfRangeError as e:
            coord.request_stop(e)
        coord.request_stop(e)
        coord.join(threads)
```

[这里](http://wiki.jikexueyuan.com/project/tensorflow-zh/how_tos/threading_and_queues.html)对于多线程和队列的用法给出了详细描述。


## 参考
* [Tensorflow Records? What they are and how to use them](https://medium.com/mostly-ai/tensorflow-records-what-they-are-and-how-to-use-them-c46bc4bbb564)
* [How to write and read from TFRecords file in TensorFlow](http://machinelearninguru.com/deep_learning/data_preparation/tfrecord/tfrecord.html)
* [TFRecords Guide](http://warmspringwinds.github.io/tensorflow/tf-slim/2016/12/21/tfrecords-guide/)
* [Official convert_to_records.py](https://github.com/tensorflow/tensorflow/blob/master/tensorflow/examples/how_tos/reading_data/convert_to_records.py)
* [Official fully_connected_reader.py](https://github.com/tensorflow/tensorflow/blob/master/tensorflow/examples/how_tos/reading_data/fully_connected_reader.py)
* [TensorFlow document: Importing Data]()
* [tensorflow读取tfrecord格式数据](https://www.jianshu.com/p/78467f297ab5)
* [Tensorflow中创建自己的TFRecord格式数据集](https://blog.csdn.net/sinat_34474705/article/details/78966064)