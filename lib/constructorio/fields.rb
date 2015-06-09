require 'singleton'

module ConstructorIO
  class Fields
    include Singleton

    attr_accessor :set

    def initialize
      @set = {}
    end

    def add(model, field)
      @set[model] ||= {}
      if field.is_a?(String)
        @set[model][field] = {
          item_name: field
        }
      elsif field.is_a?(Hash)
        if ! field[:item_name] || ( field[:item_name].is_a?(String) && field[:item_name].empty? )
          raise ArgumentError.new("The field parameters must include an :item_name")
        else
          @set[model][field[:item_name]] = field
        end
      else
        raise ArgumentError.new("The field must be a string or a hash")
      end
    end

    def list(model_name)
      if @set[model_name].is_a?(Hash)
        @set[model_name].keys
      else
        []
      end
    end
  end
end

