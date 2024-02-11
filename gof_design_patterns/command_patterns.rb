class Command
  def initialize(command)
    @command = command
  end

  def execute
    command. if command
  end
end

class FileOpen < Command
  def 
end

file_open_action = FileOpen.new(path: 'sample.text')
command = Command.new(file_open_action)
command.execute

# コマンドの振る舞いをオブジェクトとして切り出す
## commandパターンを使わない例
File.open('/sample.text')
## commandパターンを使う例
class Command
  attr_reader :command

  def initialize(&block)
    @command = block
  end

  def execute
    command.call if @command
  end
end

file_open = Command.new { File.open('/sample.text') }
file_open.execute
