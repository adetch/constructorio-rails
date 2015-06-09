require 'constructorio/version'
require 'constructorio/configuration'
require 'constructorio/helper'
require 'constructorio/fields'
require 'active_record'
require 'faraday'
require 'active_support/core_ext/string/output_safety'
require 'json'

require 'constructorio/railtie' if defined?(Rails)

begin
  require 'pry'
rescue LoadError
end

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

  def autocomplete(fields, autocomplete_key = ConstructorIO.configuration.autocomplete_key)

    fields.each do |field|
      ConstructorIO::Fields.instance.add(self.model_name, field)
    end

    after_save do |record|
      updated_fields = record.changed.select do |changed|
        ConstructorIO::Fields.instance.list(record.class.model_name).include? changed
      end

      updated_fields.each do |field|
        field_data = ConstructorIO::Fields.instance.set[record.class.model_name][field]
        evaluated_field_data = record.class.send(:evaluate_field_data, record, field_data)
        record.class.send(
          :add_record,
          evaluated_field_data,
          autocomplete_key
        )
      end
    end

    before_destroy do |record|
      ConstructorIO::Fields.instance.list(record.class.model_name).each do |field|
        record.class.send(
          :delete_record,
          record[field.to_sym],
          autocomplete_key
        )
      end
    end
  end

  # should these be more unique to prevent collisions?
  def add_record(params, autocomplete_key)
    call_api("post", params, autocomplete_key)
  end

  def delete_record(params, autocomplete_key)
    call_api("delete", params, autocomplete_key)
  end

  private

  def call_api(method, params, autocomplete_key)
    @api_token = ConstructorIO.configuration.api_token
    @api_url = ConstructorIO.configuration.api_url || "https://ac.constructor.io/"
    @http_client ||= Faraday.new(url: @api_url)
    @http_client.basic_auth(@api_token, '')
    response = @http_client.send(method) do |request|
      request.url "/v1/item?autocomplete_key=#{autocomplete_key}"
      request.headers['Content-Type'] = 'application/json'
      request.body = params.to_json
    end
    if response.status.to_s =~ /^2/
      return nil
    else
      return response.status
    end
  end

  def evaluate_field_data(record, params)
    evaluated_params = {}
    params.each do |k,v|
      value = v.is_a?(Proc) ? v.call(record) : record.send(v.to_s)
      evaluated_params[k] = value
    end
    return evaluated_params
  end

end
