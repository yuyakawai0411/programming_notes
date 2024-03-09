require 'bundler/inline'

gemfile do
  source 'https://rubygems.org'
  gem 'pry'
end

def backup(dir)
  puts "backup対象のディレクトリは、#{dir}"
end

def to(dir)
  puts "backup先のディレクトリは、#{dir}"
end

def interval(number)
  puts "バックアップの間隔は、#{number}分"
end

eval(File.read('backup.txt'))
