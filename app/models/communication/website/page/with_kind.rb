module Communication::Website::Page::WithKind
  extend ActiveSupport::Concern

  included do

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

    # -> dans les nouvelles classes
    SPECIAL_PAGES_WITH_GIT_SPECIAL_PATH = [
      'communication_posts',
      'education_programs',
      'education_diplomas',
      'research_papers',
      'research_volumes',
      'organizations',
      'persons',
      'administrators',
      'authors',
      'researchers',
      'teachers'
    ].freeze

    # -> dans les nouvelles classes
    def has_special_git_path?
      is_special_page? && SPECIAL_PAGES_WITH_GIT_SPECIAL_PATH.include?(kind)
    end

    # -> dans les nouvelles classes
    def special_page_git_dependencies(website)
      dependencies = [website.config_default_permalinks]
      case kind
      when "communication_posts"
        dependencies += [
          website.categories,
          website.authors.map(&:author),
          website.posts
        ].flatten
      when "education_programs", "education_diplomas", "research_papers", "organizations"
        # dependencies += website.education_programs
        dependencies += website.public_send(kind)
      when "people"
        dependencies += website.people_with_facets
      when "administrators", "authors", "researchers", "teachers"
        # dependencies += website.authors.map(&:author)
        dependencies += website.public_send(kind).map(&kind.singularize.to_sym)
      end

      dependencies
    end

  end

end
