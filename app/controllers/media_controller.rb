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

  # Resize a blob, coming from Vue advanced cropper
  # answers with another blob
  def resize
    @rotation = params.dig(:rotation)
    @left = params.dig(:left)
    @top = params.dig(:top)
    @width = params.dig(:width)
    @height = params.dig(:height)
    @untouched =  @rotation == 0 &&
                  @left == 0 && 
                  @top == 0 &&
                  @width == @blob.metadata.dig(:width) &&
                  @height == @blob.metadata.dig(:height)
    if @untouched
      @resized_blob = @blob
    else
      transformations = { :'auto-orient' => true }
      # Handle rotation
      transformations[:rotate] = @rotation if @rotation.present?
      # Handle cropping
      transformations[:crop] = "#{@width}x#{@height}+#{@left}+#{@top}"
      # Finalize by repaging
      transformations.merge!({
        repage: true,
        :'+' => true
      })
      @resized_blob = @blob.variant(**transformations).processed.image
    end
    render json: {
      id: @resized_blob.id,
      signed_id: @resized_blob.signed_id,
      checksum: @resized_blob.checksum,
    }
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
