module Features::Websites
  extend ActiveModel::Naming
  extend ActiveModel::Translation

  def self.table_name_prefix
    'features_websites_'
  end
end
