module Communication::Website::Permalink::WithValidations
  extend ActiveSupport::Concern

  included do
    before_validation :set_university, on: :create

    # Jamais de permalink sans path, quoi qu'il en soit
    validates :path, presence: true
    # Seule la home peut utiliser /
    validate :root_path_is_reserved_for_home

    # Un même path ne peut être utilisé qu'une seule fois pour un même website, et du type de page
    # Normalement en passant par le save_if_needed?, on ne peut pas créer de doublon, mais ça évite les erreurs si jamais on essaye de forcer un path déjà utilisé pour une même page
    # Empêche d'avoir deux fois "/ma-page/" (pour le même site, le même objet et le même état) => Empêche les multi-créations
    validates :path, uniqueness: { scope: [:website_id, :is_current, :about_type, :about_id] }
    # Pour les redirections ajoutées à la main, dans l'admin, ça évite les doublons
    # Si on ajoute un alias /fr/actualites/ comme adresse de redirection, et que c'est déjà utilisé pour ce website (en actuel ou en alias), c'est refusé
    validates :path, uniqueness: { scope: :website_id }, unless: :is_current
  end

  protected

  def set_university
    self.university_id = website.university_id
  end

  def root_path_is_reserved_for_home
    return unless path == "/"
    errors.add(:path, :reserved_for_home) unless about.about.is_a?(Communication::Website::Page::Home)
  end
end
