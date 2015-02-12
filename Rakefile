require 'rubygems'
require 'bundler/setup'

Bundler.require

require_all 'lib'
# Dir.glob('./lib/*.rb').each(&method(:require))
# Dir.glob('./src/*.rb').each(&method(:require))


task :default do
  Gosu::enable_undocumented_retrofication

  Game.new.show
end
