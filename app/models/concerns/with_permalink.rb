module WithPermalink
  extend ActiveSupport::Concern

  included do
    has_many  :permalinks,
              class_name: "Communication::Website::Permalink",
              as: :about,
              dependent: :destroy
  end

  def manage_permalink_in_website(website)
    last_permalink = permalinks.for_website(website).current.first
    new_permalink = Communication::Website::Permalink.for_object(self, website)

    # If the object had no permalink or if its path changed, we create a new permalink
    if new_permalink.computed_path.present? && (last_permalink.nil? || last_permalink.path != new_permalink.computed_path)
      last_permalink&.update(is_current: false)
      new_permalink.path = new_permalink.computed_path
      new_permalink.save
    end
  end

end
