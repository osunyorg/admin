module Communication::Website::WithFeaturePortfolio
  extend ActiveSupport::Concern

  included do
    has_many    :portfolio_projects,
                class_name: "Communication::Website::Portfolio::Project",
                foreign_key: :communication_website_id,
                dependent: :destroy
                alias :projects :portfolio_projects

    has_many    :portfolio_categories,
                class_name: 'Communication::Website::Portfolio::Category',
                foreign_key: :communication_website_id,
                dependent: :destroy
                alias :projects_categories :portfolio_categories

    scope :with_feature_portfolio, -> { where(feature_portfolio: true) }
  end

  def feature_portfolio_name(language)
    begin
      special_page(Communication::Website::Page::CommunicationPortfolio).best_localization_for(language)
    rescue
      Communication::Website::Portfolio::Project.model_name.human(count: 2)
    end
  end

  def feature_portfolio_dependencies
    projects +
    portfolio_categories
  end
end