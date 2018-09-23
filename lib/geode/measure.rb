require 'forwardable'

# This adds helper functionality to the Numeric class which allows us to specify
# Measures in the form of 1.degree and 20.miles.
class Numeric
  def degrees
    Geode::Measure.new(self, :degree)
  end
  alias degree degrees

  def kilometers
    Geode::Measure.new(self, :kilometer)
  end
  alias kilometer kilometers

  def miles
    Geode::Measure.new(self, :mile)
  end
  alias mile miles

  def radians
    Geode::Measure.new(self, :radian)
  end
  alias radian radians
end

module Geode
  # Provides the ability to specify and convert between units. Current units
  # are radian, degree, kilometer, and mile. Measure inherits from Numeric, so
  # it has all of the capabilities of any other numeric.
  # Because this does perform conversions involving very long floats or
  # irrational numbers (e.g. pi), repeated conversion should be avoided due to
  # accumulation of error.
  class Measure < Numeric
    extend Forwardable

    UNITS = %i[radian degree kilometer mile].freeze

    attr_reader :unit, :value
    def_delegators :@value, :to_i, :to_f, :hash

    def initialize(value, unit)
      unit = unit.to_s.delete_suffix('s').to_sym # Accept plurals, but fix them
      unless UNITS.include?(unit.to_sym)
        msg = "Unknown unit #{unit} given. Must be one of #{UNITS.join(', ')}"
        raise UnitError, msg
      end

      @unit  = unit
      @value = value.to_f
    end

    def to_s
      num_value = (@value % 1).zero? ? @value.to_i : @value
      string_value = "#{num_value} #{@unit}"
      string_value << 's' unless @value == 1 || @value == -1
      string_value
    end
    alias inspect to_s

    def coerce(other)
      [convert_other(other), self]
    end

    def -@
      self.class.new(-@value, @unit)
    end

    def <=>(other)
      @value <=> convert_other(other).value if other.is_a? Numeric
    end

    def ==(other)
      convert_other(other).value <=> @value
    end

    def +(other)
      self.class.new(@value + convert_other(other).value, @unit)
    end

    def -(other)
      self.class.new(@value - convert_other(other).value, @unit)
    end

    def *(other)
      self.class.new(@value * convert_other(other).value, @unit)
    end

    def /(other)
      self.class.new(@value / convert_other(other).value, @unit)
    end

    def %(other)
      self.class.new(@value % convert_other(other).value, @unit)
    end

    def eql?(other)
      other.is_a?(Measure) && @value.eql?(convert_other(other).value)
    end

    def is_a?(klass)
      Measure == klass || @value.is_a?(klass)
    end
    alias kind_of? is_a?

    def instance_of?(klass)
      Measure == klass || @value.instance_of?(klass)
    end

    def degrees
      return self if @unit == :degree

      convert_self(:degree)
    end
    alias degree degrees

    def kilometers
      return self if @unit == :kilometer

      convert_self(:kilometer)
    end
    alias kilometer kilometers

    def miles
      return self if @unit == :mile

      convert_self(:mile)
    end
    alias mile miles

    def radians
      return self if @unit == :radian

      convert_self(:radian)
    end
    alias radian radians

    private

    def convert_other(other)
      if other.is_a? Geode::Measure
        other.send(@unit)
      elsif other.is_a? Numeric
        self.class.new(other, @unit)
      else
        raise TypeError, "#{other.class.name} can't be coerced into Numeric"
      end
    end

    def convert_self(new_unit)
      @value * CONVERSION_TABLE[@unit][new_unit]
    end
  end
end
