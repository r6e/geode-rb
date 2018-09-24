module Geode
  # Describes a simple lat/lon point within the geographic coordinate system
  class Point
    include Comparable

    attr_reader :latitude, :longitude

    # Creates a new Point. Latitude and longitude supplied in any thing _but_
    # degrees (e.g. radians, km from 0,0, etc.) will be converted into degrees.
    #
    # @param latitude [Numeric] latitude between -90 and 90 degrees
    # @param longitude [Numeric] longitude between -180 and 180 degrees
    def initialize(latitude, longitude)
      @latitude  = latitude.degrees
      @longitude = longitude.degrees

      unless LATITUDE_RANGE.include?(@latitude) &&
             LONGITUDE_RANGE.include?(@longitude)
        raise CoordinateError
      end
    end

    def to_s
      "#{latitude.value},#{longitude.value}"
    end
    alias inspect to_s

    def <=>(other)
      own_line   = Line.between_points(self, Point.new(0, 0))
      other_line = Line.between_points(other, Point.new(0, 0))
      own_line.distance <=> other_line.distance
    end
  end
end
