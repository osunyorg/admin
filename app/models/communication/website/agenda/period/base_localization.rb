module Communication::Website::Agenda::Period::BaseLocalization
  extend ActiveSupport::Concern

  included do
    belongs_to  :website,
                class_name: 'Communication::Website',
                foreign_key: :communication_website_id

    delegate    :value, to: :about

    after_commit :denormalize_events_count
  end

  def events
    raise NotImplementedError
  end

  def time_slots
    raise NotImplementedError
  end

  def events?
    events_count > 0
  end

  protected

  def denormalize_events_count
    count = events.count + time_slots.count
    self.update_column :events_count, count
  end
end