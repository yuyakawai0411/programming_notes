# observer パターン

## 目次

1. 目的
2. クラス図
3. 実現方法
4. 注意点

## 目的

あるオブジェクトが状態を変えたときに、それに依存する全てのオブジェクトに自動的にそのことが知らされ、また、それらが更新されるように、オブジェクト間に 1 対多の依存関係を定義する

### 背景

あるオブジェクトが変更された時に、それに関連するオブジェクトも自動で変更したいケースがよくある。例えば、スプレッドシートで棒グラフと折れ線グラフが作画されている時、元のデータを更新すると、棒グラフと折線グラムも更新される<br>
1 つのシステムを、協調動作するクラスの集まりに分割する際の一般的な副作用は、関連するオブジェクト間で無矛盾性を保つことである。しかし、無矛盾にするためにクラスの結合度を高めるようなことはしたくない

## クラス図

[![Image from Gyazo](https://i.gyazo.com/ca7b522c4e26e76c9352a1c003633756.png)](https://gyazo.com/ca7b522c4e26e76c9352a1c003633756)

\*Observer の notify メソッドは、今回の例では update or draw メソッドのこと

## 実装方法

- 通知者を subject、観察者を observer とする。
- subject は複数の observer を持つ。その方法は subject が observer を subscribe することである

## 実装例

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

### 1. 募集状況の更新を担当者と顧客に通知する機能を作成

募集状況の更新を担当者と顧客に通知する機能を作成した<br>
この例の悪いところは、

- Property が Manger と Client の内部構造(クラス)を知っているため、Manager や Client を修正した時に、Property に影響がないか確認しなければならない
- 通知先が増える度に、Property が通知先を区別しなければならなくなる

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

### 2. subject を作成する

通知に関する機能を Subject に分離し、受信側のリストを持つようにする。こうすることで、通知者は受信側を区別する必要がなくなる

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
      observer.update(self) # 通信者が変更されたことを知りたいため、自ずとselfになる
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

### 3. 受信者が共通のインターフェース observer を持つようにする

observe が共通のインターフェース(update)を持つことで、observer クラスを mixin すれば使えることが確定するため、Property は Manger や Client のことを知らなくてよくなる

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

プロバイダーとオブザーバーの間の結合は疎であるため、例外が起きた場合でも、お互いに影響を与えないかどうかを確認する必要がある<br>

offer_status が正常に更新された時、募集の掲載を落とすのではなく、offer_status と募集の掲載は同時に落とさなければならない。下記の例だと、Property が DB に変更を保存した後、notify_observer でエラーになった時、不整合が起きる。notify_observer が正常に済み、その後 offer_status の更新に失敗した時も同様。(もう一度通知する際に、関係のないところまで通知してしまう)。

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
