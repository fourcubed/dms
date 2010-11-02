module DMS
  require 'httparty'
  require 'openssl'
  require 'base64'
  
  autoload :API, 'dms/api'
  autoload :Node, 'dms/node'
  
  class ResourceNotFound < RuntimeError; end
  class AuthenticationError < RuntimeError; end
  class UnknownError < RuntimeError; end
end