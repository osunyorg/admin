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
  end
end
