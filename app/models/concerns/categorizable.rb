module Categorizable
  extend ActiveSupport::Concern

  included do
    attr_accessor :categories_were_changed

    has_and_belongs_to_many :categories,
                            after_add: :mark_categories_as_changed,
                            after_remove: :mark_categories_as_changed

    after_save :touch_after_categories_change, if: :saved_only_changed_categories?

    scope :for_category, -> (category_ids, language = nil) {
      categories_table_name = _reflect_on_association(:categories).klass.table_name
      joins(:categories).where(categories_table_name => { id: category_ids }).distinct
    }
  end

  protected

  def touch_after_categories_change
    touch
    @categories_were_changed = false
  end

  def saved_only_changed_categories?
    saved_changes.blank? && @categories_were_changed
  end

  def mark_categories_as_changed(_)
    @categories_were_changed = true
  end

end