require 'spec_helper'
require_relative '../lib/builder/query_builder.rb'

RSpec.describe QueryBuilder do
    let(:table_name) { 'SomeTable' }

    describe '#initialize' do
      it 'initializes a QueryBuilder instance with the provided table name' do
        query_builder = QueryBuilder.new(table_name)
        expect(query_builder.table_name).to eq(table_name)
      end
    end
  
    describe '#by_key' do
      it 'adds a key condition expression for the primary key' do
        query_builder = QueryBuilder.new(table_name)
        query_builder.by_key(pk: 'id', val: '123')
        expect(query_builder.key_condition_expression).to eq('id = :pk_val')
        expect(query_builder.expression_attribute_values).to eq({ ":pk_val" => '123' })
      end
    end
  
    describe '#sort' do
      it 'adds a sort condition to the key condition expression' do
        query_builder = QueryBuilder.new(table_name)
        query_builder.sort('timestamp')
        expect(query_builder.key_condition_expression).to eq(' AND timestamp')
      end
    end
  
    describe '#equal' do
      it 'builds an equal expression and updates expression_attribute_values' do
        query_builder = QueryBuilder.new(table_name)
        query_builder.by_key(pk: 'id', val: '123').equal('example_value')
        expect(query_builder.key_condition_expression).to eq('id = :pk_val = :sk_val')
        expect(query_builder.expression_attribute_values).to eq({ ":pk_val" => '123', ":sk_val" => 'example_value' })
      end
    end
  
    describe '#less_then' do
      it 'builds a less than expression and updates expression_attribute_values' do
        query_builder = QueryBuilder.new(table_name)
        query_builder.by_key(pk: 'id', val: '123')
        query_builder.sort('timestamp').less_than(456)
        expect(query_builder.key_condition_expression).to eq('id = :pk_val AND timestamp < :sk_val')
        expect(query_builder.expression_attribute_values).to eq({ ":pk_val" => '123', ":sk_val" => 456 })
      end
    end
  
    describe '#execute' do
      it 'executes a query and returns the items' do
        allow(DynamoClient.client).to receive(:query).and_return(double(items: [{ id: '123', timestamp: 456, data: 'example_data' }]))
        query_builder = QueryBuilder.new(table_name)
        items = query_builder.by_key(pk: 'id', val: '123').execute
        expect(items).to eq([{ id: '123', timestamp: 456, data: 'example_data' }])
      end
  
      it 'handles errors gracefully' do
        allow(DynamoClient.client).to receive(:query).and_raise(StandardError, 'Some error')
        query_builder = QueryBuilder.new(table_name)
        result = query_builder.by_key(pk: 'id', val: '123').execute
        expect(result).to include('Error querying items Here\'s why')
      end
    end
end