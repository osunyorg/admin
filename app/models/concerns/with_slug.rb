module WithSlug
  extend ActiveSupport::Concern

  included do
    validates :slug,
              uniqueness: { scope: :university_id },
              format: { with: /\A[a-z0-9\-]+\z/, message: "ne peut contenir que des lettres minuscules, des chiffres et des traits d'union." },
              allow_blank: true
  end
end
