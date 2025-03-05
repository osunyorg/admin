module Communication::Website::Agenda::Period::BaseLocalization
  extend ActiveSupport::Concern

  included do
    belongs_to  :website,
                class_name: 'Communication::Website',
                foreign_key: :communication_website_id

    delegate    :value, to: :about

    after_commit :denormalize_events_count
  end

  def events?
    events_count > 0
  end

  protected

  def denormalize_events_count
    self.update_column :events_count, events.count
  end
end