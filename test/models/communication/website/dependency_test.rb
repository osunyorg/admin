require "test_helper"

# rails test test/models/communication/website/dependency_test.rb
class Communication::Website::DependencyTest < ActiveSupport::TestCase
  def test_page_dependencies
    # Rien : 0 dépendances
    page = communication_website_pages(:page_with_no_dependency)
    assert_equal 0, page.recursive_dependencies.count

    #  On ajoute un block "Chapitre" : 7 dépendances (les 6 composants du chapitre + le block lui même)
    page.blocks.create(position: 1, published: true, template_kind: :chapter)
    assert_equal 7, page.recursive_dependencies.count
  end

  def test_change_block_dependencies
    page = communication_website_pages(:page_with_no_dependency)

    # On ajoute un block "OrganizationChart" lié à Arnaud : 9 dépendances (4 composants du organization_chart + 1 élément du organization_chart (arnaud) + 3 éléments liés à arnaud + le block lui-même)
    block = page.blocks.create(position: 1, published: true, template_kind: :organization_chart)
    block.data = "{ \"elements\": [ { \"id\": \"#{arnaud.id}\" } ] }"
    block.save

    page = page.reload

    assert_equal 9, page.recursive_dependencies.count

    # On modifie le target du block
    block.data = "{ \"elements\": [ { \"id\": \"#{olivia.id}\" } ] }"
    block.save
  end
end
