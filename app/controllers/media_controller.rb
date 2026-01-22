class MediaController < ApplicationController
  skip_before_action :authenticate_user!

  before_action :load_blob

  def show
    service = VariantService.manage(@blob, params)
    if service.blob_or_variant.present?
      # ActiveStorage
      redirect_to url_for(service.blob_or_variant)
    else
      # KeyCDN
      redirect_to service.url, allow_other_host: true
    end
  end

  def download
    send_data URI.parse(@blob.url).read,
              type: "#{@blob.content_type}",
              disposition: "attachment; filename=#{@blob.filename.to_s}"
  end

  def static
    @about = @blob
    render  template: 'admin/active_storage/blobs/static',
            layout: false,
            content_type: "text/plain; charset=utf-8"
  end

  def resize
    resizer = Osuny::Media::Resizer.new(@blob, params)
    render json: resizer.to_json
  end

  protected

  def load_blob
    begin
      @blob = ActiveStorage::Blob.find_signed! params[:signed_id]
      raise_404_unless(@blob.university_id == current_university.id)
    rescue ActiveSupport::MessageVerifier::InvalidSignature
      raise ActiveRecord::RecordNotFound
    end
  end
end
