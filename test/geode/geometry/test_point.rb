require 'test_helper'

class PointTest < Minitest::Test
  def setup
    @subject = Geode::Point
  end

  def test_it_creates_point_from_degrees
    point = @subject.new(82.773.degrees, -17.453.degrees)
    assert_equal 82.773.degrees, point.latitude.value
    assert_equal(-17.453.degrees, point.longitude.value)
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
end
