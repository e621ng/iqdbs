require 'rubygems'
require 'bundler/setup'
Bundler.require(:default)

fileDir = File.dirname(__FILE__)

$LOAD_PATH.unshift File.join(fileDir, '..')
$LOAD_PATH.unshift File.expand_path("../../lib", __FILE__)

require "dotenv"
Dotenv.load

require "cityhash"
require "iqdb/responses/collection"
require "iqdb/responses/error"
require "iqdb/responses/responses"
require "iqdb/server"
require "iqdb/command"

require 'app/redis_init'
require 'app/workers/add_image'
require 'app/workers/remove_image'


