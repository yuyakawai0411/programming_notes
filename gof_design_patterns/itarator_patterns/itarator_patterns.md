# Itarator パターン

## 目次

1. 目的
2. 実現方法
3. 外部イテレータータの実装
4. 内部イテレータータの実装

## 目的

集約オブジェクトの内部表現を公開せずに、走査をクライアント(呼び出し先)に提供すること

### 背景

集約オブジェクトや走査は仕様変更が起きやすい。例えば、集約オブジェクトに新しい要素が追加されたり、パフォーマンスを向上するため走査ロジックを変更したりするなどである<br>
仕様変更が起きやすい箇所をクラスに切り出すことで、結合度を弱め、変更に強い柔軟な設計にすることができる(ex.クライアント側で走査を複数箇所で呼び出している場合、集約オブジェクトや走査に変更が加わる度に、クライアント側を修正ないといけない)

### 走査とは

集約されたオブジェクト(ex. Array オブジェクト)が存在し、そのオブジェクトが持つ要素に順番にアクセスすること<br>
要素の名前順にアクセスしたり、要素をフィルターしてアクセスしたい場合など、目的に応じて走査ロジックはさまざまである

## 実装方法

- 走査ロジックは集約オブジェクトに定義せず、Iterator クラスに分離する
- Iterator クラスは集約オブジェクトに依存しない共通のインターフェースである
- 集約オブジェクトは Iterator のサブクラスを作成する機能を持つ
- クライアント(走査の呼び出し元)は Iterator のサブクラスを経由して、走査を行う

## 外部イテレータータの実装

生徒の情報を集約するオブジェクト(StudentList)が存在する。先生が生徒の点呼や採点をしたいケースで考える

```ruby
# 集約オブジェクト
class StudentList
  attr_reader :students
  # @param students [Array<Student>]
  # @return [void]
  def initialize(students:)
    @students = students
  end

  # @param student [Integer]
  # @return [Student, nil]
  def get_student(index)
    @students[index]
  end

  # @return [Integer]
  def length
    @students.length
  end
end

class Student
  attr_reader :name
  def initialize(name:)
    @name = name
  end
end

students = [Student.new(name: '一郎'), Student.new(name: '二郎')]
student_list = StudentList.new(students: students)
```

### 1.クライアントの作成

Teacher クラスに生徒の点呼と採点ロジックを追加した<br>
この状態だと Teacher は StudentList の実装(length, get_student)を知ることになる。StudentList に変更があった時には、点呼と採点ロジックなどの StudentList にアクセスしているコードを全て見直さなければならない<br>

```ruby
class Teacher
  attr_reader :student_list
  # @param student_list [StudentList]
  # @return [void]
  def initialize(student_list:)
    @student_list = @student_list
  end

  # 点呼をする
  def call_student
    index = 0
    while @student_list.length > index
      student = @student_list.get_student(@index)
      index += 1
      student.name
    end
  end

  # 点数計算をする
  def calculate_scores
    index = 0
    while @students.length > index
      student = @students.get_student(@index)
      index += 1
      rand(100) # ランダムに点数計算
    end
  end
end

teacher = Teacher.new(student_list: student_list)
teacher.call_student
```

### 2.クライアントと集約オブジェクトの結合度を減らす

走査ロジックを StudentListIterator クラスに分離して作成する<br>
こうすることで、StudentList に変更があった時または走査ロジックを変更したい時は、Teacher の各メソッドを見直すさなくとも、StudentListIterator の実装を見直すだけで済み、変更が容易になる

```ruby
class StudentListIterator
  def initialize(students:)
    @students = students
    @index = 0
  end

  def has_next?
    @students.length > @index
  end

  def next
    element = @students.get_student(@index)
    @index += 1
    element
  end
end

class StudentList
  ...
  # @return [StudentListIterator]
  def iterator
    StudentListIterator.new(students: self)
  end
end

class Teacher
  ...
  # 点呼をする
  def call_student
    itr = student_list.iterator
    while itr.has_next?
      itr.next.name
    end
  end

  # 点数計算をする
  def calculate_scores
    itr = student_list.iterator
    while itr.has_next?
      rand(100)
    end
  end
end

teacher = Teacher.new(student_list: student_list)
teacher.call_student
```

### 3.Iterator クラスと集約オブジェクトの結合度を減らす

StudentListIterator を Iterator クラスという共通のインターフェースとして切り出し、クライアントからは共通のインターフェースを呼ぶようにする<br>
そうすることで、集約オブジェクトが新しいものに変更された時、Iterator クラスのサブクラスを作成するだけでクライアントの変更する必要がなくなる

```ruby
class Iterator
  # @param array [Array<Object>]
  def initialize(array:)
    @array = students
    @index = 0
  end

  def has_next?
    @array.length > @index
  end

  def next
    element = @array[@index]
    @index += 1
    element
  end
end

class StudentListIterator < Iterator
  # @param student_list [StudentList]
  def initialize(student_list)
    super(student_list.students)
  end
end

class NewStudentListIterator < Iterator
  # @param student_list [NewStudentList]
  def initialize(new_student_list)
    new_students = remove_duplicate(new_student_list.students)
    super(new_students)
  end

  private
  # フィルターする処理
  def remove_duplicate(student_list)
    ...
  end
end

class Teacher
  ...
  # 点呼をする
  def call_student
    itr = student_list.new_iterator
    while itr.has_next?
      itr.next.name
    end
  end

  # 点数計算をする
  def calculate_scores
    itr = student_list.new_iterator
    while itr.has_next?
      rand(100)
    end
  end
end

teacher = Teacher.new(student_list: student_list)
teacher.call_student
```

## 内部イテレータータの実装

外部イテレータではクライアント側から反復処理していたが、内部イテレータでは Iterator クラスが反復処理をする。クライアントは走査中に実行して欲しい処理をブロックで渡す<br>
ruby の each 等のビルドインメソッドも基本的にこの方式を使っていると思う<br>
クライアント側に走査ロジックを持たなくて済むため、走査ロジックが複雑でなければこちらを使う方がいいと思う

```ruby
class StudentListIterator
  def initialize(students:)
    @students = students
    @index = 0
  end

  def each
    while @students.length > @index
      student = @students.get_student(@index)
      yield(student)
      @index += 1
    end
  end
end

class Teacher
  ...
  # 点呼をする
  def call_student
    student_list.each { |student| student.name}
  end
end

teacher = Teacher.new(student_list: student_list)
teacher.call_student
```
