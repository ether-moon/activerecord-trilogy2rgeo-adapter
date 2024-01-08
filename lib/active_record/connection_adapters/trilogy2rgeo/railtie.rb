# frozen_string_literal: true

if defined?(Rails)
  require "rails/railtie"

  module ActiveRecord
    module ConnectionAdapters
      class Trilogy2RgeoAdapter
        class Railtie < ::Rails::Railtie
          ActiveSupport.on_load(:active_record) do
            require "active_record/connection_adapters/trilogy2rgeo/connection"
            ActiveRecord::Base.public_send :extend, ActiveRecord::ConnectionAdapters::Trilogy2RgeoAdapter::Connection
          end
        end
      end
    end
  end
end

if defined?(Rails::DBConsole)
  require "trilogy_adapter/rails/dbconsole"
  Rails::DBConsole.prepend(ActiveRecord::ConnectionAdapters::Trilogy2RgeoAdapter::Rails::DBConsole)
end
