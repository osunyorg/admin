# Resize a blob, coming from Vue advanced cropper
# answers with another blob (or the same if untouched)
class Osuny::Media::Resizer
  attr_reader :blob, :params

  def initialize(blob, params)
    @blob = blob
    @params = params
  end

  def to_json
    {
      id: resized_blob.id,
      signed_id: resized_blob.signed_id,
      checksum: resized_blob.checksum,
      key: resized_blob.key,
    }
  end

  protected

  # TODO ImageProcessing: Verify if compatible with Vips
  def resized_blob
    @resized_blob ||= begin
      if should_resize?
        blob.variant(**transformations)
            .processed
            .image
            .blob
      else
        blob
      end
    end
  end

  def rotation
    params.dig(:rotation)
  end

  def left
    params.dig(:left)
  end

  def top
    params.dig(:top)
  end

  def width
    params.dig(:width)
  end

  def height
    params.dig(:height)
  end

  def should_resize?
    !invalid_params? && !untouched?
  end

  def invalid_params?
    [left, top, width, height].any? { |key| params[key].nil? } ||
    width <= 0 || height <= 0
  end

  def untouched?
    rotation == 0 &&
    left == 0 &&
    top == 0 &&
    width == blob.metadata.dig(:width) &&
    height == blob.metadata.dig(:height)
  end

  def transformations
    transformations = {}
    # Handle rotation
    transformations[:rotate] = rotation if rotation.present?
    # Handle cropping
    transformations[:crop] = [left, top, width, height]
    transformations
  end
end
