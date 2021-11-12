module WithSlug
  extend ActiveSupport::Concern

  included do
    before_validation :generate_slug, if: Proc.new { |o| o.slug.nil? }
  end

  protected

  def generate_slug
    n = nil
    loop do
      self.slug = [to_s.parameterize, n].compact.join('-')
      break if slug_available?
      n = n.to_i + 1
    end
  end

  def slug_available?
    self.class.unscoped.where.not(id: self.id).where(university_id: self.university_id, slug: self.slug).none?
  end
end
