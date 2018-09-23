require 'test_helper'

class MeasureTest < Minitest::Test
  def setup
    @subject = Geode::Measure
  end

  def test_numerics_return_new_instance_with_unit
    assert_equal :degree, 1.degree.unit
    assert_equal :kilometer, 1.kilometer.unit
    assert_equal :mile, 1.mile.unit
    assert_equal :radian, 1.radian.unit
  end

  def test_numerics_return_new_instance_with_given_value
    assert_equal 1.1, 1.1.degrees.value
    assert_equal 2.2, 2.2.kilometers.value
    assert_equal 3.3, 3.3.miles.value
    assert_equal 4.4, 4.4.radians.value
  end

  def test_it_accepts_both_singular_and_plural_units
    assert_equal @subject.new(1, :degree), @subject.new(1, :degrees)
    assert_equal @subject.new(1, :kilometer), @subject.new(1, :kilometers)
    assert_equal @subject.new(1, :mile), @subject.new(1, :miles)
    assert_equal @subject.new(1, :radian), @subject.new(1, :radians)

  end

  def test_it_rases_error_for_bad_units
    assert_raises(Geode::UnitError) { @subject.new(1, :not_a_unit) }
  end

  def test_it_outputs_string_with_unit
    assert_equal '1 degree', 1.degree.to_s
    assert_equal '2 kilometers', 2.kilometers.to_s
    assert_equal '3 miles', 3.miles.to_s
    assert_equal '4 radians', 4.radians.to_s
  end

  def test_it_casts_values_for_math_operations
    assert_equal (1.degree + 2.kilometers).unit, :degree
    assert_equal (1.kilometer - 2.miles).unit, :kilometer
    assert_equal (1.mile * 2.radians).unit, :mile
    assert_equal (1.radian / 2.degrees).unit, :radian
    assert_equal (3.degrees % 4.miles).unit, :degree
  end

  def test_it_rases_error_for_incompatible_types
    assert_raises(TypeError) { 1.degree + 'what is this i dont even' }
    assert_raises()
  end

  def test_it_converts_to_degrees_correctly
    assert_equal 1.degree, 1.degree.degrees
    assert_equal 0.008998244115858544.degrees, 1.kilometer.degrees
    assert_equal 0.014481270178392253.degrees, 1.mile.degrees
    assert_equal 57.29577951308232.degrees, 1.radian.degrees
  end

  def test_it_converts_to_kilometers_correctly
    assert_equal 111.13279292318774.kilometers, 1.degree.kilometers
    assert_equal 1.kilometer, 1.kilometer.kilometers
    assert_equal 1.609344.kilometers, 1.mile.kilometers
    assert_equal 6367.44.kilometers, 1.radian.kilometers
  end

  def test_it_converts_to_miles_correctly
    assert_equal 69.0547160353459.miles, 1.degree.miles
    assert_equal 0.621371192237334.miles, 1.kilometer.miles
    assert_equal 1.mile, 1.mile.miles
    assert_equal 3956.5437842996894.miles, 1.radian.miles
  end

  def test_it_converts_to_radians_correctly
    assert_equal 0.017453292519943295.radians, 1.degree.radians
    assert_equal 0.00015704898671993768.radians, 1.kilometer.radians
    assert_equal 0.0002527458444838114.radians, 1.mile.radians
    assert_equal 1.radian, 1.radian.radians
  end
end
