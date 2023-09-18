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
    instance.title = I18n.t('copy_of', title: self.title)
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
    duplicated_block = block.duplicate
    duplicated_block.about = instance
    duplicated_block.position = block.position
    duplicated_block.heading_id = heading_id
    duplicated_block.save
  end

  def duplicate_heading(instance, heading, parent_id = nil)
    duplicated_heading = heading.duplicate
    duplicated_heading.about = instance
    duplicated_heading.position = heading.position
    duplicated_heading.parent_id = parent_id
    duplicated_heading.save

    heading.blocks.ordered.each do |block|
      duplicate_block(instance, block, duplicated_heading.id)
    end
    heading.children.ordered.each do |child|
      duplicate_heading(instance, child, duplicated_heading.id)
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