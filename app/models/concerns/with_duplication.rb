module WithDuplication
  extend ActiveSupport::Concern

  def duplicate
    instance = duplicate_instance
    duplicate_blocks_to(instance)
    duplicate_featured_image_to(instance)
    instance
  end

  protected

  def duplicate_instance
    instance = self.dup
    instance.published = false if respond_to?(:published)
    instance.published_at = nil if respond_to?(:published_at)
    instance.save
    instance
  end

  def duplicate_blocks_to(instance)
    return unless respond_to?(:blocks)
    blocks.ordered.each do |block|
      b = block.duplicate
      b.about = instance
      b.position = block.position
      b.save
    end
  end

  def duplicate_featured_image_to(instance)
    return unless respond_to?(:featured_image) && featured_image.attached?
    instance.featured_image.attach(
      io: URI.open(featured_image.url),
      filename: featured_image.filename.to_s,
      content_type: featured_image.content_type
    )
  end
end