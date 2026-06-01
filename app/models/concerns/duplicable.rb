module Duplicable
  extend ActiveSupport::Concern

  # Thread-local flag read by side-effect callbacks (clean websites,
  # connect to websites, identify git files, synchronize list blocks,
  # update tree position, connect dependencies, automatic menus, touch about)
  # to skip themselves while a duplication is in progress.
  # The work is performed once at the end of the duplication, in finalize_duplication.
  IN_PROGRESS_KEY = :duplicable_in_progress

  def self.in_progress?
    Thread.current[IN_PROGRESS_KEY] == true
  end

  def self.in_progress
    previous = Thread.current[IN_PROGRESS_KEY]
    Thread.current[IN_PROGRESS_KEY] = true
    yield
  ensure
    Thread.current[IN_PROGRESS_KEY] = previous
  end

  def duplicate
    instance = nil
    ActiveRecord::Base.transaction do
      Duplicable.in_progress do
        instance = duplicate_instance
        duplicate_categories_for(instance)
        duplicate_localizations_for(instance)
      end
    end
    finalize_duplication(instance)
    instance
  end

  def duplicate_blocks(from, to)
    return unless from.respond_to?(:blocks)
    from.blocks.ordered.each do |block|
      duplicate_block(to, block)
    end
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

  def duplicate_block(instance, block)
    duplicated_block = block.dup
    duplicated_block.about = instance
    duplicated_block.position = block.position
    duplicated_block.save
  end

  # Once the duplication has been fully committed, trigger the side-effect
  # callbacks exactly once for the new instance. This replaces the per-save
  # cascade that was firing N times (one per localization, one per block).
  def finalize_duplication(instance)
    return if instance.nil?
    # touch fires after_touch callbacks: connect_dependencies (sync),
    # identify_git_files, synchronize_list_blocks, update_position_in_tree_later,
    # connect_to_websites (for indirect objects). All have been skipped during
    # the duplication via Duplicable.in_progress?, so they run here only once.
    instance.touch
    # after_save-only callbacks need explicit re-firing:
    Dependencies::CleanWebsitesIfNecessaryJob.perform_later(instance)
    if instance.respond_to?(:generate_automatic_menus_after_duplication, true)
      instance.send(:generate_automatic_menus_after_duplication)
    end
  end
end
