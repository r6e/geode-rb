require 'minitest/autorun'
require 'minitest/reporters'
require 'test-prof'

$LOAD_PATH.unshift File.expand_path('../lib', __dir__)
require 'geode'

TestProf::RubyProf.configure do |config|
  config.printer = :graph_html
end

TestProf::StackProf.configure do |config|
  config.format = 'html'
end

Minitest::Reporters.use!
