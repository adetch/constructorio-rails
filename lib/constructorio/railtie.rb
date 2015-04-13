require 'rails'

module ConstructorIO
  class Railtie < Rails::Railtie
    initializer 'constructorio.action_view' do
      ActiveSupport.on_load(:action_view) do
        include ConstructorIO::Helper
      end
    end

    rake_tasks do
      Dir[File.join(File.dirname(__FILE__),'tasks/*.rake')].each { |f| load f }
    end
  end
end
