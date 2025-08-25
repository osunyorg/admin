module MentionableByBlocks
  extend ActiveSupport::Concern

  def mentions_by_blocks
    localizations_mentioning_self +
    objects_mentioning_self
  end

  def objects_mentioning_self
    @objects_mentioning_self ||= localizations_mentioning_self.collect(&:about).compact.uniq
  end

  def localizations_mentioning_self
    @localizations_mentioning_self ||= blocks_mentioning_self.collect(&:about).compact.uniq
  end

  def blocks_mentioning_self
    raise NoMethodError, "You must implement the `blocks_mentioning_self` method in #{self.class.name}"
  end
end
