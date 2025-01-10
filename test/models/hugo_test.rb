require "test_helper"

# Pour tester juste ce jeu `rake test TEST=test/models/hugo_test.rb`
class HugoTest < ActiveSupport::TestCase
  test "pages" do
    website = communication_websites(:website_with_github)
    # FIXME les permalinks ne sont pas calculés, tous les path sont faux
    # Home
    page_l10n = communication_website_page_localizations(:root_page_fr)
    # assert_equal '/fr/', page_l10n.hugo(website).path
    assert_equal 'content/fr/_index.html', page_l10n.hugo(website).file
    assert_equal '', page_l10n.hugo(website).slug
    # Test
    page_l10n = communication_website_page_localizations(:test_page_fr)
    # assert_equal '/fr/test/', page_l10n.hugo(website).path
    assert_equal 'content/fr/pages/test/_index.html', page_l10n.hugo(website).file
    assert_equal 'test', page_l10n.hugo(website).slug
    # Page sans dépendances
    page_l10n = communication_website_page_localizations(:page_with_no_dependency_fr)
    # assert_equal '/fr/page-with-no-dependency/', page_l10n.hugo(website).path
    assert_equal 'content/fr/pages/page-with-no-dependency/_index.html', page_l10n.hugo(website).file
    assert_equal 'page-with-no-dependency', page_l10n.hugo(website).slug
  end
end