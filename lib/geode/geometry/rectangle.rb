module Geode
  class Rectangle
    attr_reader :height, :width, :corners

    # Defined by a line along its diagonal
    def self.from_line(line)
      new(line.origin, line.terminus)
    end

    # Two opposing corners
    def self.from_corners(point_a, point_b)
      new(point_a, point_b)
    end

    # Point and height/width as signed values indicating direction
    def self.from_point_and_dimensions(point, height, width)
      bearing  = height.positive? ? 0.degrees : 180.degrees
      corner_a = Line.from_point(point, bearing, height.abs).terminus

      bearing  = width.positive? ? 270.degrees : 90.degrees
      corner_b = Line.from_point(point, bearing, width.abs).terminus

      point_b = Point.new(
        corner_a.terminus.latitude,
        corner_b.terminus.longitude
      )

      new(point, point_b)
    end

    def contains?(point)
      point.latitude >= min_point.latitude &&
        point.latitude <= max_point.latitude &&
        point.longitude >= min_point.longitude &&
        point.longitude <= max_point.longitude
    end

    private

    # Representing as a line is probably easiest
    def initialize(point_a, point_b)
      latitudes  = [point_a.latitude, point_b.latitude].minmax
      longitudes = [point_a.longitude, point_b.longitude].minmax

      min_point = Point.new(latitudes[0], longitudes[0])
      max_point = Point.new(latitudes[1], longitudes[1])

      @corners = [min_point, max_point]
      @height  = (max_point.latitude - min_point.latitude).kilometers
      @width   = (max_point.longitude - min_point.longitude).kilometers
    end
  end
end
