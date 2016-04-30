# Constructor.io

A Rails client for the [Constructor.io API](https://constructor.io/docs).  Constructor.io provides a lightning-fast, typo-tolerant autocomplete service that ranks your users' queries by popularity to let them find what they're looking for as quickly as possible.

## Installation

Add this line to your application's Gemfile:

    gem 'constructorio-rails'

And then execute:

    $ bundle

Or install it yourself:

    $ gem install constructorio-rails

## Usage

### Configuration for Rails

Add an initializer file at config/initializers/constructor-io.rb with values from the [customer dashboard](https://constructor.io/dashboard):
```
ConstructorIORails.configure do |config|
  config.api_token = 'API_TOKEN'
  config.autocomplete_key = 'AUTOCOMPLETE_KEY'
  config.autocomplete_section = 'Search Suggestions'
end
```
To add autocomplete to a model:

```
class MyModel < ActiveRecord::Base
  include ConstructorIORails
  constructorio_autocomplete(['attribute1', 'attribute2'])
end

```

To attach an autocomplete dropdown to an input field, just insert this in your view:

```
<%= constructorio_autocomplete(dom_id: 'id_of_input_field') %>
```

To import an existing data set into Constructor.io, you can use the rake task:

```
rake constructorio:import:model CLASS='MyModel'
```
