module Communication::Website::Agenda
  extend ActiveModel::Naming
  extend ActiveModel::Translation

  def self.table_name_prefix
    "communication_website_agenda_"
  end
end
