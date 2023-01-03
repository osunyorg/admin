module Communication::Website::Page::WithKind
  extend ActiveSupport::Concern

  included do
    # Deprecated
    # Utile pour la migration, le rails app:fix
    # Supprimer après seulement
    enum kind: {
      home: 0,
      communication_posts: 10,
      education_programs: 20,
      education_diplomas: 21,
      research_papers: 30,
      research_volumes: 32,
      legal_terms: 80,
      sitemap: 81,
      privacy_policy: 82,
      accessibility: 83,
      organizations: 90,
      persons: 100,
      administrators: 110,
      authors: 120,
      researchers: 130,
      teachers: 140
    }, _prefix: 'kind'

  end

end
