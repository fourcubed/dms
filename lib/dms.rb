module DMS
  require 'httparty'
  require 'openssl'
  require 'base64'
  require 'dms/api'
  require 'dms/node'
  
  class ResourceNotFound < RuntimeError; end
  class AuthenticationError < RuntimeError; end
  class UnknownError < RuntimeError; end
end