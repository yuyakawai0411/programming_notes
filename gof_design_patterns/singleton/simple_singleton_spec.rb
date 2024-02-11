require 'minitest/autorun'
require 'minitest/spec'
require_relative 'singleton_test'

describe 'Config get' do
  let(:config) { Config.instance }

  it 'when not found key' do
    puts 'テスト1実行'
    _(config.get('foo')).must_be_nil
  end

  it 'when found key' do
    puts 'テスト2実行'
    config.set('foo', 'Foo')
    _(config.get('foo')).must_equal 'Foo'
  end
end
