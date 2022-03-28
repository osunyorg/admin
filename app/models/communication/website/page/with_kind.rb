module Communication::Website::Page::WithKind
  extend ActiveSupport::Concern

  included do

    enum kind: {
      home: 0,
      communication_posts: 10,
      education_programs: 20,
      research_articles: 30,
      research_volumes: 32,
      persons: 100,
        administrators: 110,
        authors: 120,
        researchers: 130,
        teachers: 140
    }, _prefix: 'kind'

    def is_special_page?
      kind != nil
    end

    def is_not_special_page?
      !is_special_page?
    end

  end

end
