module WithDuplication
  extend ActiveSupport::Concern

  def duplicate
    instance = duplicate_instance
    duplicate_contents_to(instance)
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

  def duplicate_contents_to(instance)
    return unless respond_to?(:contents)
    blocks.without_heading.ordered.each do |block|
      duplicate_block(instance, block)
    end
    headings.root.ordered.each do |heading|
      duplicate_heading(instance, heading)
    end
  end

  def duplicate_block(instance, block, heading_id = nil)
    b = block.duplicate
    b.about = instance
    b.position = block.position
    b.heading_id = heading_id
    b.save
  end

  def duplicate_heading(instance, heading, parent_id = nil)
    h = heading.duplicate
    h.about = instance
    h.position = heading.position
    h.save

    heading.blocks.ordered.each do |block|
      duplicate_block(instance, block, h.id)
    end
    heading.children.ordered.each do |child|
      duplicate_heading(instance, child, h.id)
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