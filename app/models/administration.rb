module Administration
  extend ActiveModel::Naming
  extend ActiveModel::Translation

  def self.table_name_prefix
    'administration_'
  end
end
