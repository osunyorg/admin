class VariantService
  GRAVITIES = [
    'top',
    'right',
    'bottom',
    'left',
    'center'
  ]

  SIZE_REGEX = /^[^_]*_([0-9]+x[0-9]*|[0-9]*x[0-9]+).*(?:\.[a-z]+)?$/i

  def self.manage(blob, params)
    use_keycdn = params.dig(:keycdn) == 'true'
    use_keycdn  ? VariantService::KeyCdn.new(blob, params)
                : VariantService::ActiveStorage.new(blob, params)
  end

  attr_reader :blob, :incoming_params, :filename

  def initialize(blob, incoming_params)
    @blob = blob
    @incoming_params = incoming_params
    @filename = incoming_params[:filename_with_transformations]
  end

  def url
    raise NoMethodError, 'You must implement this method in the service'
  end

  def blob_or_variant
    nil
  end

  def format
    # Forced format
    incoming_params.dig(:format) ||
      # Format inferred from filename with transformations
      File.extname(filename).remove('.').presence ||
      # Real file format
      blob.filename.extension_without_delimiter
  end

  protected

  def variant_dimensions
    @variant_dimensions ||= begin
      dimensions = size.present? ? size : blob_size
      dimensions = dimensions.map { |dimension|
        if dimension.is_a?(Integer) && scale.is_a?(Integer)
          dimension * scale
        else
          dimension
        end
      }
      dimensions
    end
  end

  def format_unchanged?
    format == blob.filename.extension_without_delimiter
  end

  # If one of the dimensions is greater than the original one, no crop and resize to limit
  def should_crop?
    variant_dimensions_set? && variant_dimensions_smaller_than_original?
  end

  def variant_dimensions_set?
    variant_dimensions.size == 2 && variant_dimensions.all?(&:present?)
  end

  def variant_dimensions_smaller_than_original?
    variant_dimensions[0].to_i <= blob_size[0].to_i &&
    variant_dimensions[1].to_i <= blob_size[1].to_i
  end

  def scale
    if filename.include?('@2x')
      2
    elsif filename.include?('@3x')
      3
    else
      # 1 is nil, no scale
      nil
    end
  end

  # top, left...
  def gravity
    GRAVITIES.detect { |key| filename.include?("_crop_#{key}") }
  end

  # [800, nil]
  # [800, 400]
  # [nil, 400]
  def size
    return nil unless SIZE_REGEX.match? filename
    string_size = SIZE_REGEX.match(filename)[1]
    split_size = string_size.split('x')
    Array.new(2) { |i| split_size[i].blank? ? nil : split_size[i].to_i }
  end

  # [1024, 1365]
  def blob_size
    @blob_size ||= begin
      @blob.analyze unless @blob.analyzed?
      @blob.metadata.slice('width', 'height').values
    end
  end
end
