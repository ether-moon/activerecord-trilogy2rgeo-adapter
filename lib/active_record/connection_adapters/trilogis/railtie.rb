# frozen_string_literal: true

if defined?(Rails)
  require "rails/railtie"

  module ActiveRecord
    module ConnectionAdapters
      class TrilogisAdapter
        class Railtie < ::Rails::Railtie
          ActiveSupport.on_load(:active_record) do
            require "active_record/connection_adapters/trilogis/connection"
            ActiveRecord::Base.public_send :extend, ActiveRecord::ConnectionAdapters::TrilogisAdapter::Connection
          end
        end
      end
    end
  end
end

if defined?(Rails::DBConsole)
  require "trilogy_adapter/rails/dbconsole"
  Rails::DBConsole.prepend(ActiveRecord::ConnectionAdapters::TrilogisAdapter::Rails::DBConsole)
end
