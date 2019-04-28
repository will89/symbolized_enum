# frozen_string_literal: true

require 'symbolized_enum/version'
require 'active_support'
require 'active_record'
require 'active_record-type-symbol'

module SymbolizedEnum
  extend ActiveSupport::Concern

  module ClassMethods
    NO_DEFAULT_PROVIDED = Object.new # :nodoc:

    # @param [String, Symbol] attr_name Activerecord attribute to treat as a symbol
    # @param kwargs [Boolean] :predicates (false) Generate boolean methods for each enum value.
    #   This must be true for any of the other predicate options to take effect
    # @param kwargs [Boolean] :prefixed_predicate (false) Generate boolean methods for each enum value
    #   prefixed with the name of the attribute
    # @param kwargs [Boolean] :suffixed_predicate (false) Generate boolean methods for each enum value
    #   suffixed with the name of the attribute
    # @param kwargs [Proc, nil] :predicate_name_generator (nil) Generate boolean methods for each enum value by calling
    #   the proc with attribute name and enum value
    # @param kwargs [Object, nil] :default This value is passed to the activerecord attribute default option
    # @param [Hash] **validates_inclusion_of_options Any options accepted by activerecord's validates_inclusion_of
    def symbolized_enum(attr_name, predicates: false,
                        prefixed_predicate: false,
                        suffixed_predicate: false,
                        predicate_name_generator: nil,
                        default: NO_DEFAULT_PROVIDED,
                        **validates_inclusion_of_options)
      if default == NO_DEFAULT_PROVIDED
        attribute(attr_name, :symbol)
      else
        attribute(attr_name, :symbol, default: default)
      end

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
