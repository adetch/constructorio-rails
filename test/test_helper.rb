require 'minitest/autorun'
require 'minitest/unit'
require 'mocha/mini_test'
require_relative '../lib/constructorio'


ActiveRecord::Base.establish_connection(
  adapter: 'sqlite3',
  database: ':memory:'
)

ActiveRecord::Schema.define do
  create_table :people, force: true do |t|
    t.string :first_name
    t.string :last_name
    t.string :address
  end
end

ConstructorIO.configure do |config|
  config.api_token = "example_api_token"
  config.autocomplete_key = "example_autocomplete_key"
  config.api_url = "http://example.constructor.io"
end

class Person < ActiveRecord::Base
  include ConstructorIO

  autocomplete [{
    'item_name' => 'first_name',
    'metadata' => {
      'test_metadata' => 'test_values',
      'test_proc' => ->{ self.address.upcase }
    }
  }], "person_autocomplete_key"
end

class PersonNoKey < ActiveRecord::Base
  self.table_name = 'people'

  include ConstructorIO

  autocomplete [{'item_name' => 'last_name'}]
end

class FakeView
  include ConstructorIO::Helper
end
