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
    }
  end

  protected

  def resized_blob
    @resized_blob ||= begin
      if untouched?
        blob
      else
        blob.variant(**transformations)
            .processed
            .image
            .blob
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

  def untouched?
    rotation == 0 &&
    left == 0 && 
    top == 0 &&
    width == blob.metadata.dig(:width) &&
    height == blob.metadata.dig(:height)
  end

  def transformations
    # Default orientation
    transformations = { :'auto-orient' => true }
    # Handle rotation
    transformations[:rotate] = rotation if rotation.present?
    # Handle cropping
    transformations[:crop] = "#{width}x#{height}+#{left}+#{top}"
    # Finalize by repaging
    transformations.merge!({
      repage: true,
      :'+' => true
    })
    transformations
  end
end
