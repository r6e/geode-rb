$LOAD_PATH.unshift File.expand_path('../lib', __dir__)
require 'geode'

require 'minitest/autorun'
require 'minitest/reporters'
require 'simplecov'

SimpleCov.start
Minitest::Reporters.use!
