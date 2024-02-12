module Filters
  class Server::Universities < Filters::Base
    def initialize(user)
      super
      add_search
      add_for_real_university
      add_for_contribution
      add_for_university_kind
    end

    private

    def add_for_real_university
      add :for_real_university,
          [
            { to_s: I18n.t('true'), id: 'true' }, 
            { to_s: I18n.t('false'), id: 'false' }
          ],
          University.human_attribute_name('is_really_a_university')
    end

    def add_for_contribution
      add :for_contribution,
          [
            { to_s: I18n.t('server_admin.universities.contribution_filter.true'), id: 'true' }, 
            { to_s:  I18n.t('server_admin.universities.contribution_filter.false'), id: 'false' }
          ],
          I18n.t(
            'filters.attributes.element',
            element: I18n.t('server_admin.universities.contribution_filter.title').downcase
          )
    end

    def add_for_university_kind
      add :for_university_kind,
          [
            { to_s: I18n.t('server_admin.universities.university_kind_filter.public'), id: 'public' }, 
            { to_s:  I18n.t('server_admin.universities.university_kind_filter.private'), id: 'private' }
          ],
          I18n.t(
            'filters.attributes.element',
            element: I18n.t('server_admin.universities.university_kind_filter.title').downcase
          )
    end


  end
end
