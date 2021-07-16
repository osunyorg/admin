module Qualiopi
  extend ActiveModel::Naming

  def self.table_name_prefix
    'qualiopi_'
  end
end
