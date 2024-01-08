# デザインパターンとは

## 目次

1. 概要
2. 良い設計とは
3. 設計原則
4. その他必要になる知識

## 概要

デザインパターンとはオブジェクト指向において、**よく出会う問題とそれに対処する良い設計**をパターン化し、カタログにしたもの<br>
GoF (Gang of Four)と呼ばれる 4 人の共著者によって執筆された書籍「オブジェクト指向における再利用のためのデザインパターン」で登場した<br>
デザインパターンを知ることで、経験が浅いプログラマでも先人たちの知恵を利用した良い設計をすることが出来る

> Design patterns solve specific design problems and make object-oriented designs more flexible, elegant, and ultimately reusable. They help designers reuse successful designs by basing new designs on prior experience. A designer who is familiar with such patterns can apply them immediately to design problems without having to rediscover them.

[wiki\_デザインパターン](<https://ja.wikipedia.org/wiki/%E3%83%87%E3%82%B6%E3%82%A4%E3%83%B3%E3%83%91%E3%82%BF%E3%83%BC%E3%83%B3_(%E3%82%BD%E3%83%95%E3%83%88%E3%82%A6%E3%82%A7%E3%82%A2)>)

## 良い設計とは？

オブジェクト指向の恩恵を最大限に得るための設計原則に則り、クラスやモジュール設計をすること<br>
オブジェクト指向の最大の恩恵は、コードをカプセル化することで、再利用性、拡張性に優れたコードが書けるところである

[テックスコア](https://www.techscore.com/tech/DesignPattern/foundation/foundation1#dp0-2)

### オブジェクト指向の設計思想

Alan Kay が Smalltalk というプログラミング言語を開発する中で生まれたプログラミングパラダイム<br>
状態(プロパティ)と振る舞い(メソッド)を隠蔽した再帰的な要素(コンポジションを持つオブジェクト)を作成し、それらがメッセージを通じて互いに対話する(メソッド呼び出し)ことで、大きなシステムを構築する<br>
状態と振る舞いを同じ要素に閉じ込めることで凝縮度を高め、メッセージというインターフェースを介し情報隠蔽性を高めることで、カプセル化することが目的だと思う<br>
これにより、プログラムの各部分は独立していながらも、一つの統合されたシステムとして機能するため、再利用性、拡張性に優れている<br>

> Smalltalk's design—and existence—is due to the insight that everything we can describe can be represented by the recursive composition of a single kind of behavioral building block that hides its combination of state and process inside itself and can be dealt with only through the exchange of messages.

[The Early History Of Smalltalk](http://worrydream.com/EarlyHistoryOfSmalltalk/)

## 設計原則

オブジェクト指向の恩恵を最大限に得るためのに守らなければならないルール<br>
デザインパターンはこのルールを守りながら設計する具体的な方法を提示してくれる

- SOLID
- DRY
- デルメルの法則

## その他必要になる知識

- 継承
- ポリモーフィズム

## オブジェクト指向のルール

- インターフェースに対してプログラミングするのであって、実装に対してプログラミングするのではない
- クラス継承よりもオブジェクトコンポジションを多用すること

### インターフェースに対してプログラミングするのであって、実装に対してプログラミングするのではない

クライアント(呼び出し先)は具象クラスのインターフェースではなく、抽象クラスのインターフェースに則って実装すべきだということを示している<br>
そうすることによって、クライアントと具象クラスの結合度が低くなり、柔軟な実装にすることができる(具象クラスに変更があったとしても、クライアントを変更せずに済むため)

#### クラスの継承とインターフェースの継承の違い

Ruby にはインターフェースを定義する機能がなく、サブタイピングがこれに該当すると思われる<br>

- クラスの継承
  - 他のオブジェクトの実装を用いて新たなオブジェクトの実装を定義すること
- インターフェースの継承(サブタイピング)
  - あるオブジェクトを他のオブジェクトの代わりに使うことができる時に用いる

クラスの継承では、抽象クラスと具象クラスに分離し、抽象クラスは基本的にインスタンス化しないようになっている(クラス図では抽象クラスをイタリックで書いく)。抽象クラスは共通のインターフェースを提供することを目的としているため、メソッド定義だけしておいて処理の中身を具象クラスに任せることがある。これを抽象オペレーションという
**抽象オペレーションの例**

```ruby
# 抽象クラス
class Animal
  # 抽象オペレーション、処理の中身は具象クラスに委ねられる
  def make_sound
    raise NotImplementedError, 'このメソッドはサブクラスで実装する必要があります'
  end

  def eat
    puts "この動物は食事をしています。"
  end
end

# DogクラスはAnimalモジュールをinclude
class Dog < Animal
  def make_sound
    puts "ワン！"
  end
end
```

### クラス継承よりもオブジェクトコンポジションを多用すること

機能を再利用する方法は、クラス継承とオブジェクトコンポジションの 2 種類存在する<br>
クラス継承は再利用が簡単である反面、サブクラスが親クラスの内部構造を知ることになるため、カプセル化を破壊してしまう。これにより、1.具象クラスを拡張する際に抽象クラスの実装が拡張に制限をかける、2.抽象クラスを変更した際に継承している全ての具象クラスに影響が出る、といった問題が起きる<br>
オブジェクトコンポジションと委譲を用いることで、クラス継承の問題を回避しつつ、機能を再利用することができる

#### クラス継承で実装する

SportUtilityVehicle は燃料がガソリンであることを期待している<br>
電気で動く SUV が出た時、SportUtilityVehicle をそのまま再利用することができない。Vehicle を修正する場合、Vehicle のサブクラス全てを修正しなければならず、影響範囲が大きくなる

```ruby
class Vehicle
  def initialize(fuel)
    @fuel = fuel
  end

  # 指定した距離(km)走るメソッド
  # @param distance [Integer]
  # @return [void]
  def run(distance)
    fuel_remain = calculate_fuel_remain(distance)
    raise '燃料が足りません' if fuel_remain < 10
    # 走るためのロジック
    ...
  end

  # 指定した距離(km)走った時の燃料残量を計算するロジック
  # @param distance [Integer]
  # @return [Integer]
  def calculate_fuel_remain(distance)
    NotImplementedError, 'このメソッドはサブクラスで実装する必要があります'
  end
end

class SportUtilityVehicle < Vehicle
  FUEL_EFFICIENCY = 15

  def initialize(fuel)
    super(fuel)
  end

  # SUVの燃費計算のロジック
  def calculate_fuel_remain(distance)
    fuel - (distance / FUEL_EFFICIENCY)
  end
end

suv_vehicle = SportUtilityVehicle.new(50)
suv.run
```

#### オブジェクトコンポジションで実装する

車という単位で切り出すのではなく、車を構成する部品としてクラスを切り出し、SportUtilityVehicle はプロパティでそのクラスを参照できるようにする<br>
こうすることで、電気で動く SUV が出た時は、実行時にオブジェクトの参照を電気用エンジンに取り替えるだけで良い

```ruby
class GasolineEngine
  def initialize(fuel)
    @fuel = fuel
  end

  def calculate_fuel_remain(distance)
    # SUVの燃費計算のロジック
    fuel - (distance / FUEL_EFFICIENCY)
  end
end

class ElectricEngine
  def initialize(fuel)
    @fuel = fuel
  end

  def calculate_fuel_remain(distance)
    # SUVの燃費計算のロジック
    fuel - (distance / FUEL_EFFICIENCY)
  end
end

class SportUtilityVehicle
  def initialize(engine, steering, brake)
    @engine = engine
    @steering = steering
    @brake = brake
  end

  def run(distance)
    fuel_remain = @engine.calculate_fuel_remain(distance)
    raise '燃料が足りません' if fuel_remain < 10
    # 走るためのロジック
    ...
  end
end

# 実行時にオブジェクトの参照を獲得する
suv_vehicle = SportUtilityVehicle.new(100, GasolineEngine.new)
electric_vehicle = SportUtilityVehicle.new(1000, ElectricEngine.new)
```

#### 部品のインターフェースを統一する

オブジェクトコンポジションで部品ごとにクラスを切り出したとしても、全てのシステムが既存の部品を使って動くようにできるとは限らない。むしろ細かな要求の違いによって、新しい部品を作ることが多い。そのため、部品が共通のインターフェースを持つようにしておき(GasolineEngine の抽象クラスの Engine のクラスを作る)、クライアント側の変更を少なく済むようにしておくべきである

### 委譲とは？

一部の機能を別のオブジェクトに渡すこと。クラス継承は全ての機能をオブジェクトに渡すことになってしいまう
