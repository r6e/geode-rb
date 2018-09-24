require 'test_helper'

class RectangleTest < Minitest::Test
  def setup
    @subject = Geode::Rectangle
  end

  def test_it_creates_rectangle_from_corners
    bottom_right = Geode::Point.new(0, 0)
    top_left     = Geode::Point.new(2, 2)

    rectangle = Geode::Rectangle.from_corners(bottom_right, top_left)
    assert_equal rectangle.corners[0], bottom_right
    assert_equal rectangle.corners[1], top_left
  end
end
