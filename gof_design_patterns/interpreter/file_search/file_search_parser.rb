require_relative 'file_search_ast'
require 'bundler/inline'

gemfile do
  source 'https://rubygems.org'
  gem 'pry-rails'
end

class Parser
  def initialize(text)
    # tokens Array
    @tokens = text.scan(/\(|\)|[\w\.\*]+/)
  end

  # @return [String]
  def next_token
    @tokens.shift
  end

  def expression
    token = next_token

    if token == nil
      return nil
    elsif token == '('
      result = expression
      result
    elsif token == 'all'
      return All.new
    elsif token == 'writable'
      return Writable.new
    elsif token == 'bigger'
      return Bigger.new(next_token.to_i)
    elsif token == 'filename'
      return FileName.new(next_token)
    elsif token == 'not'
      return Not.new(expression)
    elsif token == 'and'
      return And.new(expression, expression)
    elsif token == 'or'
      return Or.new(expression, expression)
    end
  end

  def puts_tokens
    puts @tokens.class
  end
end

parsed = Parser.new('and (and(bigger 1024)(filename *.rb)) writable').expression

