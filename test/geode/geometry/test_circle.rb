require 'test_helper'

class CircleTest < Minitest::Test
  def setup
    @subject = Geode::Circle
  end

  def test_it_is_not_yet_implemented
    assert_raises(NotImplementedError) do
      @subject.new
    end
  end
end
