class Filter
  attr_reader :value

  def initialize(value)
    @value = value
  end
end

class PropertyNameFilter < Filter
  FIELD = 'propertyName'
end

class ChinryoFilter < Filter
  FIELD = 'chinryo'
end

class WarkMinutesFilter < Filter
  FIELD = 'wark_minutes'
end
