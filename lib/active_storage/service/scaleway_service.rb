# frozen_string_literal: true

# cf https://github.com/rails/rails/issues/41070

require 'active_storage/service/s3_service.rb'

module ActiveStorage
  class Service::ScalewayService < Service::S3Service

    def headers_for_direct_upload(key, content_type:, checksum:, filename: nil, disposition: nil, **)
      content_disposition = content_disposition_with(type: disposition, filename: filename) if filename

      headers = public? ? { "x-amz-acl" => "public-read" } : {}

      headers.merge({ "Content-Type" => content_type, "Content-MD5" => checksum, "Content-Disposition" => content_disposition })
    end

    private

    def public_url(key, **options)
      disposition, filename, content_type = options.values_at(:disposition, :filename, :content_type)
      uri = URI.parse(object_for(key).public_url)
      uri.query = URI.encode_www_form({
        "response-content-disposition" => content_disposition_with(type: disposition, filename: filename),
        "response-content-type" => content_type
      })
      uri.to_s
    end
  end
end
