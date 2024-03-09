require 'bundler/inline'

gemfile do
  source 'https://rubygems.org'
  gem 'pry'
end

require_relative 'interpreter_nontermination'
require_relative 'interpreter_termination'

class Parser
  def initialize(text)
    @tokens = text.scan(/\(|\)|\w+/)
  end

  def puts_tokens
    @tokens
  end

  def next_token
    @tokens.shift
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
      PropertyNameFilter.build(next_token.to_s)
    when 'chinryo_ltep'
      ChinryoLtepFilter.build(next_token.to_i)
    when 'wark_minutes_ltep'
      WarkMinutesLtep.build(next_token.to_i)
    when 'and'
      AndFilterCollection.new(expression, expression)
    when 'or'
      OrFilterCollection.new(expression, expression)
    else
      raise "Unexpected token: #{token}"
    end
  end
end
params = { q: "and (property_name=test) (or (chinryo_ltep=500000) (wark_minutes_ltep=0))" }
expression = Parser.new(params[:q]).expression
