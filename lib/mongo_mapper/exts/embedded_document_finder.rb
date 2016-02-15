module MongoMapper
  module Exts
    module EmbeddedDocumentFinder

      extend ActiveSupport::Concern

      included do
        class_eval %( class << self; attr_accessor :klass; end )
      end

      module ClassMethods

        # Sets up finder
        #
        # @param [String] class name
        # @option options [String] path
        # @option options [String] nodes
        # @option options [String] clause
        def find_through class_or_class_name, options = {}

          options = HashWithIndifferentAccess.new( options )

          @klass = class_or_class_name.to_s

          @path    = options.fetch( :path, "" ).to_s
          @nodes   = @path.split "."
          @clause  = @path + "._id"

        end

        def inherited subclass
          subclass.instance_variable_set :@klass,  instance_variable_get( :@klass  )
          subclass.instance_variable_set :@path,   instance_variable_get( :@path   )
          subclass.instance_variable_set :@nodes,  instance_variable_get( :@nodes  )
          subclass.instance_variable_set :@clause, instance_variable_get( :@clause )
          super
        end

        # Finds entity by id
        #
        # @param [BSON::ObjectId, String] id
        # @option options [Hash]
        # @return [Object, nil] the object or nil if not found
        def find id, options = {}

          raise "class or class name required" unless @klass.present?
          raise "path required" unless @nodes.size > 0

          id      = id.is_a?( BSON::ObjectId ) ? id : BSON::ObjectId( id )
          options = HashWithIndifferentAccess.new( options )

          if document = @klass.constantize.first( @clause => id )
            embedded_documents = @nodes.inject( [ document ] ) { | documents, key| documents.map { |document| document.send( key.to_sym ) }.flatten }.compact
            embedded_documents.detect { |embedded_document| embedded_document.id.to_s == id.to_s }
          end

        rescue BSON::InvalidObjectId
          nil
        end

        # Finds entity by id
        #
        # @param [BSON::ObjectId, String] id
        # @param options [Hash]
        # @return [Object] the object
        # @raise [MongoMapper::DocumentNotFound] if not found
        def find! id, options = {}

          find( id, options ) ||
            raise( MongoMapper::DocumentNotFound.new("#{self.to_s} with id #{id} not found") )

        end

        # @see #find
        def find_by_id id, options = {}
          find id, options = {}
        end

        # @see #find!
        def find_by_id! id, options = {}
          find! id, options = {}
        end


      end

    end
  end

end
