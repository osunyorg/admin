class VariantService
  GRAVITY_PER_CROP = {
    'top' => 'North',
    'right' => 'East',
    'bottom' => 'South',
    'left' => 'West',
    'center' => 'Center'
  }

  SCALE_REGEX = /@[23]x$/
  CROP_REGEX = /_crop_(#{GRAVITY_PER_CROP.keys.join('|')})$/
  SIZE_REGEX = /_([0-9]+x[0-9]*|[0-9]*x[0-9]+)$/

  def self.manage(blob, params)
    return blob unless blob.variable?
    variant_service = compute(blob, params[:filename_with_transformations], params[:format])
    transformations = variant_service.transformations
    if transformations.empty?
      blob
    else
      variant = blob.variant transformations
      variant
    end
  end

  def self.keycdn_manage(blob, params)
    return unless ENV["KEYCDN_HOST"].present? && blob.variable?
    variant_service = compute(blob, params[:filename_with_transformations], params[:format])
    keycdn_url_params = variant_service.keycdn_url_params
    query_string = URI.encode_www_form(keycdn_url_params)
    "https://#{ENV["KEYCDN_HOST"]}/#{blob.key}?#{query_string}"
  end

  def self.compute(blob, filename, format)
    new blob, filename, format
  end

  def initialize(blob, filename, format)
    @blob = blob
    @filename = filename
    @format = format
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
        if params[:gravity].present? && crop_dimensions_are_valid
          transformations[:resize_to_fill] = [*variant_dimensions, { gravity: params[:gravity] }]
          transformations[:crop] = "#{variant_dimensions.join('x')}+0+0"
        else
          transformations[:resize_to_limit] = variant_dimensions
        end
      end

      transformations[:format] = variant_format if variant_format.present?
      transformations
    end
  end

  def keycdn_url_params
    @keycdn_url_params ||= begin
      params = {}
      # Resize and/or crop unless original size
      unless variant_dimensions == blob_size
        if params[:gravity].present? && crop_dimensions_are_valid
          params = { width: variant_dimensions[0], height: variant_dimensions[1] }
          params[:position] = keycdn_position if keycdn_position.present?
        elsif variant_dimensions[0].present?
          params = { width: variant_dimensions[0], enlarge: 0 }
        else
          params = { height: variant_dimensions[1], enlarge: 0 }
        end
      end
      params[:format] = variant_format if variant_format.present?
      params
    end
  end

  def variant_dimensions
    @variant_dimensions ||= begin
      dimensions = params[:size].present? ? params[:size] : blob_size
      dimensions = dimensions.map { |dimension|
        dimension * params[:scale].to_i if dimension.is_a?(Integer)
      } if params[:scale].present?
      dimensions
    end
  end

  def variant_format
    return if @format.blank? || @format == @blob.filename.extension_without_delimiter
    @format
  end

  # If one of the dimensions is greater than the original one, no crop and resize to limit
  def crop_dimensions_are_valid
    variant_dimensions.size == 2 &&
      variant_dimensions.all?(&:present?) &&
      variant_dimensions[0] <= blob_size[0].to_i &&
      variant_dimensions[1] <= blob_size[1].to_i
  end

  # Example params
  # {
  #   size: ['1000', '1000'],
  #   gravity: 'North',
  #   scale: '2'
  # }
  def params
    @params ||= begin
      filename_dup = @filename.dup
      params = {}
      params[:scale], filename_dup = extract_scale_from_filename(filename_dup)
      params[:gravity], filename_dup = extract_gravity_from_filename(filename_dup)
      params[:size], filename_dup = extract_size_from_filename(filename_dup)
      params.compact
    end
  end

  protected

  def keycdn_position
    return @keycdn_position if defined?(@keycdn_position)
    @keycdn_position ||= begin
      position = GRAVITY_PER_CROP.detect { |key, value| value == params[:gravity] }&.first
      # Ignore center position as it's the default one
      position.in?([nil, 'center']) ? nil : position
    end
  end

  def extract_scale_from_filename(filename)
    return [nil, filename] unless SCALE_REGEX.match? filename
    scale = filename.ends_with?('@2x') ? 2 : 3
    clean_filename = filename.gsub(SCALE_REGEX, '')
    [scale, clean_filename]
  end

  def extract_gravity_from_filename(filename)
    return [nil, filename] unless CROP_REGEX.match? filename
    gravity = GRAVITY_PER_CROP.detect { |key, value| filename.ends_with?("_crop_#{key}") }&.last
    clean_filename = filename.gsub(CROP_REGEX, '')
    [gravity, clean_filename]
  end

  def extract_size_from_filename(filename)
    return [nil, filename] unless SIZE_REGEX.match? filename
    string_size = SIZE_REGEX.match(filename)[1]
    split_size = string_size.split('x')
    size = Array.new(2) { |i| split_size[i].blank? ? nil : split_size[i].to_i }
    clean_filename = filename.gsub(SIZE_REGEX, '')
    [size, clean_filename]
  end

  def blob_size
    @blob_size ||= begin
      @blob.analyze unless @blob.analyzed?
      @blob.metadata.slice('width', 'height').values
    end
  end
end
