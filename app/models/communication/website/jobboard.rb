module Communication::Website::Jobboard
  extend ActiveModel::Naming
  extend ActiveModel::Translation

  def self.table_name_prefix
    "communication_website_jobboard_"
  end
end
