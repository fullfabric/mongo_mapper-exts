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
        return s3_url if s3_url.blank?
        s3_url.gsub(ORIGIN_DOMAIN_NAME_PATTERN, opts.fetch(:public, false) ? 'public/files' : 'files')
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
