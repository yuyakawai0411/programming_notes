require 'minitest/autorun'
require 'minitest/spec'
require_relative 'application'

describe 'Application debug?' do
  let(:application) { Application.new }
  let(:config) { Config.instance }

  it 'when config is not debug' do
    puts 'テスト1実行'
    _(application.debug?).must_equal false
  end

  it 'when found key' do
    puts 'テスト2実行'
    config.set('debug', true)
    _(application.debug?).must_equal true
  end
end
