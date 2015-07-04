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

### Atoms - Not the Periodic Kind
![RIP](http://i.imgur.com/vzmFTqX.png)

We are going to embody this principle here. Since we are beginning with an implementation that is largely calculator
functions, we will need to convert anything that is not a number to a symbol. Now, Python handles this a bit differently
than Ruby. In Ruby, if we coerce random things to ints or floats, we get...well. Let's see:

```ruby
2.2.1 :001 > 1.to_f
 => 1.0 
2.2.1 :002 > 1.0.to_i
 => 1 
2.2.1 :003 > 'i fear weasels'.to_f
 => 0.0 
2.2.1 :004 > 'i fear weasels'.to_i
 => 0 
```

I will not speak on whether or not I believe this is reasonable in any way. But nonetheless we have to deal with it.
In Norvig's original piece he wrote this function for atom's:

```python
def atom(token):
    "Numbers become numbers; every other token is a symbol."
    try: return int(token)
    except ValueError:
        try: return float(token)
        except ValueError:
            return Symbol(token)
```

`ValueError` is not an exception we have, and if we get no exceptions if we coerce nonsense to numbers. So, let's get
half of our ass and work around this. But first we should write a test since we know our end-goal.

```ruby
    it 'can create atoms from tokens' do
      expect(Ribby.atom('0')).to eq 0
      expect(Ribby.atom('0.0')).to eq 0.0
      expect(Ribby.atom('f')).to eq :f
    end
```

I don't generally like multiple expects, but remember, we're working with half an ass here. Now, how to define this?

```ruby
  def atom(token)
    # numbers become numbers. all else becomes a symbol
    begin # start checking for integers
      check_zero_int(token)
    rescue ValueError # WOOPS not an int
      begin
        check_zero_float(token) # maybe a float?
      rescue ValueError # NOPE, fuck it lets make a symbol
        token.to_sym
      end
    end
  end

  class ValueError < StandardError; end # could just raise Exception but this is easy and a tad less horrible
  def check_zero_int(num)
    if num == '0' # these first blocks allow us to have 0. This is important in a calculator.
      num.to_i
    else
      raise ValueError
    end
  end

  def check_zero_float(num)
    if num == '0.0' # see above
      num.to_f
    else
      raise ValueError
    end
  end
```

And now, our specs can pass. The alternative here would be monkeypatching the core `Float` and `Integer` classes, but
I really dont like that idea for something as toy-ish as a LISP calculator.

### To be continued.
