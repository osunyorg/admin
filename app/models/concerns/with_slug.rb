module WithSlug
  extend ActiveSupport::Concern

  included do
    validates :slug,
              uniqueness: { scope: :university_id }
    validates :slug,
              format: { with: /\A[a-z0-9\-]+\z/, message: I18n.t('slug_error') }

    before_validation :regenerate_slug, :make_path

    def regenerate_slug
      current_slug = self.slug
      n = 0
      while slug_unavailable?(self.slug)
        n += 1
        self.slug = [current_slug, n].join('-')
      end
    end

    protected

    def slug_unavailable?(slug)
      self.class.unscoped
                .where(university_id: self.university_id, slug: slug)
                .where.not(id: self.id)
                .exists?
    end

    def make_path
      return unless respond_to? :path
      self.path = "#{parent&.path}/#{slug}".gsub(/\/+/, '/')
    end
  end
end
