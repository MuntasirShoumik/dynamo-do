require "aws-sdk-dynamodb"
module DynamoClient
  class << self
    def client
        @client ||=init_dynamodb_client
    end

    private
      
    def init_dynamodb_client
        Aws::DynamoDB::Client.new(
          region: ENV['AWS_REGION'],
          access_key_id: ENV['AWS_ACCESS_KEY_ID'],
          secret_access_key: ENV['AWS_SECRET_ACCESS_KEY']
        )
    end
  end
end