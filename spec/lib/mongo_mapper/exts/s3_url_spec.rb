require 'spec_helper'

describe MongoMapper::Exts::S3Url do
  let(:s3_hostname)             { "https://s3-eu-west-1.amazonaws.com" }
  let(:file_path)               { "bucket.name/root/subfolder/file.pdf" }
  let(:s3_url)                  { "#{s3_hostname}/#{file_path}"}
  let(:application_path)        { "files/#{file_path}" }
  let(:public_application_path) { "public/files/#{file_path}" }

  describe MongoMapper::Exts::S3Url::Proxy do
    class ProxyTestSubject
      include MongoMapper::Document

      key :url, String

      include MongoMapper::Exts::S3Url::Proxy
    end

    it 'updates #path when #url is set' do
      expect(ProxyTestSubject.new(url: s3_url).path).to eq application_path

      doc = ProxyTestSubject.new
      doc.url = s3_url

      expect(doc.path).to eq application_path
    end

    it '#path may be public' do
      expect(ProxyTestSubject.new(url: s3_url, public: true).path).to eq public_application_path
    end
  end

  describe 'URL conversions' do
    context 'AWS S3' do
      it 'to managed download path' do
        expect(MongoMapper::Exts::S3Url.origin_to_application_path(s3_url)).to eq application_path
      end

      it 'to managed public download path' do
        expect(MongoMapper::Exts::S3Url.origin_to_application_path(s3_url, public: true)).to eq public_application_path
      end

      it 'nil to nil' do
        expect(MongoMapper::Exts::S3Url.origin_to_application_path(nil)).to be_nil
      end
    end

    context 'upload parameters' do
      it 'to S3 URL' do
        params = {url: file_path[0..-5], format: 'pdf'}
        expect(MongoMapper::Exts::S3Url.upload_params_to_s3_url(params)).to eq s3_url
      end
    end
  end
end
