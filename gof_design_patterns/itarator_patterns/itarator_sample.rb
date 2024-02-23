# 集約オブジェクト
# 役割
  # - オブジェクトの集約
  # - オブジェクトの追加
  # - オブジェクトの削除
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

  # @param student [Student]
  def add_student(student)
    @students << student
  end

  # @param index [Integer]
  # @return [Array<Student>, []]
  def remove_student(index)
    @students.delete(index)
  end

  # @return [Integer]
  def length
    @students.length
  end

  # @return [StudentListExternalIterator]
  def external_iterator
    StudentListExternalIterator.new(students: self)
  end

  # @return [StudentListInternalIterator]
  def internal_iterator
    StudentListInternalIterator.new(students: self)
  end
end

class Student
  attr_reader :name, :age

  # @param name [String]
  # @param age [Integer]
  def initialize(name:, age:)
    @name = name
    @age = age
  end
end

# 外部イテレータ
# 役割: 走査処理
class StudentListExternalIterator
  def initialize(students:)
    @students = students
    @index = 0
  end

  def has_next?
    @students.length > @index
  end

  def next
    student = @students.get_student(@index)
    @index += 1
    student
  end
end

# 内部イテレータ
# 役割: 走査処理
class StudentListInternalIterator
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

# Iteratorを挟まないと、TeacherがStudentListに強依存したモデルになってしまう
# デザインパターンの本質は、変更されにくいところと変更されやすいところを見極め、クラス分けしてクッションにすることで変更に対応しやすくすること
class Teacher
  attr_reader :students

  def initialize(students:)
    @students = @students
  end

  # 前提: 集約クラスに変更が加わることはよくあることだ
    # ex1. 集約されているオブジェクトに要素を追加する
    # ex2. 走査のロジックを新しく追加する(フィルターや1つ1つの要素に何かの処理をする時)
  # @studentオブジェクトに変更が加わった時、Teacherで@studentを呼んでいるメソッド全てに変更を加えなければならない
  # TeacherクラスがStudentListクラスの内部構造を知る必要がない
  # 現在はTeacherクラスが走査のロジックをになっているため、StudentListクラスに依存してしまっている
  def call_student
    index = 0
    while @students.length > index
      student = @students.get_student(@index)
      index += 1
      student.name
    end
  end

  # ここではInterfaceに定義されている共通のインターフェースを使うようにする
  # そうすることで集約クラスが変更になった時に、Teacherクラスの各種メソッドを変更する必要がなく

  def calculate_scores
    index = 0
    while @students.length > index
      student = @students.get_student(@index)
      index += 1
      calculate_score
    end
  end

  private

  def calculate_score
    rand(100)
  end
end

## 集約に対して順にアクセスする時のロジックは色々なものがある

students = [
  Student.new(name: '九郎', age: 9),
  Student.new(name: '十郎', age: 10),
  Student.new(name: '十一郎', age: 11),
  Student.new(name: '十二郎', age: 12)
]
student_list = StudentList.new(students: students)

external_iterator = student_list.external_iterator
while external_iterator.has_next?
  puts external_iterator.next.name
end

internal_iterator = student_list.internal_iterator
internal_iterator.each { |student| puts student.name }

teacher = Teacher.new(students: student_list)
puts 'aaaaaaaaaa'
puts student_list.length
puts teacher.students