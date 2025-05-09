# == Schema Information
#
# Table name: communication_website_git_files
#
#  id            :uuid             not null, primary key
#  about_type    :string           not null, indexed => [about_id]
#  previous_path :string
#  previous_sha  :string
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#  about_id      :uuid             not null, indexed => [about_type]
#  website_id    :uuid             not null, indexed
#
# Indexes
#
#  index_communication_website_git_files_on_website_id  (website_id)
#  index_communication_website_github_files_on_about    (about_type,about_id)
#
# Foreign Keys
#
#  fk_rails_8505d649e8  (website_id => communication_websites.id)
#
require "test_helper"

class Communication::Website::GitFileTest < ActiveSupport::TestCase
  test "should_create? a new file" do
    VCR.use_cassette(location) do
      file = communication_website_git_files(:git_file_1)
      analyzer = Git::Analyzer.new(file.website.git_repository)
      analyzer.git_file = file
      assert analyzer.should_create?
    end
  end

  test "should_update? an existing file" do
    VCR.use_cassette(location) do
      # To create the file, i first did that:
      # file = communication_website_git_files(:git_file_2)
      # file.website.git_repository.add_git_file file
      # file.website.git_repository.sync!
      # Then i got the sha and path, pasted it in the fixtures,
      # changed the text so the content would need an update.
      file = communication_website_git_files(:git_file_2)
      analyzer = Git::Analyzer.new(file.website.git_repository)
      analyzer.git_file = file
      assert analyzer.should_update?
    end
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

    # On lance l'identification pour Arnaud
    assert_difference -> { arnaud.original_localization.git_files.count } do
      perform_enqueued_jobs(only: Communication::Website::GitFile::IdentifyJob)
    end
    # On vérifie qu'Arnaud sera bien écrit quelque part dans le repository
    assert(arnaud.original_localization.git_files.first.computed_path)
    
    clear_enqueued_jobs

    # On modifie le target du block
    block.data = "{ \"elements\": [ { \"id\": \"#{olivia.id}\" } ] }"
    assert_enqueued_with(job: Dependencies::CleanWebsitesIfNecessaryJob) do
      block.save
    end

    # On lance l'identification pour Olivia
    assert_difference -> { olivia.original_localization.git_files.count } do
      perform_enqueued_jobs(only: Communication::Website::GitFile::IdentifyJob)
    end

    # On vérifie qu'on enqueue le job qui clean les websites
    assert_enqueued_with(job: Communication::Website::CleanJob) do
      perform_enqueued_jobs(only: Dependencies::CleanWebsitesIfNecessaryJob)
    end
      
    perform_enqueued_jobs(only: Communication::Website::CleanJob)
    # On vérifie qu'Arnaud sera bien supprimé du repository (computed_path == nil)
    refute(arnaud.original_localization.git_files.first.computed_path)

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

end
