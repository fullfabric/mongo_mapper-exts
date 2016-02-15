module MongoMapper
  module Exts
    module Duplicator

      def duplicate
      end

      # Returns a copy of the attributes of the object it is called on.
      #
      # @option options [Array] :blacklist a list of attributes to ignore
      # @return [Hash ] a hash of attributes
      def duplicate_attributes options = {}

        blacklist = options.fetch( :blacklist, [] )

        clean_up self.attributes, blacklist

      end

      private

        def clean_up attributes, blacklist

          return attributes unless attributes.is_a?(Hash)

          blacklist.each { |key| attributes.delete key.to_s }

          attributes.each do |key, value|

            if value.is_a?( Hash )
              clean_up value, blacklist
            elsif value.is_a?( Array )
              value.map { |attributes| clean_up attributes, blacklist }
            end

          end

          attributes

        end

    end
  end
end
