# singletonにする
# class SimpleLogger
#   attr_accessor :level

#   ERROR = 1
#   WARNING = 2
#   INFO = 3

#   def initialize
#     @log = File.open("log.txt", "w")
#     @level = WARNING
#   end

#   def error(msg)
#     @log.puts(msg)
#     @log.flush
#   end

#   def warning(msg)
#     @log.puts(msg) if @level >= WARNING
#     @log.flush
#   end

#   def info(msg)
#     @log.puts(msg) if @level >= INFO
#     @log.flush
#   end
# end

# logger = SimpleLogger.new
# logger.level = SimpleLogger::INFO

# logger.info('1つ目の処理を実行')
# logger.info('2つ目の処理を実行')

# singletonにする
## そのクラスのインスタンスが1つしか存在しないことを保証する
### 同じクラスであれば、同じインスタンスを返すようにする => クラス変数
### 外部からインスタンスを生成できないようにする => newメソッドをprivateにする
## どこからでもアクセスできるようにする
### クラスメソッドを定義する
class SimpleLogger
  attr_accessor :level

  ERROR = 1
  WARNING = 2
  INFO = 3

  def initialize
    @log = File.open("log.txt", "w")
    @level = WARNING
  end

  # https://www.rubydoc.info/gems/rubocop/RuboCop/Cop/Style/ClassVarsのエラーが発生
  def self.instance
    @@instance ||= new
  end

  def error(msg)
    @log.puts(msg)
    @log.flush
  end

  def warning(msg)
    @log.puts(msg) if @level >= WARNING
    @log.flush
  end

  def info(msg)
    @log.puts(msg) if @level >= INFO
    @log.flush
  end

  private_class_method :new
end

logger = SimpleLogger.instance
logger_2 = SimpleLogger.instance
logger.level = SimpleLogger::INFO

# 同じインスタンスを返すため、同じファイルに書き込まれる
logger.info('1つ目の処理を実行')
logger_2.info('2つ目の処理を実行')
