require_relative 'interpreter_termination'

# 以下のように専門の言語として検索条件を記述することができる。
"?q=テスト in:propertyName chinryo:<500000 warkMinutesMin:<5"
# メリット
# - or検索を追加する時も以下のようにするだけで良いため拡張しやすい
# - 実装が見やすくなる
"?q=テスト in:propertyName,remarks chinryo:<500000 warkMinutesMin:<5"
"?propertyName:in=テスト&remarks:in=テスト&chinryo:gteq=500000&warkMinutes:gteq=5" # bbの実装(and検索しかできない)

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
