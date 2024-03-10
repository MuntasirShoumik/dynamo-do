# dynamo-do Ruby Gem

dynamo-do is a Ruby gem that simplifies interactions with Amazon DynamoDB. It Makes querying the DynamoDB tables easy and simple by providing a convenient interface by method chaining.

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'dynamo-do', git: "https://github.com/MuntasirShoumik/dynamo-do.git"
```

And then execute:

```bash
$ bundle install
```

## Usage

First, you need to configure aws by setting your region, access_key, secret_access_key in your environment

```bash
AWS_REGION=your-region-here
AWS_ACCESS_KEY_ID=your-access-key-id
AWS_SECRET_ACCESS_KEY=your-secret-access-key
```

Then import the gem

```ruby
require 'dynamo-do'
```

Note:

```
If your table's primary key does not include any sort key, just provide the partition key for performing the operations.
pk = "your_partition_key"
pk_val = "your_partition_keys_value"
sk = "sort_key"
sk_val = "sort_keys_value"
```

<b> Adding an item to an existing table </b>

```ruby
item = {
  p_id: "5", #pk
  entry_date: "2024-03-07", #sk
  name: "Shoes",
  price: 50,
  tags: ["Fashion", "Footwear"]
}
res = DynamoDo.add_item(table_name: "product", item: item)
puts "Add Item Response: #{res}"
```

<b> Getting an item from an existing table </b>

```ruby
res = DynamoDo.get_item_by(pk: "p_id", pk_val: "1", sk: "entry_date", sk_val: "2024-03-04", table_name: "product")
puts "Get Item Response: #{res}"
```

<b> Updating an item in an existing table </b>

```ruby
item = {
  name: "Iphone 15 pro",
  price: 1200
}
res = DynamoDo.update(table_name: "product", pk: "p_id", pk_val: "2", sk: "entry_date", sk_val: "2024-03-05", do_update: item)
puts "Update Item Response: #{res}"
```

<b> Deleting an item from an existing table </b>

```ruby
res = DynamoDo.delete(table_name: "product", pk: "p_id", pk_val: "1", sk: "entry_date", sk_val: "2024-03-04")
puts "Delete Item Response: #{res}"
```

<b> Describing an existing table </b>

```ruby
res = DynamoDo.describe_table("product")
puts "Describe Table Response: #{res}"
```

<b> Scanning an existing table </b>

The scan_table method is used to perform a scan operation on a DynamoDB table. It allows you to filter the results based on certain conditions.

`Methods:` <br>

`scan_table("Table_name"):` return all the items from the table. <br>
`where("attribute"):` Specifies the attribute to filter on. <br>
`equals(value):` Specifies that the attribute must be equal to the given value. <br>
`less_than(value):` Specifies that the attribute must be less than the given value. <br>
`less_or_eql(value):` Specifies that the attribute must be less than or equal to the given value. <br>
`greater_than(value):` Specifies that the attribute must be greater than the given value. <br>
`greateror_eql(value):` Specifies that the attribute must be greater than or equal to the given value. <br>
`and("attribute"):` Combines the previous condition with a logical AND with the next condition. <br>
`or("attribute"):` Combines the previous condition with a logical OR with the next condition. <br>
`limit(limit):` Specifies the maximum number of items to return. <br>
`execute:` Executes the scan operation and returns the result. <br>

```ruby
data = DynamoDo.scan_table("product").where("price").greater_than(100).and("tags").equal(["Electronics", "Smartphone"]).limit(10).execute
puts "Scan Table Response: #{data}"
```

<b> Querying an existing table </b>

The query_table method is used to perform a query operation on a DynamoDB table. It allows you to query items based on key conditions and sort the results.

`Methods:`<br>

`by_key("attribute", value):` Specifies the primary key attribute and its value for the query. <br>
`sort("attribute"):` Specifies the attribute to use for sorting the results. <br>
`equals(value):` Specifies that the attribute must be equal to the given value. <br>
`less_than(value):` Specifies that the attribute must be less than the given value. <br>
`less_or_eql(value):` Specifies that the attribute must be less than or equal to the given value. <br>
`greater_than(value):` Specifies that the attribute must be greater than the given value. <br>
`greater_or_eql(value):` Specifies that the attribute must be greater than or equal to the given value. <br>
`execute:` Executes the query operation and returns the result. <br>

```ruby
data = DynamoDo.query_table("product").by_key(pk: "p_id", val: "1").sort("entry_date").less_than("2024-03-07").execute
puts "Query Table Response: #{data}"
```
<br>
<hr>
<br>

## Contributing

Bug reports and pull requests are welcome.

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).
