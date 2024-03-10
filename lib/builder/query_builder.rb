require_relative  "../client/dynamo_client.rb"
class QueryBuilder
    attr_accessor :table_name, :expression_attributes, :filter_expression, :key_condition_expression, :expression_attribute_values

    def initialize(table_name)
      @table_name = table_name
      @key_condition_expression = ''
      @expression_attribute_values = {}
    end


    def by_key(pk:, val:)
      @key_condition_expression += "#{pk} = :pk_val"
      @expression_attribute_values[":pk_val"] = val
      self
    end

    def sort(sk)
      @key_condition_expression += " AND #{sk}"
      self
    end

    def build_expression(operator: , val: )
      @key_condition_expression += " #{operator} :sk_val"
      @expression_attribute_values[":sk_val"] = val
    end

    def equal(val)
      build_expression(operator: "=", val: val)
      self  
    end

    def less_than(val)
      build_expression(operator: "<", val: val)
      self  
    end

    def greater_than(val)
      build_expression(operator: ">", val: val)
      self  
    end

    def less_or_eql(val)
      build_expression(operator: "<=", val: val)
      self  
    end

    def greater_or_eql(val)
      build_expression(operator: ">=", val: val)
      self  
    end

    def execute
      params = {
        table_name: @table_name,
        key_condition_expression: @key_condition_expression,
        expression_attribute_values: @expression_attribute_values
      }

      begin
        response = DynamoClient.client.query(params)
        response.items
      rescue StandardError => exception
        "Error querying items Here's why: #{exception.message}"
      end
    end
  end