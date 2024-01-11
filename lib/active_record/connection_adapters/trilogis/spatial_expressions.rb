# frozen_string_literal: true

module RGeo
  module ActiveRecord
    module Trilogis
      module SpatialExpressions
        def st_distance_sphere(rhs, units = nil)
          args = [self, rhs]
          args << units.to_s if units
          SpatialNamedFunction.new("ST_Distance_Sphere", args, [false, true, true, false])
        end
      end
    end
  end
end

# Allow chaining of spatial expressions from attributes
Arel::Attribute.include RGeo::ActiveRecord::Trilogis::SpatialExpressions
RGeo::ActiveRecord::SpatialConstantNode.include RGeo::ActiveRecord::Trilogis::SpatialExpressions
RGeo::ActiveRecord::SpatialNamedFunction.include RGeo::ActiveRecord::Trilogis::SpatialExpressions
