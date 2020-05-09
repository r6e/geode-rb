module Geode
  # Describes a line between two points on the earth's surface. Provides
  # measurements of the line's bearing, distance, origin, and terminus.
  class Line
    attr_reader :origin, :terminus

    # Creates a new Geode::Line from the given origin and terminus points.
    #
    # @param origin [Geode::Point] the originating point for the line
    # @param terminus [Geode::Point] the terminating point of the line
    # @return [Geode::Line] a new line calculated from the given origin/terminus
    def self.between_points(origin, terminus)
      new(origin, terminus: terminus)
    end

    # Creates a new Geode::Line with the given origin, bearing, and distance.
    # The bearing is the initial bearing, or the bearing of the line at the
    # point of origin. This must be taken into account because the bearing of a
    # curved line (or in this case, a straight line on a curved surface) is not
    # constant
    #
    # @param origin [Geode::Point] the originating point for the line
    # @param bearing [Numeric] the initial bearing, given in degrees
    # @param distance [Numeric] the distance of the line, default in kilometers
    def self.from_point(origin, bearing, distance)
      bearing_degrees = bearing.degrees

      unit_distance =
        if distance.is_a?(Geode::Measure)
          distance
        else
          distance.kilometers
        end

      raise BearingError unless BEARING_RANGE.include? bearing_degrees

      new(origin, bearing: bearing_degrees, distance: unit_distance)
    end

    private

    # Bearing should be specified as degrees clockwise from true north
    def initialize(origin, terminus: nil, bearing: nil, distance: nil)
      @origin   = origin
      @terminus = terminus || origin.destination_point(bearing, distance)
    end

    def distance_to(origin, terminus)
      # The haversine formula
      origin_latitude, origin_longitude = lat_lon_for(origin)
      terminus_latitude, terminus_longitude = lat_lon_for(terminus)

      2 * RADIAN * Math.asin(
        Math.sqrt(
          Math.sin((terminus_latitude - origin_latitude) / 2)**2 +
          Math.cos(terminus_latitude) * Math.cos(origin_latitude) *
          Math.sin((terminus_longitude - origin_longitude) / 2)**2
        )
      ).abs.kilometers
    end

    def bearing_to(origin, terminus)
      origin_latitude, origin_longitude = lat_lon_for(origin)
      terminus_latitude, terminus_longitude = lat_lon_for(terminus)

      Math.atan2(
        Math.sin(terminus_longitude - origin_longitude) *
        Math.cos(terminus_latitude),
        Math.cos(origin_latitude) * Math.sin(terminus_latitude) -
        Math.sin(origin_latitude) * Math.cos(terminus_latitude) *
        Math.cos(terminus_longitude - origin_longitude)
      ).radians.degrees
    end

    def lat_lon_for(point)
      [point.latitude.radians.value, point.longitude.radians.value]
    end
  end
end
