$LOAD_PATH.unshift(File.join(File.dirname(__FILE__), '..', 'lib'))
$LOAD_PATH.unshift(File.dirname(__FILE__))

require 'rubygems'
require 'bundler/setup'
require 'dms'
require 'spec'
require 'webmock/rspec'

Spec::Runner.configure do |config|
  config.include WebMock::API
end