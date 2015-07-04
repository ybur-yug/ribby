require "ribby/version"

module Ribby
  extend self

  def tokenize(chars)
    # Convert a string of characters into a list of tokens
    chars.gsub!('(', ' ( ')
    chars.gsub!(')', ' ) ')
    chars.split ' '
  end

  def atom(token)
    # numbers become numbers. all else becomes a symbol
    begin
      check_zero_int(token)
    rescue ValueError
      begin
        check_zero_float(token)
      rescue ValueError
        token.to_sym
      end
    end
  end

  # these will later become monkeypatches
  class ValueError < StandardError; end
  def check_zero_int(num)
    if num == '0' || num == 0
      num.to_i
    else
      raise ValueError
    end
  end

  def check_zero_float(num)
    if num == '0.0' || num == 0.0
      num.to_f
    else
      raise ValueError
    end
  end
end
