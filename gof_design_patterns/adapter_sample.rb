# Adapterパターン
# インタフェースに互換性の無いクラス同士を組み合わせることを目的
# 継承を利用するパターンと委譲を利用するパターンの2種類がある

# 会長には役割がある=organizeクラス
# た

Target.request
 # Adaptee.old_request

class Target
  def request
    '新しいクラスです'
  end
end

class Adaptee
  def old_request
    '古いクラスです'
  end
end

def client_code(target)
  puts target.request
end

target = Target.new
client_code(target)
#=> '新しいクラスです'

class Adapter < Target

  def initialize(adaptee)
    @adaptee = adaptee
  end

  def request
    @adaptee.old_request
  end
end