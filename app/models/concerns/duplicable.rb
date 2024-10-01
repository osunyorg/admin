module Duplicable
  extend ActiveSupport::Concern

  def duplicate
    instance = duplicate_instance
    duplicate_localizations_for(instance)
    instance
  end

  protected

  def duplicate_instance
    instance = self.dup
    instance.save
    instance
  end

  def duplicate_localizations_for(instance)
    localizations.each do |l10n|
      instance_l10n = l10n.dup
      instance_l10n.about = instance
      # note: fragile. It only works because every duplicate objects currently has a "title" property.
      instance_l10n.title = I18n.t('copy_of', title: l10n.title)
      instance_l10n.save
      duplicate_featured_image(l10n, instance_l10n)
      duplicate_blocks(l10n, instance_l10n)
    end
  end

  def duplicate_featured_image(from, to)
    return unless from.respond_to?(:featured_image) && from.featured_image.attached?
    to.featured_image.attach(
      io: URI.open(from.featured_image.url),
      filename: from.featured_image.filename.to_s,
      content_type: from.featured_image.content_type
    )
  end

  def duplicate_blocks(from, to)
    return unless from.respond_to?(:contents)
    from.blocks.without_heading.ordered.each do |block|
      duplicate_block(to, block)
    end
    from.headings.root.ordered.each do |heading|
      duplicate_heading(to, heading)
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
end