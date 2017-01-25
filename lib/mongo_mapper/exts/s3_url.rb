module MongoMapper
  module Exts
    module S3Url
      module Proxy
        extend ActiveSupport::Concern

        included do
          # Transitory phase of the managed downloads implementation.
          # TODO: Set require to true on full implementation rollout
          key :path, String, required: false
          key :public, Boolean, required: true, default: false

          alias_method :original_url=, :url=
          alias_method :original_public=, :public=

          def url=(value)
            self.original_url = value
            update_path
            value
          end

          def public=(value)
            self.original_public = value
            update_path
            value
          end
        end

        private

        def update_path
          self.path = S3Url.origin_to_application_path(self.url, public: self.public)
        end
      end

      def self.origin_to_application_path(s3_url, opts={})
        ::MongoMapper::S3UriFactory.build_path_from_url(s3_url, opts)
      end

      def self.upload_params_to_s3_url(params)
        ::MongoMapper::S3UriFactory.build_s3_url_from_http_params(params)
      end

    end
  end
end
