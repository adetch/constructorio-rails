require 'constructorio/version'
require 'constructorio/configuration'
require 'constructorio/helper'
require 'constructorio/fields'
require 'active_record'
require 'faraday'
require 'active_support/core_ext/string/output_safety'

require 'constructorio/railtie' if defined?(Rails)

begin
  require 'pry'
rescue LoadError
end

class MissingItemName < StandardError; end

module ConstructorIO

  class << self
    attr_accessor :configuration
  end

  def self.configuration
    @configuration ||= Configuration.new
  end

  def self.configure
    yield(configuration)
  end

  # This injects the methods on the included hook
  def self.included base
    base.send :include, InstanceMethods
    base.extend ClassMethods
  end

  module ClassMethods
    # Fields are expected to be something like:
    # { 'item_name' => 'some_name', 'metadata' => { metadata_one => ->{ something_dynamic }} }
    def autocomplete(fields, autocomplete_key = ConstructorIO.configuration.autocomplete_key)
      # All fields require an item_name
      field_names = fields.map { |f| f['item_name'] }
      raise MissingItemName if field_names.include? nil

      field_names.each do |field|
        ConstructorIO::Fields.instance.add(self.model_name.name, field)
      end

      after_save do |record|
        updated_fields = record.changed.select { |c| field_names.include? c }
        updated_fields.each do |field|
          record.send(:add_record, record[field.to_sym], autocomplete_key)
        end
      end

      before_destroy do |record|
        field_names.each do |field|
          record.send(:delete_record, record[field.to_sym], autocomplete_key)
        end
      end
    end
  end

  module InstanceMethods
    def add_record(value, autocomplete_key)
      call_api("post", value, autocomplete_key)
    end

    def delete_record(value, autocomplete_key)
      call_api("delete", value, autocomplete_key)
    end

    private

    def call_api(method, value, autocomplete_key)
      @api_token = ConstructorIO.configuration.api_token
      @api_url = ConstructorIO.configuration.api_url || "https://ac.constructor.io/"
      @http_client ||= Faraday.new(url: @api_url)
      @http_client.basic_auth(@api_token, '')
      response = @http_client.send(method) do |request|
        request.url "/v1/item?autocomplete_key=#{autocomplete_key}"
        request.headers['Content-Type'] = 'application/json'
        request.body = %Q|{"item_name": "#{value}"}|
      end
      if response.status.to_s =~ /^2/
        return nil
      else
        return response.status
      end
    end
  end
end
