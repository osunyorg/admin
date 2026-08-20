# Resize a blob, coming from Vue advanced cropper
# answers with another blob (or the same if untouched)
class Osuny::Media::Resizer
  attr_reader :blob, :params

  def initialize(blob, params)
    @blob = blob
    @params = params&.symbolize_keys
  end

  def resized_blob
    @resized_blob ||= begin
      if should_resize?
        create_resized_blob
      else
        blob
      end
    end
  end

  def params_valid?
    [left, top, width, height].none?(&:nil?) &&
    width > 0 && height > 0
  end

  def should_resize?
    params_valid? && params_would_cause_a_change?
  end

  protected

  def rotation
    params&.dig(:rotation).to_i % 360
  end

  def left
    params&.dig(:left)
  end

  def top
    params&.dig(:top)
  end

  def width
    params&.dig(:width)
  end

  def height
    params&.dig(:height)
  end

  def params_would_cause_a_change?
    [rotation, left, top].any? { |param| param != 0 } ||
    width != blob.width ||
    height != blob.height
  end

  def transformations
    transformations = {}
    # Handle rotation
    transformations[:rotate] = rotation if rotation.present?
    # Handle cropping
    transformations[:crop] = [left, top, width, height]
    transformations
  end

  def create_resized_blob
    variation = ActiveStorage::Variation.new(transformations)
    blob.open do |file|
      variation.transform(file) do |output|
        return ActiveStorage::Blob.create_and_upload!(
          io: output,
          filename: "#{blob.filename.base}.#{variation.format}",
          content_type: variation.content_type
        ).tap do |resized_blob|
          resized_blob.update_column :university_id, blob.university_id
        end
      end
    end
  end
end
