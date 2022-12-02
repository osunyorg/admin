module WithWebsitePermalink
  extend ActiveSupport::Concern

  included do

    def permalink_for_website(website)
      computed_permalink = computed_permalink_for_website(website)
      computed_permalink.present? ? Static.clean_path(computed_permalink) : nil
    end

    def computed_permalink_for_website(website)
      raw_permalink_for_website(website).gsub(':slug', self.slug)
    end

    protected

    def raw_permalink_for_website(website)
      website.config_permalinks.permalinks_data[permalink_config_key]
    end

    def permalink_config_key
      raise NotImplementedError
    end

  end
end
