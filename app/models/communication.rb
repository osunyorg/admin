module Communication
  extend ActiveModel::Naming
  extend ActiveModel::Translation

  def self.table_name_prefix
    'communication_'
  end

  def self.parts
    [
      [University::Person::Localization::Author, :admin_communication_authors_path],
      [Communication::Website, :admin_communication_websites_path],
      [Communication::Extranet, :admin_communication_extranets_path],
    ]
  end
end
