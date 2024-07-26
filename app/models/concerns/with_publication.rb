# L'objet doit avoir 2 attributs :
# - published:boolean
# - published_at:datetime
module WithPublication
  extend ActiveSupport::Concern

  included do
    scope :published, -> { where(published: true) }
    scope :draft, -> { where(published: false) }
    scope :ordered_by_published_at, -> { order(published_at: :desc) }

    before_validation :set_published_at
  end

  def published?
    published_now?
  end

  def draft?
    !published
  end

  def published_in_the_future?
    published && published_at.present? && published_at > Time.now
  end

  def published_now?
    published && published_at.present? && published_at <= Time.now
  end

  protected

  def set_published_at
    self.published_at = Time.zone.now if published && published_at.nil?
  end
end
