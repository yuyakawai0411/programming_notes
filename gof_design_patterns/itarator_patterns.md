# Itarator パターン

## 目次

1. 目的
2. 実現方法
3. 外部イテレータータの実装
4. 内部イテレータータの実装

## 目的

集約オブジェクトが基にある内部表現を公開せずに、走査を提供すること

### 背景

集約オブジェクトに新しい要素が追加されたり、それを元に走査方法を変更したりなど、集約オブジェクトと走査には仕様変更が起きやすい<br>
仕様変更が起きやすい箇所を別クラスに分離し、カプセル化することで、変更に強い実装にすることができる

### 走査とは

集約されたオブジェクト(Array オブジェクト等)が存在し、そのオブジェクトが持つ要素に順番にアクセスすること(反復処理)<br>
要素の名前順にアクセスしたり、要素をフィルターしてアクセスしたい場合など、さまざまな走査方法が存在する

## 実装方法

- 走査ロジックは集約オブジェクトに定義せず、Iterator クラスに分離する
- Iterator クラスは集約オブジェクトに依存しない共通のインターフェースである
- 集約オブジェクトは Iterator のサブクラスを作成する機能を持つ
- クライアント(走査の呼び出し元)は Iterator のサブクラスを経由して、走査を行う

## 外部イテレータータの実装

以下のような集約オブジェクトが存在する。先生が担当する生徒の点呼や採点をしたい場合(StudentList を走査する)で考える

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

Teacher クラスに生徒の点呼と採点ロジックを追加した。この状態だと Teacher は StudentList にアクセスする方法(length, get_student)を知っていることになり、StudentList に変更が加わった際には、点呼と採点ロジックなどの依存している部文のコードを全て見直さなければならない<br>

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

走査ロジックを Iterator クラスに分離して作成する<br>
こうすることで、StudentList に変更があった時や走査ロジックを変更したい時に、Teacher クラスの各メソッドを見直すさなくとも、Iterator クラスの実装を見直すだけで済み、変更が容易になる

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

Iterator クラスを共通のインターフェースとして切り出し、クライアントからは共通のインターフェースを呼ぶようにする<br>
そうすることで、集約オブジェクトが新しいものに変更された時、新しい Iterator クラスを作成するだけでクライアントが呼んでいる走査を変更する必要がない

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

外部イテレータではクライアント側から走査していたが、内部イテレータでは Iterator が走査する。クライアントは走査中に実行して欲しい処理をブロックで渡す<br>
ruby の each 等のビルドインメソッドも基本的にこの方式を使っていると思う<br>
クライアント側に走査ロジックを持たなくて済むため、走査が複雑でなければこちらを使う方がいいと思う

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
