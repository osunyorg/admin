module Administration
  extend ActiveModel::Naming
  extend ActiveModel::Translation

  def self.table_name_prefix
    'administration_'
  end

  def self.parts
    [
      [Administration::Qualiopi, :admin_administration_qualiopi_criterions_path],
    ]
  end
end
