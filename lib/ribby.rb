require "ribby/version"

module Ribby
  extend self

  def tokenize(chars)
    # Convert a string of characters into a list of tokens
    chars.gsub!('(', ' ( ')
    chars.gsub!(')', ' ) ')
    chars.split ' '
  end
end
