require 'minitest/autorun'
require 'minitest/reporters'

$LOAD_PATH.unshift File.expand_path('../lib', __dir__)
require 'geode'

Minitest::Reporters.use!
