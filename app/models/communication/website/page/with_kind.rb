module Communication::Website::Page::WithKind
  extend ActiveSupport::Concern

  included do

    enum kind: {
      home: 0,
      communication_posts: 10,
      education_programs: 20,
      research_articles: 30,
      research_volumes: 32,
      legal_terms: 80,
        sitemap: 81,
        privacy_policy: 82,
      organizations: 90,
      persons: 100,
        administrators: 110,
        authors: 120,
        researchers: 130,
        teachers: 140
    }, _prefix: 'kind'

    SPECIAL_PAGES_WITH_GIT_SPECIAL_PATH = [
      'communication_posts',
      'education_programs',
      'research_articles',
      'research_volumes',
      'organizations',
      'persons',
      'administrators',
      'authors',
      'researchers',
      'teachers'
    ].freeze

    after_create :move_legacy_root_pages, if: :kind_home?

    def is_special_page?
      kind != nil
    end

    def is_regular_page?
      !is_special_page?
    end

  end

  private

  def move_legacy_root_pages
    root_pages = website.pages.where.not(id: id).root
    root_pages.update_all(parent_id: id)
  end

end
