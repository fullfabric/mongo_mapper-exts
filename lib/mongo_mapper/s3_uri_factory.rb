module MongoMapper
  class S3UriFactory

    def self.build_path_from_url(url_on_s3, opts={})
      return url_on_s3 if url_on_s3.blank?
      # match https://s3-eu-west-1.amazonaws.com/fullfabric.env/tbs or
      # https://fullfabric-env.s3-eu-west-1.amazonaws.com/tbs and replace
      # using this regex means we don't need to know the actual bucket/tenant
      url_on_s3.
        gsub(Regexp.new("https://s3[-.]+.*amazonaws.com/[a-z\.\-]+/[a-z0-9]+/"), opts.fetch(:public, false) ? 'public/files/' : 'files/').
        gsub(Regexp.new("https://[a-z\-]+[-.]+s3[-.]+.*amazonaws.com/[a-z0-9]+/"), opts.fetch(:public, false) ? 'public/files/' : 'files/')
    end

    def self.build_s3_url_from_http_params(params)
      aws_s3_domain = "https://s3-eu-west-1.amazonaws.com" # we shouldn't have this hardcoded here
      "#{aws_s3_domain}/#{params[:url]}.#{params[:format]}"
    end

  end
end
