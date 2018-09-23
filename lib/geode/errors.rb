module Geode
  class GeodeError < RuntimeError
  end

  class CoordinateError < GeodeError
    def initialize(message = nil)
      if message.nil?
        message = <<-MESSAGE
          Invalid coordinate(s) specified.
          Latitude must be in #{LATITUDE_RANGE}
          Longitude must be in #{LONGITUDE_RANGE}
        MESSAGE
      end

      super(message)
    end
  end

  class BearingError < GeodeError
    def initialize(message = nil)
      if message.nil?
        message = <<-MESSAGE
          Invalid bearing specified. Bearing must be specified as compass point
          or degrees clockwise from true north within #{BEARING_RANGE}
        MESSAGE
      end

      super(message)
    end
  end

  class UnitError < GeodeError; end
end
