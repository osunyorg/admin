module Communication::Website::Agenda
  extend ActiveModel::Naming
  extend ActiveModel::Translation

  STATUS_CURRENT = 'current'
  STATUS_FUTURE = 'future'
  STATUS_FUTURE_OR_CURRENT = 'future_or_current'
  STATUS_ARCHIVE = 'archive'

  AUTHORIZED_SCOPES = [
    STATUS_CURRENT,
    STATUS_FUTURE_OR_CURRENT,
    STATUS_FUTURE,
    STATUS_ARCHIVE,
  ].freeze

  def self.table_name_prefix
    "communication_website_agenda_"
  end
end
