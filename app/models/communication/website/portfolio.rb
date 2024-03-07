module Communication::Website::Portfolio
  extend ActiveModel::Naming
  extend ActiveModel::Translation

  def self.table_name_prefix
    "communication_website_portfolio_"
  end
end
