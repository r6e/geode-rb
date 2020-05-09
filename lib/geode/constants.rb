module Geode
  RADIUS_OF_EARTH = 6371.0088 # Radius of Earth, per IUGG

  # Base units, in km
  KILOMETER = 1
  RADIAN    = RADIUS_OF_EARTH

  # Derived units
  MILE   = 1.609344 # In km, per international standard
  DEGREE = Math::PI / 180 # In radians

  # Easy conversion: CONVERSION_TABLE[:from][:to]
  CONVERSION_TABLE = {
    degree:    {
      degree:    1.degree,
      kilometer: (DEGREE * RADIAN).kilometers,
      mile:      ((DEGREE * RADIAN) / MILE).miles,
      radian:    DEGREE.radians
    },
    kilometer: {
      degree:    (1 / (DEGREE * RADIAN)).degrees,
      kilometer: 1.kilometer,
      mile:      (KILOMETER / MILE).miles,
      radian:    (KILOMETER / RADIAN).radians
    },
    mile:      {
      degree:    (MILE / (DEGREE * RADIAN)).degrees,
      kilometer: MILE.kilometers,
      mile:      1.mile,
      radian:    (MILE / RADIAN).radians
    },
    radian:    {
      degree:    (1 / DEGREE).degrees,
      kilometer: RADIAN.kilometers,
      mile:      (RADIAN / MILE).miles,
      radian:    1.radian
    }
  }.freeze

  # Boundaries
  LATITUDE_RANGE  = (-90.degrees..90.degrees).freeze
  LONGITUDE_RANGE = (-180.degrees..180.degrees).freeze
  BEARING_RANGE   = (0.degrees..360.degrees).freeze

  # Compass Directions
  N   = 0.degrees
  NNE = 22.5.degrees
  NE  = 45.degrees
  ENE = 67.5.degrees
  E   = 90.degrees
  ESE = 112.5.degrees
  SE  = 135.degrees
  SSE = 157.5.degrees
  S   = 180.degrees
  SSW = 202.5.degrees
  SW  = 225.degrees
  WSW = 247.5.degrees
  W   = 270.degrees
  WNW = 292.5.degrees
  NW  = 315.degrees
  NNW = 337.5.degrees
end
