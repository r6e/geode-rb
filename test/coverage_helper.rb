require 'simplecov'

SimpleCov.start do
  add_filter(/(^|#{File::PATH_SEPARATOR})test#{File::PATH_SEPARATOR}/)
  coverage_dir File.join('tmp', 'coverage')
end
