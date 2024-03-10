require 'spec_helper'
require_relative '../lib/builder/scan_query_builder.rb'

RSpec.describe ScanQueryBuilder do
  let(:table_name) { 'someTable' }

  describe '#initialize' do
    it 'initializes a ScanQueryBuilder instance with the provided table name' do
      scan_query_builder = ScanQueryBuilder.new(table_name)
      expect(scan_query_builder.table_name).to eq(table_name)
    end
  end

  describe '#where' do
    it 'sets the attribute for the filter expression' do
      scan_query_builder = ScanQueryBuilder.new(table_name)
      scan_query_builder.where('someAttribute')
      expect(scan_query_builder.attribute).to eq('someAttribute')
    end
  end

  describe '#and' do
    it 'adds "AND" to the filter expression' do
      scan_query_builder = ScanQueryBuilder.new(table_name)
      scan_query_builder.where('someAttribute').and('another_attribute')
      expect(scan_query_builder.filter_expression).to eq(' AND ')
    end
  end

  describe '#or' do
    it 'adds "OR" to the filter expression' do
      scan_query_builder = ScanQueryBuilder.new(table_name)
      scan_query_builder.where('someAttribute').or('another_attribute')
      expect(scan_query_builder.filter_expression).to eq(' OR ')
    end
  end

  describe '#equal' do
    it 'builds an equal expression and updates expression_attributes' do
      scan_query_builder = ScanQueryBuilder.new(table_name)
      scan_query_builder.where('someAttribute').equal('someValue')
      expect(scan_query_builder.filter_expression).to eq('someAttribute = :someAttribute')
      expect(scan_query_builder.expression_attributes).to eq({ ":someAttribute" => 'someValue' })
    end
  end

  describe '#limit' do
    it 'sets the limit value for the scan query' do
      scan_query_builder = ScanQueryBuilder.new(table_name)
      scan_query_builder.limit(10)
      expect(scan_query_builder.limit_value).to eq(10)
    end
  end

  describe '#execute' do
    it 'executes a scan query and returns the items' do
      allow(DynamoClient.client).to receive(:scan).and_return(double(items: [{ id: '123', timestamp: 456, data: '1/1/1' }], last_evaluated_key: nil))
      scan_query_builder = ScanQueryBuilder.new(table_name)
      items = scan_query_builder.where('someAttribute').equal('someValue').execute
      expect(items).to eq([{ id: '123', timestamp: 456, data: '1/1/1' }])
    end

    it 'handles errors gracefully' do
      allow(DynamoClient.client).to receive(:scan).and_raise(StandardError, 'Some error')
      scan_query_builder = ScanQueryBuilder.new(table_name)
      result = scan_query_builder.where('someAttribute').equal('someValue').execute
      expect(result).to include('Error querying items Here\'s why')
    end
  end
end
