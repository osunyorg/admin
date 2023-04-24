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

    # On ajoute un block Personnes lié à Arnaud : 9 dépendances
    # - le block Personnes (1)
    # - 4 composants du template du block + 1 élément (5)
    # - 2 composants de l'élément du template (2)
    # - La personne en dépendance du composant Person (1)
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
