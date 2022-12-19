module WithSlug
  extend ActiveSupport::Concern

  included do
    validates :slug, presence: true
    validate :slug_must_be_unique
    validates :slug, format: { with: /\A[a-z0-9\-]+\z/, message: I18n.t('slug_error') }

    before_validation :check_slug, :make_path

    def check_slug
      byebug
      self.slug = to_s.parameterize if self.slug.blank?
      current_slug = self.slug
      n = 0
      while slug_unavailable?(self.slug)
        n += 1
        self.slug = [current_slug, n].join('-')
      end
    end

    def generated_path
      "#{parent.nil? ? '/' : parent.path}#{slug}/".gsub(/\/+/, '/')
    end

    protected

    def slug_unavailable?(slug)
      self.class.unscoped
                .where(university_id: self.university_id, slug: slug)
                .where.not(id: self.id)
                .exists?
    end

    def make_path
      return unless respond_to?(:path) && respond_to?(:parent)
      self.path = generated_path
    end

    def slug_must_be_unique
      errors.add(:slug, ActiveRecord::Errors.default_error_messages[:taken]) if slug_unavailable?(slug)
    end
  end
end
