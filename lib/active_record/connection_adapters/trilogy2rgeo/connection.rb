# frozen_string_literal: true

require "trilogy"
require "active_record/connection_adapters/trilogy_adapter"
require "active_record/connection_adapters/trilogy2rgeo_adapter"

module ActiveRecord
  module ConnectionAdapters
    class Trilogy2RgeoAdapter
      module Connection
        def trilogy_adapter_class
          ActiveRecord::ConnectionAdapters::Trilogy2RgeoAdapter
        end
      end
    end
  end
end
