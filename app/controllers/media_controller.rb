class MediaController < ApplicationController
  def show
    @blob = ActiveStorage::Blob.find_signed! params[:signed_id]
    variant_service = VariantService.compute(@blob, params[:filename_with_transformations], params[:format])
    transformations = variant_service.transformations
    blob_or_variant_url = transformations.empty?  ? url_for(@blob)
                                                  : url_for(@blob.variant(transformations))

    render json: { transformations: transformations, url: blob_or_variant_url }
  end
end
