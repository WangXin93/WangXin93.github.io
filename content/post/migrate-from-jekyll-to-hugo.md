---
title: "Migrate From Jekyll to Hugo"
date: 2022-12-22T20:03:45+08:00
draft: true
---

## why hugo

- speed
- crossplatform binary executable. I am bad at ruby
- themes

## use hugo command to migrate

```
mkdir migrate
hugo import jekyll prev-blog migrate
```

## grad a theme

```
git clone https://github.com/adityatelange/hugo-PaperMod themes/PaperMod --depth=1
```

## create a new branch

```
git checkout -b hugo
```

delete unnecessary things and move content from hugo directory to original directory