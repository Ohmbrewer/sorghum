require 'sinatra/base'
require 'sinatra/config_file'
require 'sinatra/json'
require 'sinatra/reloader'
require_relative 'lib/logging'
require_relative 'lib/version'
require_relative 'config/routes'

class SorghumApp < Sinatra::Application
  # Register some extensions...
  register Sinatra::JSON
  register Sinatra::ConfigFile
  configure :development do
    register Sinatra::Reloader
  end

  # We want logging...
  enable :logging

  # Load any config files...
  config_file './config/*'

  # Finally, include our module
  include Sorghum

end


