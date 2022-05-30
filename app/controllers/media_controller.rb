class MediaController < ApplicationController
  skip_before_action :authenticate_user!

  def show
    @blob = ActiveStorage::Blob.find_signed! params[:signed_id]
    @size = @blob.byte_size
    if @blob.variable?
      variant_service = VariantService.compute(@blob, params[:filename_with_transformations], params[:format])
      transformations = variant_service.transformations
      if transformations.empty?
        blob_or_variant_url = url_for @blob
      else
        variant = @blob.variant transformations
        @size = variant.processed.image.byte_size
        blob_or_variant_url = url_for variant
      end
    else
      blob_or_variant_url = url_for(@blob)
    end
    response.headers["Content-Length"] = "#{@size}"
    redirect_to blob_or_variant_url
  end
end
