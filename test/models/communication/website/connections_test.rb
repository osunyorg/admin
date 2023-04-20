require "test_helper"

# rails test test/models/communication/website/connections_test.rb
class Communication::Website::ConnectionsTest < ActiveSupport::TestCase
  test "connect objects to page" do

    # Au début, rien
    page = communication_website_pages(:page_with_no_dependency)
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

    # On dépublie un bloc : +0
    assert_no_difference("Communication::Website::Connection.count") do
      page.blocks.second.update(published: false)
    end

    # TODO Suppression d'objet direct

    # TODO Désactivation d'objet direct

    # Suppression d'objet indirect
    # On supprime le bloc qui contient PA : -2 (parce que PA doit être supprimé aussi)
    assert_difference -> { Communication::Website::Connection.count } => -2 do
      page.blocks.find_by(position: 2).destroy
    end

    # TODO Suppression d'un objet indirect qui a en dépendance un autre objet utilisé ailleurs (dans le cas précédent si PA était utilisé par une autre source)

    # TODO Désactivation d'objet indirect


    # TODO Suppression d'objet direct avec indirect connecté par 2 canaux (le problème du saumon)
    # https://developers.osuny.org/docs/admin/communication/sites-web/dependencies/iteration-4/#olivia-et-le-saumon-de-schr%C3%B6dinger
  end
end
