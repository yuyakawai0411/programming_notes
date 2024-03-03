require 'bundler/inline'

gemfile do
  source 'https://rubygems.org'
  gem 'rspec', require: %w[rspec/core]
end

module TestRunner
  def self.execute(format:, file_path:)
    # 指定したpathのRspecを実行する
    # Ref: https://github.com/rspec/rspec-core/blob/f273314f575ab62092b2ad86addb6a3c93d6041f/lib/rspec/core/configuration_options.rb#L129
    RSpec::Core::Runner.run(['-O', '', '--format', format, file_path])
  end
end

if __FILE__ == $PROGRAM_NAME
  TestRunner.execute(
    format: 'documentation', file_path: 'gof_design_patterns/singleton_patterns/singleton_test_spec.rb'
  )
end
