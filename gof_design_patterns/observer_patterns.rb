module Subject
  def initialize
    @observers = []
  end

  def add_observer(observer)
    @observers = [] unless defined? @observers
    @observers << observer
  end

  def delete_observer(observer)
    @observers.delete(observer) if defined? @observers
  end

  def notify_observers
    return unless defined? @observers

    @observers.each do |observer|
      observer.update(self)
    end
  end
end

module Observer
  def update(_object)
    raise NotImplementedError, 'include先で再定義する必要があります'
  end
end

class Property
  include Subject
  attr_reader :name, :offer_status, :chinryo

  def initialize(name:, offer_status:, chinryo:)
    @name = name
    @offer_status = offer_status
    @chinryo = chinryo
  end

  def offer_status=(offer_status)
    @offer_status = offer_status
    notify_observers
  end
end

class Manager
  include Observer
  attr_reader :name, :email

  def initialize(name:, email:)
    @name = name
    @email = email
  end

  def update(property)
    puts "物件の募集状況が#{property.offer_status}に更新されました"
    # 登録されているemail宛にメール送るロジック
  end
end

class Client
  include Observer
  attr_reader :name, :email

  def initialize(name:, email:)
    @name = name
    @email = email
  end

  def update(property)
    puts "物件の募集状況が#{property.offer_status}に更新されました"
    # 登録されているemail宛にメール送るロジック
  end
end

manager = Manager.new(name: '田中', email: 'manager@test.co.jp')
client = Client.new(name: '伊藤', email: 'client@test.co.jp')
property_info = { name: '田中ハイム', offer_status: :rented, chinryo: 60000}
property = Property.new(**property_info)
property.add_observer(manager)
property.add_observer(client)

property.offer_status = '空き'

