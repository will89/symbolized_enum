# frozen_string_literal: true

RSpec.describe SymbolizedEnum do
  it 'has a version number' do
    expect(SymbolizedEnum::VERSION).not_to be nil
  end

  context 'model without predicates' do
    with_model :ModelWithSymbolizedEnumAttribute do
      table do |t|
        t.string :data_type
      end

      model do
        include(SymbolizedEnum)
        symbolized_enum :data_type, in: [:string, :numeric]
      end
    end

    it 'assigns and persists valid enum values', :aggregate_failures do
      model = ModelWithSymbolizedEnumAttribute.new(data_type: :string)
      expect(model.data_type).to eq(:string)
      expect { model.save! }.not_to raise_error
      expect(model.reload.data_type).to eq(:string)
    end

    it 'assigns and persists valid coerced enum values', :aggregate_failures do
      model = ModelWithSymbolizedEnumAttribute.new(data_type: 'string')
      expect(model.data_type).to eq(:string)
      expect { model.save! }.not_to raise_error
      expect(model.reload.data_type).to eq(:string)
    end

    it 'does not respond to predicate methods' do
      model = ModelWithSymbolizedEnumAttribute.new(data_type: 'string')
      expect(model.respond_to?(:string?)).to eq(false)
    end

    it 'reports invalid enum value assignment', :aggregate_failures do
      model = ModelWithSymbolizedEnumAttribute.new(data_type: :not_a_valid_option)
      expect(model).to be_invalid
      expect { model.save! }.to raise_error(ActiveRecord::RecordInvalid,
                                            'Validation failed: Data type is not included in the list')
    end
  end

  context 'model with default value' do
    with_model :ModelWithSymbolizedEnumAttribute do
      table do |t|
        t.string :data_type
      end

      model do
        include(SymbolizedEnum)
        symbolized_enum :data_type, default: :string, in: [:string, :numeric]
      end
    end

    it 'assigns and persists default enum values', :aggregate_failures do
      model = ModelWithSymbolizedEnumAttribute.new
      expect(model.data_type).to eq(:string)
      expect { model.save! }.not_to raise_error
      expect(model.reload.data_type).to eq(:string)
    end

    context 'saved record with nil in the database' do
      it 'still returns nil', :aggregate_failures do
        model = ModelWithSymbolizedEnumAttribute.create
        # Bypass activerecord validation to make data_type nil in the database
        model.update_attribute(:data_type, nil)
        model.reload
        expect(model.data_type).to eq(nil)
      end
    end
  end

  context 'model with predicates' do
    context 'default predicates' do
      with_model :ModelWithSymbolizedEnumAttribute do
        table do |t|
          t.string :data_type
        end

        model do
          include(SymbolizedEnum)
          symbolized_enum :data_type, predicates: true, in: [:string, :numeric]
        end
      end

      it 'responds to predicate methods', :aggregate_failures do
        model = ModelWithSymbolizedEnumAttribute.new(data_type: :string)
        expect(model.respond_to?(:string?)).to eq(true)
        expect(model.string?).to eq(true)
        expect(model.numeric?).to eq(false)

        # predicate works when values are coerced
        model.data_type = 'numeric'
        expect(model.string?).to eq(false)
        expect(model.numeric?).to eq(true)
      end
    end

    context 'prefixed predicates' do
      with_model :ModelWithSymbolizedEnumAttribute do
        table do |t|
          t.string :data_type
        end

        model do
          include(SymbolizedEnum)
          symbolized_enum :data_type, predicates: true, prefixed_predicate: true, in: [:string, :numeric]
        end
      end

      it 'responds to predicate methods', :aggregate_failures do
        model = ModelWithSymbolizedEnumAttribute.new(data_type: :string)
        expect(model.respond_to?(:data_type_string?)).to eq(true)
        expect(model.data_type_string?).to eq(true)
        expect(model.data_type_numeric?).to eq(false)
      end
    end

    context 'suffixed predicates' do
      with_model :ModelWithSymbolizedEnumAttribute do
        table do |t|
          t.string :data_type
        end

        model do
          include(SymbolizedEnum)
          symbolized_enum :data_type, predicates: true, suffixed_predicate: true, in: [:string, :numeric]
        end
      end

      it 'responds to predicate methods', :aggregate_failures do
        model = ModelWithSymbolizedEnumAttribute.new(data_type: :string)
        expect(model.respond_to?(:string_data_type?)).to eq(true)
        expect(model.string_data_type?).to eq(true)
        expect(model.numeric_data_type?).to eq(false)
      end
    end

    context 'custom predicate generator' do
      with_model :ModelWithSymbolizedEnumAttribute do
        table do |t|
          t.string :data_type
        end

        model do
          include(SymbolizedEnum)
          method_name_proc = proc { |attr_name, enum_value| "crazy_#{enum_value}_#{attr_name}_crazy?" }
          symbolized_enum :data_type, predicates: true,
                                      predicate_name_generator: method_name_proc, in: [:string, :numeric]
        end
      end

      it 'responds to predicate methods', :aggregate_failures do
        model = ModelWithSymbolizedEnumAttribute.new(data_type: :string)
        expect(model.respond_to?(:crazy_string_data_type_crazy?)).to eq(true)
        expect(model.crazy_string_data_type_crazy?).to eq(true)
        expect(model.crazy_numeric_data_type_crazy?).to eq(false)
      end
    end
  end
end
