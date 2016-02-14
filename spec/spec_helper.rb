require 'mongo_mapper/exts'
require 'factory_girl'
require 'faker'
require 'pry-byebug'

config = { test: { database: 'FF_test_default', host: '127.0.0.1', port: '27017'} }
MongoMapper.setup(config, 'test')
MongoMapper.database = 'FF_test_default'

# require 'factories'
# FactoryGirl.factories.clear
# FactoryGirl.definition_file_paths = ['spec/factories']
# FactoryGirl.find_definitions

