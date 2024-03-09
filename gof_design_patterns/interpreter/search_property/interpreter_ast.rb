# 以下のように専門の言語として検索条件を記述することができる。
"?q=テスト in:propertyName chinryo:<500000 warkMinutesMin:<5"
# メリット
# - or検索を追加する時も以下のようにするだけで良いため拡張しやすい
# - 実装が見やすくなる
"?q=テスト in:propertyName,remarks chinryo:<500000 warkMinutesMin:<5"
"?propertyName:in=テスト&remarks:in=テスト&chinryo:gteq=500000&warkMinutes:gteq=5" # bbの実装(and検索しかできない)
# TODO: parserとastの実装を見て作ってみる
require_relative 'not_use_interpreter_ast'

class And
  def initialize(expression1, expression2)
    @expression1 = expression1
    @expression2 = expression2
  end

  def convert_to_h
    {
      @expression1.convert_to_h.merge(@expression2.convert_to_h)

    }
  end
end
