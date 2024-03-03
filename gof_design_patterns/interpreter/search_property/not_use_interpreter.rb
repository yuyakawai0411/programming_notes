# 物件名テスト & 賃料が5万円以下 & 駅から徒歩5分以内
# デメリット
# - 検索条件が増えるたびにパラメータが増る
# - 検索条件の追加が難しい(ex. not検索、or検索)
"?propertyName=テスト&chinryoMax=500000&chinryoMin=0&warkMinutesMax=5&warkMinutesMin=0"

# TODO: bkkの現状のfilterの実装を見て作ってみる

# def search_property(params)
#   {
#     "propertyName:In" => params[:propertyName]
#     "chinryo:Less" => params[:chinryoMax]
#     "warkMinutes:Less" => params[:warkMinutesMax]
#   }
# end

# class PropertyName
#   MATCH = "In"

#   def initialize(name)
#     @name = name
#   end

#   def convert_to_h
#     {
#       "property:#{MATCH}" => 
#     }
#   end
# end

