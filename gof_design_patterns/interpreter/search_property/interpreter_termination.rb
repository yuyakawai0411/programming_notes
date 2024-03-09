class FilterBase
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

class ChinryoLtepFilter < FilterBase
  FIELD = 'chinryo'
  private_constant :FIELD

  MATCHER = 'ltep'
  private_constant :MATCHER

  class << self
    def build(amount)
      new(
        FIELD,
        MATCHER,
        amount
      )
    end
  end
end

class WarkMinutesLtep < FilterBase
  FIELD = 'wark_minutes'
  private_constant :FIELD

  MATCHER = 'ltep'
  private_constant :MATCHER

  class << self
    def build(minutes)
      new(
        FIELD,
        MATCHER,
        minutes
      )
    end
  end
end
