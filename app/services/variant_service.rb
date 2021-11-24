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
      if params[:size].present?
        split_size = params[:size].split('x')
        dimensions = Array.new(2) { |i| split_size[i].blank? ? nil : split_size[i].to_i }
      else
        dimensions = blob_size
      end
      dimensions.map! { |dimension| dimension * params[:scale].to_i if dimension.is_a?(Integer) } if params[:scale].present?
      # If one of the dimensions is greater than the original one, no crop and resize to limit
      crop_dimensions_are_valid = dimensions.all?(&:present?) && dimensions[0] <= blob_size[0].to_i && dimensions[1] <= blob_size[1].to_i

      # Resize and/or crop unless original size
      unless dimensions == blob_size
        if params[:gravity].present? && crop_dimensions_are_valid
          transformations[:resize_to_fill] = [*dimensions, { gravity: params[:gravity] }]
          transformations[:crop] = "#{dimensions.join('x')}+0+0"
        else
          transformations[:resize_to_limit] = dimensions
        end
      end

      transformations[:format] = @format if @format.present? && @format != @blob.filename.extension_without_delimiter
      transformations
    end
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

  def format
    @format
  end

  protected

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
    size = SIZE_REGEX.match(filename)[1]
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
