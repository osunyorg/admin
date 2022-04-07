module Communication::Website::WithSpecialPages
  extend ActiveSupport::Concern

  included do

    def create_missing_special_pages
      homepage = create_special_page('home')
      # first level generic pages
      ['legal_terms', 'sitemap', 'privacy_policy'].each do |kind|
        create_special_page(kind, homepage.id)
      end
      # first level pages with test
      ['communication_posts', 'education_programs', 'research_articles', 'research_volumes'].each do |kind|
        create_special_page(kind, homepage.id) if public_send("has_#{kind}?")
      end
      # team pages
      if has_people?
        people = create_special_page('people', homepage.id)
        ['administrators', 'authors', 'researchers', 'teachers'].each do |kind|
          create_special_page(kind, people.id) if public_send("has_#{kind}?")
        end
      end
    end
    # handle_async

    def manage_special_pages_publication
      current_special_pages_keys = pages.where.not(kind: nil).pluck(:kind).uniq
      current_special_pages_keys.each do |kind|
        state = !(respond_to?("has_#{kind}?") && !public_send("has_#{kind}?"))
        pages.where(kind: kind).update_all(published: state)
      end
    end

  end

  private

  def create_special_page(kind, parent_id = nil)
    i18n_key = "communication.website.pages.defaults.#{kind}"
    pages.where(kind: kind).first_or_create(
      title: I18n.t("#{i18n_key}.title"),
      slug: I18n.t("#{i18n_key}.slug"),
      description_short: I18n.t("#{i18n_key}.description_short"),
      parent_id: parent_id,
      published: true,
      university_id: university_id
    )
  end


end
