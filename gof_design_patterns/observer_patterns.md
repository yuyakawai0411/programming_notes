# observer パターン

## 目次

1. 目的
2. クラス図
3. 実現方法

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

### 1.subject の作成

従業員情報が更新された時、従業員数の推移グラフを更新したい場合で考える<br>
Employees という Subject を作成した。新しく従業員の年齢別円グラフを作成し、このグラフも更新したい場合、Employees に円グラフを更新するときのロジックを追加しなければならない

```ruby
class Employees
  def initialize(employees)
    @employees = employees
  end

  def add_employee(employee)
    @employees << employee
    draw_line_graph
    draw_pie_graph
  end

  def delete_employees(employee)
    @employees.delete(employee)
    draw_line_graph
    draw_pie_graph
  end

  def draw_line_graph
    LineGraph.new(@employees).draw
  end

  def draw_pie_graph
    PieGraph.new(@employees).draw
  end
end

class Employee
  attr_reader :name, :age, :join_date

  def initialize(name, age, join_date)
    @name = name
    @age = age
    @join_date = join_date
  end
end

class EmployeeLineGraph
  def initialize(employees)
    @employees = employees
  end

  # 折れ線グラフを作成するロジック
  def draw
    ...
  end
end

class EmployeePieGraph
  def initialize(employees)
    @employees
  end

  # 円グラフを作成するロジック
  def draw
    ...
  end
end
```

### 2. subject が observer のリストを購読するようにする

これにより Employees は各グラフオブジェクトの実装を知らなくても良くなる。これにより 1.observer を動的に付け替えたりすることが容易になる(円グラフは 1 日 1 回だけ更新したい場合は、delete_observer で消す)、2.observer を追加するときは Observer のサブクラスを add_observer で追加するだけで済み、拡張しやすくなる

```ruby
class Employees
  def initialize(employees)
    @employees = employees
    @observers = []
  end

  def add_employee(employee)
    @employees << employee
    notify
  end

  def delete_employees(employee)
    @employees.delete(employee)
    notify
  end

  def add_observer(observer)
    @observers << observer
  end

  def delete_observer(observer)
    @observers.delete(observer)
  end

  def notify
    @observers.each do |observer|
      observer.update
    end
  end
end

class LineGraph
  # 折れ線グラフの見た目を更新する処理
  def update(employees)
    @employees = employees
    draw
    ...
  end

  def draw
    ...
    puts '折れ線グラフの表示'
  end
end

class BarGraph
  # 棒グラフの見た目を更新する処理
  def update(area)
    @employees = employees
    draw
    ...
  end

  def draw
    ...
    puts '円グラフの表示'
  end
end

employees = Employees.new
line_graph = LineGraph.new(employees)
bar_graph = BarGraph.new(employees)
```

### 3. subject と observer の共通インターフェースを抜き出す

observe が共通のインターフェース(update)を持つことで、observer のサブクラスであれば、リストに登録するだけで全ての observer に通知することができる

```ruby
class Subject
  def initialize
    @observers = []
  end

  def add_observer(observer)
    @observers << observer
  end

  def delete_observer(observer)
    @observers.delete(observer)
  end

  def notify
    @observers.each do |observer|
      observer.update
    end
  end
end

class Employees << Subject
  def add_employee(employee)
    @employees << employee
    notify
  end

  def delete_employees(employee)
    @employees.delete(employee)
    notify
  end
end

class Observer
  def update(area)
  end
end

class LineGraph < Graph
  ...
end

class BarGraph < Graph
  ...
end
```

## ライブラリで使用されている例

## 実際に使用するときの例

## 気づき

- メルマガ配信の例で考えてもわかりやすそう
  - メールで配信する場合
  - sms で配信する場合
