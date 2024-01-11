# frozen_string_literal: true

module ActiveRecord # :nodoc:
  module ConnectionAdapters # :nodoc:
    module Trilogis # :nodoc:
      class TableDefinition < MySQL::TableDefinition # :nodoc:
        include ColumnMethods
        # super: https://github.com/rails/rails/blob/master/activerecord/lib/active_record/connection_adapters/abstract/schema_definitions.rb
        def new_column_definition(name, type, **options)
          if (info = TrilogisAdapter.spatial_column_options(type.to_sym))
            if (limit = options.delete(:limit)) && limit.is_a?(::Hash)
              options.merge!(limit)
            end

            geo_type = ColumnDefinitionUtils.geo_type(options[:type] || type || info[:type])

            options[:spatial_type] = geo_type
            column = super(name, geo_type.downcase.to_sym, **options)
          else
            column = super(name, type, **options)
          end

          column
        end
      end

      module ColumnDefinitionUtils
        class << self
          def geo_type(type = "GEOMETRY")
            type.to_s.delete("_").upcase
          end
        end
      end
    end
  end
end
