require "test_helper"

# rails test test/models/communication/website/permalink_test.rb
class Communication::Website::PermalinkTest < ActiveSupport::TestCase

  def test_page_permalink
    # Créer une page et sa localisation FR
    page = website_with_github.pages.new(
      university_id: default_university.id,
      parent: communication_website_pages(:root_page),
      localizations_attributes: [
        { language_id: french.id, title: "Nouvelle page", slug: "nouvelle-page", published: true, published_at: Time.current }
      ]
    )
    assert_difference ->{ Communication::Website::Page.count } => 1,
                      ->{ Communication::Website::Page::Localization.count } => 1 do
      page.save!
    end

    # Générer le permalink de la l10n (vérifier qu'il est bon)
    page_l10n = page.localizations.first
    assert_difference "Communication::Website::Permalink.count" => 1 do
      page_l10n.manage_permalink_in_website(website_with_github)
    end

    # Relancer une génération pour vérifier que rien ne change
    assert_no_difference "Communication::Website::Permalink.count" do
      page_l10n.manage_permalink_in_website(website_with_github)
    end

    page_l10n_permalink = page_l10n.permalinks.first
    assert_equal "/nouvelle-page/", page_l10n_permalink.path

    # Créer une deuxième page avec le même nom
    page_with_same_title = website_with_github.pages.create!(
      university_id: default_university.id,
      parent: communication_website_pages(:root_page),
      localizations_attributes: [
        { language_id: french.id, title: "Nouvelle page", published: true, published_at: Time.current }
      ]
    )
    # Vérifier que le slug et le permalink sont bien suffixés "-1"
    page_with_same_title_l10n = page_with_same_title.localizations.first
    assert_equal "nouvelle-page-1", page_with_same_title_l10n.slug
    page_with_same_title_l10n.manage_permalink_in_website(website_with_github)
    page_with_same_title_l10n_permalink = page_with_same_title_l10n.permalinks.first
    assert_equal "/nouvelle-page-1/", page_with_same_title_l10n_permalink.path

    page_l10n.update!(title: "Titre modifié", slug: "titre-modifie")
    assert_difference "Communication::Website::Permalink.count" => 1 do
      page_l10n.manage_permalink_in_website(website_with_github)
    end
    page_l10n_permalink.reload
    refute page_l10n_permalink.is_current

    page_l10n_new_permalink = page_l10n.permalinks.order(:created_at).last
    assert page_l10n_new_permalink.is_current
    assert_equal "/titre-modifie/", page_l10n_new_permalink.path

    # Ajoute (équivalent d'à la main) un permalink pour cette page
    page_l10n.permalinks.create(website_id: website_with_github.id, path: '/ancienne-url/', is_current: false)

    new_page = website_with_github.pages.create!(
      university_id: default_university.id,
      parent: communication_website_pages(:root_page),
      localizations_attributes: [
        { language_id: french.id, title: "Ancienne url", published: true, published_at: Time.current }
      ]
    )
    # Vérifier que le slug et le permalink sont bien suffixés "-1"
    new_page_l10n = new_page.localizations.first
    assert_equal "ancienne-url", new_page_l10n.slug
    new_page_l10n.manage_permalink_in_website(website_with_github)
    new_page_l10n_permalink = new_page_l10n.permalinks.first
    assert_equal "/ancienne-url/", new_page_l10n_permalink.path
    # Vérifie que l'alias ajoutée à page_l10n a bien été supprimé
    refute page_l10n.reload.permalinks.find_by(path: "/ancienne-url/")
  end

  def test_hard_creation
    page = website_with_github.pages.create!(
      university_id: default_university.id,
      parent: communication_website_pages(:root_page),
      localizations_attributes: [
        { language_id: french.id, title: "Nouvelle page", slug: "nouvelle-page", published: true, published_at: Time.current }
      ]
    )
    page_l10n = page.localizations.first

    permalink = page_l10n.new_permalink_in_website(website_with_github)
    permalink.path = permalink.computed_path
    assert_difference "Communication::Website::Permalink.count" do
      permalink.save
    end

    permalink2 = page_l10n.new_permalink_in_website(website_with_github)
    permalink2.path = permalink2.computed_path
    assert_no_difference "Communication::Website::Permalink.count" do
      permalink2.save
    end
  end

  def test_agenda_permalink
    event = website_with_github.events.create!(
      university_id: default_university.id,
      from_day: Date.current,
      to_day: Date.current + 1.day,
      localizations_attributes: [
        { language_id: french.id, title: "Festival", slug: "festival", published: true, published_at: Time.current }
      ]
    )
    event_l10n = event.localizations.first

    permalink = event_l10n.new_permalink_in_website(website_with_github)
    permalink.path = permalink.computed_path
    assert_difference "Communication::Website::Permalink.count" do
      permalink.save
    end
    # /agenda/2026/festival/
    assert_equal "/agenda/#{Date.current.year}/festival/", permalink.path

    first_child_event = website_with_github.events.create!(
      university_id: default_university.id,
      parent_id: event.id,
      from_day: Date.current,
      localizations_attributes: [
        { language_id: french.id, title: "Concert", slug: "concert", published: true, published_at: Time.current }
      ]
    )
    first_child_event_l10n = first_child_event.localizations.first

    first_child_event_permalink = first_child_event_l10n.new_permalink_in_website(website_with_github)
    first_child_event_permalink.path = first_child_event_permalink.computed_path
    assert_difference "Communication::Website::Permalink.count" do
      first_child_event_permalink.save
    end
    # /agenda/2026/festival/concert/
    assert_equal "/agenda/#{Date.current.year}/festival/concert/", first_child_event_permalink.path

    second_child_event = website_with_github.events.create!(
      university_id: default_university.id,
      parent_id: event.id,
      from_day: Date.current,
      localizations_attributes: [
        { language_id: french.id, title: "Conférence", slug: "conference", published: true, published_at: Time.current }
      ]
    )
    second_child_event_l10n = second_child_event.localizations.first

    second_child_event_permalink = second_child_event_l10n.new_permalink_in_website(website_with_github)
    second_child_event_permalink.path = second_child_event_permalink.computed_path
    assert_difference "Communication::Website::Permalink.count" do
      second_child_event_permalink.save
    end
    # /agenda/2026/festival/conference/
    assert_equal "/agenda/#{Date.current.year}/festival/conference/", second_child_event_permalink.path

    assert_equal 2, event.days.reload.count
    assert_difference "Communication::Website::Permalink.count", 2 do
      event.days.first.manage_permalink_in_website(website_with_github)
      event.days.second.manage_permalink_in_website(website_with_github)
    end
    # /agenda/2026/festival/ (days take the same path as the event)
    assert_equal  "/agenda/#{Date.current.year}/festival/",
                  event.days.first.current_permalink_in_website(website_with_github).path

    # As the days have the same path, we can't turn the previous permalink into an alias. So +1-1=0, no delta
    assert_no_difference "Communication::Website::Permalink.count" do
      event_l10n.update!(title: "Festival modifié", slug: "festival-modifie")
    end
    event_l10n_permalink = event_l10n.current_permalink_in_website(website_with_github)
    # /agenda/2026/festival-modifie/
    assert_equal "/agenda/#{Date.current.year}/festival-modifie/", event_l10n_permalink.path

    # Create a new permalink, and update the old one to an alias
    assert_difference "Communication::Website::Permalink.count" do
      first_child_event_l10n.reload.manage_permalink_in_website(website_with_github)
    end
    # /agenda/2026/festival-modifie/concert/
    assert_equal  "/agenda/#{Date.current.year}/festival-modifie/concert/",
                  first_child_event_l10n.current_permalink_in_website(website_with_github).path

    # Create a new permalink, and update the old one to an alias
    assert_difference "Communication::Website::Permalink.count" do
      second_child_event_l10n.reload.manage_permalink_in_website(website_with_github)
    end
    # /agenda/2026/festival-modifie/conference/
    assert_equal  "/agenda/#{Date.current.year}/festival-modifie/conference/",
                  second_child_event_l10n.current_permalink_in_website(website_with_github).path

    event.reload

    # As the second day has the same path, we can't create an alias yet. No delta again
    assert_no_difference "Communication::Website::Permalink.count" do
      event.days.first.manage_permalink_in_website(website_with_github)
    end

    # No more objects use the previous path, we can create an alias for this day
    assert_difference "Communication::Website::Permalink.count" do
      event.days.second.reload.manage_permalink_in_website(website_with_github)
    end
  end
end
