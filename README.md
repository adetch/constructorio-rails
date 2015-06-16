# Constructor.io

A Ruby client for the [Constructor.io API](http://constructor.io/docs).  Constructor.io provides a lightning-fast, typo-tolerant autocomplete service that ranks your users' queries by popularity to let them find what they're looking for as quickly as possible.

## Installation

Add this line to your application's Gemfile:

    gem 'constructorio'

And then execute:

    $ bundle

Or install it yourself:

    $ gem install customerio

## Usage

### Configuration for Rails

Add an initializer file at config/initializers/constructor-io.rb with values from the [customer dashboard](http://constructor.io/dashboard):
```
ConstructorIO.configure do |config|
  config.api_token = 'API_TOKEN'
  config.autocomplete_key = 'AUTOCOMPLETE_KEY'
end
```
To add autocomplete to a model:

```
class MyModel < ActiveRecord::Base
  include ConstructorIO
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
