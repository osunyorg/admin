# L'objet doit avoir 2 attributs :
# - published:boolean
# - published_at:datetime
module Publishable
  extend ActiveSupport::Concern

  PUBLICATION_STATE_PUBLISHED = 'published'
  PUBLICATION_STATE_PLANNED = 'planned'
  PUBLICATION_STATE_DRAFT = 'draft'

  included do
    scope :draft, -> {
      where(published: false)
    }

    scope :published, -> {
      where(published: true)
    }

    scope :published_today, -> {
      where(published_at: Date.current.all_day)
    }

    scope :published_now, -> {
      published.where("#{table_name}.published_at <= ?", Time.zone.now)
    }

    scope :published_in_the_future, -> {
      published.where("#{table_name}.published_at > ?", Time.zone.now)
    }

    scope :ordered_by_published_at, -> {
      order(published_at: :desc)
    }

    before_validation :set_published_at
  end

  def publish!
    self.published = true
    save
  end

  def unpublish!
    self.published = false
    self.published_at = nil
    save
  end

  def draft?
    !published
  end

  def published?
    published_now?
  end

  def published_now?
    published && published_at.present? && published_at <= Time.zone.now
  end

  def published_in_the_future?
    published && published_at.present? && published_at > Time.zone.now
  end

  def publication_state
    if published_in_the_future?
      PUBLICATION_STATE_PLANNED
    elsif published_now?
      PUBLICATION_STATE_PUBLISHED
    else
      PUBLICATION_STATE_DRAFT
    end
  end

  protected

  def set_published_at
    self.published_at = Time.zone.now if published && published_at.nil?
  end
end
