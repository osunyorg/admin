class MediaController < ApplicationController
  skip_before_action :authenticate_user!

  before_action :load_blob

  def show
    if @blob.variable?
      variant_service = VariantService.compute(@blob, params[:filename_with_transformations], params[:format])
      transformations = variant_service.transformations
      if transformations.empty?
        blob_or_variant_url = url_for @blob
      else
        variant = @blob.variant transformations
        blob_or_variant_url = url_for variant
      end
    else
      blob_or_variant_url = url_for(@blob)
    end
    redirect_to blob_or_variant_url
  end

  def download
    data = URI.parse(@blob.url).read
    send_data data,
              type: "#{@blob.content_type}",
              disposition: "attachment; filename=#{@blob.filename.to_s}"
  end

  def static
    @about = @blob
    render  template: 'admin/active_storage/blobs/static',
            layout: false,
            content_type: "text/plain; charset=utf-8"
  end

  protected

  def load_blob
    begin
      @blob = ActiveStorage::Blob.find_signed! params[:signed_id]
      raise_404_unless(@blob.university == current_university)
    rescue ActiveSupport::MessageVerifier::InvalidSignature
      raise ActiveRecord::RecordNotFound
    end
  end
end
