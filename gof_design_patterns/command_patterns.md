## 目次

1. 適用箇所
   1. 具体的なシチュエーション
   2. 解決すること
2. 構成図
3. command パターンを使わない実装
4. command パターンの使った実装 Proc
5. command パターンの使った実装 Command
6. 具体的な実装

## 適用箇所

命令を管理したいシチュエーションで使える

- 特定のタイミングで命令を実行したい
- 選択肢に応じて複数の命令を一括で実行したい
- 実行済みの命令の履歴を確認したい
- 実行済みの命令を取り消したい(ロールバック)
- 一度実行した命令を再実行したい

### 具体的なシチュエーション

- GUI 画面で保存ボタンをクリックした時に、保存する。メニューボタンをクリックした時は、メニューを開く
- ソフトウェアのインストール時に、選択肢によってディレクトリの作成、必要なファイルのインストール等の一連の命令を実行する
- ワードやエクセル等で、データの追加や誤ってデータを削除してしまったりなど、すでに完了してしまった命令を取り消す

### 解決すること

命令を管理したいシチュエーション(命令の内容+命令の実行)は多く存在する。シチュエーション毎にオブジェクトを作成してしまうと、オブジェクトの数が膨大になってしまう。命令の内容をオブジェクトとして切り出し、命令の内容と命令の実行を分離することで、再利用性を高めることが command パターンである

```ruby
# 命令の内容と実行が切り離されていない
File.open('sample.rb', 'r')

# 命令の内容と実行が切り離されている
# 遅延実行や実行する前に命令を記述したい場合などに使える
obj = Proc.new { File.open('sample.rb', 'r') }
obj.call
```

## 構成図

- Command は命令の内容(object)と命令の実行(execute)を持つ

```mermaid
classDiagram
Command <| -- ConcreteCommand1
Command <| -- ConcreteCommand2
Command : object
Command : execute()
ConcreteCommand1 : object
ConcreteCommand1 : execute()
ConcreteCommand2 : object
ConcreteCommand2 : execute()
```

## command パターンを使わない実装

命令を実行したい箇所に命令の内容が記述されている。どちらも命令を実行したいタイミングは、配列の各要素にアクセスするときのため共通化できそうである

```ruby
values = [6, 8, 10]
## 各要素を倍にした処理の結果を表示する
def double_values(values)
  double_values = []
  for element in values
    double_values << element * 2 # 命令を実行したい箇所に命令の内容が記述されている
  end
  double_values
end

## 各要素を半分にした処理の結果を表示する
def half_values(values)
  half_values = []
  for element in values
    half_values << element / 2 # 命令を実行したい箇所に命令の内容が記述されている
  end
  half_values
end

double_values(values) => [12, 16, 20]
half_values(values) => [3, 4, 5]
```

## command パターンを使った実装

Ruby では Command オブジェクトを作成しなくとも Proc を使うことで同じことを実現できる<br>

- Proc とは、ブロックをコンテキスト(ローカル変数のスコープやスタックフレーム)とともにオブジェクト化したもの。([参考文献](https://docs.ruby-lang.org/ja/2.7.0/class/Proc.html))<br>
- ブロックとは制御構造(順次, 繰り返し, 分岐)の抽象化のために用いられる処理の塊(命令)。メソッドの引数として渡すことができ、単体で存在することはできない([参考文献](https://docs.ruby-lang.org/ja/latest/doc/spec=2fcall.html#block))<br>

```ruby
# ブロックで実装する
values = [6, 8, 10]
## 各要素に対して特定の計算処理をした結果を表示する
def calculate_values(values)
  new_values = []
  for element in values
    # yieldでブロックを実行
    new_values << yield(element) if block_given?
  end
  new_values
end

calculate_values(values) { |element| element * 2 }
=> [12, 16, 20]
calculate_values(values) { |element| element / 2 }
=> [3, 4, 5]

# procを使った例
## 処理内容はわかっているが、どの要素を2倍して、どの配列に追加するのかの具体的な部文はまだわからない
add_double_element = Proc.new do |array, element|
  array << element * 2
end
add_half_element = Proc.new do |array, element|
  array << element / 2
end

values = [6, 8, 10]

def calculated_values(values, &block)
  new_values = []
  for element in values
    block.call(new_values, element)
  end
  new_values
end

calculated_values(values, &add_double_element)
=> [12, 16, 20]
calculated_values(values, &add_half_element)
=> [3, 4, 5]
```

## command パターンの使った実装 Command
