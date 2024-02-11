class Config
  def initialize
    @store = {}
  end

  def self.instance
    @@instance ||= new
  end

  def set(key, value)
    @store[key] = value
  end

  def get(key)
    @store[key]
  end

  private_class_method :new
end
