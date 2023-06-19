# == Schema Information
#
# Table name: communication_website_connections
#
#  id                   :uuid             not null, primary key
#  direct_source_type   :string           indexed => [direct_source_id]
#  indirect_object_type :string           not null, indexed => [indirect_object_id]
#  created_at           :datetime         not null
#  updated_at           :datetime         not null
#  direct_source_id     :uuid             indexed => [direct_source_type]
#  indirect_object_id   :uuid             not null, indexed => [indirect_object_type]
#  university_id        :uuid             not null, indexed
#  website_id           :uuid             not null, indexed
#
# Indexes
#
#  index_communication_website_connections_on_object         (indirect_object_type,indirect_object_id)
#  index_communication_website_connections_on_source         (direct_source_type,direct_source_id)
#  index_communication_website_connections_on_university_id  (university_id)
#  index_communication_website_connections_on_website_id     (website_id)
#
# Foreign Keys
#
#  fk_rails_728034883b  (website_id => communication_websites.id)
#  fk_rails_bd1ac8383b  (university_id => universities.id)
#
require "test_helper"

# rails test test/models/communication/website/connection_test.rb
class Communication::Website::ConnectionTest < ActiveSupport::TestCase
  def test_unpublish_indirect_does_nothing
    page = communication_website_pages(:page_with_no_dependency)
    setup_page_connections(page)

    # On dépublie un bloc : +0
    assert_no_difference("Communication::Website::Connection.count") do
      page.blocks.second.update(published: false)
    end
  end

  def test_unpublish_direct_does_nothing
    page = communication_website_pages(:page_with_no_dependency)
    setup_page_connections(page)

    # On dépublie la page ayant un bloc chapitre : +0
    assert_no_difference("Communication::Website::Connection.count") do
      page.update(published: false)
    end
  end

  def test_deleting_direct_removes_all_its_connections
    page = communication_website_pages(:page_with_no_dependency)
    setup_page_connections(page)

    # On supprime la page ayant un bloc chapitre, et ainsi toutes ses connexions : -10
    assert_difference -> { Communication::Website::Connection.count } => -10 do
      page.destroy
    end
  end

  def test_deleting_indirect_removes_all_its_connections
    page = communication_website_pages(:page_with_no_dependency)
    setup_page_connections(page)

    # On supprime le bloc qui contient PA : -2 (parce que PA doit être supprimé aussi)
    assert_difference -> { Communication::Website::Connection.count } => -2 do
      page.blocks.find_by(position: 2).destroy
    end
  end

  def test_deleting_indirect_with_a_dependency_having_two_sources
    page = communication_website_pages(:page_with_no_dependency)
    setup_page_connections(page)

    # On ajoute noesya à PA via un block "Organisations"
    assert_difference -> { Communication::Website::Connection.count } => 1 do
      block = pa.blocks.create(position: 1, published: true, template_kind: :partners)
      block.data = "{ \"elements\": [ { \"id\": \"#{noesya.id}\" } ] }"
      block.save
    end

    # Suppression d'un objet indirect qui a en dépendance un autre objet utilisé ailleurs (dans le cas précédent si PA était utilisé par une autre source)
    # On supprime le bloc qui contient PA : -3 (parce que PA doit être supprimé aussi ainsi que son bloc Organisations mais pas Noesya, toujours connectée via le block 3)
    assert_difference -> { Communication::Website::Connection.count } => -3 do
      page.blocks.find_by(position: 2).destroy
    end
  end

  def test_unpublish_indirect_does_nothing
    page = communication_website_pages(:page_with_no_dependency)
    setup_page_connections(page)

    # On dépublie la page ayant un bloc chapitre : +0
    assert_no_difference("Communication::Website::Connection.count") do
      page.blocks.ordered.last.update(published: false)
    end
  end

  def test_deleting_direct_with_indirect_dependency_having_two_sources
    # https://developers.osuny.org/docs/admin/communication/sites-web/dependencies/iteration-4/#olivia-et-le-saumon-de-schr%C3%B6dinger
    page = communication_website_pages(:page_with_no_dependency)
    setup_page_connections(page)

    second_page = communication_website_pages(:page_test)
    block = second_page.blocks.create(position: 1, published: true, template_kind: :partners)
    block.data = "{ \"elements\": [ { \"id\": \"#{noesya.id}\" } ] }"
    block.save

    # Noesya est connectée via les 2 pages, donc 2 connexions
    assert_equal 2, page.website.connections.where(indirect_object: noesya).count

    # On supprime la 2e page, donc ses 7 connexions à savoir :
    # - Le block Organisations et Noesya (2)
    # - Les 5 connexions via Noesya, à savoir :
    #   - Le block Personnes avec Olivia et son block Organisations (3)
    #     note : Pas Noesya car la connexion existe déjà plus haut
    #   - Le block Personnes avec Arnaud (2)
    assert_difference -> { Communication::Website::Connection.count } => -7 do
      second_page.destroy
    end

    # Noesya est toujours connectée via la 1re page
    assert_equal 1, page.website.connections.where(indirect_object: noesya).count
  end

  def test_connecting_and_disconnecting_indirect_to_website_directly
    # En connectant l'école au site, on crée une connexion pour :
    # L'école, avec ses formations et ses diplômes en cascade, donc 3 connexions avec direct_source = website
    # En cascade, le save du website va créer les pages de liste des formations et des diplômes, qui ont elles aussi leurs dépendances
    # La page des diplômes aura en dépendance les diplômes (default_diploma), donc 1 connexion avec direct_source = page diplômes
    # La page des formations aura en dépendance les formations (default_program) et leurs diplômes en cascade (default_diploma), donc 2 connexions avec direct_source = page formations
    # Donc un total de 3 + 1 + 2 = 6 connexions
    assert_difference -> { Communication::Website::Connection.count } => 6 do
      website_with_github.update(about: default_school)
    end

    # En déconnectant l'école du site, on supprime les connexions créées précédemment
    assert_difference -> { Communication::Website::Connection.count } => -6 do
      website_with_github.update(about: nil)
    end
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

    # La page est donc comme ceci
    # Page
    # - Block Chapitre
    # - Block Personnes
    #   - PA
    # - Block Organisations
    #   - Noesya
    #     - Block Personnes
    #       - Olivia
    #         - Block Organisations
    #           - Noesya
    #     - Block Personnes
    #       - Arnaud
  end
end
