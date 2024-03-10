require_relative "lib/dynamo/do/version"

Gem::Specification.new do |spec|
  spec.name = "dynamo-do"
  spec.version = Dynamo::Do::VERSION
  spec.authors = ["MuntasirShoumik"]
  spec.email = ["shomikrahman.sr@gmail.com"]

  spec.summary = "DynamoDo: Simplifying DynamoDB operations in Ruby on Rails"
  spec.description = " DynamoDo is a Ruby gem designed to streamline and simplify DynamoDB operations within Ruby on Rails applications. 
    It provides a convenient interface for DynamoDB actions, making it easier for developers to query DynamoDB tables using a 
    method chaining interface. This gem can also perform basic operations such as adding items, retrieving items, updating records, and more."
  spec.homepage = "https://github.com/MuntasirShoumik/dynamo-do.git"
  spec.license = "MIT"
  spec.required_ruby_version = ">= 2.6.0"

  spec.metadata["allowed_push_host"] = "https://rubygems.org"

  spec.metadata["homepage_uri"] = spec.homepage
  spec.metadata["source_code_uri"] = "https://github.com/MuntasirShoumik/dynamo-do.git"
  spec.metadata["changelog_uri"] = "https://github.com/MuntasirShoumik/dynamo-do.git"

  spec.files = Dir.chdir(__dir__) do
    `git ls-files -z`.split("\x0").reject do |f|
      (File.expand_path(f) == __FILE__) ||
        f.start_with?(*%w[bin/ test/ spec/ features/ .git .github .circleci appveyor Gemfile])
    end
  end
  spec.bindir = "exe"
  spec.executables = spec.files.grep(%r{\Aexe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]
  spec.add_dependency "aws-sdk-dynamodb", "~> 1"
end
