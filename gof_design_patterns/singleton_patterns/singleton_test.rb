require 'singleton'
class Config
  include Singleton

  def initialize
    @store = {}
  end

  def set(key, value)
    @store[key] = value
  end

  def get(key)
    @store[key]
  end
end

# テストするとしたら、2つクラスを作成し、Configクラスをテストする必要がある
# class Config
#   def initialize
#     @store = {}
#   end

#   def set(key, value)
#     @store[key] = value
#   end

#   def get(key)
#     @store[key]
#   end
# end

# class SingletonConfig < Config
#   include Singleton
# end
