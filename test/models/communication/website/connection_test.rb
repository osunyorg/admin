require "test_helper"

# rails test test/models/communication/website/connection_test.rb
class Communication::Website::ConnectionTest < ActiveSupport::TestCase
  test "unpublish indirect does nothing" do
    page = communication_website_pages(:page_with_no_dependency)
    setup_page_connections(page)

    # On dépublie un bloc : +0
    assert_no_difference("Communication::Website::Connection.count") do
      page.blocks.second.update(published: false)
    end
  end

  test "unpublish direct does nothing" do
    page = communication_website_pages(:page_with_no_dependency)
    setup_page_connections(page)

    # On dépublie la page ayant un bloc chapitre : +0
    assert_no_difference("Communication::Website::Connection.count") do
      page.update(published: false)
    end
  end

  test "deleting direct removes all its connections" do
    page = communication_website_pages(:page_with_no_dependency)
    setup_page_connections(page)

    # On supprime la page ayant un bloc chapitre, et ainsi toutes ses connexions : -10
    assert_difference -> { Communication::Website::Connection.count } => -10 do
      page.destroy
    end
  end

  test "deleting indirect removes all its connections" do
    page = communication_website_pages(:page_with_no_dependency)
    setup_page_connections(page)

    # On supprime le bloc qui contient PA : -2 (parce que PA doit être supprimé aussi)
    assert_difference -> { Communication::Website::Connection.count } => -2 do
      page.blocks.find_by(position: 2).destroy
    end
  end

  test "deleting indirect with a dependency having 2 sources should keep a connection for this dependency somewhere else" do
    page = communication_website_pages(:page_with_no_dependency)
    setup_page_connections(page)
    # TODO 3 Suppression d'un objet indirect qui a en dépendance un autre objet utilisé ailleurs (dans le cas précédent si PA était utilisé par une autre source)
  end

  test "unpublish indirect ..." do
    page = communication_website_pages(:page_with_no_dependency)
    setup_page_connections(page)
    # TODO 4 Désactivation d'objet indirect
  end

  test "deleting direct with indirect dependency having 2 sources ..." do
    page = communication_website_pages(:page_with_no_dependency)
    setup_page_connections(page)
    # TODO 5 Suppression d'objet direct avec indirect connecté par 2 canaux (le problème du saumon)
    # https://developers.osuny.org/docs/admin/communication/sites-web/dependencies/iteration-4/#olivia-et-le-saumon-de-schr%C3%B6dinger
  end

  test "connecting indirect to website directly" do
    page = communication_website_pages(:page_with_no_dependency)
    setup_page_connections(page)
    # TODO 6 Connexion d'un objet indirect au website directement (about)
  end

  private

  def setup_page_connections(page)
    assert_no_difference("Communication::Website::Connection.count") do
      page.save
    end

    # On ajoute un block "Chapitre" : +1
    assert_difference -> { Communication::Website::Connection.count } => 1 do
      page.blocks.create(position: 1, published: true, template_kind: :chapter)
    end

    # On connecte PA via un block "Personnes" : +2
    assert_difference -> { Communication::Website::Connection.count } => 2 do
      block = page.blocks.create(position: 2, published: true, template_kind: :organization_chart)
      block.data = "{ \"elements\": [ { \"id\": \"#{pa.id}\" } ] }"
      block.save
    end

    # On ajoute noesya via un block "Organisations" : +4 parce que noesya a un block "Personnes" avec Olivia
    assert_difference -> { Communication::Website::Connection.count } => 4 do
      block = page.blocks.create(position: 3, published: true, template_kind: :partners)
      block.data = "{ \"elements\": [ { \"id\": \"#{noesya.id}\" } ] }"
      block.save
    end

    # On ajoute Arnaud à noesya via un block "Personnes" : +2
    assert_difference -> { Communication::Website::Connection.count } => 2 do
      block = noesya.blocks.create(position: 2, published: true, template_kind: :organization_chart)
      block.data = "{ \"elements\": [ { \"id\": \"#{arnaud.id}\" } ] }"
      block.save
    end

    # On tente la boucle infine en ajoutant noesya à Olivia : +1 (le block ajouté à Olivia)
    assert_difference -> { Communication::Website::Connection.count } => 1 do
      block = olivia.blocks.create(position: 1, published: true, template_kind: :partners)
      block.data = "{ \"elements\": [ { \"id\": \"#{noesya.id}\" } ] }"
      block.save
    end
  end
end
