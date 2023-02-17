module Research::Hal
  extend ActiveModel::Naming
  extend ActiveModel::Translation

  def self.table_name_prefix
    'research_hal_'
  end
end
