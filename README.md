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

### Tokenize
Let's start with `tokenize`. I will begin by simply creating a gem to package all of this in, and we will start
simple but get gradually more complex.

`bundle gem ribby`

`cd ribby`

Now, with something this complex we'd just be masochists if we didn't write specs. 

>The Lispy tokens are parentheses, symbols, and numbers. There are many tools for lexical analysis (such as Mike Lesk and Eric Schmidt's lex), but we'll use a very simple tool: Python's str.split. The function tokenize takes as input a string of characters; it adds spaces around each paren, and then calls str.split to get a list of tokens:

This is how Norvig went about the implementation in python and it translates to Ruby quite well. We can write a basic
failing spec as follows:

```ruby
require 'spec_helper'

describe Ribby do
  it 'has a version number' do
    expect(Ribby::VERSION).not_to be nil
  end

  context "on input" do
    it 'can tokenize input' do
      input = "(+ 2 3 4)"
      expect(Ribby.tokenize(input)).to eq ["(", "+", "2", "3", "4", ")"]
    end
  end
end
```

This will obviously fail, as expected since we haven't written any non-spec code. However, it is not too crazy.
Now, I know immutability is awesome and stuff. But we're gonna start simple here to fulfill this spec's needs:

```ruby
module Ribby
  extend self

  def tokenize(chars)
    # Convert a string of characters into a list of tokens
    chars.gsub!('(', ' ( ')
    chars.gsub!(')', ' ) ')
    chars.split ' '
  end
end
```

Here, we do a few things:

- extend `self` so we can call it easily from the `Ribby` module
- substitute all `(` and `)` to have leading/trailing spaces
- split on those spaces

Simple enough!

### To be continued

