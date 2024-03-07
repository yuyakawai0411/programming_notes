# 物件名テスト & 賃料が5万円以下 & 駅から徒歩5分以内
# デメリット
# - 検索条件が増えるたびにパラメータが増る
# - 検索条件の追加が難しい(ex. not検索、or検索)
"?propertyName=テスト&chinryoMax=500000&chinryoMin=0&warkMinutesMax=5&warkMinutesMin=0"

# TODO: bkkの現状のfilterの実装を見て作ってみる

class PropertyName
  MATCH = "in"

  attr_reader :name

  def initialize(name)
    @name = name
  end

  def convert_to_h
    {
      "property:#{MATCH}" => name
    }
  end
end

class Chinryo
  LESS_MATCH = "le"
  GREATER_MATCH = "gr"

  attr_reader :max_amount, :min_amount

  def initialize(max_amount, min_amount)
    @max_amount = max_amount
    @min_amount = min_amount
  end

  def convert_to_h
    {
      "chinryo:#{LESS_MATCH}" => max_amount,
      "chinryo:#{GREATER_MATCH}" => min_amount
    }
  end
end

class WarkMinutes
  LESS_MATCH = "le"
  GREATER_MATCH = "gr"

  attr_reader :max_minutes, :min_minutes

  def initialize(max_minutes, min_minutes)
    @max_minutes = max_minutes
    @min_minutes = min_minutes
  end

  def convert_to_h
    {
      "warkMinutes:#{LESS_MATCH}" => max_minutes,
      "warkMinutes:#{GREATER_MATCH}" => min_minutes
    }
  end
end

class Filter
  class << self
    def search_property(params)
      snake_params = camel_to_snake(params)
      property_name = PropertyName.new(snake_params[:property_name])
      chinryo = Chinryo.new(snake_params[:chinryo_max], snake_params[:chinryo_min])
      wark_minutes = WarkMinutes.new(snake_params[:wark_minutes_max], snake_params[:wark_minutes_min])


      {
        filter: [property_name, chinryo, wark_minutes].map(&:convert_to_h),
        opreator: "and"
      }
    end

    private

    def camel_to_snake(hash)
      hash.each_with_object({}) do |(key, value), new_hash|
        snake_key = key.to_s.gsub(/([A-Z])/, '_\1').downcase.to_sym
        new_hash[snake_key] = value
      end
    end
  end
end
params = { propertyName: 'テスト', chinryoMax: 500000, chinryoMin: 0, warkMinutesMax: 5, warkMinutesMin: 0 }
pp Filter.search_property(params)
