require_relative 'interpreter_termination'

"?q=テスト in:propertyName,remarks chinryo:<500000 warkMinutesMin:<5"
"?propertyName:in=テスト&remarks:in=テスト&chinryo:gteq=500000&warkMinutes:gteq=5"

# どういうtokenに分けるか？
"?propertyName:=テスト and chinryo:<=500000"

# propertyName フィールド
# :
# = マッチャー
# テスト = value


class Parser
  def initialize(string)
    @tokens = string
  end
end