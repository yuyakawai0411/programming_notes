front から検索パラメータを受け取り、別の検索 API に渡すパラメータを生成する例で考える
検索できるパラメータは、以下のパラメータだとする

- name: 物件名
- chinryo: 家賃
- wark_minutes: 駅徒歩

サードパーティーに以下の Hash 形式の検索パラメータを渡す想定

```json
// AND検索
{ "filter" => [
    { "propertyName:In" => "テスト" },
    { "chinryo:Less" => "1000000" },
  ],
  "operator" => "and"
}
// OR検索
{ "filter" => [
    { "propertyName:In" => "テスト" },
    { "chinryo:Less" => "1000000" },
  ]
  "operator" => "or"
}
```

各サイトの検索するためのクエリパラメータのパターンは以下に参考例がある
https://qiita.com/keigodasu/items/c02239968ea0db833c74
