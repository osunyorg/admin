module Communication::Website::Agenda::Event::WithTime
  extend ActiveSupport::Concern

  included do
    STATUS_FUTURE = 'future'
    STATUS_CURRENT = 'current'
    STATUS_ARCHIVE = 'archive'
    
    scope :future, -> { where('from_day > :today', today: Date.today).ordered_asc }
    scope :future_or_current, -> { where('from_day >= :today', today: Date.today).ordered_asc }
    scope :current, -> { where('(from_day <= :today AND to_day IS NULL) OR (from_day <= :today AND to_day >= :today)', today: Date.today).ordered_asc }
    scope :archive, -> { where('to_day < :today', today: Date.today).ordered_desc }
    scope :past, -> { archive }

    before_validation :set_to_day

    validates_presence_of :from_day, :title
    validate :to_day_after_from_day, :to_hour_after_from_hour_on_same_day
  end

  def status
    if future?
      STATUS_FUTURE
    elsif current?
      STATUS_CURRENT
    else
      STATUS_ARCHIVE
    end
  end

  def future?
    from_day > Date.today
  end

  def current?
    to_day.present? ? (Date.today >= from_day && Date.today <= to_day)
                    : from_day <= Date.today # Les événements sans date de fin restent actifs
  end

  def archive?
    to_day.present? ? to_day < Date.today
                    : false # Les événements sans date de fin restent actifs
  end

  def same_day?
    from_day == to_day
  end

  # Un événement demain aura une distance de 1, comme un événement hier
  # On utilise cette info pour classer les événements à venir dans un sens et les archives dans l'autre
  def distance_in_days
    (Date.today - from_day).to_i.abs
  end
  
  protected

  def set_to_day
    self.to_day = self.from_day if self.to_day.nil?
  end

  def to_day_after_from_day
    errors.add(:to_day, :too_soon) if to_day.present? && to_day < from_day
  end

  def to_hour_after_from_hour_on_same_day
    return if from_day != to_day
    errors.add(:to_hour, :too_soon) if to_hour.present? && from_hour.present? && to_hour <= from_hour
  end
end
