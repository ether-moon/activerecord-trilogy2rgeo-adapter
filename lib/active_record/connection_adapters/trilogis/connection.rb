# frozen_string_literal: true

require "trilogy"
require "active_record/connection_adapters/trilogy_adapter"
require "active_record/connection_adapters/trilogis_adapter"

module ActiveRecord
  module ConnectionAdapters
    class TrilogisAdapter
      module Connection
        def trilogy_adapter_class
          ActiveRecord::ConnectionAdapters::TrilogisAdapter
        end
      end
    end
  end
end
