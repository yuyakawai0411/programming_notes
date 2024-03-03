# 以下のように専門の言語として検索条件を記述することができる。
"?q=テスト in:propertyName chinryo:<500000 warkMinutesMin:<5"
# メリット
# - or検索を追加する時も以下のようにするだけで良いため拡張しやすい
# - 実装が見やすくなる
"?q=テスト in:propertyName,remarks chinryo:<500000 warkMinutesMin:<5"

# TODO: parserとastの実装を見て作ってみる
