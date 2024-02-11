# observer パターン

## 目次

1. 適用箇所
   1. 具体的なシチュエーション
   2. 解決すること
2. 構成図
3. observer パターンを使わない実装
   1. シチュエーション
   2. 具体的な実装
4. observer パターンを使った実装
   1. subject を作成する
   2. observer を作成する
5. 注意点

## 適用箇所

あるオブジェクトが状態を変えたときに、それに依存する全てのオブジェクトに自動的にそのことが通知され、また、それらが更新されるようにするシチュエーション

### 具体的なシチュエーション

- スプレッドシートで棒グラフと折れ線グラフが作画されている時、元のデータを更新すると、棒グラフと折線グラムも更新する
- 物件情報が更新された時に、出稿先 A、出稿先 B の情報も更新する

### 解決すること

前途のシチュエーションでは、オブジェクト間に 1 対多の依存関係が生じ、それらが協調動作している。このシチュエーションの一般的な副作用は、無矛盾性を担保するために、オブジェクト間で結合度が高まってしまうことである。結合度を高めずにこのシチュエーションを実装することが observer パターンが解決することである

## 構成図

- 通知者を subject、観察者を observer と定義する
- subject は observer のコレクションを持つ。subject は observer の追加(subscribe)、削除(unsubscribe)、通知するメソッドを持つ
- subject は observer の具象クラスを知らないため、オブジェクト間に 1 対多の依存関係がありながらも、結合度は低い

