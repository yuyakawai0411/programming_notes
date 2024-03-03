require_relative 'singleton_test'

RSpec.describe Config, type: :model do
  describe 'Config get' do
    let(:config) { Config.instance }

    # before do
    #   Config.instance_variable_set(:@_instance, nil)
    # end

    it 'when not found key' do
      puts 'テスト1実行'
      expect(config.get('foo')).to eq nil
    end

    it 'when found key' do
      puts 'テスト2実行'
      config.set('foo', 'Foo')
      expect(config.get('foo')).to eq 'Foo'
    end
  end
end
