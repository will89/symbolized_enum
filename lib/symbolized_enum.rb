# frozen_string_literal: true

require 'symbolized_enum/version'
require 'active_support'
require 'active_record'
require 'active_record-type-symbol'

module SymbolizedEnum
  extend ActiveSupport::Concern

  module ClassMethods
    def symbolized_enum(attr_name, predicates: false, prefixed_predicate: false, suffixed_predicate: false, predicate_name_generator: nil, **validates_inclusion_of_options)
      attribute(attr_name, :symbol)
      validates_inclusion_of(attr_name, validates_inclusion_of_options)

      return unless predicates

      enum_values = validates_inclusion_of_options[:in]
      if prefixed_predicate
        enum_values.each do |enum_value|
          define_method("#{attr_name}_#{enum_value}?") do
            send(attr_name) == enum_value
          end
        end
      elsif suffixed_predicate
        enum_values.each do |enum_value|
          define_method("#{enum_value}_#{attr_name}?") do
            send(attr_name) == enum_value
          end
        end
      elsif predicate_name_generator
        enum_values.each do |enum_value|
          define_method(predicate_name_generator.call(attr_name, enum_value)) do
            send(attr_name) == enum_value
          end
        end
      else
        enum_values.each do |enum_value|
          define_method("#{enum_value}?") do
            send(attr_name) == enum_value
          end
        end
      end
    end
  end
end
