require 'contracts'
require 'mongo_mapper'
require 'active_support'

require "mongo_mapper/exts/version"


module MongoMapper
  module Exts
  end
end

require 'mongo_mapper/exts/embedded_document_finder'
require 'mongo_mapper/exts/unique_name'
require 'mongo_mapper/exts/duplicator'
require 'mongo_mapper/exts/s3_url'
