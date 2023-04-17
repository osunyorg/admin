require "test_helper"

# rails test test/models/communication/website/dependencies_test.rb
class Communication::Website::DependenciesTest < ActiveSupport::TestCase
  test "page" do
    # Rien : 0 dépendances
    page = communication_website_pages(:page_with_no_dependency)
    assert_equal 0, page.recursive_dependencies.count
    
    #  On ajoute un block "Chapitre" : 7 dépendances (les 6 composants du chapitre + le chapitre)
    page = communication_website_pages(:page_with_no_dependency)
    page.blocks.create(position: 1, published: true, template_kind: :chapter)
    assert_equal 7, page.recursive_dependencies.count
  end
end
