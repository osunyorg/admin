module User::WithAuthorship
  extend ActiveSupport::Concern

  included do
    has_many  :research_journal_papers,
              class_name: "Research::Journal::Paper",
              foreign_key: :updated_by_id,
              dependent: :nullify
  end
end
