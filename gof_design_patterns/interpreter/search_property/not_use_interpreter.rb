# ケース
## frontから物件名と賃料の値が渡され、その値に応じて物件を検索する
## 検索に使うマッチャは、in, not_id, gtep, lteq
## 以下のようなURLクエリパラメータをfrontから受け取る想定
"?propertyName=テスト&chinryoMax=500000&chinryoMin=0"
# メリット
## - URLクエリパラメータとfilterが一致しているため、実装がシンプル
# デメリット
# - 検索対象と条件が増えるたびに、PropertyFilterのメソッドとURLクエリパラメータが肥大化する => 柔軟性がない

require 'bundler/inline'

gemfile do
  source 'https://rubygems.org'
  gem 'pry'
end

# 名称と賃料で物件を検索するクラス
class PropertyFilter
  class << self
    def build_property_name_and_chinryo(params)
      filters = [
        property_name_filter(params[:property_name]),
        chinryo_gtep_filter(params[:chinryo_max]),
        chinryo_ltep_filter(params[:chinryo_min])
      ]

      { filter: filters,  operator: "and" }
    end

    private

    def property_name_filter(property_name)
      { "propertyName:in" => property_name }
    end

    def chinryo_gtep_filter(chinryo_max)
      { "chinryo:gtep" => chinryo_max }
    end

    def chinryo_ltep_filter(chinryo_min)
      { "chinryo:lteq" => chinryo_min }
    end
  end
end

params = { property_name: 'テスト', chinryo_max: 500000, chinryo_min: 0 }
property_filter = PropertyFilter.build_property_name_and_chinryo(params)
# Kensakukun.search(property_filter) 物件を検索する

# class PropertyName
#   MATCH = "in"

#   attr_reader :name

#   def initialize(name)
#     @name = name
#   end

#   def convert_to_h
#     {
#       "property:#{MATCH}" => name
#     }
#   end
# end

# class Chinryo
#   LESS_MATCH = "le"
#   GREATER_MATCH = "gr"

#   attr_reader :max_amount, :min_amount

#   def initialize(max_amount, min_amount)
#     @max_amount = max_amount
#     @min_amount = min_amount
#   end

#   def convert_to_h
#     {
#       "chinryo:#{LESS_MATCH}" => max_amount,
#       "chinryo:#{GREATER_MATCH}" => min_amount
#     }
#   end
# end

# class WarkMinutes
#   LESS_MATCH = "le"
#   GREATER_MATCH = "gr"

#   attr_reader :max_minutes, :min_minutes

#   def initialize(max_minutes, min_minutes)
#     @max_minutes = max_minutes
#     @min_minutes = min_minutes
#   end

#   def convert_to_h
#     {
#       "warkMinutes:#{LESS_MATCH}" => max_minutes,
#       "warkMinutes:#{GREATER_MATCH}" => min_minutes
#     }
#   end
# end

# class Filter
#   class << self
#     def search_property(params)
#       snake_params = camel_to_snake(params)
#       property_name = PropertyName.new(snake_params[:property_name])
#       chinryo = Chinryo.new(snake_params[:chinryo_max], snake_params[:chinryo_min])
#       wark_minutes = WarkMinutes.new(snake_params[:wark_minutes_max], snake_params[:wark_minutes_min])


#       {
#         filter: [property_name, chinryo, wark_minutes].map(&:convert_to_h),
#         opreator: "and"
#       }
#     end

#     private

#     def camel_to_snake(hash)
#       hash.each_with_object({}) do |(key, value), new_hash|
#         snake_key = key.to_s.gsub(/([A-Z])/, '_\1').downcase.to_sym
#         new_hash[snake_key] = value
#       end
#     end
#   end
# end
# params = { propertyName: 'テスト', chinryoMax: 500000, chinryoMin: 0, warkMinutesMax: 5, warkMinutesMin: 0 }
# pp Filter.search_property(params)
