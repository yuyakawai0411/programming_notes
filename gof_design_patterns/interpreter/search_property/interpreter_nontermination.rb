class FilterCollectionBase
  class << self
    def self.operator
      raise NotImplementedError, "#{self.name} must implement the .operator class method"
    end
  end

  def initialize(expression1, expression2)
    @expression1 = expression1
    @expression2 = expression2
  end

  def convert_to_h
    {
      filter: [expression1, expression2].map(&:convert_to_h),
      operator: self.class.operator
    }
  end

  private

  attr_reader :expression1, :expression2
end

class AndFilterCollection < FilterCollectionBase
  OPERATOR = 'and'

  class << self
    def operator
      OPERATOR
    end
  end
end

class OrFilterCollection < FilterCollectionBase
  OPERATOR = 'or'

  class << self
    def operator
      OPERATOR
    end
  end
end
