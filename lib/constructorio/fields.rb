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
      @set[model][field] = 1
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

