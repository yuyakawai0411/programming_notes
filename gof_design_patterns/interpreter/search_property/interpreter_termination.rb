class FilterBase
  IN_MATCHER = 'in'
  GTEQ_MATCHER = 'gteq'
  LTEQ_MATCHER = 'lteq'

  VALID_MATCHERS = [IN_MATCHER, GTEQ_MATCHER, LTEQ_MATCHER].freeze
  private_constant :VALID_MATCHERS

  def initialize(field, matcher, values)
    @field = field
    @matcher = matcher
    @values = values
  end

  def convert_to_h
    { "#{field}:#{matcher}": values }
  end

  private

  attr_reader :field
  attr_reader :matcher
  attr_reader :values
end

class PropertyNameFilter < FilterBase
  FIELD = 'propertyName'
  private_constant :FIELD

  MATCHER = 'in'
  private_constant :MATCHER

  class << self
    def build(property_name)
      new(
        FIELD,
        MATCHER,
        property_name
      )
    end
  end
end

class ChinryoFilter < FilterBase
  FIELD = 'chinryo'
  private_constant :FIELD

  VALID_MATCHERS = %w[gteq lteq].freeze
  private_constant :VALID_MATCHERS

  class << self
    def build(chinryo_amount, matcher)
      raise ArgumentError, 'matcher is invalid' unless VALID_MATCHERS.include?(matcher)

      new(
        FIELD,
        matcher,
        chinryo_amount
      )
    end
  end
end
