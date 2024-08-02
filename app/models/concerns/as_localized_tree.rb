module AsLocalizedTree
  extend ActiveSupport::Concern

  included do
    scope :root, -> {
      joins(:about).where(about_table_name => { parent_id: nil })
    }
    scope :ordered, -> {
      joins(:about).order("#{about_table_name}.position")
    }
  end

  class_methods do
    # Communication::Website::Page::Localization => Communication::Website::Page
    def about_class
      reflect_on_association(:about).klass
    end

    # Communication::Website::Page => communication_website_pages
    def about_table_name
      about_class.table_name
    end
  end

  def parent
    about.parent.localization_for(language)
  end

  def children
    localizations_for(about.children)
  end

  def has_children?
    children.any?
  end

  # Attention, si le parent existe  mais pas localisé, la méthode renvoie false.
  # C'est un peu troublant parce que le parent de l'about (non localisé) peut exister.
  # Au sens strict, la localisation n'a pas de parent.
  def has_parent?
    about.parent_id.present? &&
      about.parent.localized_in?(language)
  end

  def ancestors
    has_parent? ? parent.ancestors.push(parent)
                : []
  end

  def ancestors_and_self
    ancestors + [self]
  end

  def descendants
    has_children? ? children.ordered.map { |child| [child, child.descendants].flatten }.flatten
                  : []
  end

  def descendants_and_self
    [self] + descendants
  end

  def siblings
    localizations_for(parent_siblings)
  end

  protected

  def parent_siblings
    self.class.about_class
              .unscoped
              .where(
                parent_id: about.parent_id,
                university: university
              )
              .where.not(id: about.id)
              .ordered
  end

  def localizations_for(abouts)
    about_ids = abouts.pluck(:id)
    self.class.unscoped
              .where(
                language_id: language_id,
                about_id: about_ids
              )
  end

end
