module Education
  extend ActiveModel::Naming
  extend ActiveModel::Translation

  def self.table_name_prefix
    'education_'
  end
end
