# L'objet doit avoir 2 attributs :
# - published:boolean
# - published_at:datetime
module WithPublication
  extend ActiveSupport::Concern

  included do
    scope :draft, -> { where(published: false) }
    scope :published, -> { where(published: true) }
    scope :published_now, -> { where(published: true).where('published_at <= ?', Time.zone.now) }
    scope :published_in_the_future, -> { where(published: true).where('published_at > ?', Time.zone.now) }
    scope :ordered_by_published_at, -> { order(published_at: :desc) }

    before_validation :set_published_at
  end

  def publish!
    self.published = true
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

  protected

  def set_published_at
    self.published_at = Time.zone.now if published && published_at.nil?
  end
end
