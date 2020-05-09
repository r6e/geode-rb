require 'test_helper'

class LineTest < Minitest::Test
  def setup
    @subject  = Geode::Line
    @origin   = Geode::Point.new(0.degrees, 0.degrees)
    @terminus = Geode::Point.new(2.degrees, 2.degrees)
    @bearing  = 44.98.degrees
    @distance = 314.5.kilometers

    # The expected worst-case accuracy of the Haversine algorithm for distance
    # is 0.5%. We're testing the implementation here, not the mathematical
    # principles themselves, so @distance is a good-enough estimate and we won't
    # hit worst-case in these tests anyway.
    @delta = 0.0005
  end

  def test_it_creates_line_between_points
    line = @subject.between_points(@origin, @terminus)

    assert_equal @origin, line.origin
    assert_equal @terminus, line.terminus
  end

  def test_it_calculates_line_from_point
    line   = @subject.from_point(@origin, @bearing, @distance)
    d_dist = @origin.distance_to(@terminus) * @delta

    assert @terminus.distance_to(line.terminus) < d_dist
  end

  def test_it_calculates_correctly_when_crossing_the_pole
    distance  = 19_792.7.kilometers
    bearing   = 0.0.degrees
    line      = @subject.from_point(@terminus, bearing, distance)
    latitude  = line.terminus.latitude
    longitude = line.terminus.longitude

    assert_in_delta 0.0, latitude, 0.101
    assert_in_delta(-178.0, longitude, 0.101)
  end

  def test_it_fails_when_bearing_out_of_range
    assert_raises(Geode::BearingError) do
      @subject.from_point(@origin, -1.degrees, @distance)
    end
    assert_raises(Geode::BearingError) do
      @subject.from_point(@origin, 361.degrees, @distance)
    end
  end
end
