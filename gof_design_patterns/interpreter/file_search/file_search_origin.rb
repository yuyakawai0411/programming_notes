require 'find'
require 'bundler/inline'

gemfile do
  source 'https://rubygems.org'
  gem 'pry-rails'
end

# 特定のディレクトリ下のファイルを全て取得する
class All
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
class FileName
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
class Bigger
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
class Writable
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
class Not
  def initialize(expression)
    @expression = expression
  end

  def evaluate(dir)
    All.new.evaluate(dir) - @expression.evaluate(dir)
  end
end

class Or
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

class And
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

# all_file = All.new.evaluate('/Users/kawaiyuya/projects/programming_notes/gof_design_patterns/interpreter/sample')
# specified_file = FileName.new('*.txt').evaluate('/Users/kawaiyuya/projects/programming_notes/gof_design_patterns/interpreter/sample')

# Not.new(FileName.new('*.txt')).evaluate('/Users/kawaiyuya/projects/programming_notes/gof_design_patterns/interpreter/sample')
# Or.new(FileName.new('*.txt'), FileName.new('*.rb')).evaluate('/Users/kawaiyuya/projects/programming_notes/gof_design_patterns/interpreter/sample')
# And.new(FileName.new('*.txt'), FileName.new('*.rb')).evaluate('/Users/kawaiyuya/projects/programming_notes/gof_design_patterns/interpreter/sample')
# 100byte以上のtextもしくはrbファイルを検索する場合
And.new(
  Bigger.new(100),
  Or.new(
    FileName.new('*.txt'),
    FileName.new('*.rb')
  )
).evaluate('/Users/kawaiyuya/projects/programming_notes/gof_design_patterns/interpreter/sample')
