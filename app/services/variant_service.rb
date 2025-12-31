class VariantService
  GRAVITIES = [
    'top',
    'right',
    'bottom',
    'left',
    'center'
  ]

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

  def variant_width
    variant_dimensions.first
  end

  def variant_height
    variant_dimensions.last
  end

  def crop_ratio
    1.0 * variant_width / variant_height
  end

  def max_crop_width
    [blob_width, blob_width * crop_ratio].min
  end

  def max_crop_height
    [blob_height, blob_height * crop_ratio].min
  end

  def max_width
    [blob_width, variant_width].min
  end

  def max_height
    [blob_height, variant_height].min
  end

  def format_unchanged?
    format == blob.filename.extension_without_delimiter
  end

  # Is there a target size set (or maybe 2!) different from blob size?
  def should_resize?
    variant_dimensions != blob_size
  end

  # If one of the dimensions is greater than the original one, no crop and resize to limit
  def should_crop?
    should_resize? && both_variant_dimensions_set?
  end

  def both_variant_dimensions_set?
    variant_dimensions.size == 2 && variant_dimensions.all?(&:present?)
  end

  def variant_dimensions_smaller_than_original?
    variant_width.to_i <= blob_width.to_i &&
    variant_height.to_i <= blob_height.to_i
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

  # dan-gold.jpeg         -> nil
  # dan-gold_800x.jpeg    -> [800, nil]
  # dan-gold_800x400.jpeg -> [800, 400]
  # dan-gold_x400.jpeg    -> [nil, 400]
  def size
    extension = File.extname(filename)
    # dan-gold_250x250_crop_left@2x.jpeg
    name = File.basename(filename, extension)
    # dan-gold_250x250_crop_left@2x
    [
      '@2x', '@3x', 
      '_crop_top', '_crop_right', '_crop_bottom', '_crop_left', '_crop_center'
    ].each do |fragment|
      name = name.remove(fragment)
    end
    # dan-gold_250x250
    parts = name.split('_')
    if parts.many?
      # 250x250
      name = parts.last
    else
      # dan-gold.jpeg -> dan-gold
      name = nil
    end
    return nil if name.blank? || !name.include?('x')
    split_size = name.split('x')
    # puts filename, name, split_size
    Array.new(2) { |i| split_size[i].blank? ? nil : split_size[i].to_i }
  end

  # [1024, 1365]
  def blob_size
    @blob_size ||= begin
      @blob.analyze unless @blob.analyzed?
      @blob.metadata.slice('width', 'height').values
    end
  end

  def blob_width
    blob_size.first
  end

  def blob_height
    blob_size.last
  end
end
