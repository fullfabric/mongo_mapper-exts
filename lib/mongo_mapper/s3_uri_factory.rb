module MongoMapper
  class S3UriFactory

    ORIGIN_DOMAIN_NAME         = "https://s3-eu-west-1.amazonaws.com"
    ORIGIN_DOMAIN_NAME_PATTERN = Regexp.new(ORIGIN_DOMAIN_NAME)

    def self.build_path_from_url(url_on_s3, opts={})
      return url_on_s3 if url_on_s3.blank?
      url_on_s3.gsub(ORIGIN_DOMAIN_NAME_PATTERN, opts.fetch(:public, false) ? 'public/files' : 'files')
    end

    def self.build_s3_url_from_http_params(params)
      "#{ORIGIN_DOMAIN_NAME}/#{params[:url]}.#{params[:format]}"
    end

  end
end
