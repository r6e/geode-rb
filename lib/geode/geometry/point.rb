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
      delta = distance_to(other)
      delta *= -1 if bearing_to(other).negative?

      delta
    end

    # Algorithms below adapted from Javascript by Chris Veness. Originals found
    # at https://www.movable-type.co.uk/scripts/latlong.html copyright 2002-2017
    # Chris Veness, licensed under the MIT license

    # Returns the distance in kilometers from this point to a given destination
    #
    # @param point [Geode::Point] the destination point
    # @return [Geode::Measure] the distance in km to the destination point
    def distance_to(point)
      lat_a = latitude.radians.value
      lat_b = point.latitude.radians.value
      d_lat = lat_b - lat_a
      d_lon = point.longitude.radians.value - longitude.radians.value

      part_a = Math.sin(d_lat / 2)**2 +
               Math.cos(lat_a) *
               Math.cos(lat_b) *
               Math.sin(d_lon / 2)**2
      part_b = 2 * Math.atan2(Math.sqrt(part_a), Math.sqrt(1 - part_a))

      (RADIUS_OF_EARTH * part_b).kilometers
    end

    # Returns the bearing in degrees from this point to a given destination
    #
    # @param point [Geode::Point] the destination point
    # @return [Geode::Measure] the bearing in degrees to the destination point
    def bearing_to(point)
      lat_a = latitude.radians.value
      lat_b = point.latitude.radians.value
      d_lon = point.longitude.radians.value - longitude.radians.value

      y_dir = Math.sin(d_lon) * Math.cos(lat_b)
      x_dir = Math.cos(lat_a) * Math.sin(lat_b) -
              Math.sin(lat_a) * Math.cos(lat_b) * Math.cos(d_lon)

      (Math.atan2(y_dir, x_dir).radians.degrees + 360) % 360 # Normalize
    end

    # Returns the final bearing in degrees from this point at the destination
    #
    # @param point [Geode::Point] the destination point
    # @return [Geode::Measure] the bearing in degrees at the destination point
    def final_bearing_to(point)
      (point.bearing_to(self) + 180) % 360
    end

    # Returns the midpoint between this point and a given destination
    #
    # @param point [Geode::Point] the destination point
    # @return [Geode::Point] the midpoint between this and the destination point
    def midpoint_to(point)
      lat_a = latitude.radians.value
      lon_a = longitude.radians.value
      lat_b = point.latitude.radians.value
      d_lon = point.longitude.radians.value - longitude.radians.value

      b_x = Math.cos(lat_b) * Math.cos(d_lon)
      b_y = Math.cos(lat_b) * Math.sin(d_lon)

      lat_c =
        Math.atan2(
          Math.sin(lat_a) + Math.sin(lat_b),
          Math.sqrt((Math.cos(lat_a) + b_x) * (Math.cos(lat_a) + b_x) + b_y**2)
        ).radians
      lon_c = (lon_a + Math.atan2(b_y, Math.cos(lat_a) + b_x)).radians

      Point.new(lat_c.degrees, lon_c.degrees)
    end

    # Returns the midpoint between this point and a given destination
    #
    # @param point [Geode::Point] the destination point
    # @param fraction [Numeric] the fraction of distance to find the point
    # @return [Geode::Point] the midpoint between this and the destination point
    def intermediate_point_to(point, fraction)
      lat_a = latitude.radians.value
      lon_a = longitude.radians.value
      lat_b = point.latitude.radians.value
      lon_b = point.longitude.radians.value

      d_rad = distance_to(point).radians.value

      part_a = Math.sin((1 - fraction) * d_rad) / Math.sin(d_rad)
      part_b = Math.sin(fraction * d_rad) / Math.sin(d_rad)

      x_dir = part_a * Math.cos(lat_a) * Math.cos(lon_a) +
              part_b * Math.cos(lat_b) * Math.cos(lon_b)
      y_dir = part_a * Math.cos(lat_a) * Math.sin(lon_a) +
              part_b * Math.cos(lat_b) * Math.sin(lon_b)
      z_dir = part_a * Math.sin(lat_a) + part_b * Math.sin(lat_b)

      lat_c = Math.atan2(z_dir, Math.sqrt(x_dir**2 + y_dir**2)).radians
      lon_c = Math.atan2(y_dir, x_dir).radians

      Point.new(lat_c.degrees, (lon_c.degrees + 540) % 360 - 180) # Normalize
    end

    # Returns the midpoint between this point and a given destination
    #
    # @param point [Geode::Point] the destination point
    # @param fraction [Numeric] the fraction of distance to find the point
    # @return [Geode::Point] the midpoint between this and the destination point
    def destination_point(bearing, distance)
      lat_a = latitude.radians.value
      lon_a = longitude.radians.value

      b_rad = bearing.radians.value
      d_rad = distance.radians.value

      lat_b =
        Math.asin(
          Math.sin(lat_a) * Math.cos(d_rad) +
          Math.cos(lat_a) * Math.sin(d_rad) * Math.cos(b_rad)
        ).radians

      # This differs slightly from the reference; here we subtract because the
      # Ruby implementation of atan2 has the x-axis flipped (positive-right) vs
      # geographic values (positive-left)
      lon_b =
        lon_a + Math.atan2(
          Math.sin(b_rad) * Math.sin(d_rad) * Math.cos(lat_a),
          Math.cos(d_rad) - Math.sin(lat_a) * Math.sin(lat_b)
        ).radians

      # Normalize
      lon_b = (lon_b.degrees + 540) % 360 - 180
      lat_b = (lat_b.degrees + 270) % 180 - 90

      Point.new(lat_b, lon_b)
    end
  end
end
