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

## Migrate other features

- [ ] fix image link: plan to put post and image in the same directory
- [ ] draft post: use `draft` post variable to hide some draft posts
- [ ] fix tag: use `-` for space between words in a tag, for example `deep-learning`
- [ ] home page: drop previous home page
- [ ] image gallery: use <https://www.liwen.id.au/heg/> to add gallery in blog
- [ ] agolia search: It may not be used, because papermod use `fuse.js`
- [ ] email subscription
- [ ] comments
- [ ] toc: use `ShowToc: true` post variable to generate table of contents for each post