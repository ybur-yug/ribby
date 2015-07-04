# Ribby

## Introduction
I enjoy Lisp and reading about it. [Peter Norvig](link) has a wonderful tutorial on writing a LISP interpreter in
Python. I decided I would redo it in Ruby for no particular reason other than I don't have many plans for this 4th
of July weekend.

## Getting Started

From the original [article](link):

> Language 1: Lispy Calculator
> Step one is to define a language I call Lispy Calculator that is a subset of Scheme using only three of the six special forms. Lispy Calculator lets you do any computation you could do on a typical calculator—as long as you are comfortable with prefix notation. And you can do some things that are not offered in typical calculator languages: "if" expressions, and the definition of new variables, for example. Here is a table of all the allowable expressions in the Lispy Calculator language: 

To do these things. We will need a parser. From the basics he outlines, we will need several pieces:

- variable reference
- constant literal
- quotation
- conditional
- definition
- procedure call

This will take a bit to get to. But we can start with a few simple pieces. We need to be able to `parse`, `tokenize`, and
`read_from_tokens`.

