require 'find'
require 'bundler/inline'

gemfile do
  source 'https://rubygems.org'
  gem 'pry-rails'
end

class Expression
  def |(other)
    Or.new(self, other)
  end

  def &(other)
    And.new(self, other)
  end

  def all
    All.new
  end

  def bigger(size)
    Bigger.new(size)
  end

  def name(pattern)
    FileName.new(pattern)
  end

  def except(expression)
    Not.new(expression)
  end

  def writable
    Writable.new
  end
end

# 特定のディレクトリ下のファイルを全て取得する
class All < Expression
  def evaluate(dir)
    results = []
    Find.find(dir) do |p|
      next unless File.file?(p)
      results << p
    end
    results
  end
end

# 特定のディレクトリ下の名前に一致するファイルを全て取得する
class FileName < Expression
  def initialize(pattern)
    @pattern = pattern
  end

  def evaluate(dir)
    results = []
    Find.find(dir) do |p|
      next unless File.file?(p)

      name = File.basename(p)
      results << p if File.fnmatch(@pattern, name)
    end
    results
  end
end

# 特定のディレクトリ下の指定したサイズ以上のファイルを全て取得する
class Bigger < Expression
  def initialize(size)
    @size = size
  end

  def evaluate(dir)
    results = []
    Find.find(dir) do |p|
      next unless File.file?(p)

      results << p if (File.size(p) > @size)
    end
    results
  end
end

# 特定のディレクトリ下の書き込み可能ファイルを全て取得する
class Writable < Expression
  def evaluate(dir)
    results = []
    Find.find(dir) do |p|
      next unless File.file?(p)
      results << p if (File.writable?(p))
    end
    results
  end
end

# nonterminalのクラスを扱う
## 特定のファイル以外を検索したい場合
class Not < Expression
  def initialize(expression)
    @expression = expression
  end

  def evaluate(dir)
    All.new.evaluate(dir) - @expression.evaluate(dir)
  end
end

class Or < Expression
  attr_reader :expression1, :expression2

  def initialize(expression1, expression2)
    @expression1 = expression1
    @expression2 = expression2
  end

  def evaluate(dir)
    expression1 = @expression1.evaluate(dir)
    expression2 = @expression2.evaluate(dir)
    expression1 + expression2
  end
end

class And < Expression
  attr_reader :expression1, :expression2

  def initialize(expression1, expression2)
    @expression1 = expression1
    @expression2 = expression2
  end

  def evaluate(dir)
    expression1 = @expression1.evaluate(dir)
    expression2 = @expression2.evaluate(dir)
    expression1 & expression2
  end
end

new_result = (Bigger.new(100) & FileName.new('*.txt')) | FileName.new('*.rb')
