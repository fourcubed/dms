module DMS
  require 'httparty'
  require 'openssl'
  require 'base64'
  
  autoload :API, 'dms/api'
  autoload :Node, 'dms/node'
  
  class RecordNotFound < RuntimeError; end
end