require "test_helper"

# Pour tester juste ce jeu `rake test TEST=test/models/hugo_test.rb`
class HugoTest < ActiveSupport::TestCase
  test "pages" do
    website = communication_websites(:website_with_github)
    # FIXME les permalinks ne sont pas calculés, tous les path sont faux
    # Home
    page = communication_website_pages(:page_root)
    assert_equal '/fr/', page.hugo(website).path
    assert_equal 'content/fr/_index.html', page.hugo(website).file
    assert_equal '', page.hugo(website).slug
    # Test
    page = communication_website_pages(:page_test)
    assert_equal '/fr/test/', page.hugo(website).path
    assert_equal 'content/fr/pages/test/_index.html', page.hugo(website).file
    assert_equal 'test', page.hugo(website).slug
    # Page sans dépendances
    page = communication_website_pages(:page_with_no_dependency)
    assert_equal '/fr/page-with-no-dependency/', page.hugo(website).path
    assert_equal 'content/fr/pages/page-with-no-dependency/_index.html', page.hugo(website).file
    assert_equal 'page-with-no-dependency', page.hugo(website).slug
  end
end