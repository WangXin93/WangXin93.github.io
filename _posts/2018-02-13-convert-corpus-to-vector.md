---
layout: post
title:  "NLP Convert Corpus to Vector Format"
date:   2018-02-13 19:43:02 +0800
categories: Python, NLP
toc: true
---

## 前言
分类算法大多需要特征向量作为输入，然后才能完成分类任务。将corpus转化为向量vector的形式有很多，最简单的方法是[bag-of-words](https://en.wikipedia.org/wiki/Bag-of-words_model),它的主要思想是文本中的每一个单独的词都会被表示为一个数字，一个文本会被转化为它的单词的多元集合，或者说词袋，而文本中的语法，单词顺序将会被忽略。

## 准备工作
作为实例演示使用的数据集为[UCI datasets](https://archive.ics.uci.edu/ml/datasets/SMS+Spam+Collection),该数据集包含超过5000条电话短信，同时标注有它们是否为垃圾短信。在下面的内容之前，先确保成功读取数据。由于该数据集为[TSV](https://en.wikipedia.org/wiki/Tab-separated_values)格式，因此通过下面方法可以读取：
```python
messages = pd.read_csv('SMSSpamCollection',
                       sep='\t',
                       names=['label','message'])
messages.head()
# See head like this
"""
  label                                            message
0   ham  Go until jurong point, crazy.. Available only ...
1   ham                      Ok lar... Joking wif u oni...
2  spam  Free entry in 2 a wkly comp to win FA Cup fina...
3   ham  U dun say so early hor... U c already then say...
4   ham  Nah I don't think he goes to usf, he lives aro...
"""
```
## 文本预处理
在使用词袋模型之前，还有一步准备工作要做，那就是去除停顿词和标点符号。什么是停顿词和标点符合呢？与其解释它们不如直接看一下它们的内容：
```python
import string
print(string.punctuation)
# Get this !"#$%&'()*+,-./:;<=>?@[\]^_`{|}~i
# Print stop words
import nltk
nltk.download('stopwords') # Return True if succeed to download
from nltk.corpus import stopwords
print(stopwords.words('english')[:10])
# You get these:
# ['i', 'me', 'my', 'myself', 'we', 'our', 'ours', 'ourselves', 'you', "you're"]
```
可以看见停顿词都是一些经常使用但是却对文本内容没有很大影响的词。去除标点符号和停顿词，保留的是文本中体现内容的词。具体方法可以是这样：
```python
def text_process(mess):
    """Remove stopwords and punctuation in text

    1. Remove all punctuations
    2. Remove all stopwords
    3. Split a list of the cleaned text

    Args:
        mess: string, text content
    Return:
        processed: list of words
    """
    out = []
    nopunc = [char for char in mess if char not in string.punctuation]
    nopunc = ''.join(nopunc)
    for word in nopunc.split():
        if word.lower() not in stopwords.words('english'):
            out.append(word)
    return out

# Apply text process to messages
In [30]: messages['message'].head().apply(text_process)
Out[30]: 
0    [Go, jurong, point, crazy, Available, bugis, n...
1                       [Ok, lar, Joking, wif, u, oni]
2    [Free, entry, 2, wkly, comp, win, FA, Cup, fin...
3        [U, dun, say, early, hor, U, c, already, say]
4    [Nah, dont, think, goes, usf, lives, around, t...
Name: message, dtype: object
```
现在，一条文本可以被`text_process`函数转化为一个单词组成的`list`，这些单词又称为`tokens`，或者[`lemmas`](nlp.stanford.edu/IR-book/html/htmledition/stemming-and-lemmatization-1.html)。接着，这一串tokens将通过`bag-of-words`模型转化为向量。

## Bag-of-words
`Bag-of-words`可以由`tokens`组成的list转化为机器学习模型能够理解的向量`vector`。使用`scikit-learn`执行`bag-of-words`的方法非常简单，使用`CountVectorizer`函数可以将文本转化为一个存储着每条信息每个`token`数量的矩阵。
```python
In [31]: from sklearn.feature_extraction.text import CountVectorizer
In [32]: bow_transformer = CountVectorizer(analyzer=text_process).fit(messages['message'])
In [33]: messages_bow = bow_transformer.transform(messages['message'])
In [34]: print(messages_bow[0])
    (0, 1110)   1
    (0, 1483)   1
    (0, 2060)   1
    (0, 4653)   1
    (0, 5217)   1
    (0, 5218)   1
    (0, 5769)   1
    (0, 6217)   1
    (0, 6906)   1
    (0, 6937)   1
    (0, 7555)   1
    (0, 7668)   1
    (0, 8336)   1
    (0, 8917)   1
    (0, 10965)  1
    (0, 11163)  1
```
这些`(0, 1110)`,`(0, 1483)`是什么？想象一个这样的矩阵：

|CountVectorizer|Message1|Message2|...|MessageN|
|:---:|:---:|:---:|:---:|:---:|
|Word 1 Count|0|1|...|0|
|Word 2 Count|0|0|...|0|
|...|1|2|...|0|
|Word N Count|0|1|...|1|

在这个矩阵中，每一列代表着一条信息，而每一列中的每一行代表某个单词出现的次数。比如`Message2`中`Word 1`出现的次数是1,而`Word 2`出现的次数为0。`messages_bow[0]`中存储的正是第1条信息中那些出现的单词和数量。

为什么不存储整个矩阵呢？可以发现这个矩阵的行数非常大，使用`print(len(bow_transformer.vocaublary_))`可以知道共有11425种单词，而每条信息中包含的单词数量相对于这个数字是非常小的。因此，该矩阵中有大量元素为0，被称为[Sparse Matrix](https://en.wikipedia.org/wiki/Sparse_matrix)。因此`scikit learn`会以更加高效的方式记录这个矩阵，比如记录非零元素，从而避免记录大量的0值浪费内存。

## TF-IDF
`Bag-of-words`模型包含三个步骤：
- 计数每条信息中每个单词出现的次数（称为term frequency）
- 对计数进行权重计算，它的意思是频繁出现的tokens会被分配较低的权重（inverse document frequency）
- 将向量进行正则化到单位长度（L2 norm）

至今所做的工作只是第一步，之后的步骤二和三，权重分配和正则化可以通过[TF-IDF](https://en.wikipedia.org/wiki/Tf%E2%80%93idf)来实现，`scikit learn`的函数`TfidfTransformer`可以帮助该过程：
```python
In [42]: from sklearn.feature_extraction.text import TfidfTransformer
In [44]: tfidf_transformer = TfidfTransformer().fit(messages_bow)
In [45]: messages_tfidf = tfidf_transformer.transform(messages_bow)
In [47]: print(messages_tfidf[0])
    (0, 11163)  0.23026685592418913
    (0, 10965)  0.19073428545061483
    (0, 8917)   0.24704652376837993
    (0, 8336)   0.17046869292195632
    (0, 7668)   0.26403384065473806
    (0, 7555)   0.31253856260694546
    (0, 6937)   0.1834692413608692
    (0, 6906)   0.15158474664662352
    (0, 6217)   0.18915557732842803
    (0, 5769)   0.24984711892976424
    (0, 5218)   0.26870593862526665
    (0, 5217)   0.29835184088197164
    (0, 4653)   0.31253856260694546
    (0, 2060)   0.24203960256420656
    (0, 1483)   0.31253856260694546
    (0, 1110)   0.2882862016308418
```
什么是TF-IDF?

TF-IDF的意思是*term frequency-inverse document frequency*，tf-idf权重是信息搜索和文本挖掘中常用的权重。这个权重是在一个corpus中一个单词对一个文档的重要性的统计描述。这个重要性会随着文档中这个词出现次数的变多而增大，而会因为这个词在整个corpus中出现的次数变多而减少。tf-idf的权重的变体是搜索引擎中按文档评分和相关性进行排序检索的重要工具。最简单的搜索打分函数方法是：根据将文档中搜索词的tf-idf权重相加，很多复杂的打分函数都是这个简单模型的变体。

tf-idf的数学定义可以如下表示：

$$
W_{x,y} = tf_{x,y} \times log(\frac{N}{df_x})
$$

这里tf_{x,y}是单词x在文档y中出现的频率，反映一个单词在文档中的重要。对数部分是Inverse Document Frequency，反映一个单词在corpus中的重要性。其中df_x是包含单词x的文档的数目，N是所有文档的总数目。

举个例子：假定一个文档包含100个单词而cat这个词出现了3次。所以cat这个词的term frequency(tf)值为(3/100)=0.03。现在，如果有10,000,000份文档，而出现cat这个词的文档有1000份，所以cat这个词的inverse document frequency(idf)值为log(10,000,000/1,000)=4，所以最终的tf-idf权重为0.03×4=0.12。

## Training a model
现在，每条消息文本都被转化为了一个向量，因此可以作为几乎任何机器学习算法的输入。但是由于一些[原因](www.inf.ed.ac.uk/teaching/courses/inf2b/learnnotes/inf2b-learn-note07-2up.pdf)，[Naive Bayes](http://en.wikipedia.org/wiki/Naive_Bayes_classifier)是很好的选择。通过`scikit learn`的实现方法如下：
```python
from sklearn.naive_bayes import MultinomialNB
from sklearn.model_selection import train_test_split
from sklearn.metrics import classification_report

X_train, X_test, y_train, y_test = train_test_split(
            messages_tfidf, messages['label'], test_size=0.2)
spam_detect_model = MultinomialNB()
spam_detect_model.fit(X_train, y_train)
pred = spam_detect_model.predict(X_test)
print(classification_report(y_test, pred))
"""
               precision    recall  f1-score   support

        ham         0.96      1.00      0.98       967
       spam         1.00      0.70      0.83       148

avg / total         0.96      0.96      0.96      1115
"""
```
## 更多NLP学习资源
[NLTK Book Online](http://www.nltk.org/book/)

[Kaggle Walkthrough](https://www.kaggle.com/c/word2vec-nlp-tutorial/details/part-1-for-beginners-bag-of-words)

[SciKit Learn's Tutorial](http://scikit-learn.org/stable/tutorial/text_analytics/working_with_text_data.html)
