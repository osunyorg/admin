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
end