[![Image from Gyazo](https://i.gyazo.com/ca7b522c4e26e76c9352a1c003633756.png)](https://gyazo.com/ca7b522c4e26e76c9352a1c003633756)

## observer パターンを使わない実装

### シチュエーション

物件の募集状況が更新されたとき、担当者や顧客のメールアドレスに通知したいケースで考える

```ruby
class Property
  attr_reader :name, :offer_status, :chinryo

  # @param name [String]
  # @param offer_status [String]
  # @param chinryo [Integer]
  def initialize(name:, offer_status:, chinryo:)
    @name = name
    @offer_status = offer_status # 募集状況
    @chinryo = chinryo
  end
end

class Manager
  attr_reader :name, :email

  def initialize(name:, email:)
    @name = name
    @email = email
  end

  def update(property)
    puts "物件の募集状況が#{property.offer_status}に更新されました"
    # 登録されているemail宛にメール送るロジック
  end
end

class Client
  attr_reader :name, :email

  def initialize(name:, email:)
    @name = name
    @email = email
  end

  def update(property)
    puts "物件の募集状況が#{property.offer_status}に更新されました"
    # 登録されているemail宛にメール送るロジック
  end
end

property = Property.new(name: '田中ハイム', offer_status: '居住中', chinryo: 60000)
manager = Manager.new(name: '田中', email: 'manager@test.co.jp')
client = Client.new(name: '伊藤', email: 'client@test.co.jp')
```

### 具体的な実装

この実装のデメリットは、

- Property が Manger と Client の内部構造(クラス)を知っているため、結合度が高く、Manager や Client を修正した時に、Property に影響がないか確認しなければならない
- 観察者が増える度に、Property を更新するメソッドが肥大化する

```ruby
class Property
  attr_reader :name, :offer_status, :chinryo

  def initialize(name:, offer_status:, chinryo:, manager:, client:)
    @name = name
    @offer_status = offer_status
    @chinryo = chinryo
    @manager = manager
    @client = client
  end

  def offer_status=(offer_status)
    @offer_status = offer_status
    @manager.update(self)
    @client.update(self)
  end
end

property_info_hash = { name: '田中ハイム', offer_status: '居住中', chinryo: 60000, manager: manager, client: client }
property = Property.new(**property_info_hash)
property.offer_status = '空き'

=> 物件の募集状況が空きに更新されました
```

## observer パターンを使った実装

### 1. subject を作成する

通知に関する機能を Subject に分離し、観察者のリストを持つようにする。こうすることで、観察者が増えても、Property を更新するメソッドは肥大化しない

```ruby
module Subject
  def add_observer(observer)
    @observers = [] unless defined? @observers
    @observers << observer
  end

  def delete_observer(observer)
    @observers.delete(observer) if defined? @observers
  end

  def notify_observers
    return unless defined? @observers

    @observers.each do |observer|
      observer.update(self) # 観察者は通信者が変更されたことを知りたいため、自ずとselfになる
    end
  end
end

class Property
  include Subject
  attr_reader :name, :offer_status, :chinryo

  def initialize(name:, offer_status:, chinryo:)
    @name = name
    @offer_status = offer_status
    @chinryo = chinryo
  end

  def offer_status=(offer_status)
    @offer_status = offer_status
    notify_observers
  end
end

property = Property.new(name: '田中ハイム', offer_status: '居住中', chinryo: 60000)
property.add_observer(manager)
property.add_observer(client)

property.offer_status = '空き'

=> 物件の募集状況が空きに更新されました
```

### 2. observer を作成する

通知を受け取った後に更新する内容を observer に分離する。観察者が共通のインターフェース(update)を持つことで、Property は Manger や Client のことを知らなくてよくなり、結合度が低くなる

```ruby
module Observer
  def update(_object)
    raise NotImplementedError, 'include先で再定義する必要があります'
  end
end

class Manager
  include Observer
  ...
end

class Client
  include Observer
  ...
end
```

## 注意点

### 無駄な通知しないようにすること

observer パターンの注意点として、無駄な通知しないようにすること。例えば、offer_status が更新の時に呼ばれた時、必ずしも前の値とことなるとは限らない。また、offer_status が頻繁に呼ばれるかもしれない。その場合、担当者と顧客に無駄に通知されてしまい、マシンのリソースを無駄に食ってしまう可能性がある<br>
このように無駄な通知をしないよう、どのような時に通知するべきかは吟味しておく必要がある。ruby の Observable には changed というフラグを提供している。Observer は change 通知の責務をになっているため、通知するかどうかを制御するメソッドを汎用的に提供している(実際に通知するかどうかの制御は、Observer 側の責務のため)

https://docs.ruby-lang.org/ja/latest/class/Observable.html

```ruby
class Property
  include Observable
  attr_reader :name, :offer_status, :chinryo

  def initialize(name:, offer_status:, chinryo:)
    @name = name
    @offer_status = offer_status
    @chinryo = chinryo
  end

  def offer_status=(offer_status)
    @offer_status = offer_status
    if @offer_status != offer_status
      changed
      notify_observers
    end
  end
end
```

### データ間の整合性が強く求められる場合は注意すること

サブジェクトとオブザーバーは疎結合であるため、オブザーバーが例外を起こした時に、サブジェクトに影響を及ぼす場合は、Observer パターンではない<br>
Excel のグラフの作成に失敗した時、元のセルデータに対して影響を及ぼすことはない<br>
物件の募集状況が更新された後、掲載を落とすようなケースだと、掲載を落とすことに失敗した時、募集状況を変更前に戻すような逆順処理があってはならない<br>
Observer が正常に処理されなかった時、Subject に影響を及ぼすことがないか考えて使う必要がある<br>
強結合な一連の処理に Observer パターンを適用してしまうと、例外処理が難しくなる

```ruby
class Property
  def offer_status=(offer_status)
    @offer_status = offer_status
    if @offer_status != offer_status
      changed
      notify_observers
    end
  end
end

class Advertisement
  def initalize(property, publication)
    @property = property
    @publication = publication
  end
  def update(property)
    @property = property
    if @publication && (property.offer_status == '居住中')
      # 掲載を落とす処理
      raise StandardError
    end
  end
end
```

## 感想

front のフックメソッドとやっていることが近いと思った。useState で状態が変更された時、通知するという考え方とにている
