module Communication::Website::Showcase
  FEATURES = [
    :actualites,
    :agenda,
    :portfolio
  ].freeze

  def self.table_name_prefix
    "communication_website_showcase_"
  end

  def self.features
    FEATURES.map do |feature| 
      { 
        name: title_for_feature(feature),
        path: "/#{feature}",
        websites: websites_for_feature(feature)
      }
    end
  end

  def self.title_for_feature(feature)
    case feature
    when :actualites
      Communication::Website::Post.model_name.human(count: 2)
    when :agenda
      Communication::Website::Agenda.model_name.human(count: 2)
    when :portfolio
      Communication::Website::Portfolio.model_name.human(count: 2)
    end
  end

  def self.websites_for_feature(feature)
    websites = Communication::Website.in_showcase
    case feature
    when :actualites
      websites.with_feature_posts
    when :agenda
      websites.with_feature_agenda
    when :portfolio
      websites.with_feature_portfolio
    end
  end
end
