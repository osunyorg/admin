module WithSlug
  extend ActiveSupport::Concern

  included do
    validates :slug,
              uniqueness: { scope: :university_id }
    validates :slug,
              format: { with: /\A[a-z0-9\-]+\z/, message: I18n.t('slug_error') }
  end
end
