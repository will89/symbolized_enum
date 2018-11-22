require "symbolized_enum/version"
require "active_support"
require "active_record"
require "active_record-type-symbol"

module SymbolizedEnum
  extend ActiveSupport::Concern

  module ClassMethods
    def symbolized_enum(attr_name, predicates: false, predicate_generator: nil, **active_record_options)
      attribute(attr_name, :symbol)
      validate_inclusion_of(attr_name, active_record_options)
    end
  end
end
