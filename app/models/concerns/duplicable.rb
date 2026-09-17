module Duplicable
  extend ActiveSupport::Concern

  def duplicate
    instance = nil
    Osuny::BulkOperation.silently do
      instance = duplicate_instance
      duplicate_categories_for(instance)
      duplicate_localizations_for(instance)
    end
    instance.touch
    instance
  end

  def duplicate_blocks(from, to)
    return unless from.respond_to?(:blocks)
    from.blocks.ordered.each do |block|
      block.duplicate(to: to, keep_position: true)
    end
  end

  protected

  def duplicate_instance
    instance = self.dup
    instance.migration_identifier = nil if instance.respond_to?(:migration_identifier)
    instance.position = nil if instance.respond_to?(:position)
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
      instance_l10n.migration_identifier = nil if instance_l10n.respond_to?(:migration_identifier)
      instance_l10n.published = false if instance_l10n.respond_to?(:published)
      instance_l10n.published_at = nil if instance_l10n.respond_to?(:published_at)
      instance_l10n.save
      duplicate_blocks(l10n, instance_l10n)
    end
  end
end
