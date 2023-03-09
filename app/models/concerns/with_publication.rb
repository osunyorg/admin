module WithPublication
  extend ActiveSupport::Concern

  included do
    scope :published, -> { where(published: true) }
    scope :draft, -> { where(published: false) }
    scope :ordered, -> { order(published_at: :desc) }

    before_validation :set_published_at
  end

  def draft?
    !published || published_in_the_future?
  end

  def published_in_the_future?
    published && published_at > Time.now
  end

  def published_now?
    published && published_at <= Time.now
  end

  protected

  def set_published_at
    self.published_at = Time.zone.now if published && published_at.nil?
  end
end
