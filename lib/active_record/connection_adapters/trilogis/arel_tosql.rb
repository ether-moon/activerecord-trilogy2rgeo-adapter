# frozen_string_literal: true

module Arel # :nodoc:
  module Visitors # :nodoc:
    class Trilogis < MySQL # :nodoc:

      include RGeo::ActiveRecord::SpatialToSql

      if ::Arel::Visitors.const_defined?(:BindVisitor)
        include ::Arel::Visitors::BindVisitor
      end

      FUNC_MAP = {
        "st_wkttosql" => "ST_GeomFromText",
        "st_wkbtosql" => "ST_GeomFromWKB",
        "st_length" => "ST_Length"
      }.freeze

      def st_func(standard_name)
        FUNC_MAP[standard_name.downcase] || standard_name
      end

      def visit_String(node, collector)
        node, srid = Trilogis.parse_node(node)
        collector << wkttosql_statement(node, srid)
      end

      def visit_RGeo_ActiveRecord_SpatialNamedFunction(node, collector)
        aggregate(st_func(node.name), node, collector)
      end

      def visit_in_spatial_context(node, collector)
        case node
        when String
          node, srid = Trilogis.parse_node(node)
          collector << wkttosql_statement(node, srid)
        when RGeo::Feature::Instance
          collector << visit_RGeo_Feature_Instance(node, collector)
        when RGeo::Cartesian::BoundingBox
          collector << visit_RGeo_Cartesian_BoundingBox(node, collector)
        else
          visit(node, collector)
        end
      end

      def self.parse_node(node)
        value, srid = nil, 0
        if node =~ /.*;.*$/i
          params = Regexp.last_match(0).split(";")
          if params.first =~ /(srid|SRID)=\d*/
            srid = params.first.split("=").last.to_i
          else
            value = params.first
          end
          if params.last =~ /(srid|SRID)=\d*/
            srid = params.last.split("=").last.to_i
          else
            value = params.last
          end
        else
          value = node
        end
        [value, srid]
      end

      private

      def wkttosql_statement(node, srid)
        func_name = st_func("ST_WKTToSQL")

        args = [quote(node)]
        args << srid unless srid.zero?
        args << ActiveRecord::ConnectionAdapters::TrilogisAdapter::AXIS_ORDER_LONG_LAT

        "#{func_name}(#{args.join(', ')})"
      end
    end
  end
end
