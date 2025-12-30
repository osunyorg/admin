class VariantService::ActiveStorage < VariantService
  GRAVITY_PER_CROP = {
    'top' => 'North',
    'right' => 'East',
    'bottom' => 'South',
    'left' => 'West',
    'center' => 'Center'
  }

  # FIXME Problem with host missing when called outside controller
  def url
    Rails.application.routes.url_helpers.url_for(blob_or_variant)
  end

  def blob_or_variant
    return blob unless blob.variable?
    transformations.empty? ? blob : blob.variant(transformations)
  end

  # Example params
  # {
  #   size: [1000, 1000],
  #   gravity: 'North',
  #   scale: 2
  # }
  def params
    @params ||= {
        size: size,
        gravity: gravity_keyword,
        scale: scale
      }.compact
  end

  # Example transformations
  # {
  #   resize_to_fill: [1000, nil, { gravity: 'Center' }],
  #   crop: '1000x+0+0',
  #   format: 'webp'
  # }
  # {
  #   resize_to_limit: [1000, 2000],
  #   format: 'webp'
  # }
  def transformations
    @transformations ||= begin
      transformations = {}
      # Resize and/or crop unless original size
      unless variant_dimensions == blob_size
        if gravity.present? && should_crop?
          transformations[:resize_to_fill] = [*variant_dimensions, { gravity: gravity_keyword }]
          transformations[:crop] = "#{variant_dimensions.join('x')}+0+0"
        elsif variant_dimensions_smaller_than_original?
          transformations[:resize_to_limit] = variant_dimensions
        end
      end
      transformations[:format] = format unless format_unchanged?
      transformations
    end
  end

  protected

  def gravity_keyword
    return if gravity.nil?
    GRAVITY_PER_CROP[gravity]
  end
end
