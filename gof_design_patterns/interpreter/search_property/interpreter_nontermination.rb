class Operator
  def initialize(expression1, expression2)
    @expression1 = expression1
    @expression2 = expression2
  end

  def to_query
    {
      filter: [expression1, expression2].map(&:to_query),
      operator: self.class::OPERATOR
    }
  end

  private

  attr_reader :expression1, :expression2
end

class AndOperator < Operator
  OPERATOR = 'and'
end

class OrOperator < Operator
  OPERATOR = 'or'
end

class Matcher
  def initialize(expression)
    @expression = expression
  end

  def to_query
    { "#{expression.class::FIELD}:#{self.class::MATCHER}" => expression.value }
  end

  private

  attr_reader :expression
end

class GteqMatcher < Matcher
  MATCHER = 'gteq'
end

class InMatcher < Matcher
  MATCHER = 'in'
end
