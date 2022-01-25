class MediaController < ApplicationController
  def show
    @blob = ActiveStorage::Blob.find_signed! params[:signed_id]
    @size = @blob.byte_size
    if @blob.variable?
      variant_service = VariantService.compute(@blob, params[:filename_with_transformations], params[:format])
      transformations = variant_service.transformations
      blob_or_variant_url = transformations.empty? ? url_for(@blob) : url_for(@blob.variant(transformations))
    else
      blob_or_variant_url = url_for(@blob)
    end
    response.headers["Content-Length"] = "#{@size}"
    redirect_to blob_or_variant_url
  end
end
