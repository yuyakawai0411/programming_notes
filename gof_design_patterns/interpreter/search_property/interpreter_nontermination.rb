require_relative 'interpreter_termination'
require 'bundler/inline'

gemfile do
  source 'https://rubygems.org'
  gem 'pry'
end

class FilterCollectionBase
  class << self
    def self.operator
      raise NotImplementedError, "#{self.name} must implement the .operator class method"
    end
  end

  def initialize(*filters)
    @filters = filters
  end

  def convert_to_h
    {
      filter: filters.map(&:convert_to_h),
      operator: self.class.operator
    }
  end

  private

  attr_reader :filters
end

class AndFilterCollection < FilterCollectionBase
  OPERATOR = 'and'

  class << self
    def operator
      OPERATOR
    end
  end
end

class OrFilterCollection < FilterCollectionBase
  OPERATOR = 'or'

  class << self
    def operator
      OPERATOR
    end
  end
end

params = { property_name: 'テスト', chinryo_max: 500000, chinryo_min: 0 }
property_and_filter = AndFilterCollection.new(
  PropertyNameFilter.build(params[:property_name]),
  ChinryoFilter.build(params[:chinryo_max], 'gteq'),
  ChinryoFilter.build(params[:chinryo_min], 'lteq')
)
property_or_filter = OrFilterCollection.new(
  PropertyNameFilter.build(params[:property_name]),
  ChinryoFilter.build(params[:chinryo_max], 'gteq'),
  ChinryoFilter.build(params[:chinryo_min], 'lteq')
)
