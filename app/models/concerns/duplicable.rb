module Duplicable
  extend ActiveSupport::Concern

  def duplicate
    instance = duplicate_instance
    duplicate_categories_for(instance)
    duplicate_localizations_for(instance)
    instance
  end

  protected

  def duplicate_instance
    instance = self.dup
    instance.save
    instance
  end

  def duplicate_categories_for(instance)
    return unless respond_to?(:categories)
    instance.categories = categories
  end

  def duplicate_localizations_for(instance)
    localizations.each do |l10n|
      instance_l10n = l10n.dup
      instance_l10n.about = instance
      # note: fragile. It only works because every duplicate objects currently has a "title" property.
      instance_l10n.title = I18n.t('copy_of', title: l10n.title)
      instance_l10n.published = false if instance_l10n.respond_to?(:published)
      instance_l10n.published_at = nil if instance_l10n.respond_to?(:published_at)
      instance_l10n.save
      duplicate_featured_image(l10n, instance_l10n)
      duplicate_blocks(l10n, instance_l10n)
    end
  end

  def duplicate_featured_image(from, to)
    return unless from.respond_to?(:featured_image) && from.featured_image.attached?
    ActiveStorage::Utils.duplicate(from.featured_image, to.featured_image)
  end

  def duplicate_blocks(from, to)
    return unless from.respond_to?(:contents)
    from.blocks.ordered.each do |block|
      duplicate_block(to, block)
    end
  end

  def duplicate_block(instance, block)
    duplicated_block = block.duplicate
    duplicated_block.about = instance
    duplicated_block.position = block.position
    duplicated_block.save
  end
end