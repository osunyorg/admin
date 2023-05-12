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
    # - la personne en dépendance du composant Person (1)
    block = page.blocks.create(position: 1, published: true, template_kind: :organization_chart)
    block.data = "{ \"elements\": [ { \"id\": \"#{arnaud.id}\" } ] }"
    block.save

    page = page.reload

    assert_equal 9, page.recursive_dependencies.count

    # On modifie le target du block
    Delayed::Job.destroy_all
    block.data = "{ \"elements\": [ { \"id\": \"#{olivia.id}\" } ] }"
    block.save
    # On vérifie qu'on appelle bien la méthode destroy_obsolete_git_files sur le site de la page
    assert(destroy_obsolete_git_files_job)

    assert_equal 9, page.recursive_dependencies.count

    # Vérifie qu'on a bien
    # - une tâche pour resynchroniser la page
    # - une tâche de nettoyage des git files (dépendances du bloc supprimé)
    Delayed::Job.destroy_all
    block.destroy
    assert(sync_with_git_job(page))
    assert(destroy_obsolete_git_files_job)

  end

  def test_change_website_dependencies
    website_with_github.save
    dependencies_before_count = website_with_github.reload.recursive_dependencies.count

    # On modifie l'about du website en ajoutant une école
    website_with_github.update(about: default_school)
    refute(destroy_obsolete_git_files_job)
    delta = website_with_github.reload.recursive_dependencies.count - dependencies_before_count
    # En ajoutant l'école, on rajoute en dépendances :
    # - L'école, et ses formations et diplômes en cascade (3)
    # - Les catégories d'actus liés aux formations, soit la catégorie racine et la catégorie de default_program (2)
    # - Les pages "Teachers", "Administrators", "Researchers", "EducationDiplomas", "EducationPrograms" (5)
    # Donc un total de 3 + 2 + 5 = 10 dépendances
    assert_equal 10, delta

    Delayed::Job.destroy_all

    # On enlève l'about du website
    website_with_github.update(about: nil)

    # On vérifie qu'on appelle bien la méthode destroy_obsolete_git_files sur le site
    assert(destroy_obsolete_git_files_job)
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
    item.destroy
    refute(destroy_obsolete_git_files_job)
  end


  protected

  def sync_with_git_job(object)
    find_performable_method_job(:sync_with_git_without_delay, object)
  end

  def destroy_obsolete_git_files_job(website = website_with_github)
    find_performable_method_job(:destroy_obsolete_git_files_without_delay, website)
  end

  # On ne peut pas utiliser assert_enqueued_jobs sur les méthodes asynchrones gérées avec handle_asynchronously
  def find_performable_method_job(method, object)
    Delayed::Job.all.detect { |job|
      job.payload_object.method_name == method &&
        job.payload_object.object == object
    }
  end
end
