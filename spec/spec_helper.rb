require 'yaml'

require_relative '../lib/addic7ed/errors'
require_relative '../lib/addic7ed/videofile'
require_relative '../lib/addic7ed/episode'
require_relative '../lib/addic7ed/subtitle'

RSpec.configure do |config|
  # Use color in STDOUT
  config.color = true

  # Use color not only in STDOUT but also in pagers and files
  #config.tty = true

  # Use the specified formatter
  config.formatter = :documentation # :progress, :html, :textmate

  config.raise_errors_for_deprecations!
end
