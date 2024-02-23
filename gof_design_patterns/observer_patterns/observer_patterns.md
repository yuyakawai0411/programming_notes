# observer パターン

## 目次

1. 適用箇所
   1. 具体的なシチュエーション
   2. 解決すること
2. 構成図
3. observer パターンを使わない実装
4. observer パターンを使った実装
   1. 通知を受け取った後の処理を抽象クラス observer に切り出す
   2. 通知に必要な処理を抽象クラス subject に切り出す
5. 具体的な実装
   1. ruby での実装
   2. bkk での実装
   3. front での実装

## 適用箇所

あるオブジェクトの状態が変化したときに、それに依存する全てのオブジェクトに通知し、何らかのアクションを起こしたいとき

### 具体的なシチュエーション

- スプレッドシートで棒グラフと折れ線グラフが作画されている時、元のデータを更新すると、棒グラフと折線グラムも更新する
- 新しい商品が入荷したとき、メルマガ登録者に対して、入荷のお知らせメールを出すとき

### 解決すること

前途のシチュエーションでは、オブジェクト間に 1 対多の依存関係が生じ、高い結合度を生みやすい。結合度を高めずに、状態の変化を別のオブジェクトに通知する方法をこのパターンが提供する

## 構成図

- オブジェクトの変化を通知する者を subject、その通知を受け取る者を observer と定義する
- subject は 通知するロジックと、observer の管理を担う(observer のコレクション、observer の追加・削除)

[![Image from Gyazo](https://i.gyazo.com/ca7b522c4e26e76c9352a1c003633756.png)](https://gyazo.com/ca7b522c4e26e76c9352a1c003633756)

## observer パターンを使わない実装

物件の保険情報が変更されたとき、担当者や居住者にメールでその否を通知したいケースで考える<br>
observer パターンを使わないと、

- Property が Manger と Resident の内部構造(クラス)を知っており、結合度が高くなる(Manager や Resident を修正した時に、Property に影響がないか確認しなければならない)
- 通知先が増える度に、Property の`insurance=`メソッドが肥大化する

```ruby
class Property
  attr_reader :name, :insurance, :manager, :resident

  def initialize(name, insurance, manager, resident)
    @name = name
    @insurance = insurance
    @manager = manager
    @resident = resident
  end

  def insurance=(insurance)
    @insurance = insurance
    @manager.update(self) if @manager.present?
    @resident.update(self) if @manager.present?
  end
end

class Manager
  ...

  def update(property)
    message = <<~EOS
      #{property.name}の保険が変更になりましたので、更新手続きをしてください。
      保険名: #{property.insurance.name}
      契約期間: #{property.insurance.term}
    EOS
    # 登録されているemail宛にメール送るロジック
    puts message
  end
end

class Resident
  ...

  def update(property)
    message = <<~EOS
      #{property.name}の保険が変更になりましたので、更新手続きをしてください。
      保険名: #{property.insurance.name}
      契約期間: #{property.insurance.term}
    EOS
    # 登録されているemail宛にメール送るロジック
    puts message
  end
end

manager = Manager.new(name: '田中', email: 'manager@test.co.jp')
resident = Resident.new(name: '伊藤', email: 'client@test.co.jp')
insurance = Insurance.new(name: '〇〇保険', term: 2024-01-01)
new_insurance = Insurance.new(name: '××保険', term: 2026-01-01)

property = Property.new('田中ハイム', insurance, manager, resident)
property.insurance = new_insurance
 => メッセージが送られる
```

## observer パターンを使った実装

subject と observer という抽象クラスを作成し、subject を observer のインターフェースに対してプログラミングする<br>
observer パターンを使うことで、

- subject は observer の具象クラスを知らず、Manger や Resident の内部構造を知る必要がない
- 通知先の増減に柔軟に対応できる(Property が肥大化しない)

### 1. 通知を受け取った後の処理を抽象クラス observer に切り出す

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

### 2. 通知に必要な処理を抽象クラス subject に切り出す

通知に関する機能を subject クラスに分離し、Property(通知者)が subject を継承する。

- observer のコレクション
- observer の追加
- observer の削除
- 通知ロジック(notify)

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
  attr_reader :name, :insurance

  def initialize(name:, insurance:)
    @name = name
    @insurance = insurance
  end

  def insurance=(insurance)
    @insurance = insurance
    notify_observers
  end
end

property = Property.new('田中ハイム', insurance)
property.add_observer(manager)
property.add_observer(client)

property.insurance = new_insurance
  => メッセージが送られる
```

## 具体的な実装

### ruby での実装

ruby では[observer](https://docs.ruby-lang.org/ja/latest/class/Observable.html)モジュールを提供しており、自作する必要がない。observer モジュールでは、無駄な通知しないよう changed フラグを提供している(changed フラグが false の時は、notify_observers が呼ばれても通知されない)<br>
例えば、前途の`insurance=`メソッドが呼ばれたとき、からなずしも保険情報が更新されたとは限らない。また、保険名が変わったとき(別の保険に変わったときで更新年が変わったときではない)のみ通知したい場合もある

```ruby
class Property
  include Observable
  ...

  def insurance=(insurance)
    changed if @insurance.name != insurance.name

    @insurance = insurance

    notify_observers
  end
end
```

### bkk での実装

不動産関係で考えると、物件情報を更新した時に、出稿先の情報も更新したり、顧客に物件提案したりするときに使えそうなパターンである。bkk では物件情報を更新した後、出稿先の情報更新や、顧客への提案といったはプロダクトが分かれている(協調処理はプロダクトを分けて設計しているのではないか？)。もしこれらの処理が 1 つのプロダクトに集中していたとしても、observer パターンを使うと疎結合になるため、例外時のロールバック処理が難しくなってしまう<br>
observer 側で正常に処理されなかったとき、逆順処理しなければいけないような一連処理には observer パターンは適さない

```ruby
# 強い結合が求められる一連処理には、observerは適さない

class RentRoom
  def update
    @rent_room.update!(update_params) # amaterasのAPIを叩く

    begin
      @bukkakun_room.update!(bk_update_params) # bkのAPIを叩く
    rescue Bukkakun::RequestError
      @rent_room.rollback!(raw_rent_room)
      raise
    end
  end
end

```

### front での実装

React の useEffect が似たような実装だと思う。指定した state 変数の状態が変更された時に特定の処理が動くため
