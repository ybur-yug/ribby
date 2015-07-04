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

    it 'can create atoms from tokens' do
      # numbers should become numbers, everything else should become symbols
      val_1 = '0'
      val_2 = '0.0'
      val_3 = 'f'
      expect(Ribby.atom(val_1)).to eq 0
      expect(Ribby.atom(val_2)).to eq 0.0
      expect(Ribby.atom(val_3)).to eq :f
    end
  end
end
