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

    # Au départ, 2 dépendances :
    # - la localisation FR de la page
    # - La content security policy
    assert_equal 2, page.recursive_dependencies(follow_direct: true).count

    # On ajoute un block Personnes lié à Arnaud : +3 dépendances
    # - le block Personnes
    # - la personne en dépendance du composant Person
    # - la localisation FR de la personne
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
      
    perform_enqueued_jobs(only: Communication::Website::CleanJob)

    # On modifie le bloc Personnes en remplaçant Arnaud par Olivia : -2 puis +2 dépendances
    # - On retire Arnaud et sa localisation FR
    # - On ajoute Olivia et sa localisation FR
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

    # Vérifie qu'on a bien  une tâche de nettoyage (dépendances du bloc supprimé)
    assert_enqueued_with(job: Communication::Website::CleanJob) do
      block.destroy
    end

    # On a enlevé le bloc, reste les 2 dépendances d'origine
    # - la localisation FR de la page
    # - La content security policy
    assert_equal 2, page.recursive_dependencies(follow_direct: true).count
  end

  def test_change_website_dependencies
    website_with_github.save
    perform_enqueued_jobs

    dependencies_before_count = website_with_github.reload.recursive_dependencies(follow_direct: true).count

    # On modifie l'about du website en ajoutant une école
    # On vérifie que le job de destroy obsolete git files n'est pas enqueued
    website_with_github.update(about: default_school)
    perform_enqueued_jobs

    delta = website_with_github.reload.recursive_dependencies(follow_direct: true).count - dependencies_before_count
    # En ajoutant l'école, on rajoute en dépendances :
    # - L'école, sa formations (default_program), son diplôme (default_diploma) et les localisations de ces objets (6)
    # - Les catégories d'actus liés aux formations, soit la catégorie racine et la catégorie de default_program, ainsi que leurs localisations (4)
    # - Les catégories d'agenda liés aux formations, soit la catégorie racine et la catégorie de default_program, ainsi que leurs localisations (4)
    # - Les catégories de pages liés aux formations, soit la catégorie racine et la catégorie de default_program, ainsi que leurs localisations (4)
    # - Les pages "Teachers", "Administrators", "Researchers", "EducationDiplomas", "EducationPrograms", "AdministrationLocation" et leurs localisations (12)
    # Donc un total de 6 + 4 + 4 + 4 + 12 = 30 dépendances
    assert_equal 30, delta

    clear_enqueued_jobs
  end

  def test_change_website_dependencies_with_multilingual
    website_with_github.save
    dependencies_before_count = website_with_github.reload.recursive_dependencies(follow_direct: true).count
    # On crée une localisation anglaise de la homepage
    communication_website_pages(:root_page).localize_in!(english)

    # Tant qu'on n'a pas activé l'anglais sur le website le nombre de dépendances ne doit pas bouger
    assert_equal dependencies_before_count, website_with_github.reload.recursive_dependencies(follow_direct: true).count
  end

end
