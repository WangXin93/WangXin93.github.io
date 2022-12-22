---
date: "2020-05-01T00:00:00Z"
draft: true
link: https://tex.stackexchange.com/questions/268196/how-to-convert-latex-to-word-using-pandoc-and-keep-citations-as-numeral
title: Convert LaTeX to Word with pandoc
---

## Convert LaTeX to word with pandoc

Keep the math, keep the citation, follow a word template like IEEE_template.docx.

```
brew install pandoc
brew install pandoc-citeproc
```

```
pandoc -s haha.tex --bibliography=haha.bib --csl=ieee.csl --reference-doc=conference-template-letter.docx -o haha.docx
```

## Reference

* [bibliographies - How to convert LaTex to word using PanDoc and keep citations as numeral - TeX - LaTeX Stack Exchange](https://tex.stackexchange.com/questions/268196/how-to-convert-latex-to-word-using-pandoc-and-keep-citations-as-numeral)

* [How to Convert from Latex to MS Word with ‘Pandoc’](https://medium.com/@zhelinchen91/how-to-convert-from-latex-to-ms-word-with-pandoc-f2045a762293)