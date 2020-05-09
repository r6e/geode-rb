require 'test_helper'

class CircleTest < Minitest::Test
  def setup
    @subject = Geode::Circle
    @center  = Geode::Point.new(0.degrees, 0.degrees)
    @radius  = 200.kilometers
    @delta   = 0.0005
  end

  def test_it_creates_circle_from_center_and_radius
    circle = @subject.new(@center, @radius)

    assert_equal @center, circle.center
    assert_equal @radius, circle.radius
  end

  def test_it_verifies_point_in_circle
    circle = @subject.new(@center, @radius)
    point  = Geode::Point.new(1.degrees, 1.degrees)

    assert circle.contains?(point)
  end

  def test_it_verifies_points_not_in_circle
    circle = @subject.new(@center, @radius)
    point  = Geode::Point.new(2.degrees, 2.degrees)

    assert !circle.contains?(point)
  end

  def test_it_creates_bounding_box_from_circle
    circle = @subject.new(@center, @radius)

    bounding_box = circle.bounding_box
    top_left     = bounding_box.corners[1]
    bottom_right = bounding_box.corners[0]

    assert_in_delta 1.7986.degrees, top_left.latitude, @delta
    assert_in_delta 1.7986.degrees, top_left.longitude, @delta

    assert_in_delta -1.7986.degrees, bottom_right.latitude, @delta
    assert_in_delta -1.7986.degrees, bottom_right.longitude, @delta
  end
end
