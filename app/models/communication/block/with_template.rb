module Communication::Block::WithTemplate
  extend ActiveSupport::Concern

  included do
    OPTION_PREFIX = 'option_'.freeze

    # Used to purge images when unattaching them
    # template_blobs would be a better name, because there are files
    has_many_attached :template_images

    before_save :attach_template_blobs
  end

  def template
    @template ||= template_class.new self, self.attributes['data']
  end

  def template_reset!
    @template = nil
  end

  def options
    options = {}
    template.components_descriptions.map do |desc|
      property = desc[:property].to_s
      next unless property.start_with?(OPTION_PREFIX)
      property_without_prefix = property.remove(OPTION_PREFIX)
      options[property_without_prefix] = template.send(property)
    end
    options
  end

  protected

  def template_class
    "Communication::Block::Template::#{template_kind.classify}".constantize
  end

  # FIXME @sebou
  # Could not find or build blob: expected attachable, got #<ActiveStorage::Blob id: "f4c78657-5062-416b-806f-0b80fb66f9cd", key: "gri33wtop0igur8w3a646llel3sd", filename: "logo.svg", content_type: "image/svg+xml", metadata: {"identified"=>true, "width"=>709, "height"=>137, "analyzed"=>true}, service_name: "scaleway", byte_size: 4137, checksum: "aZqqTYabP5+72ZeddcZ/2Q==", created_at: "2022-05-05 12:17:33.941505000 +0200", university_id: "ebf2d273-ffc9-4d9f-a4ee-a2146913d617">
  def attach_template_blobs
    # self.template_images = template.active_storage_blobs
  end

end
