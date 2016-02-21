module MongoMapper
  module Exts
    module S3Url

      # Adds 'path' key and updates it based on the value of 'url'. While 'url' stores the original S3 path,
      # 'path' stores the path used by our S3 proxy, allowing us to serve S3 files securily.
      #
      # @note This module needs to be included after the key 'url' has been defined.
      module Proxy

        extend ActiveSupport::Concern

        included do

          key :path, String, required: false

          alias_method :original_url=, :url=

          def url=(value)
            self.original_url = value
            update_path
          end

        end

        private

          def update_path
            self.path = S3Url.origin_to_application_path(self.url)
          end

      end

      def self.origin_to_application_path(s3_url)
        return s3_url if s3_url.blank?
        s3_url.gsub(ORIGIN_DOMAIN_NAME_PATTERN, 'files')
      end

      def self.upload_params_to_s3_url(params)
        "#{ORIGIN_DOMAIN_NAME}/#{params[:url]}.#{params[:format]}"
      end

      private

        ORIGIN_DOMAIN_NAME         = "https://s3-eu-west-1.amazonaws.com"
        ORIGIN_DOMAIN_NAME_PATTERN = Regexp.new(ORIGIN_DOMAIN_NAME)

    end

  end
end
