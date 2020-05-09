require 'test_helper'
class PointTest < Minitest::Test
  def setup
    @subject  = Geode::Point
    @origin   = Geode::Point.new(0.degrees, 0.degrees)
    @terminus = Geode::Point.new(2.degrees, 2.degrees)
    @midpoint = Geode::Point.new(1.degree, 1.degree)
    @bearing  = 44.98.degrees
    @distance = 314.5.kilometers

    # The expected worst-case accuracy of the Haversine algorithm for distance
    # is 0.5%. We're testing the implementation here, not the mathematical
    # principles themselves, so @distance is a good-enough estimate and we won't
    # hit worst-case in these tests anyway.
    @delta = 0.0005
  end

  def test_it_creates_point_from_degrees
    lat   = 82.773.degrees
    lon   = -17.453.degrees
    point = @subject.new(lat, lon)

    assert_equal lat, point.latitude.value
    assert_equal lon, point.longitude.value
  end

  def test_it_keeps_degrees_as_degrees
    bare_point = @subject.new(23.456, 7)
    assert_equal 23.456.degrees, bare_point.latitude.value
    assert_equal 7.0.degrees, bare_point.longitude.value
  end

  def test_it_converts_kilometers_to_degrees
    km_point = @subject.new(5.kilometers, 10.kilometers)
    assert_equal 0.04499122057929272.degrees, km_point.latitude.value
    assert_equal 0.08998244115858545.degrees, km_point.longitude.value
  end

  def test_it_converts_miles_to_degrees
    mi_point = @subject.new(5.miles, 10.miles)
    assert_equal 0.07240635089196126.degrees, mi_point.latitude.value
    assert_equal 0.14481270178392253.degrees, mi_point.longitude.value
  end

  def test_it_converts_radians_to_degrees
    rad_point = @subject.new(1.2.radians, 3.radians)
    assert_equal 68.75493541569878.degrees, rad_point.latitude.value
    assert_equal 171.88733853924697.degrees, rad_point.longitude.value
  end

  def test_it_converts_mixed_units_to_degrees
    mix_point = @subject.new(5.kilometers, 3.radians)
    assert_equal 0.04499122057929272.degrees, mix_point.latitude.value
    assert_equal 171.88733853924697.degrees, mix_point.longitude.value
  end

  def test_it_fails_when_degrees_out_of_range
    assert_raises(Geode::CoordinateError) { @subject.new(91, 0) }
    assert_raises(Geode::CoordinateError) { @subject.new(-91, 0) }
    assert_raises(Geode::CoordinateError) { @subject.new(0, 181) }
    assert_raises(Geode::CoordinateError) { @subject.new(0, -181) }
  end

  def test_has_correct_string_output
    point = @subject.new(24.5, -8)
    assert_equal '24.5,-8.0', point.to_s
  end

  def test_it_calculates_distance
    distance = @origin.distance_to(@terminus)

    assert_in_delta @distance, distance, @distance * @delta
  end

  def test_it_calculates_bearing_to
    bearing = @origin.bearing_to(@terminus)

    assert_in_delta @bearing, bearing, @bearing * @delta
  end

  def test_it_calculates_final_bearing_to
    bearing = @origin.final_bearing_to(@terminus)

    assert_in_delta 45.017.degrees, bearing, @bearing * @delta
  end

  def test_it_calculates_midpoint_between
    result = @origin.midpoint_to(@terminus)
    d_dist = @origin.distance_to(@midpoint) * @delta

    assert @midpoint.distance_to(result) < d_dist
  end

  def test_it_calculates_intermediate_point_between
    result = @origin.intermediate_point_to(@terminus, 0.5)
    d_dist = @origin.distance_to(@midpoint) * @delta

    assert @midpoint.distance_to(result) < d_dist
  end

  def test_it_calculates_destination_point
    result = @origin.destination_point(@bearing, @distance)
    d_dist = @origin.distance_to(@terminus) * @delta

    assert @terminus.distance_to(result) < d_dist
  end
end
