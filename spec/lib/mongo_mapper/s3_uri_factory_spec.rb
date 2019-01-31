describe MongoMapper::S3UriFactory do

  let(:s3_url)                  { "https://s3-eu-west-1.amazonaws.com/bucket-name/tenant/subfolder/file.pdf"}
  let(:application_path)        { "files/subfolder/file.pdf" }
  let(:public_application_path) { "public/files/subfolder/file.pdf" }

  describe '.build_path_from_url' do

    context 'creates download path' do

      # There are two types of AWS URLs: http://www.wryway.com/blog/aws-s3-url-styles/
      it 'creates download path for https://s3-eu-west-1.amazonaws.com/bucket-name/tenant/subfolder/file.pdf' do
        expect(described_class.build_path_from_url(s3_url)).to eq application_path
      end

      it 'creates download path for https://s3.eu-central-1.amazonaws.com/bucket-name/tenant/subfolder/file.pdf' do
        s3_url = "https://s3.eu-central-1.amazonaws.com/bucket-name/tenant/subfolder/file.pdf"
        expect(described_class.build_path_from_url(s3_url)).to eq application_path
      end

      it 'creates download path for https://bucket-name.s3.region.amazonaws.com' do
        s3_url = "https://bucket-name.s3.eu-central-1.amazonaws.com/tenant/subfolder/file.pdf"
        expect(described_class.build_path_from_url(s3_url)).to eq application_path
      end

    end

    it 'creates public download path' do
      expect(described_class.build_path_from_url(s3_url, public: true)).to eq public_application_path
    end

    it 'nil to nil' do
      expect(described_class.build_path_from_url(nil)).to be_nil
    end
  end

  describe '.build_s3_url_from_http_params' do

    it 'creates s3 url' do
      params = { url: "bucket-name/tenant/subfolder/file", format: 'pdf' }
      expect(described_class.build_s3_url_from_http_params(params)).to eq s3_url
    end

  end

end
