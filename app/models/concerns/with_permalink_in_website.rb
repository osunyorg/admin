module WithPermalinkInWebsite
  extend ActiveSupport::Concern

  included do

    has_many  :permalinks,
              class_name: "Communication::Website::Permalink",
              as: :about,
              dependent: :destroy

    after_validation :manage_permalinks, on: [:create, :update]

  end

  def permalink_path_in_website(website)
    computed_permalink = computed_permalink_in_website(website)
    computed_permalink.present? ? Static.clean_path(computed_permalink) : nil
  end

  def computed_permalink_path_in_website(website)
    raw_permalink_in_website(website)&.gsub(':slug', self.slug)
  end

  def manage_permalinks
    websites_for_self.each do |website|
      last_permalink = permalinks.for_website(website).current.first
      new_permalink_path = permalink_path_in_website(website)

      # If the object had no permalink or if its path changed, we create a new permalink
      if last_permalink.nil? || new_permalink_path != last_permalink.path
        last_permalink&.update(is_current: false)
        permalinks.create(website: website, path: new_permalink_path)
      end

    end
  end

  protected

  def raw_permalink_in_website(website)
    website.config_permalinks.permalinks_data[permalink_config_key]
  end

  def permalink_config_key
    raise NotImplementedError
  end
end
