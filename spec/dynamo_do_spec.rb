require 'spec_helper'
require_relative '../lib/dynamo-do.rb'

RSpec.describe DynamoDo do
  let(:table_name) { 'table_name' }
  let(:pk) { 'id' }
  let(:pk_val) { '123' }
  let(:sk) { 'timestamp' }
  let(:sk_val) { 456 }
  let(:item) { { id: '123', timestamp: 456, data: 'example_data' } }

  describe '.add_item' do
    it 'adds an item to the DynamoDB table' do
      allow(DynamoClient.client).to receive(:put_item).and_return(double)
      expect(DynamoDo.add_item(table_name: table_name, item: item)).not_to be_nil
    end

    it 'handles errors gracefully' do
      allow(DynamoClient.client).to receive(:put_item).and_raise(StandardError, 'Some error')
      expect(DynamoDo.add_item(table_name: table_name, item: item)).to include('Error adding Item Here\'s why')
    end
  end

  describe '.get_item_by' do
    it 'retrieves an item from the DynamoDB table by primary key' do
      allow(DynamoClient.client).to receive(:get_item).and_return(double(item: item))
      expect(DynamoDo.get_item_by(pk: pk, pk_val: pk_val, table_name: table_name)).to eq(item)
    end

    it 'handles errors gracefully' do
      allow(DynamoClient.client).to receive(:get_item).and_raise(StandardError, 'Some error')
      expect(DynamoDo.get_item_by(pk: pk, pk_val: pk_val, table_name: table_name)).to include('Error getting Item Here\'s why')
    end
  end

  describe '.update' do
    it 'updates an item in the DynamoDB table' do
      allow(DynamoClient.client).to receive(:update_item).and_return(double(attributes: { updated: true }))
      expect(DynamoDo.update(pk: pk, pk_val: pk_val, table_name: table_name, do_update: { data: 'new_data' })).to eq({ updated: true })
    end

    it 'handles errors gracefully' do
      allow(DynamoClient.client).to receive(:update_item).and_raise(StandardError, 'Some error')
      expect(DynamoDo.update(pk: pk, pk_val: pk_val, table_name: table_name, do_update: { data: 'new_data' })).to be_nil.or(include('Error updating item Here\'s why'))
    end
  end

  describe '.delete' do
    it 'deletes an item from the DynamoDB table' do
      allow(DynamoClient.client).to receive(:delete_item).and_return(double(attributes: { deleted: true }))
      expect(DynamoDo.delete(pk: pk, pk_val: pk_val, table_name: table_name)).to eq({ deleted: true })
    end

    it 'handles errors gracefully' do
      allow(DynamoClient.client).to receive(:delete_item).and_raise(StandardError, 'Some error')
      expect(DynamoDo.delete(pk: pk, pk_val: pk_val, table_name: table_name)).to be_nil.or(include('Error updating item Here\'s why'))
    end
  end

  describe '.describe_table' do
    it 'describes a table in DynamoDB' do
      allow(DynamoClient.client).to receive(:describe_table).and_return(double(table: { table_name: table_name }))
      expect(DynamoDo.describe_table(table_name)).to eq({ table_name: table_name })
    end

    it 'handles errors gracefully' do
      allow(DynamoClient.client).to receive(:describe_table).and_raise(StandardError, 'Some error')
      expect(DynamoDo.describe_table(table_name)).to be_nil.or(include('Error updating item Here\'s why'))
    end
  end

  describe '.query_table' do
    it 'returns a QueryBuilder instance' do
      expect(DynamoDo.query_table(table_name)).to be_a(QueryBuilder)
    end
  end

  describe '.scan_table' do
    it 'returns a ScanQueryBuilder instance' do
      expect(DynamoDo.scan_table(table_name)).to be_a(ScanQueryBuilder)
    end
  end
end
