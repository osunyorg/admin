class MediaController < ApplicationController
  def show
    @blob = ActiveStorage::Blob.find_signed! params[:signed_id]
    variant_service = VariantService.compute(@blob, params[:filename_with_transformations], params[:format])
    transformations = variant_service.transformations
    if !@blob.variable? || transformations.empty?
      blob_or_variant_url = url_for(@blob)
    else
      blob_or_variant_url = url_for(@blob.variant(transformations))
    end

    redirect_to blob_or_variant_url
  end
end
