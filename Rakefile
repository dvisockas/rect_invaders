require 'rubygems'
require 'bundler/setup'

Bundler.require

require_all 'lib'

task :default do
  Gosu::enable_undocumented_retrofication

  Game.new.show
end
