module Geode
  # Describes a simple circle within the geographic coordinate system. This is
  # represented internally as a point and radius, with other values calculated
  class Circle
    attr_reader :center, :radius

    def initialize(center, radius)
      @center = center
      @radius = radius.kilometers
    end

    def contains?(point)
      center.distance_to(point) < radius
    end

    def bounding_box
      # This gets a little weird; since we're starting at a midpoint, we have
      # to calculate two boxes (upper left, lower right) and use their extrema
      max = Rectangle.from_point_and_dimensions(center, radius, -radius)
      min = Rectangle.from_point_and_dimensions(center, -radius, radius)

      Rectangle.from_corners(max.corners[1], min.corners[0])
    end
  end
end
