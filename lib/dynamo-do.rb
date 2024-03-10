require_relative  "./builder/query_builder.rb"
require_relative  "./builder/scan_query_builder.rb"
require_relative  "./client/dynamo_client.rb"
module DynamoDo

  class << self

    def add_item(table_name: "", item: "")

      begin
        params = {
          item: item.to_h,
          table_name: table_name,
          return_consumed_capacity: "INDEXES"
        }
        response = DynamoClient.client.put_item(params)
      rescue StandardError => e
        "Error adding Item Here's why: #{e.message}"
      end
    end

    def get_item_by(pk: nil, pk_val: nil, sk: nil, sk_val: nil, table_name: nil)
      begin
        keys = build_keys(pk: pk, pk_val: pk_val, sk: sk, sk_val: sk_val)
        params = {
          key: keys, 
          table_name: table_name
        }
        response = DynamoClient.client.get_item(params)
        response.item
      rescue StandardError => e
        "Error getting Item Here's why: #{e.message}"
      end

    end

    def update(pk:, pk_val:, sk: nil, sk_val: nil, table_name:, do_update: {})
      begin
        keys = build_keys(pk: pk, pk_val: pk_val, sk: sk, sk_val: sk_val)
        update_expression = "SET "
        attribute_values = {}
        do_update.to_h
        do_update.each_with_index do |(attribute, value), index|
          update_expression += "#{attribute} = :value#{index}, "
          attribute_values[":value#{index}"] = value
        end

        update_expression.chomp!(', ')

        params = {
          key: keys,
          table_name: table_name,
          update_expression: update_expression,
          expression_attribute_values: attribute_values,
          return_values: "ALL_NEW"
        }

        response = DynamoClient.client.update_item(params)
        response.attributes
      rescue StandardError => e
        puts "Error updating item Here's why: #{e.message}"
      end
    end

    def delete(pk:, pk_val:, sk: nil, sk_val: nil, table_name:)
      begin
        keys = build_keys(pk: pk, pk_val: pk_val, sk: sk, sk_val: sk_val)
        params = {
          key: keys,
          table_name: table_name,
          return_values: "ALL_OLD"
        }

        response = DynamoClient.client.delete_item(params)
        response.attributes
      rescue StandardError => e
        puts "Error deleting item Here's why: #{e.message}"
      end
    end

    def describe_table(table_name)
      begin
        params = {
          table_name: table_name
        }

        response = DynamoClient.client.describe_table(params)
        table_description = response.table

        return table_description
      rescue StandardError => e
        puts "Error describing table Here's why: #{e.message}"
      end
    end

    def query_table(table_name)
      QueryBuilder.new(table_name)
    end

    def scan_table(table_name)
      ScanQueryBuilder.new(table_name)
    end
    

    private

    def build_keys(pk: nil, pk_val: nil, sk: nil, sk_val: nil)
      keys = { pk => pk_val }
      keys.merge!({ sk => sk_val }) unless sk.nil?
      keys
    end



  end   

end
