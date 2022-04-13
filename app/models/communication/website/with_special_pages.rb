module Communication::Website::WithSpecialPages
  extend ActiveSupport::Concern

  included do

    after_create :create_missing_special_pages
    after_touch :create_missing_special_pages, :manage_special_pages_publication

    def special_page(kind)
      pages.where(kind: kind).first
    end

    def create_missing_special_pages
      homepage = create_special_page('home')
      # first level pages with test
      ['legal_terms', 'sitemap', 'privacy_policy', 'communication_posts', 'education_programs', 'research_articles', 'research_volumes'].each do |kind|
        create_special_page(kind, homepage.id) if public_send("has_#{kind}?")
      end
      # team pages
      if has_persons?
        persons = create_special_page('persons', homepage.id)
        ['administrators', 'authors', 'researchers', 'teachers'].each do |kind|
          create_special_page(kind, persons.id) if public_send("has_#{kind}?")
        end
      end
    end

    def manage_special_pages_publication
      special_pages_keys.each do |kind|
        published = public_send("has_#{kind}?")
        special_page(kind).update(published: published)
      end
    end

  end

  private

  def create_special_page(kind, parent_id = nil)
    i18n_key = "communication.website.pages.defaults.#{kind}"
    # TODO: remove legacy after migrations
    legacy_index_page = Communication::Website::IndexPage.where(communication_website_id: id, kind: kind).first
    if legacy_index_page.present?
      page = pages.where(kind: kind).first
      unless page.present?
        page = pages.create(
          kind: kind,
          title: legacy_index_page.title,
          slug: legacy_index_page.path,
          description_short: legacy_index_page.description,
          parent_id: parent_id,
          published: true,
          university_id: university_id,
          breadcrumb_title: legacy_index_page.breadcrumb_title,
          featured_image_alt: legacy_index_page.featured_image_alt,
          header_text: legacy_index_page.header_text,
          text: legacy_index_page.text
        )
        if legacy_index_page.featured_image.attached?
          blob_to_duplicate = legacy_index_page.featured_image.blob
          page.featured_image.attach(
            io: URI.open(blob_to_duplicate.url),
            filename: blob_to_duplicate.filename.to_s
          )
        end
      end
    else
      page = pages.where(kind: kind).first_or_create(
        title: I18n.t("#{i18n_key}.title"),
        slug: I18n.t("#{i18n_key}.slug"),
        description_short: I18n.t("#{i18n_key}.description_short"),
        parent_id: parent_id,
        published: true,
        university_id: university_id
      )
    end
    page
  end

  def special_pages_keys
    @special_pages_keys ||= pages.where.not(kind: nil).pluck(:kind).uniq
  end


end
