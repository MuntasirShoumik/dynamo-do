require_relative  "../client/dynamo_client.rb"
class ScanQueryBuilder
  attr_accessor :table_name, :expression_attributes, :filter_expression, :attribute, :limit_value

  def initialize(table_name)
    @table_name = table_name
    @expression_attributes = {}
    @filter_expression = ""
    @attribute = ""
  end

  def build_expression(operator: , val: )
    @filter_expression += "#{@attribute} #{operator} :#{@attribute}"
    @expression_attributes[":#{@attribute}"] = val
  end

  def where(attribute)
    @attribute = attribute
    self
  end

  def and(attribute)
    @attribute = attribute
    @filter_expression += " AND "
    self
  end

  def or(attribute)
    @attribute = attribute
    @filter_expression += " OR "
    self
  end

  def equal(value)
    build_expression(operator: "=", val: value)
    self
  end

  def less_than(value)
    build_expression(operator: "<", val: value)
    self
  end

  def greater_than(value)
    build_expression(operator: ">", val: value)
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

  def limit(value)
    @limit_value = value
    self
  end


  def execute
    params = {}
    items = []
    done = false
    start_key = nil

    begin
    params = {
        table_name: table_name,
        limit: @limit_value
      }
    unless @expression_attributes.empty? && @filter_expression.empty?
      params[:filter_expression] = @filter_expression
      params[:expression_attribute_values] = @expression_attributes 
    end

    until done
      params[:exclusive_start_key] = start_key unless start_key.nil?
      response = DynamoClient.client.scan(params)
      items.concat(response.items) unless response.items.empty?
      start_key = response.last_evaluated_key
      done = start_key.nil?
    end
    items

    rescue StandardError => exception
      "Error querying items Here's why: #{exception.message}"
    end
  end


end
