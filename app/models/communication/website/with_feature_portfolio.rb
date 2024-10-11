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

end