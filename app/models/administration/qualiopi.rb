module Administration::Qualiopi
  extend ActiveModel::Naming
  extend ActiveModel::Translation

  def self.table_name_prefix
    'administration_qualiopi_'
  end
end
