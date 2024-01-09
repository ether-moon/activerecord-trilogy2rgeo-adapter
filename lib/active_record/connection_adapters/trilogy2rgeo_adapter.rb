# frozen_string_literal: true

# The activerecord-trilogy2rgeo-adapter gem installs the *trilogy2rgeo*
# connection adapter into ActiveRecord.

# :stopdoc:

require "rgeo/active_record"

require "active_record/connection_adapters"
require "active_record/connection_adapters/trilogy_adapter"
require "active_record/connection_adapters/trilogy2rgeo/version"
require "active_record/connection_adapters/trilogy2rgeo/column_methods"
require "active_record/connection_adapters/trilogy2rgeo/schema_creation"
require "active_record/connection_adapters/trilogy2rgeo/schema_statements"
require "active_record/connection_adapters/trilogy2rgeo/spatial_table_definition"
require "active_record/connection_adapters/trilogy2rgeo/spatial_column"
require "active_record/connection_adapters/trilogy2rgeo/spatial_column_info"
require "active_record/connection_adapters/trilogy2rgeo/spatial_expressions"
require "active_record/connection_adapters/trilogy2rgeo/arel_tosql"
require "active_record/type/spatial"

# :startdoc:

module ActiveRecord
  module ConnectionHandling # :nodoc:
    # Establishes a connection to the database that's used by all Active Record objects.
    def trilogy2rgeo_connection(config)
      configuration = config.dup

      # Set FOUND_ROWS capability on the connection so UPDATE queries returns number of rows
      # matched rather than number of rows updated.
      configuration[:found_rows] = true

      options = [
        configuration[:host],
        configuration[:port],
        configuration[:database],
        configuration[:username],
        configuration[:password],
        configuration[:socket],
        0
      ]

      ActiveRecord::ConnectionAdapters::Trilogy2RgeoAdapter.new nil, logger, options, configuration
    end
  end

  module ConnectionAdapters
    class Trilogy2RgeoAdapter < TrilogyAdapter
      ADAPTER_NAME = "Trilogy2Rgeo"
      AXIS_ORDER_LONG_LAT = "'axis-order=long-lat'".freeze

      include Trilogy2Rgeo::SchemaStatements

      SPATIAL_COLUMN_OPTIONS =
        {
          geometry:            {},
          geometrycollection:  {},
          linestring:          {},
          multilinestring:     {},
          multipoint:          {},
          multipolygon:        {},
          spatial:             { type: "geometry" },
          point:               {},
          polygon:             {}
        }.freeze

      # http://postgis.17.x6.nabble.com/Default-SRID-td5001115.html
      DEFAULT_SRID = 0
      GEOGRAPHIC_SRID = 4326

      %w[
              geometry
              geometrycollection
              point
              linestring
              polygon
              multipoint
              multilinestring
              multipolygon
            ].each do |geo_type|
        ActiveRecord::Type.register(geo_type.to_sym, adapter: :trilogy2rgeo) do |sql_type|
          Type::Spatial.new(sql_type.to_s)
        end
      end

      def initialize(connection, logger, connection_options, config)
        super

        @visitor = Arel::Visitors::Trilogy2Rgeo.new(self)
      end

      def self.spatial_column_options(key)
        SPATIAL_COLUMN_OPTIONS[key]
      end

      def default_srid
        DEFAULT_SRID
      end

      def native_database_types
        # Add spatial types
        # Reference: https://dev.mysql.com/doc/refman/5.6/en/spatial-type-overview.html
        super.merge(
          geometry:            { name: "geometry" },
          geometrycollection:  { name: "geometrycollection" },
          linestring:          { name: "linestring" },
          multi_line_string:   { name: "multilinestring" },
          multi_point:         { name: "multipoint" },
          multi_polygon:       { name: "multipolygon" },
          spatial:             { name: "geometry" },
          point:               { name: "point" },
          polygon:             { name: "polygon" }
        )
      end

      class << self

        private
          def initialize_type_map(m)
            super

            %w[
              geometry
              geometrycollection
              point
              linestring
              polygon
              multipoint
              multilinestring
              multipolygon
            ].each do |geo_type|
              m.register_type(geo_type,Type.lookup(geo_type.to_sym, adapter: :trilogy2rgeo))
            end
          end
      end

      TYPE_MAP = Type::TypeMap.new.tap { |m| initialize_type_map(m) }
      TYPE_MAP_WITH_BOOLEAN = Type::TypeMap.new(TYPE_MAP).tap do |m|
        m.register_type %r(^tinyint\(1\))i, Type::Boolean.new
      end

      def supports_spatial?
        !mariadb? && version >= "5.7.6"
      end

      def quote(value)
        dbval = value.try(:value_for_database) || value
        if RGeo::Feature::Geometry.check_type(dbval)
          "ST_GeomFromWKB(0x#{RGeo::WKRep::WKBGenerator.new(hex_format: true, little_endian: true).generate(dbval)},#{dbval.srid}, #{AXIS_ORDER_LONG_LAT})"
        else
          super
        end
      end

      private
        def type_map
          emulate_booleans ? TYPE_MAP_WITH_BOOLEAN : TYPE_MAP
        end
    end
  end
end
