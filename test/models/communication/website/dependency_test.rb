require "test_helper"

# rails test test/models/communication/website/dependency_test.rb
class Communication::Website::DependencyTest < ActiveSupport::TestCase
  include ActiveJob::TestHelper

  def test_page_dependencies
    # Par défaut, 2 dépendances :
    # - la localisation FR de la page
    # - la configuration CSP du site
    page = communication_website_pages(:page_with_no_dependency)
    assert_equal 2, page.recursive_dependencies(follow_direct: true).count

    #  On ajoute un block "Chapitre" à la l10n FR : +1 dépendance (le block)
    page_l10n = communication_website_page_localizations(:page_with_no_dependency_fr)
    page_l10n.blocks.create(position: 1, published: true, template_kind: :chapter)
    assert_equal 3, page.recursive_dependencies(follow_direct: true).count
  end

  def test_change_block_dependencies
    page = communication_website_pages(:page_with_no_dependency)
    page_l10n = communication_website_page_localizations(:page_with_no_dependency_fr)

    # On ajoute un block Personnes lié à Arnaud : 9 dépendances
    # - la localisation FR de la page
    # - le block Personnes
    # - la personne en dépendance du composant Person
    # - la localisation FR de la personne
    # - La content security policy
    block = page_l10n.blocks.create(position: 1, published: true, template_kind: :persons)
    block.data = "{ \"elements\": [ { \"id\": \"#{arnaud.id}\" } ] }"
    block.save

    page = page.reload
    assert_equal 5, page.recursive_dependencies(follow_direct: true).count

    clear_enqueued_jobs

    # On modifie le target du block
    block.data = "{ \"elements\": [ { \"id\": \"#{olivia.id}\" } ] }"
    assert_enqueued_with(job: Dependencies::CleanWebsitesIfNecessaryJob) do
      block.save
    end

    # On vérifie qu'on enqueue le job qui clean les websites
    assert_enqueued_with(job: Communication::Website::CleanJob) do
      perform_enqueued_jobs(only: Dependencies::CleanWebsitesIfNecessaryJob)
    end

    # On vérifie qu'on enqueue le job qui destroy les obsolete git files
    assert_enqueued_with(job: Communication::Website::DestroyObsoleteGitFilesJob) do
      perform_enqueued_jobs(only: Communication::Website::CleanJob)
    end

    assert_equal 5, page.recursive_dependencies(follow_direct: true).count

    clear_enqueued_jobs

    # Vérifie qu'en resauvant immédiatement l'objet on ne relance pas la boucle
    # On doit lancer un job CleanWebsitesIfNecessaryJob, mais la boucle s'arrête là (comme les dépendances sont rigoureusement les mêmes)
    assert_enqueued_with(job: Dependencies::CleanWebsitesIfNecessaryJob) do
      block.save
    end

    assert_no_enqueued_jobs(only: Communication::Website::CleanJob) do
      perform_enqueued_jobs(only: Dependencies::CleanWebsitesIfNecessaryJob)
    end

    clear_enqueued_jobs

    # Vérifie qu'on a bien
    # - une tâche pour resynchroniser la page
    # - une tâche de nettoyage des git files (dépendances du bloc supprimé)
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
    dependencies_before_count = website_with_github.reload.recursive_dependencies(follow_direct: true).count

    # On modifie l'about du website en ajoutant une école
    # On vérifie que le job de destroy obsolete git files n'est pas enqueued
    assert_no_enqueued_jobs only: Communication::Website::DestroyObsoleteGitFilesJob do
      assert_enqueued_with(job: Communication::Website::SetProgramsCategoriesJob) do
        website_with_github.update(about: default_school)
      end
    end
    perform_enqueued_jobs
    delta = website_with_github.reload.recursive_dependencies(follow_direct: true).count - dependencies_before_count
    # En ajoutant l'école, on rajoute en dépendances :
    # - L'école, sa formations (default_program), son diplôme (default_diploma) et les localisations de ces objets (6)
    # - Les catégories d'actus liés aux formations, soit la catégorie racine et la catégorie de default_program, ainsi que leurs localisations (4)
    # - Les catégories d'agenda liés aux formations, soit la catégorie racine et la catégorie de default_program, ainsi que leurs localisations (4)
    # - Les catégories de pages liés aux formations, soit la catégorie racine et la catégorie de default_program, ainsi que leurs localisations (4)
    # - Les pages "Teachers", "Administrators", "Researchers", "EducationDiplomas", "EducationPrograms", "AdministrationLocation" et leurs localisations (12)
    # Donc un total de 6 + 4 + 4 + 12 = 26 dépendances
    assert_equal 30, delta

    clear_enqueued_jobs

    # On enlève l'about du website
    # On vérifie qu'on appelle bien la méthode destroy_obsolete_git_files sur le site
    assert_enqueued_with(job: Communication::Website::DestroyObsoleteGitFilesJob) do
      website_with_github.update(about: nil)
    end
  end

  def test_change_website_dependencies_with_multilingual
    website_with_github.save
    dependencies_before_count = website_with_github.reload.recursive_dependencies(follow_direct: true).count
    # On crée une localisation anglaise de la homepage
    communication_website_pages(:root_page).localize_in!(english)

    # Tant qu'on n'a pas activé l'anglais sur le website le nombre de dépendances ne doit pas bouger
    assert_equal dependencies_before_count, website_with_github.reload.recursive_dependencies(follow_direct: true).count
  end

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
