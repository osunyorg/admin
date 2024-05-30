require "test_helper"

# rails test test/models/communication/website/dependency_test.rb
class Communication::Website::DependencyTest < ActiveSupport::TestCase
  include ActiveJob::TestHelper

  def test_page_dependencies
    # Par défaut, 1 dépendance (la configuration CSP du site)
    page = communication_website_pages(:page_with_no_dependency)
    assert_equal 1, page.recursive_dependencies.count

    #  On ajoute un block "Chapitre" : +1 dépendance (le block)
    page.blocks.create(position: 1, published: true, template_kind: :chapter)
    assert_equal 2, page.recursive_dependencies.count
  end

  def test_change_block_dependencies
    page = communication_website_pages(:page_with_no_dependency)

    # On ajoute un block Personnes lié à Arnaud : 9 dépendances
    # - le block Personnes (1)
    # - 4 composants du template du block + 1 élément (5)
    # - 2 composants de l'élément du template (2)
    # - la personne en dépendance du composant Person (1)
    # - La content security policy
    block = page.blocks.create(position: 1, published: true, template_kind: :persons)
    block.data = "{ \"elements\": [ { \"id\": \"#{arnaud.id}\" } ] }"
    block.save

    page = page.reload
    assert_equal 3, page.recursive_dependencies.count

    # On modifie le target du block
    GoodJob::Job.destroy_all
    block.data = "{ \"elements\": [ { \"id\": \"#{olivia.id}\" } ] }"
    # On vérifie qu'on enqueue le job qui clean les websites
    assert_enqueued_with(job: Communication::Website::CleanJob) do
      block.save
    end

    # On vérifie qu'on enqueue le job qui destroy les obsolete git files
    assert_enqueued_with(job: Communication::Website::DestroyObsoleteGitFilesJob) do
      perform_enqueued_jobs(only: Communication::Website::CleanJob)
    end

    assert_equal 3, page.recursive_dependencies.count

    # Vérifie qu'on a bien
    # - une tâche pour resynchroniser la page
    # - une tâche de nettoyage des git files (dépendances du bloc supprimé)
    GoodJob::Job.destroy_all

    assert_enqueued_with(job: Communication::Website::DirectObject::SyncWithGitJob, args: [page.communication_website_id, direct_object: page]) do
      assert_enqueued_with(job: Communication::Website::CleanJob) do
        block.destroy
      end
    end

    assert_enqueued_with(job: Communication::Website::DestroyObsoleteGitFilesJob) do
      perform_enqueued_jobs(only: Communication::Website::CleanJob)
    end
  end

  def test_change_website_dependencies
    website_with_github.save
    dependencies_before_count = website_with_github.reload.recursive_dependencies.count

    # On modifie l'about du website en ajoutant une école
    # On vérifie que le job de destroy obsolete git files n'est pas enqueued
    assert_no_enqueued_jobs only: Communication::Website::DestroyObsoleteGitFilesJob do
      website_with_github.update(about: default_school)
    end
    delta = website_with_github.reload.recursive_dependencies.count - dependencies_before_count
    # En ajoutant l'école, on rajoute en dépendances :
    # - L'école, ses formations, diplômes et sites en cascade (4)
    # - Les catégories d'actus liés aux formations, soit la catégorie racine et la catégorie de default_program (2)
    # - Les catégories d'agenda liés aux formations, soit la catégorie racine et la catégorie de default_program (2)
    # - Les pages "Teachers", "Administrators", "Researchers", "EducationDiplomas", "EducationPrograms" (5)
    # Donc un total de 3 + 2 + 5 = 10 dépendances
    assert_equal 13, delta

    GoodJob::Job.destroy_all

    # On enlève l'about du website
    # On vérifie qu'on appelle bien la méthode destroy_obsolete_git_files sur le site
    assert_enqueued_with(job: Communication::Website::DestroyObsoleteGitFilesJob) do
      website_with_github.update(about: nil)
    end
  end

  def test_change_website_dependencies_with_multilingual
    website_with_github.save
    dependencies_before_count = website_with_github.recursive_dependencies.count

    # On crée une copie anglaise de la homepage
    page_test_en = communication_website_pages(:page_root).dup
    page_test_en.language = languages(:en)
    page_test_en.save

    # Tant qu'on n'a pas activé l'anglais sur le website le nombre de dépendances ne doit pas bouger
    assert_equal dependencies_before_count, website_with_github.reload.recursive_dependencies.count
  end

  # TODO : Utile?
  def test_change_menu_item_dependencies
    menu = communication_website_menus(:primary_menu)

    item = menu.items.create(university: default_university, website: website_with_github, kind: :blank, title: 'Test')

    item.kind = :page
    item.about = communication_website_pages(:page_with_no_dependency)
    item.save

    # Comme les menu items ne répondent pas à is_direct_object? du coup aucune tâche de nettoyage n'est ajoutée
    assert_no_enqueued_jobs only: Communication::Website::DestroyObsoleteGitFilesJob do
      item.destroy
    end
  end

end
