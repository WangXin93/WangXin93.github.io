---
layout: post
title:  "推荐系统"
date:   2018-03-10 22:04:11 +0800
categories: Python
toc: true
---

## 前言

* **Content-based recommender systems** focus on the attributes of the items and give you recommendations based on the similarity between them.
* **Collaborative filtering** produces recommendations based on the knowledge of users’ attitude to items, that is it uses the "wisdom of the crowd" to recommend items. CF can be divided into **Memory-Based Collaborative Filtering** and **Model-Based Collaborative filtering**. 

* **Memory-based models** are based on similarity between items or users, where we use cosine-similarity.
* **Model-based CF** is based on matrix factorization where we use SVD to factorize the matrix.
* Models that use both ratings and content features are called **Hybrid Recommender Systems** where both Collaborative Filtering and Content-based Models are combined. Hybrid recommender systems usually show higher accuracy than Collaborative Filtering or Content-based Models on their own: they are capable to address the cold-start problem better since if you don't have any ratings for a user or an item you could use the metadata from the user or item to make a prediction. 

