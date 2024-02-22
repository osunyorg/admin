module Sluggable
  extend ActiveSupport::Concern

  included do
    # Filenames uses 255 bytes so should have 255 characters max. To be safe, we limit to 100.
    # Source: https://askubuntu.com/questions/166764/how-long-can-file-names-be/166767#166767
    SLUG_MAX_LENGTH = 100

    validates :slug, presence: true
    validate :slug_must_be_unique
    validates :slug, format: { with: /\A[a-z0-9\-]+\z/, message: I18n.t('slug_error') }

    before_validation :check_slug, :make_path

    def check_slug
      self.slug = to_s.parameterize if self.slug.blank?
      adjust_slug_length
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

    def adjust_slug_length
      return unless self.slug.length > SLUG_MAX_LENGTH
      # "my-very-long-and-detailed-first-blog-post" => "my-very-long-and-detailed-first-"
      self.slug = self.slug[0, SLUG_MAX_LENGTH]
      # "my-very-long-and-detailed-first-" => "my-very-long-and-detailed-first"
      self.slug.chop! if self.slug.ends_with?('-')
    end

    def slug_unavailable?(slug)
      existence_params = { university_id: self.university_id, slug: slug }
      existence_params[:language_id] = self.language_id if respond_to?(:language_id)

      self.class.unscoped
                .where(**existence_params)
                .where.not(id: self.id)
                .exists?
    end

    # FIXME `respond_to?(:parent)` sert à quoi ?
    def make_path
      return unless respond_to?(:path) && respond_to?(:parent)
      self.path = generated_path
    end

    def slug_must_be_unique
      errors.add(:slug, :taken) if slug_unavailable?(slug)
    end
  end
end
