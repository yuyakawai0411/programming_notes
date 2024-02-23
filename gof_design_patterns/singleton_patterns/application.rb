require_relative 'singleton_test'

class Application
  def debug?
    # configがsingletonであることを知っているし、テストのしにくさが伝播している
    Config.instance.get('debug') == true
  end
end

# class Application
#   def initialize(config)
#     @config = config # テストではconfigをsingletonでないオブジェクトでmockする
#   end

#   def debug?
#     @config.get('debug') == true
#   end
# end

# Application.new(Config.instance)
