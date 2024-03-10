require 'bundler/inline'

gemfile do
  source 'https://rubygems.org'
  gem 'pry'
end

require_relative 'interpreter_nontermination'
require_relative 'interpreter_termination'

class QueryParser
  attr_reader :tokens

  def initialize(text)
    @tokens = text.scan(/\(|\)|\w+/)
  end

  def next_token
    tokens.shift
  end

  def expression
    token = next_token

    case token
    when nil
      nil
    when '('
      result = expression
      raise 'Expected )' if next_token != ')'
      result
    when 'property_name'
      PropertyNameFilter.new(next_token.to_s)
    when 'chinryo'
      ChinryoFilter.new(next_token.to_i)
    when 'wark_minutes'
      WarkMinutesFilter.new(next_token.to_i)
    when 'and'
      AndOperator.new(expression, expression)
    when 'or'
      OrOperator.new(expression, expression)
    when 'in'
      InMatcher.new(expression)
    when 'gteq'
      GteqMatcher.new(expression)
    else
      raise "Unexpected token: #{token}"
    end
  end
end
params = { q: "and (in(property_name=test)) (or (gteq(chinryo=500000)) (gteq(wark_minutes=5)))" }
expression = QueryParser.new(params[:q]).expression
binding.pry