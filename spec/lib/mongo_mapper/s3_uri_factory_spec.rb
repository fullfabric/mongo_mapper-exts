describe MongoMapper::S3UriFactory do

  let(:s3_hostname)             { "https://s3-eu-west-1.amazonaws.com" }
  let(:file_path)               { "bucket.name/root/subfolder/file.pdf" }
  let(:s3_url)                  { "#{s3_hostname}/#{file_path}"}
  let(:application_path)        { "files/#{file_path}" }
  let(:public_application_path) { "public/files/#{file_path}" }

  describe '.build_path_from_url' do
    it 'creates download path' do
      expect(described_class.build_path_from_url(s3_url)).to eq application_path
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
      params = {url: file_path[0..-5], format: 'pdf'}
      expect(described_class.build_s3_url_from_http_params(params)).to eq s3_url
    end
  end

end
