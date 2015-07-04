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
