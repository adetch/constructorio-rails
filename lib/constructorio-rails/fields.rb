require 'singleton'

module ConstructorIORails
  class Fields
    include Singleton

    attr_accessor :set

    def initialize
      @set = {}
    end

    def add(model_name, field)
      @set[model_name] ||= {}
      @set[model_name][field] = 1
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

