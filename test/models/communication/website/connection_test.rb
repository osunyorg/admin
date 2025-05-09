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
  include ActiveJob::TestHelper

  def test_unpublish_indirect_does_nothing
    page_l10n = communication_website_page_localizations(:page_with_no_dependency_fr)
    setup_page_connections(page_l10n)

    # On dépublie un bloc : +0
    assert_no_difference("Communication::Website::Connection.count") do
      page_l10n.blocks.second.update(published: false)
    end
  end

  def test_unpublish_direct_does_nothing
    page_l10n = communication_website_page_localizations(:page_with_no_dependency_fr)
    setup_page_connections(page_l10n)

    # On dépublie la page ayant un bloc chapitre : +0
    assert_no_difference("Communication::Website::Connection.count") do
      page_l10n.update(published: false)
    end
  end

  def test_deleting_direct_removes_all_its_connections
    page_l10n = communication_website_page_localizations(:page_with_no_dependency_fr)
    setup_page_connections(page_l10n)

    # On supprime la page, et ainsi toutes ses connexions : -17
    assert_difference -> { Communication::Website::Connection.count } => -17 do
      page_l10n.about.destroy
    end
  end

  def test_deleting_indirect_removes_all_its_connections
    page_l10n = communication_website_page_localizations(:page_with_no_dependency_fr)
    setup_page_connections(page_l10n)

    # On supprime le bloc qui contient PA : -3 (parce que PA et sa localisation doivent être supprimés aussi)
    assert_difference -> { Communication::Website::Connection.count } => -3 do
      assert_enqueued_with(job: Communication::Website::CleanJob, args: [page_l10n.communication_website_id]) do
        page_l10n.blocks.find_by(position: 2).destroy
      end
      perform_enqueued_jobs(only: Communication::Website::CleanJob)
    end
  end

  def test_deleting_indirect_with_a_dependency_having_two_sources
    page_l10n = communication_website_page_localizations(:page_with_no_dependency_fr)
    setup_page_connections(page_l10n)

    # On ajoute noesya à PA via un block "Organisations" (+1 avec le bloc, mais noesya est déjà connectée via le bloc 3)
    pa_l10n = university_person_localizations(:pa_fr)
    assert_difference -> { Communication::Website::Connection.count } => 1 do
      block = pa_l10n.blocks.create(position: 1, published: true, template_kind: :organizations)
      block.data = "{ \"elements\": [ { \"id\": \"#{noesya.id}\" } ] }"
      block.save
      perform_enqueued_jobs
    end

    # Suppression d'un objet indirect qui a en dépendance un autre objet utilisé ailleurs (dans le cas précédent si PA était utilisé par une autre source)
    # On supprime le bloc qui contient PA : -4 (le bloc, PA, sa localisation et le bloc Organisations de PA)
    # On ne supprime pas noesya, toujours connectée via le block 3)
    assert_difference -> { Communication::Website::Connection.count } => -4 do
      assert_enqueued_with(job: Communication::Website::CleanJob, args: [page_l10n.communication_website_id]) do
        page_l10n.blocks.find_by(position: 2).destroy
      end
      perform_enqueued_jobs(only: Communication::Website::CleanJob)
    end
  end

  def test_deleting_direct_with_indirect_dependency_having_two_sources
    # https://developers.osuny.org/docs/admin/communication/sites-web/dependencies/iteration-4/#olivia-et-le-saumon-de-schr%C3%B6dinger
    page_l10n = communication_website_page_localizations(:page_with_no_dependency_fr)
    setup_page_connections(page_l10n)

    second_page_l10n = communication_website_page_localizations(:test_page_fr)
    block = second_page_l10n.blocks.new(position: 1, published: true, template_kind: :organizations)
    block.data = "{ \"mode\": \"selection\", \"elements\": [ { \"id\": \"#{noesya.id}\" } ] }"
    block.save

    # noesya est connectée via les 2 pages, donc 2 connexions
    assert_equal 2, page_l10n.website.connections.where(indirect_object: noesya).count

    # On supprime la 2e page, donc ses 13 connexions à savoir :
    # - La localisation de la page (1)
    # - Le block Organisations et noesya (2)
    # - Les 10 connexions via noesya, à savoir :
    #   - La localisation de noesya (1)
    #   - La catégorie de noesya et sa localisation (2)
    #   - Le block Personnes avec Olivia, sa localisation et son block Organisations (4)
    #     note : Pas noesya car la connexion existe déjà plus haut
    #   - Le block Personnes avec Arnaud et sa localisation (3)
    assert_difference -> { Communication::Website::Connection.count } => -13 do
      second_page_l10n.about.destroy
      perform_enqueued_jobs
    end
    # noesya est toujours connectée via la 1re page
    assert_equal 1, page_l10n.website.connections.where(indirect_object: noesya).count
  end

  def test_connecting_and_disconnecting_indirect_to_website_directly
    # En connectant l'école au site, on crée une connexion pour :
    # L'école, avec ses formations et ses diplômes en cascade, donc 3 connexions avec direct_source = website
    # En cascade, le save du website va créer les pages de liste des formations et des diplômes, qui ont elles aussi leurs dépendances
    # La page des diplômes aura en dépendance les diplômes (default_diploma), donc 1 connexion avec direct_source = page diplômes
    # La page des formations aura en dépendance les formations (default_program) et leurs diplômes en cascade (default_diploma), donc 2 connexions avec direct_source = page formations
    # Donc un total de 3 + 1 + 2 = 6 connexions directes au site
    assert_difference -> { Communication::Website::Connection.where(direct_source_type: "Communication::Website").count } => 6 do
      website_with_github.update(about: default_school)
      perform_enqueued_jobs
    end

    # En déconnectant l'école du site, on supprime les connexions créées précédemment
    assert_difference -> { Communication::Website::Connection.where(direct_source_type: "Communication::Website").count } => -6 do
      assert_enqueued_with(job: Communication::Website::CleanJob, args: [website_with_github.id]) do
        assert_enqueued_with(job: Dependencies::CleanWebsitesIfNecessaryJob) do
          website_with_github.update(about: nil)
        end
        perform_enqueued_jobs
      end
      perform_enqueued_jobs
    end
  end

  def test_delete_obsolete_connections_stays_in_scope
    website_with_github.update(about: default_school)
    page_l10n = communication_website_page_localizations(:page_with_no_dependency_fr)
    setup_page_connections(page_l10n)
    program = education_programs(:default_program)
    # On connecte une formation à la page : +3 (bloc, formation, localisation de formation, diplôme, localisation de diplôme)
    assert_difference -> { Communication::Website::Connection.count } => 5 do
      block = page_l10n.blocks.new(position: 3, published: true, template_kind: :programs)
      block.data = "{ \"elements\": [ { \"id\": \"#{program.id}\" } ] }"
      block.save
      perform_enqueued_jobs
    end
    assert_no_difference('Communication::Website::Connection.count') do
      website_with_github.reload.delete_obsolete_connections_for_self_and_direct_sources
    end
  end

  private

  def setup_page_connections(page_l10n)
    page = page_l10n.about
    homepage = page.parent
    homepage.save # Setup home connections

    # On connecte la localisation à la page : +1
    assert_difference -> { page.connections.count } => 1 do
      page_l10n.about.save
    end

    # On ajoute un block "Chapitre" : +1
    assert_difference -> { page.connections.count } => 1 do
      page_l10n.blocks.create(position: 1, published: true, template_kind: :chapter)
      perform_enqueued_jobs
    end

    # On connecte PA via un block "Personnes" : +3 (bloc, personne, localisation de personne)
    assert_difference -> { page.connections.count } => 3 do
      block = page_l10n.blocks.new(position: 2, published: true, template_kind: :persons)
      block.data = "{ \"mode\": \"selection\", \"elements\": [ { \"id\": \"#{pa.id}\" } ] }"
      block.save
      perform_enqueued_jobs
    end

    # On ajoute noesya via un block "Organisations" : +8 parce que noesya a une localisation, une catégorie (et sa localisation) et un block "Personnes" avec Olivia (et sa localisation)
    assert_difference -> { page.connections.count } => 8 do
      block = page_l10n.blocks.new(position: 3, published: true, template_kind: :organizations)
      block.data = "{ \"mode\": \"selection\", \"elements\": [ { \"id\": \"#{noesya.id}\" } ] }"
      block.save
      perform_enqueued_jobs
    end

    # On ajoute Arnaud à noesya via un block "Personnes" : +3 (bloc, personne, localisation de personne)
    noesya_l10n = university_organization_localizations(:noesya_fr)
    assert_difference -> { page.connections.count } => 3 do
      block = noesya_l10n.blocks.new(position: 2, published: true, template_kind: :persons)
      block.data = "{ \"mode\": \"selection\", \"elements\": [ { \"id\": \"#{arnaud.id}\" } ] }"
      block.save
      perform_enqueued_jobs
    end

    # On tente la boucle infine en ajoutant noesya à Olivia : +1 (le block ajouté à Olivia)
    olivia_l10n = university_person_localizations(:olivia_fr)
    assert_difference -> { page.connections.count } => 1 do
      block = olivia_l10n.blocks.new(position: 1, published: true, template_kind: :organizations)
      block.data = "{ \"mode\": \"selection\", \"elements\": [ { \"id\": \"#{noesya.id}\" } ] }"
      block.save
      perform_enqueued_jobs
    end

    # La page est donc comme ceci
    # Page
    # - Page Localization
    #   - Block Chapitre
    #   - Block Personnes
    #     - PA
    #       - PA Localization
    #   - Block Organisations
    #     - noesya
    #       - noesya Localization
    #         - Block Personnes
    #           - Olivia
    #             - Olivia Localization
    #               - Block Organisations
    #                 - noesya
    #         - Block Personnes
    #           - Arnaud
    #             - Arnaud Localization
    #       - Catégorie
    #         - Catégorie Localization
  end
end
